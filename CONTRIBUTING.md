# Contributing to ASUP

First off, thank you for considering contributing to ASUP! It's people like you that make ASUP such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the issue list as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

* Use a clear and descriptive title
* Describe the exact steps which reproduce the problem
* Provide specific examples to demonstrate the steps
* Describe the behavior you observed after following the steps
* Explain which behavior you expected to see instead and why
* Include logs if relevant

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

* Use a clear and descriptive title
* Provide a step-by-step description of the suggested enhancement
* Provide specific examples to demonstrate the steps
* Describe the current behavior and explain which behavior you expected to see instead
* Explain why this enhancement would be useful

### Pull Requests

* Fill in the required template
* Do not include issue numbers in the PR title
* Include screenshots and animated GIFs in your pull request whenever possible
* Follow the PHP coding standards
* Include tests for new functionality
* Document new code based on the Documentation Styleguide

## Development Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone git@github.com:your-username/asup.git
   ```
3. Create a branch:
   ```bash
   git checkout -b name-of-your-bugfix-or-feature
   ```
4. Generate SSH keys for development:
   ```bash
   ./scripts/generate-ssh-keys.sh asup-dev
   ```
5. Set up your environment:
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

## Development Process

1. Make your changes
2. Run the test suite:
   ```bash
   ./test.sh
   ```
3. Build and test with different PHP versions:
   ```bash
   ./build.local.sh
   ```

## Coding Standards

* Use PSR-12 coding standard
* Add comments to explain complex logic
* Keep functions focused and small
* Use meaningful variable names
* Add type hints where possible

### Example Coding Style

```php
<?php

declare(strict_types=1);

namespace Asup\Core;

/**
 * Class description.
 */
class ExampleClass
{
    private string $property;

    public function __construct(string $property)
    {
        $this->property = $property;
    }

    public function getProperty(): string
    {
        return $this->property;
    }
}
```

## Security

Security is a top priority for ASUP. When contributing:

* NEVER commit sensitive information (tokens, passwords, keys)
* Use environment variables for configuration
* Follow secure coding practices
* Report security vulnerabilities privately
* Review code for security implications

### Security Checklist

- [ ] No hardcoded credentials
- [ ] Proper input validation
- [ ] Secure error handling
- [ ] Safe dependency versions
- [ ] Proper file permissions

## Testing

* Write tests for new features
* Update tests for bug fixes
* Ensure all tests pass before submitting PR
* Include both unit and integration tests
* Test with multiple PHP versions

### Running Tests

```bash
# Run all tests
./test.sh

# Run specific test suite
./test.sh --filter TestName
```

## Documentation

* Update README.md if needed
* Document new features
* Update inline documentation
* Keep documentation clear and concise
* Include examples where helpful

## Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line

### Example Commit Message

```
Add support for PHP 8.2

- Update Dockerfile to support PHP 8.2
- Add PHP 8.2 to test matrix
- Update documentation with PHP 8.2 support

Fixes #123
```

## Additional Notes

### Issue and Pull Request Labels

* bug: Something isn't working
* enhancement: New feature or request
* documentation: Improvements or additions to documentation
* security: Security related changes
* good first issue: Good for newcomers

## Questions?

Feel free to open an issue with your question or reach out to the maintainers.

Thank you for contributing to ASUP!