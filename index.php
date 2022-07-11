<!DOCTYPE html>
<html>
<head>
<title>Macellan php-nginx docker image</title>
<style>
    body {
        width: 50em;
        margin: 0 auto;
        padding: 1rem;
        background-color: #FFFFFF;
        color: #253b42;
        font-family: Roboto, Verdana, Arial, sans-serif;
    }
    svg {
        width: 25em;
    }
    h2 {
        text-transform: capitalize;
        background-color: #d0d0d0;
        padding: 0.5rem;
    }
</style>
</head>
<body>

<h1>PHP / Nginx</h1>
<p>If you see this page, the php nginx web server is successfully installed and working. Further configuration is required.</p>

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
