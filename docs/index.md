---
layout: default
title: ASUP Open Source Updater Documentation
nav_order: 1
---

# ASUP Open Source Updater Documentation

Welcome to the documentation for ASUP Open Source Updater, part of the Automated Software Utility Platform (ASUP), a powerful tool for automating dependency updates in projects using Composer and other package managers.

## What is the ASUP Open Source Updater?

The ASUP Open Source Updater is a Docker-based automation tool that helps maintain secure and up-to-date dependencies in projects. It:

- Automatically checks for outdated dependencies
- Creates pull/merge requests with updates
- Supports both GitLab and GitHub
- Provides automated testing
- Offers optional auto-merge capabilities
- Integrates with Mattermost for notifications

## Key Features

### 1. Automated Updates
- Regular dependency checks
- Smart version constraint management
- Composer security audits

### 2. VCS Integration
- Support for GitLab and GitHub
- Automated branch creation
- Pull/Merge request management
- Optional auto-merge functionality

### 3. Testing & Validation
- Automated testing before updates
- Multiple PHP version support (7.4, 8.0, 8.1, 8.2)
- Configurable validation rules

### 4. Notifications
- Mattermost integration
- Customizable notifications
- Detailed update reports

## Quick Start

1. Install Docker and Git
2. Clone the repository:
   ```bash
   git clone https://github.com/your-org/asup.git
   cd asup
   ```

3. Run the setup script:
   ```bash
   ./scripts/setup-local-env.sh
   ```

4. Configure your environment:
   ```bash
   # Edit .env with your settings
   nano .env
   ```

5. Run ASUP:
   ```bash
   docker run --env-file .env your-org/asup:latest
   ```

## Documentation Sections

- [Getting Started](getting-started.md) - Installation and basic setup
- [Configuration](configuration.md) - Detailed configuration options
- [API Documentation](api.md) - API reference and integration guides
- [Architecture](architecture.md) - System design and components
- [Troubleshooting](troubleshooting.md) - Common issues and solutions

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](../CONTRIBUTING.md) for details.

## Security

For security-related information and reporting vulnerabilities, please see our [Security Policy](../SECURITY.md).

## License

ASUP is open-source software licensed under the MIT license. See the [LICENSE](../LICENSE) file for details.