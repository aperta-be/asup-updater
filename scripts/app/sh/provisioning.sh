#!/bin/bash

# Write Gitlab PHP variables file.
function provisioning_write_vars_gitlab() {
  cat > /code/gitlab-api/variables.php <<EOL
    <?php
    /**
     * @file
     *
     * This file is generated.
     */
    const GITLAB_HOST = '$GITLAB_HOST';
    const GITLAB_TOKEN = '$GITLAB_TOKEN';

    const GITLAB_PROJECT_ID = '$GITLAB_PROJECT_ID';
    const GIT_BRANCH_SOURCE = '$GIT_BRANCH_SOURCE';
    const GIT_BRANCH_TARGET = '$GIT_BRANCH_TARGET';

    const GIT_AUTO_MERGE = $GIT_AUTO_MERGE;

    const MERGE_REQUEST_TITLE = 'Automated security MR $ASUP_TIMESTAMP';
    const MERGE_REQUEST_DESCRIPTION = 'Automated MR by ASUP';
EOL
}
