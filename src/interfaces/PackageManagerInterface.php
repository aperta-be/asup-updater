<?php

declare(strict_types=1);

namespace Asup\Interfaces;

/**
 * Interface for package managers (Composer, npm, pip, etc.)
 */
interface PackageManagerInterface
{
    /**
     * Initialize the package manager with configuration
     *
     * @param array $config Configuration array
     */
    public function initialize(array $config): void;

    /**
     * Install packages/dependencies
     *
     * @param array $options Additional options for install
     * @return bool True if installation was successful
     */
    public function install(array $options = []): bool;

    /**
     * Get list of outdated packages
     *
     * @return array Array of outdated packages with current and available versions
     */
    public function getOutdatedPackages(): array;

    /**
     * Update package constraints to allow newer versions
     *
     * @return bool True if constraints were updated successfully
     */
    public function updateConstraints(): bool;

    /**
     * Update all packages to latest versions within constraints
     *
     * @return bool True if update was successful
     */
    public function updateAll(): bool;

    /**
     * Update specific packages
     *
     * @param array $packages List of package names to update
     * @return bool True if update was successful
     */
    public function updatePackages(array $packages): bool;

    /**
     * Check if the package manager is available in the current environment
     *
     * @return bool True if package manager is available
     */
    public function isAvailable(): bool;

    /**
     * Get the name of the package manager
     *
     * @return string Package manager name
     */
    public function getName(): string;

    /**
     * Get the configuration file path for this package manager
     *
     * @return string Path to configuration file (e.g., composer.json, package.json)
     */
    public function getConfigFilePath(): string;

    /**
     * Get the lock file path for this package manager
     *
     * @return string Path to lock file (e.g., composer.lock, package-lock.json)
     */
    public function getLockFilePath(): string;

    /**
     * Generate update report
     *
     * @return array Report with update details
     */
    public function generateReport(): array;

    /**
     * Run security audit to check for vulnerabilities
     *
     * @return array Security audit results
     */
    public function securityAudit(): array;
}