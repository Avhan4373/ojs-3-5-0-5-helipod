<?php
/**
 * Renders /var/www/html/config.inc.php from the template shipped in the image.
 * Every placeholder is replaced by an environment variable.
 */

$templatePath = $argv[1] ?? '/opt/ojs/config.inc.php.template';
$targetPath = $argv[2] ?? '/var/www/html/config.inc.php';

$map = [
    '__APP_KEY__' => getenv('OJS_APP_KEY') ?: '',
    '__BASE_URL__' => getenv('OJS_BASE_URL') ?: '',
    '__TIME_ZONE__' => getenv('OJS_TIME_ZONE') ?: 'Asia/Jakarta',
    '__ALLOWED_HOSTS__' => getenv('OJS_ALLOWED_HOSTS') ?: '',
    '__DB_HOST__' => getenv('DB_HOST') ?: '',
    '__DB_USER__' => getenv('DB_USER') ?: '',
    '__DB_PASSWORD__' => getenv('DB_PASSWORD') ?: '',
    '__DB_NAME__' => getenv('DB_NAME') ?: '',
    '__REPOSITORY_ID__' => getenv('OJS_REPOSITORY_ID') ?: 'ojs',
];

$content = file_get_contents($templatePath);
if ($content === false) {
    fwrite(STDERR, "[OJS] cannot read template {$templatePath}\n");
    exit(1);
}

foreach ($map as $placeholder => $value) {
    $content = str_replace($placeholder, $value, $content);
}

if (file_put_contents($targetPath, $content) === false) {
    fwrite(STDERR, "[OJS] cannot write {$targetPath}\n");
    exit(1);
}

echo "[OJS] config written to {$targetPath}\n";
