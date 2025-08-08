# Contributing to ASUP

Thank you for your interest in contributing to ASUP\! This document provides guidelines for contributing to the project.

## How to Contribute

### 🐛 Reporting Bugs
1. Check existing issues first to avoid duplicates
2. Provide detailed information: OS, Docker version, configuration, error messages
3. Include reproduction steps when possible

### 💡 Suggesting Features
1. Check existing feature requests to avoid duplicates
2. Explain the use case and why it would benefit the community
3. Consider if it fits the plugin architecture

### 🔌 Adding New Plugins

#### VCS Providers
1. Implement `VcsProviderInterface` in `src/plugins/vcs/`
2. Register in `VcsProviderFactory::PROVIDERS`
3. Add tests and documentation

#### Package Managers
1. Implement `PackageManagerInterface` in `src/plugins/package-managers/`
2. Register in `PackageManagerFactory::MANAGERS`
3. Add detection logic to `autoDetect()` method

#### Notification Providers
1. Implement `NotificationProviderInterface` in `src/plugins/notifications/`
2. Register in `NotificationProviderFactory::PROVIDERS`
3. Support both simple and rich notifications

### 🔧 Development Setup

1. Clone and setup:
   ```bash
   git clone https://github.com/aperta-be/asup-updater.git
   cd asup
   ./scripts/setup-local-env.sh
   ```

2. Configure:
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

3. Build and test:
   ```bash
   ./build.local.sh
   ./test.sh
   ```

### 📝 Code Style
- PHP: Follow PSR-12 standards
- Shell Scripts: Use bash best practices
- Use descriptive, generic names (avoid company-specific terms)

### 🧪 Testing
- Add tests for new functionality
- Ensure compatibility across PHP versions
- Run quality checks before submitting

## Pull Request Process

1. Fork and create a feature branch
2. Make changes following guidelines
3. Add tests and update documentation
4. Run quality checks:
   ```bash
   vendor/bin/phpcs --standard=phpcs.xml
   vendor/bin/phpstan analyse
   ./test.sh
   ```
5. Create PR with clear description

Thank you for helping make ASUP better\! 🚀
EOF < /dev/null