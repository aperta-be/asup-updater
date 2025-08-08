<?php

declare(strict_types=1);

namespace Asup\Plugins\PackageManagers;

use Asup\Interfaces\PackageManagerInterface;

/**
 * npm package manager implementation
 */
class NpmManager implements PackageManagerInterface
{
    private array $config;
    private string $workingDirectory;
    private bool $verbose;

    public function initialize(array $config): void
    {
        $this->config = $config;
        $this->workingDirectory = $config['working_directory'] ?? getcwd();
        $this->verbose = $config['verbose'] ?? true;
    }

    public function install(array $options = []): bool
    {
        $args = ['install'];
        $args = array_merge($args, $options);
        
        return $this->runNpmCommand($args);
    }

    public function getOutdatedPackages(): array
    {
        $output = [];
        $exitCode = 0;
        
        exec('npm outdated --json 2>/dev/null', $output, $exitCode);
        
        if (empty($output)) {
            return [];
        }

        $result = json_decode(implode('', $output), true);
        return $result ?? [];
    }

    public function updateConstraints(): bool
    {
        // npm doesn't have direct constraint updating like Composer
        // This would require parsing package.json and updating version ranges
        // For now, return false as this feature needs implementation
        return false;
    }

    public function updateAll(): bool
    {
        return $this->runNpmCommand(['update']);
    }

    public function updatePackages(array $packages): bool
    {
        if (empty($packages)) {
            return true;
        }

        $args = array_merge(['update'], $packages);
        return $this->runNpmCommand($args);
    }

    public function isAvailable(): bool
    {
        $output = [];
        $exitCode = 0;
        exec('npm --version 2>/dev/null', $output, $exitCode);
        return $exitCode === 0;
    }

    public function getName(): string
    {
        return 'npm';
    }

    public function getConfigFilePath(): string
    {
        return $this->workingDirectory . '/package.json';
    }

    public function getLockFilePath(): string
    {
        return $this->workingDirectory . '/package-lock.json';
    }

    public function generateReport(): array
    {
        $outdated = $this->getOutdatedPackages();
        $configExists = file_exists($this->getConfigFilePath());
        $lockExists = file_exists($this->getLockFilePath());

        return [
            'package_manager' => $this->getName(),
            'config_file_exists' => $configExists,
            'lock_file_exists' => $lockExists,
            'outdated_packages_count' => count($outdated),
            'outdated_packages' => $outdated,
        ];
    }

    public function securityAudit(): array
    {
        $output = [];
        $exitCode = 0;
        
        exec('npm audit --json 2>/dev/null', $output, $exitCode);
        
        if (!empty($output)) {
            $result = json_decode(implode('', $output), true);
            return $result ?? [];
        }

        return [
            'status' => 'unavailable',
            'message' => 'npm audit not available'
        ];
    }

    /**
     * Run an npm command
     *
     * @param array $args Command arguments
     * @return bool True if command succeeded
     */
    private function runNpmCommand(array $args): bool
    {
        $command = 'npm ' . implode(' ', array_map('escapeshellarg', $args));
        
        if ($this->verbose) {
            echo "# Running: {$command}\n";
        }

        $output = [];
        $exitCode = 0;
        exec($command . ' 2>&1', $output, $exitCode);

        if ($this->verbose) {
            echo implode("\n", $output) . "\n";
        }

        if ($exitCode !== 0) {
            error_log("npm command failed: {$command}");
            error_log("Output: " . implode("\n", $output));
        }

        return $exitCode === 0;
    }
}