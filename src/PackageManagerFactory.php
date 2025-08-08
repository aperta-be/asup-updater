<?php

declare(strict_types=1);

namespace Asup;

use Asup\Interfaces\PackageManagerInterface;
use Asup\Plugins\PackageManagers\ComposerManager;
use Asup\Plugins\PackageManagers\NpmManager;

/**
 * Factory for creating package manager instances
 */
class PackageManagerFactory
{
    private const MANAGERS = [
        'composer' => ComposerManager::class,
        'npm' => NpmManager::class,
    ];

    /**
     * Create a package manager instance
     *
     * @param string $managerName Name of the package manager
     * @param array $config Configuration array
     * @return PackageManagerInterface
     * @throws \InvalidArgumentException If manager is not supported
     */
    public static function create(string $managerName, array $config): PackageManagerInterface
    {
        $managerName = strtolower($managerName);
        
        if (!isset(self::MANAGERS[$managerName])) {
            throw new \InvalidArgumentException(
                "Unsupported package manager: {$managerName}. Supported managers: " . 
                implode(', ', array_keys(self::MANAGERS))
            );
        }

        $managerClass = self::MANAGERS[$managerName];
        $manager = new $managerClass();
        $manager->initialize($config);

        return $manager;
    }

    /**
     * Auto-detect the package manager for a project
     *
     * @param string $projectPath Path to project directory
     * @return string|null Package manager name or null if none detected
     */
    public static function autoDetect(string $projectPath): ?string
    {
        // Check for package manager config files in order of preference
        $detectionMap = [
            'composer.json' => 'composer',
            'package.json' => 'npm',
            'requirements.txt' => 'pip',
            'Cargo.toml' => 'cargo',
            'go.mod' => 'go',
        ];

        foreach ($detectionMap as $configFile => $manager) {
            if (file_exists($projectPath . '/' . $configFile)) {
                return $manager;
            }
        }

        return null;
    }

    /**
     * Get list of supported package managers
     *
     * @return array
     */
    public static function getSupportedManagers(): array
    {
        return array_keys(self::MANAGERS);
    }

    /**
     * Check if a package manager is supported
     *
     * @param string $managerName
     * @return bool
     */
    public static function isSupported(string $managerName): bool
    {
        return isset(self::MANAGERS[strtolower($managerName)]);
    }

    /**
     * Get all available package managers in the current environment
     *
     * @param array $config Configuration for testing managers
     * @return array Array of available manager names
     */
    public static function getAvailableManagers(array $config = []): array
    {
        $available = [];

        foreach (self::MANAGERS as $managerName => $managerClass) {
            try {
                $manager = new $managerClass();
                $manager->initialize($config);
                
                if ($manager->isAvailable()) {
                    $available[] = $managerName;
                }
            } catch (\Exception $e) {
                // Manager not available, skip
            }
        }

        return $available;
    }
}