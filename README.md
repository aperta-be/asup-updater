# ASUP
Aperta/Automated Security Updates Provider

This Docker container will use a GIT repository to update Drupal core, contrib 
and dependencies via composer.


## Local development
Create a .env file in the "scripts" folder in your local for local development so 
you can test during build phase.

Example content below:

```
GIT_AUTO_MERGE=1
GITLAB_HOST="https://gitlab.dazzle.be"
GITLAB_TOKEN="ksjdfoz-djfioezjfoizejio"
GITLAB_PROJECT_ID="dazzle/brrc-geoportal"
GIT_BRANCH_TARGET="test-branch-kevin"
GIT_CLONE_URL="git@gitlab.dazzle.be:dazzle/brrc-geoportal.git"

DRY_RUN=1
```
The DRY_RUN parameter will make sure actual git push commands are not executed and that the 
actions are contained to local run.
