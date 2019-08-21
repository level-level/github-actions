#!/bin/sh -l


if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

URI=https://api.github.com
API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

echo "Starting update sequence."
remote_repo="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git config --global user.email "bot-tank-top+al-dente@level-level.com"
git config --global user.name "[BOT] Tanktop Al Dente"
TIMESTAMP=$(date +'%s')
git checkout -b auto-update/$TIMESTAMP
echo "Creating a fresh composer install.";
composer install
echo "Gathering composer outdated information.";
for plugin in $(composer outdated --direct -m -f json | jq -r ".installed[].name");
do
    echo "Updating $plugin.";
    LOG=$(composer update "$plugin" --no-scripts --no-ansi --no-suggest --no-autoloader --no-progress 2>&1 >/dev/null)
    git add composer.lock;
    git commit -m "Update $plugin dependency" -m "$LOG";
done;
git remote rm origin
git remote add origin "${remote_repo}"

echo "Done. Pushing branch.";
git push -u origin auto-update/$TIMESTAMP

echo "Opening pull request.";
curl -XPOST -fsSL \
    -H "${AUTH_HEADER}" \
    -H "${API_HEADER}" \
    -H "Content-Type: application/json" \
    -d "{\"head\":\"auto-update/$TIMESTAMP\", \"base\":\"master\", \"title\":\"Plugin updates\", \"body\":\"Minor updates automatically created.\"}" \
    "${URI}/repos/${GITHUB_REPOSITORY}/pulls"