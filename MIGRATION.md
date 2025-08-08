# Migration Guide - ASUP Refactoring

This guide helps migrate from the old ASUP architecture to the new plugin-based system.

## Overview of Changes

ASUP has been significantly refactored to:
- Remove company-specific hardcoded references
- Implement a plugin-based architecture
- Support multiple package managers, VCS providers, and notification systems
- Simplify Docker configuration
- Improve extensibility and maintainability

## Breaking Changes

### 1. Environment Variable Changes

**Old Variables → New Variables:**
```bash
# Authentication
GIT_APERTA_USER → GIT_USER
GIT_APERTA_TOKEN → GIT_TOKEN

# Additional Git Configuration (new)
GIT_USER_NAME → (default: "ASUP Bot")
GIT_USER_EMAIL → (default: "asup-bot@example.com")
GIT_BRANCH_PREFIX → (default: "asup")

# Package Manager Configuration (new)
PACKAGE_MANAGER → (default: "composer", auto-detected)

# Notification Configuration (enhanced)
MATTERMOST_HOOK → Use with NOTIFICATION_PROVIDER=mattermost
NOTIFICATION_PROVIDER → (new: "mattermost", "slack", "email")
```

### 2. Docker Configuration Changes

**Before:**
- Multiple Dockerfiles: `Dockerfile-7.4`, `Dockerfile-8.0`, etc.
- Build command: `docker build -f Dockerfile-8.2 -t asup:8.2 .`

**After:**
- Single unified `Dockerfile`
- Build command: `docker build --build-arg PHP_VERSION=8.2 -t asup:dev-8.2 .`
- Use `./build.local.sh` for automated building

### 3. API Script Changes

**Before:**
- Separate scripts: `gitlab-api.php`, `github-api.php`
- Provider-specific logic

**After:**
- Unified script: `vcs-api.php`
- Plugin-based VCS providers
- Single API interface for all providers

## Migration Steps

### Step 1: Update Environment Variables

1. **Update your `.env` file:**
```bash
# Replace old variables
sed -i 's/GIT_APERTA_USER/GIT_USER/g' .env
sed -i 's/GIT_APERTA_TOKEN/GIT_TOKEN/g' .env

# Add new optional variables
echo "GIT_USER_NAME=ASUP Bot" >> .env
echo "GIT_USER_EMAIL=asup-bot@example.com" >> .env
echo "GIT_BRANCH_PREFIX=asup" >> .env
```

2. **Update CI/CD configuration:**
   - GitHub Actions: Update secret names in workflows
   - GitLab CI: Update variable names in CI settings
   - Other CI systems: Update environment variable references

### Step 2: Update Docker Usage

1. **Remove old version-specific Dockerfiles:**
```bash
rm Dockerfile-7.4 Dockerfile-8.0 Dockerfile-8.1 Dockerfile-8.2
```

2. **Use new build system:**
```bash
# Instead of building specific versions manually
./build.local.sh  # Builds all PHP versions automatically
```

3. **Update run commands:**
```bash
# Old way
docker run --env-file .env asup:8.2

# New way (same, but built differently)
docker run --env-file .env asup:dev-8.2
```

### Step 3: Update Custom Scripts (if any)

If you have custom scripts that call ASUP APIs:

**Before:**
```bash
# Provider-specific calls
php /code/app/php/gitlab-api.php
php /code/app/php/github-api.php
```

**After:**
```bash
# Unified API call
php /code/app/php/vcs-api.php
```

### Step 4: Configuration Format Migration (Optional)

The new system supports multiple configuration formats. You can optionally migrate from `.env` to JSON or YAML:

**JSON Configuration Example:**
```json
{
  "vcs_provider": "gitlab",
  "git_host": "gitlab.example.com",
  "git_user": "your-username",
  "git_token": "your-token",
  "git_namespace": "your-org",
  "git_project": "your-project",
  "package_manager": "composer",
  "notification_provider": "mattermost",
  "mattermost_hook": "https://your-mattermost/hooks/webhook-id"
}
```

**YAML Configuration Example:**
```yaml
vcs_provider: gitlab
git_host: gitlab.example.com
git_user: your-username
git_token: your-token
git_namespace: your-org
git_project: your-project
package_manager: composer
notification_provider: mattermost
mattermost_hook: https://your-mattermost/hooks/webhook-id
```

## New Features Available

### 1. Multiple Package Managers

```bash
# For Composer projects (existing)
PACKAGE_MANAGER=composer

# For npm projects (new)
PACKAGE_MANAGER=npm

# Auto-detection (new)
# Leave unset to auto-detect based on project files
```

### 2. Multiple Notification Providers

```bash
# Mattermost (existing)
NOTIFICATION_PROVIDER=mattermost
MATTERMOST_HOOK=https://your-mattermost/hooks/webhook-id

# Slack (new)
NOTIFICATION_PROVIDER=slack
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/WEBHOOK/URL

# Email (new)
NOTIFICATION_PROVIDER=email
EMAIL_TO=admin@example.com
EMAIL_FROM=asup@example.com
```

### 3. Enhanced VCS Support

The new plugin system makes it easier to add support for additional VCS providers like Bitbucket, Azure DevOps, etc.

## Troubleshooting

### Common Issues

1. **"GIT_APERTA_USER not found"**
   - **Solution:** Update environment variables as shown in Step 1

2. **"Dockerfile-8.2 not found"**
   - **Solution:** Use the new unified Dockerfile and build process

3. **VCS API authentication errors**
   - **Solution:** Verify new variable names and regenerate tokens if needed

4. **Build failures after migration**
   - **Solution:** Clean Docker images and rebuild:
   ```bash
   docker system prune -f
   ./build.local.sh
   ```

### Rollback Plan

If you need to rollback:

1. Keep backup of old Dockerfiles
2. Revert environment variable names
3. Use git to revert to previous commit before migration

### Getting Help

- Check the updated documentation in `docs/`
- Review examples in the updated `.env.example`
- Use `./scripts/debug-report.sh` for troubleshooting
- The new architecture maintains backward compatibility where possible

## Benefits After Migration

- **Extensibility**: Easy to add new VCS providers, package managers, and notification systems
- **Maintainability**: Cleaner codebase with proper abstractions
- **Flexibility**: Support for multiple configuration formats
- **Scalability**: Plugin architecture supports future enhancements
- **Security**: No hardcoded company-specific references
- **Portability**: Works across different organizations and environments

## Timeline

The old API scripts (`gitlab-api.php`, `github-api.php`) are marked as deprecated but still functional through wrapper functions. Plan to complete migration within 3 months, after which legacy support may be removed.