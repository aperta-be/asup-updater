# Changelog
All notable changes to ASUP will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- GitHub Actions support for CI/CD
- Local development setup script (`scripts/setup-local-env.sh`)
- SSH key generation script (`scripts/generate-ssh-keys.sh`)
- Comprehensive documentation for contributors
- Support for PHP 8.2

### Changed
- Updated GitLab CI configuration to use matrix builds
- Improved environment variable handling
- Made the project more generic for all PHP/Composer projects
- Enhanced security measures for sensitive data

### Removed
- Company-specific references and hardcoded values
- Legacy CI templates and factory scripts
- Embedded SSH keys

### Security
- Removed hardcoded API tokens and credentials
- Added secure defaults for environment variables
- Improved SSH key handling
- Enhanced gitignore patterns for sensitive files

## [1.0.0] - YYYY-MM-DD
### Added
- Initial release of ASUP
- Support for automated Composer updates
- GitLab and GitHub VCS provider support
- Multiple PHP version support (7.4, 8.0, 8.1)
- Mattermost integration for notifications
- Docker-based execution environment
- Auto-merge capability for updates
- Dry-run mode for testing
- Self-test functionality
- Composer constraint management

[Unreleased]: https://github.com/your-org/asup/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/your-org/asup/releases/tag/v1.0.0