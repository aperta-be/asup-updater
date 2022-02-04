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
COMPOSER_UPDATE_CONSTRAINTS=1
SELF_TEST=1
DRY_RUN=1
SSH_PUBLIC_KEY=123
SSH_PRIVATE_KEY=123
```
### Environment variables explained
- **GIT_AUTO_MERGE**: If set to 1, it will auto-merge the security branch back into the GIT_BRANCH_TARGET. 
Defaults to 0.
- **GITLAB_HOST**: The hostname with protocol and without a trailing slash.
- **GITLAB_TOKEN**: The token from Gitlab.
- **GITLAB_PROJECT_ID**: The project ID. This is normally the part that follows behind the GITLAB_HOST.
- **GIT_BRANCH_TARGET**: The branch the system will start from. For production this is *master* is most cases.
- **GIT_CLONE_URL**: The clone command provided by Gitlab.
- **COMPOSER_UPDATE_CONSTRAINTS**: If set to 1, this system will alter the composer.json file to update constraints
so that the actual latest version is used. This is an advanced feature since it will try to force-update 
libraries. Defaults to 0.
- **SELF_TEST**: If set to 0, the system will skip self-testing. Defaults to 1. It's not recommended turning this off 
unless you need to.
- **DRY_RUN**: The DRY_RUN parameter will make sure actual git push commands are not executed and that the
actions are contained to local run.
- **SSH_PUBLIC_KEY**: Optionally provide a SSH public key. Defaults to 0.
- **SSH_PRIVATE_KEY**: Optionally provide a SSH private key. Defaults to 0.
