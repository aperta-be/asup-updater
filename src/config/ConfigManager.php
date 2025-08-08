<?php

declare(strict_types=1);

namespace Asup\Config;

/**
 * Configuration manager that handles different configuration sources and formats
 */
class ConfigManager
{
    private array $config = [];
    private array $defaults = [
        // General settings
        'self_test' => true,
        'dry_run' => false,
        'verbose' => true,
        
        // Git settings
        'git_user_name' => 'ASUP Bot',
        'git_user_email' => 'asup-bot@example.com',
        'git_branch_prefix' => 'asup',
        'git_auto_merge' => false,
        'git_branch_target' => 'main',
        
        // Package manager settings
        'package_manager' => 'composer',
        'update_constraints' => false,
        
        // Notification settings
        'notifications_enabled' => false,
    ];

    public function __construct()
    {
        $this->loadDefaults();
        $this->loadFromEnvironment();
    }

    /**
     * Load default configuration values
     */
    private function loadDefaults(): void
    {
        $this->config = $this->defaults;
    }

    /**
     * Load configuration from environment variables
     */
    private function loadFromEnvironment(): void
    {
        $envMappings = [
            'SELF_TEST' => 'self_test',
            'DRY_RUN' => 'dry_run',
            'VERBOSE' => 'verbose',
            'GIT_USER_NAME' => 'git_user_name',
            'GIT_USER_EMAIL' => 'git_user_email',
            'GIT_BRANCH_PREFIX' => 'git_branch_prefix',
            'GIT_AUTO_MERGE' => 'git_auto_merge',
            'GIT_BRANCH_TARGET' => 'git_branch_target',
            'VCS_PROVIDER' => 'vcs_provider',
            'GIT_HOST' => 'git_host',
            'GIT_USER' => 'git_user',
            'GIT_TOKEN' => 'git_token',
            'GIT_NAMESPACE' => 'git_namespace',
            'GIT_PROJECT' => 'git_project',
            'COMPOSER_UPDATE_CONSTRAINTS' => 'update_constraints',
            'PACKAGE_MANAGER' => 'package_manager',
            'MATTERMOST_HOOK' => 'mattermost_hook',
            'NOTIFICATION_PROVIDER' => 'notification_provider',
        ];

        foreach ($envMappings as $envVar => $configKey) {
            $value = getenv($envVar);
            if ($value !== false) {
                $this->config[$configKey] = $this->parseValue($value);
            }
        }
    }

    /**
     * Load configuration from a file
     *
     * @param string $filePath Path to configuration file
     * @param string $format Format of the file (json, yaml, env)
     */
    public function loadFromFile(string $filePath, string $format = 'auto'): void
    {
        if (!file_exists($filePath)) {
            throw new \RuntimeException("Configuration file not found: {$filePath}");
        }

        if ($format === 'auto') {
            $format = $this->detectFileFormat($filePath);
        }

        switch ($format) {
            case 'json':
                $this->loadFromJsonFile($filePath);
                break;
            case 'yaml':
            case 'yml':
                $this->loadFromYamlFile($filePath);
                break;
            case 'env':
                $this->loadFromEnvFile($filePath);
                break;
            default:
                throw new \InvalidArgumentException("Unsupported configuration format: {$format}");
        }
    }

    /**
     * Get a configuration value
     *
     * @param string $key Configuration key
     * @param mixed $default Default value if key doesn't exist
     * @return mixed
     */
    public function get(string $key, $default = null)
    {
        return $this->config[$key] ?? $default;
    }

    /**
     * Set a configuration value
     *
     * @param string $key Configuration key
     * @param mixed $value Configuration value
     */
    public function set(string $key, $value): void
    {
        $this->config[$key] = $value;
    }

    /**
     * Get all configuration values
     *
     * @return array
     */
    public function getAll(): array
    {
        return $this->config;
    }

    /**
     * Check if a configuration key exists
     *
     * @param string $key Configuration key
     * @return bool
     */
    public function has(string $key): bool
    {
        return isset($this->config[$key]);
    }

    /**
     * Validate required configuration
     *
     * @param array $requiredKeys List of required configuration keys
     * @throws \RuntimeException If required configuration is missing
     */
    public function validateRequired(array $requiredKeys): void
    {
        $missing = [];
        foreach ($requiredKeys as $key) {
            if (!$this->has($key) || $this->get($key) === null || $this->get($key) === '') {
                $missing[] = $key;
            }
        }

        if (!empty($missing)) {
            throw new \RuntimeException(
                "Missing required configuration: " . implode(', ', $missing)
            );
        }
    }

    /**
     * Parse a configuration value to appropriate type
     *
     * @param string $value Raw value
     * @return mixed Parsed value
     */
    private function parseValue(string $value)
    {
        // Handle boolean values
        if (in_array(strtolower($value), ['true', '1', 'yes', 'on'])) {
            return true;
        }
        if (in_array(strtolower($value), ['false', '0', 'no', 'off'])) {
            return false;
        }

        // Handle numeric values
        if (is_numeric($value)) {
            return strpos($value, '.') !== false ? (float)$value : (int)$value;
        }

        // Return as string
        return $value;
    }

    /**
     * Detect file format based on extension
     *
     * @param string $filePath File path
     * @return string Format
     */
    private function detectFileFormat(string $filePath): string
    {
        $extension = strtolower(pathinfo($filePath, PATHINFO_EXTENSION));
        
        switch ($extension) {
            case 'json':
                return 'json';
            case 'yml':
            case 'yaml':
                return 'yaml';
            case 'env':
                return 'env';
            default:
                throw new \InvalidArgumentException("Cannot detect format for file: {$filePath}");
        }
    }

    /**
     * Load configuration from JSON file
     *
     * @param string $filePath File path
     */
    private function loadFromJsonFile(string $filePath): void
    {
        $content = file_get_contents($filePath);
        $data = json_decode($content, true);
        
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new \RuntimeException("Invalid JSON in configuration file: " . json_last_error_msg());
        }

        $this->config = array_merge($this->config, $data);
    }

    /**
     * Load configuration from YAML file
     *
     * @param string $filePath File path
     */
    private function loadFromYamlFile(string $filePath): void
    {
        if (!function_exists('yaml_parse_file')) {
            throw new \RuntimeException("YAML extension not available. Install php-yaml or use JSON/ENV format.");
        }

        $data = yaml_parse_file($filePath);
        if ($data === false) {
            throw new \RuntimeException("Failed to parse YAML configuration file");
        }

        $this->config = array_merge($this->config, $data);
    }

    /**
     * Load configuration from .env file
     *
     * @param string $filePath File path
     */
    private function loadFromEnvFile(string $filePath): void
    {
        $lines = file($filePath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        
        foreach ($lines as $line) {
            if (strpos(trim($line), '#') === 0) {
                continue; // Skip comments
            }

            if (strpos($line, '=') !== false) {
                [$key, $value] = explode('=', $line, 2);
                $key = trim($key);
                $value = trim($value, " \t\n\r\0\x0B\"'");
                
                if (!empty($key)) {
                    $_ENV[$key] = $value;
                    putenv("{$key}={$value}");
                }
            }
        }

        // Reload from environment after loading .env file
        $this->loadFromEnvironment();
    }
}