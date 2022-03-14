# ASUP
Aperta/Automated Security Updates Provider

This Docker container will use a GIT repository to update Drupal core, contrib 
and dependencies via composer.


## Local development
Create a .env file in the "scripts" folder in your local for local development so 
you can test during build phase.

Example content below:

```
COMPOSER_UPDATE_CONSTRAINTS=1
SELF_TEST=1
DRY_RUN=1
VERBOSE=1
APP_PUBLIC_ROOT_DIRECTORY=www
MATTERMOST_HOOK="https://mattermost.dazzle.be/hooks/33akt56za7gu7dmxg1wa5bedtr"
GIT_AUTO_MERGE=1
GITLAB_HOST="gitlab.dazzle.be"
GITLAB_PROJECT_ID="dazzle/brrc-geoportal"
GIT_BRANCH_TARGET="test-branch-kevin"
GIT_CLONE_URL="git@gitlab.dazzle.be:dazzle/brrc-geoportal.git"
GITLAB_TOKEN="ksjdfoz-djfioezjfoizejio"
SSH_PUBLIC_KEY="ssh-ed25519 NzaC1rZXktdjEAAA...."
SSH_PRIVATE_KEY="-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmU...
....AGHRyeXBva2FyaWRvc0BNaW5pWC5sb
-----END OPENSSH PRIVATE KEY-----"
```
### Environment variables explained
- **COMPOSER_UPDATE_CONSTRAINTS**: If set to 1, this system will alter the composer.json file to update constraints
so that the actual latest version is used. This is an advanced feature since it will try to force-update
libraries. Defaults to 0.
- **SELF_TEST**: If set to 0, the system will skip self-testing. Defaults to 1. It's not recommended turning this off
    unless you need to.
- **DRY_RUN**: The DRY_RUN parameter will make sure actual git push commands are not executed and that the
  actions are contained to local run.
- **VERBOSE**: Verbosity level. For now we have only 1.
- **APP_PUBLIC_ROOT_DIRECTORY**: The application's' public accessible directory. Use 0 to use the GIT root. Defaults to web.
- **MATTERMOST_HOOK**: The Mattermost web hook URL for reports.
- 
- **GIT_AUTO_MERGE**: If set to 1, it will auto-merge the security branch back into the GIT_BRANCH_TARGET. 
Defaults to 0.
- **GITLAB_HOST**: The hostname without protocol and without a trailing slash.
- **GITLAB_PROJECT_ID**: The project ID. This is normally the part that follows behind the GITLAB_HOST.
- **GIT_BRANCH_TARGET**: The branch the system will start from. For production this is *master* is most cases.
- **GIT_CLONE_URL**: The clone command provided by Gitlab.
- **GITLAB_TOKEN**: The project token from Gitlab.

- **SSH_PUBLIC_KEY**: Optionally provide a SSH public key. Defaults to (0) docker image SSH public key.
- **SSH_PRIVATE_KEY**: Optionally provide a SSH private key. Defaults to (0) docker image SSH private key.

### Variables that can be inherited from gitlab CI environment
- **GITLAB_HOST**=$CI_SERVER_HOST
- **GITLAB_PROJECT_ID**=$CI_PROJECT_PATH
- **GIT_BRANCH_TARGET**=$CI_COMMIT_BRANCH
- **GIT_CLONE_URL**=`"git@"$CI_SERVER_HOST":"$CI_PROJECT_PATH".git"`
