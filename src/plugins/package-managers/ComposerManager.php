<?php

declare(strict_types=1);

namespace Asup\Plugins\PackageManagers;

use Asup\Interfaces\PackageManagerInterface;

/**
 * Composer package manager implementation
 */
class ComposerManager implements PackageManagerInterface
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
        $args = ['install', '--no-cache', '--prefer-dist'];
        
        if (!$this->verbose) {
            $args[] = '--quiet';
        }

        $args = array_merge($args, $options);
        
        return $this->runComposerCommand($args);
    }

    public function getOutdatedPackages(): array
    {
        $output = [];
        $exitCode = 0;
        
        exec('composer outdated --direct --format=json 2>/dev/null', $output, $exitCode);
        
        if ($exitCode !== 0) {
            return [];
        }

        $result = json_decode(implode('', $output), true);
        return $result['installed'] ?? [];
    }

    public function updateConstraints(): bool
    {
        // This would need to be implemented based on the UV script logic
        // For now, let's create a placeholder that calls the existing UV script
        $uvScript = '/code/app/php/uv.php';
        if (file_exists($uvScript)) {
            $output = [];
            $exitCode = 0;
            exec("php {$uvScript}", $output, $exitCode);
            return $exitCode === 0;
        }
        
        return false;
    }

    public function updateAll(): bool
    {
        $args = ['update'];
        
        if (!$this->verbose) {
            $args[] = '--quiet';
        }
        
        return $this->runComposerCommand($args);
    }

    public function updatePackages(array $packages): bool
    {
        if (empty($packages)) {
            return true;
        }

        $args = array_merge(['update'], $packages);
        
        if (!$this->verbose) {
            $args[] = '--quiet';
        }
        
        return $this->runComposerCommand($args);
    }

    public function isAvailable(): bool
    {
        $output = [];
        $exitCode = 0;
        exec('composer --version 2>/dev/null', $output, $exitCode);
        return $exitCode === 0;
    }

    public function getName(): string
    {
        return 'composer';
    }

    public function getConfigFilePath(): string
    {
        return $this->workingDirectory . '/composer.json';
    }

    public function getLockFilePath(): string
    {
        return $this->workingDirectory . '/composer.lock';
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
        
        // Run composer audit if available (Composer 2.4+)
        exec('composer audit --format=json 2>/dev/null', $output, $exitCode);
        
        if ($exitCode === 0) {
            $result = json_decode(implode('', $output), true);
            return $result ?? [];
        }

        // Fallback to security:check if available (older versions)
        exec('composer security:check --format=json 2>/dev/null', $output, $exitCode);
        
        if ($exitCode === 0) {
            $result = json_decode(implode('', $output), true);
            return $result ?? [];
        }

        return [
            'status' => 'unavailable',
            'message' => 'Security audit not available in this Composer version'
        ];
    }

    /**
     * Run a composer command
     *
     * @param array $args Command arguments
     * @return bool True if command succeeded
     */
    private function runComposerCommand(array $args): bool
    {
        $command = 'composer ' . implode(' ', array_map('escapeshellarg', $args));
        
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
            error_log("Composer command failed: {$command}");
            error_log("Output: " . implode("\n", $output));
        }

        return $exitCode === 0;
    }
}