# ASUP Open Source Updater (Automated Software Utility Platform)

[![CI Status](https://github.com/aperta-be/asup-updater/workflows/CI/badge.svg)](https://github.com/aperta-be/asup-updater/actions)
[![Documentation Status](https://github.com/aperta-be/asup-updater/workflows/Documentation/badge.svg)](https://aperta-be.github.io/asup-updater/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PHP Versions](https://img.shields.io/badge/PHP-7.4%20|%208.0%20|%208.1%20|%208.2-blue)](https://github.com/aperta-be/asup-updater)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/aperta-be/asup-updater/blob/main/CONTRIBUTING.md)

ASUP is a powerful Docker-based automation tool that helps maintain secure and up-to-date dependencies in projects. It features a plugin-based architecture supporting multiple package managers (Composer, npm, pip), VCS providers (GitLab, GitHub, Bitbucket), and notification systems (Mattermost, Slack, Email).

## 🚀 Features

- **Automated Updates**: Check and update dependencies across multiple package managers
- **Plugin Architecture**: Extensible system for VCS providers, package managers, and notifications
- **Multiple VCS Support**: GitLab, GitHub, and extensible to other providers
- **Package Manager Support**: Composer, npm, and extensible to pip, cargo, etc.
- **Docker-based**: Consistent execution with configurable PHP versions
- **Multi-PHP Support**: Compatible with PHP 7.4, 8.0, 8.1, and 8.2
- **Flexible Configuration**: Support for ENV, JSON, and YAML configuration formats
- **Security Focused**: Built-in security checks and validations
- **Multiple Notifications**: Mattermost, Slack, Email, and extensible to other providers

## 📋 Requirements

- Docker 20.10.0 or higher
- Git 2.28.0 or higher
- Access to supported VCS provider (GitLab, GitHub, etc.)
- Project with supported package manager (Composer, npm, etc.)

## 🔧 Quick Start

1. **Clone the Repository**
   ```bash
   git clone https://github.com/aperta-be/asup-updater.git
   cd asup
   ```

2. **Run Setup Script**
   ```bash
   ./scripts/setup-local-env.sh
   ```

3. **Configure Environment**
   ```bash
   # Edit .env with your settings
   cp .env.example .env
   ```

4. **Generate SSH Keys**
   ```bash
   ./scripts/generate-ssh-keys.sh your-project
   ```

5. **Run ASUP**
   ```bash
   docker run --env-file .env your-org/asup:latest
   ```

## 📚 Documentation

Comprehensive documentation is available at [https://aperta-be.github.io/asup-updater/](https://aperta-be.github.io/asup-updater/)

- [Getting Started Guide](docs/getting-started.md)
- [Configuration Reference](docs/configuration.md)
- [API Documentation](docs/api.md)
- [Architecture Overview](docs/architecture.md)
- [Troubleshooting Guide](docs/troubleshooting.md)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on how to get involved.

### Development Setup

```bash
# Setup development environment
./scripts/setup-local-env.sh

# Run tests
./test.sh

# Generate debug report
./scripts/debug-report.sh
```

## 🔒 Security

For security-related information and reporting vulnerabilities, please see our [Security Policy](SECURITY.md).

## 📜 License

ASUP is open-source software licensed under the MIT license. See the [LICENSE](LICENSE) file for details.

## 🌟 Support

- 📖 [Documentation](https://aperta-be.github.io/asup-updater/)
- 🐛 [Issue Tracker](https://github.com/aperta-be/asup-updater/issues)
- 💬 [Discussions](https://github.com/aperta-be/asup-updater/discussions)

## ✨ Contributors

Thanks goes to these wonderful people:

<!-- ALL-CONTRIBUTORS-LIST:START -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://allcontributors.org) specification.

## 📊 Project Status

- ✅ Active development
- 🚀 Regular updates
- 💪 Production ready
- 🤝 Accepting contributions

## 🗺️ Roadmap

See our [project roadmap](https://github.com/aperta-be/asup-updater/projects) for planned features and improvements.

## 📣 Stay Informed

- [Release Notes](CHANGELOG.md)
- [GitHub Releases](https://github.com/aperta-be/asup-updater/releases)
- Star this repository to get notified about major updates

---

<p align="center">
  Made with ❤️ by the ASUP team
</p>
