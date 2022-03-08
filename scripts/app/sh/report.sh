function report_mattermost() {

  REPORT="ASUP Drupal updates report\n"
  REPORT="${REPORT}Project: ${GITLAB_PROJECT_ID}\n"
  REG='^[master|main]$'
  if [[ $GIT_BRANCH_TARGET =~ $REG ]]; then REPORT="${REPORT}Branch: ${GIT_BRANCH_TARGET}\n"; else REPORT="${REPORT}Branch: ${GIT_BRANCH_TARGET}\n:warning: This branch is not for production a developer has to test and merge with main branch.\n"; fi
  if [[ $GIT_AUTO_MERGE != "1" ]]; then REPORT="${REPORT}:warning: Git auto merge is not enabled. A developer has to approve and merge the request.\n"; fi
  if ! [ -v ${MERGE_REQUEST_URL+x} ]; then REPORT="${REPORT}Merge request URL: ${MERGE_REQUEST_URL}\n"; fi
  if [[ $COMPOSER_UPDATE_CONSTRAINTS != "1" ]]; then REPORT="${REPORT}:warning: Update constraints is not enabled.\n"; fi
  OUTDATED_TABLE="\n\n\n| Modules | Version | \n|:----------------|:---------------|\n"
  OUTDATED_TABLE="${OUTDATED_TABLE} $(sed -r 's/([a-z_-]+\/[a-z_-]+).* [v]?([0-9]+\.[0-9]+\.[0-9]+).* [v]?([0-9]+\.[0-9]+\.[0-9]+) .*$/| \1 | \2 > \3 |/g' outdated.txt)"

  curl -i -X POST -H 'Content-Type: application/json' -d "{\"text\": \"$REPORT $OUTDATED_TABLE\"}" https://mattermost.backend.gr/hooks/wxyhyob51bby8nhq73arqqepbe
}
