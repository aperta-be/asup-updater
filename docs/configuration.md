---
layout: default
title: Configuration
nav_order: 3
---

# ASUP Configuration Guide

This guide covers all configuration options available in ASUP and how to use them effectively.

## Configuration File (.env)

ASUP uses environment variables for configuration. These can be set in a `.env` file or through your CI/CD system.

## General Settings

### Core Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `SELF_TEST` | 1 | Enable/disable self-testing before updates |
| `DRY_RUN` | 0 | Run without making actual changes |
| `VERBOSE` | 1 | Enable detailed logging |

### Project Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `COMPOSER_UPDATE_CONSTRAINTS` | 0 | Update version constraints in composer.json |
| `APP_PUBLIC_ROOT_DIRECTORY` | web | Public directory path |

## VCS Configuration

### Provider Settings

| Variable | Required | Description |
|----------|----------|-------------|
| `VCS_PROVIDER` | Yes | `gitlab` or `github` |
| `GIT_HOST` | Yes | VCS host URL |
| `GIT_NAMESPACE` | Yes | Organization/group name |
| `GIT_PROJECT` | Yes | Repository name |

### Branch Management

| Variable | Default | Description |
|----------|---------|-------------|
| `GIT_AUTO_MERGE` | 0 | Automatically merge update branches |
| `GIT_BRANCH_TARGET` | main | Target branch for updates |
| `GIT_BRANCH_SOURCE` | auto | Source branch pattern (auto-generated) |

### Authentication

| Variable | Required | Description |
|----------|----------|-------------|
| `GIT_USER` | Yes | Git provider username |
| `GIT_TOKEN` | Yes | Access token |
| `SSH_PUBLIC_KEY` | No | Custom SSH public key |
| `SSH_PRIVATE_KEY` | No | Custom SSH private key |

## Notifications

### Mattermost Integration

| Variable | Required | Description |
|----------|----------|-------------|
| `MATTERMOST_HOOK` | No | Webhook URL for notifications |

## Advanced Configuration

### Update Strategies

```env
# Conservative updates (recommended for production)
COMPOSER_UPDATE_CONSTRAINTS=0
GIT_AUTO_MERGE=0

# Aggressive updates (use with caution)
COMPOSER_UPDATE_CONSTRAINTS=1
GIT_AUTO_MERGE=1
```

### Custom SSH Keys

```env
# Use custom SSH keys
SSH_PUBLIC_KEY="ssh-ed25519 AAAAC3..."
SSH_PRIVATE_KEY="-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----"
```

## CI/CD Configuration

### GitLab CI Variables

```yaml
variables:
  GIT_STRATEGY: clone
  GIT_DEPTH: 0
  COMPOSER_UPDATE_CONSTRAINTS: 1
```

### GitHub Actions Secrets

```yaml
env:
  GIT_TOKEN: ${{ secrets.GIT_TOKEN }}
  MATTERMOST_HOOK: ${{ secrets.MATTERMOST_HOOK }}
```

## Configuration Examples

### Basic Production Setup

```env
# General
SELF_TEST=1
DRY_RUN=0
VERBOSE=1

# Project
COMPOSER_UPDATE_CONSTRAINTS=0
APP_PUBLIC_ROOT_DIRECTORY=web

# VCS (GitLab)
VCS_PROVIDER=gitlab
GIT_AUTO_MERGE=0
GIT_HOST=gitlab.example.com
GIT_NAMESPACE=your-org
GIT_PROJECT=your-project
GIT_BRANCH_TARGET=main

# Authentication
GIT_USER=your-username
GIT_TOKEN=your-token

# Notifications
MATTERMOST_HOOK=https://your-mattermost/hooks/your-webhook
```

### Development Setup

```env
# General
SELF_TEST=1
DRY_RUN=1
VERBOSE=1

# Project
COMPOSER_UPDATE_CONSTRAINTS=1
APP_PUBLIC_ROOT_DIRECTORY=web

# VCS (GitHub)
VCS_PROVIDER=github
GIT_AUTO_MERGE=0
GIT_HOST=github.com
GIT_NAMESPACE=your-username
GIT_PROJECT=your-project
GIT_BRANCH_TARGET=develop
```

## Best Practices

1. **Security**
   - Use separate tokens for development and production
   - Regularly rotate access tokens
   - Never commit `.env` files

2. **Testing**
   - Always start with `DRY_RUN=1`
   - Test configuration changes in development first
   - Use `SELF_TEST=1` in production

3. **Version Control**
   - Use meaningful branch names
   - Consider using protected branches
   - Review auto-generated merge requests

4. **Monitoring**
   - Enable verbose logging in development
   - Configure Mattermost notifications
   - Regular check of update logs

## Troubleshooting

Common configuration issues and solutions:

1. **Authentication Failures**
   - Verify token permissions
   - Check SSH key deployment
   - Validate Git provider access

2. **Update Issues**
   - Check composer.json validity
   - Verify branch permissions
   - Review update constraints

3. **Notification Problems**
   - Validate webhook URL
   - Check Mattermost permissions
   - Verify network access

For more detailed troubleshooting, see the [Troubleshooting Guide](troubleshooting.md).