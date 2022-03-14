function report_mattermost() {

  REPORT="##### ASUP Drupal updates report\n"
  REPORT="${REPORT}Project: ${GITLAB_PROJECT_ID}, Branch: ${GIT_BRANCH_TARGET}\n"
  REPORT="${REPORT}Update: ${COMPOSER_REPORT}\n"

  if [[ "$COMPOSER_REPORT" == "Core update OK." ]]; then
    REG='^[master|main]$'
    if ! [[ $GIT_BRANCH_TARGET =~ $REG ]]; then REPORT="${REPORT}:warning: This branch is not for production. A developer has to test and merge with main branch.\n"; fi
    if [[ $GIT_AUTO_MERGE != "1" ]]; then REPORT="${REPORT}:warning: Git auto merge is not enabled. A developer has to approve and merge the request.\n"; fi
    if ! [ -v ${MERGE_REQUEST_URL+x} ]; then REPORT="${REPORT}Merge request URL: ${MERGE_REQUEST_URL}\n"; fi
  fi;

  OUTDATED_FILE="$(grep 'drupal\|drush' outdated.txt)"
  if [ -n "${OUTDATED_FILE// }" ]; then
    echo "OUTDATED_FILE is not empty"
    if [[ $COMPOSER_UPDATE_CONSTRAINTS != "1" ]]; then REPORT="${REPORT}:warning: Update constraints is not enabled.\n"; fi
    OUTDATED_TABLE="\n\n\n| Modules | Version | \n|:----------------|:---------------|\n"
    OUTDATED_TABLE="${OUTDATED_TABLE} $(echo "${OUTDATED_FILE}" | sed -r 's/([a-z_-]+\/[a-z_-]+).* [v]?([0-9]+\.[0-9]+\.[0-9]+(-beta[0-9]+|-alpha[0-9]+|-dev[0-9]+)?).* [v]?([0-9]+\.[0-9]+\.[0-9]+(-beta[0-9]+|-alpha[0-9]+|-dev[0-9]+)?).*$/| \1 | \2 > \4 |/g')"
  fi

  curl -i -X POST -H 'Content-Type: application/json' -d "{\"username\": \"ASUP\", \"text\": \"$REPORT $OUTDATED_TABLE\"}" "$MATTERMOST_HOOK"
}
