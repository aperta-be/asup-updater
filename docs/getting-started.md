---
layout: default
title: Getting Started
nav_order: 2
---

# Getting Started with ASUP

This guide will help you set up and start using ASUP in your environment.

## Prerequisites

Before installing ASUP, ensure you have:

- Docker (version 20.10.0 or higher)
- Git (version 2.28.0 or higher)
- Access to a GitLab or GitHub repository
- Composer-based PHP project
- Mattermost webhook URL (optional)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/asup.git
cd asup
```

### 2. Run Setup Script

The setup script will help you configure your local environment:

```bash
./scripts/setup-local-env.sh
```

This script:
- Creates a `.env` file from template
- Generates SSH keys
- Builds Docker images for all supported PHP versions
- Validates your setup

### 3. Configure Environment

Edit the `.env` file with your settings:

```env
# General settings
SELF_TEST=1
DRY_RUN=1  # Set to 0 for production
VERBOSE=1

# Project settings
COMPOSER_UPDATE_CONSTRAINTS=0
APP_PUBLIC_ROOT_DIRECTORY=web

# VCS settings
VCS_PROVIDER="gitlab"  # or "github"
GIT_AUTO_MERGE=0
GIT_HOST="gitlab.example.com"
GIT_NAMESPACE="your-namespace"
GIT_PROJECT="your-project"
GIT_BRANCH_TARGET="main"
```

### 4. Set Up VCS Access

#### For GitLab:
1. Go to Settings > Access Tokens
2. Create a token with `api`, `read_repository`, and `write_repository` scopes
3. Add the token to your `.env` file:
   ```env
   GIT_APERTA_USER="your-gitlab-username"
   GIT_APERTA_TOKEN="your-gitlab-token"
   ```

#### For GitHub:
1. Go to Settings > Developer settings > Personal access tokens
2. Create a token with `repo` and `workflow` scopes
3. Add the token to your `.env` file:
   ```env
   GIT_APERTA_USER="your-github-username"
   GIT_APERTA_TOKEN="your-github-token"
   ```

### 5. Add SSH Keys

The setup script generates SSH keys in the `ssh` directory. Add the public key to your Git provider:

1. Display the public key:
   ```bash
   cat ssh/id_asup.pub
   ```

2. Add this key to your Git provider:
   - GitLab: Settings > Repository > Deploy Keys
   - GitHub: Settings > Deploy Keys

### 6. Configure Mattermost (Optional)

If you want notifications:

1. Create a webhook in Mattermost
2. Add the webhook URL to your `.env`:
   ```env
   MATTERMOST_HOOK="https://your-mattermost-instance/hooks/your-webhook-id"
   ```

## First Run

### Test Mode

Start with a dry run to ensure everything is configured correctly:

```bash
# Keep DRY_RUN=1 in .env
docker run --env-file .env your-org/asup:latest
```

### Production Mode

Once tested, update your configuration for production:

1. Set `DRY_RUN=0` in `.env`
2. Set `GIT_AUTO_MERGE=1` if you want automatic merging
3. Run ASUP:
   ```bash
   docker run --env-file .env your-org/asup:latest
   ```

## CI/CD Integration

### GitLab CI

Add this to your `.gitlab-ci.yml`:

```yaml
include:
  - project: 'your-org/asup'
    file: '.gitlab-ci.yml'
```

### GitHub Actions

Add this to your GitHub workflow:

```yaml
uses: your-org/asup/.github/workflows/ci.yml@main
```

## Next Steps

- Read the [Configuration Guide](configuration.md) for detailed settings
- Check the [Architecture Documentation](architecture.md) to understand ASUP's internals
- See [Troubleshooting](troubleshooting.md) if you encounter issues
- Review our [Security Policy](../SECURITY.md) for best practices

## Support

If you need help:
1. Check the [Troubleshooting Guide](troubleshooting.md)
2. Search existing [Issues](https://github.com/your-org/asup/issues)
3. Create a new issue if needed

## Updates

Stay updated with the latest releases:
- Watch the GitHub repository
- Check our [CHANGELOG](../CHANGELOG.md)
- Follow security advisories