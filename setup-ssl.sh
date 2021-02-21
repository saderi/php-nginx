#!/bin/sh
set -e

if [ ! -z "$DOMAIN_NAME" ]; then
    CERT_FILE=/etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem
    if [ -f "$CERT_FILE" ]; then
        openssl x509 -checkend 86400 -noout -in $CERT_FILE  > /dev/null
        if [ $? -ne 0 ]; then
            certbot renew
        fi
    else
        certbot certonly --webroot -w /var/www/html/public \
                        --register-unsafely-without-email \
                         --email $EMAIL_FOR_SSL \
                         -d $DOMAIN_NAME \
                         --rsa-key-size 4096 \
                         --agree-tos \
                         --force-renewal
    fi

    mkdir -p /etc/nginx/ssl
    cat /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem > /etc/nginx/ssl/fullchain.pem
    cat /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem > /etc/nginx/ssl/privkey.pem

    sed -i "s/DOMAIN_NAME/$DOMAIN_NAME/g" /etc/nginx/sites-available/nginx-site-ssl.conf \
    && ln -s /etc/nginx/sites-available/nginx-site-ssl.conf /etc/nginx/conf.d/nginx-site-ssl.conf \
    && supervisorctl restart nginx

else
    echo "Domain not set!"
fi
