<!DOCTYPE html>
<html>
<head>
<title>Nginx + PHP-FPM docker image</title>
<style>
    body {
        width: 50em;
        margin: 0 auto;
        padding: 1rem;
        background-color: #EFFAFF;
        color: #253b42;
        font-family: Roboto, Verdana, Arial, sans-serif;
    }
    svg {
        width: 25em;
    }
    h2 {
        text-transform: capitalize;
        background-color: #b8d8e1;
        padding: 0.5rem;
    }
</style>
</head>
<body>


<h1>Welcome to php-nginx docker image ! :)</h1>
<p>If you see this page, the php nginx web server is successfully installed and
working. Further configuration is required.</p>

<h2><?= shell_exec('nginx -v 2>&1') ?></h2>
<h2>PHP: <?= phpversion() ?></h2>
</p>
<p>
    <strong>PHP Loaded Extensions:</strong>
</p>
<p>
    <?= implode(" | ",get_loaded_extensions()) ?>
</p>
<h4><?= shell_exec('composer --version') ?></h4>
<h2>Node: <?= shell_exec('node -v') ?></h2>

</body>
</html>
