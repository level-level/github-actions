#!/bin/sh -l

echo "Starting update sequence."
git config --global user.email "bot+github@level-level.com"
git config --global user.name "Level Level Bot on GitHub"
TIMESTAMP=$(date +'%s')
git checkout -b auto-update/$TIMESTAMP
composer install
for plugin in $(composer outdated --direct -m -f json | jq -r ".installed[].name");
do
    echo "Updating $plugin.";
    LOG=$(composer update "$plugin" --no-scripts --no-ansi --no-suggest --no-autoloader --no-progress 2>&1 >/dev/null)
    git add composer.lock;
    git commit -m "Update $plugin dependency" -m "$LOG";
done;

git push -u origin auto-update/$TIMESTAMP