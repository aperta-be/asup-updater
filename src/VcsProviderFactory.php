<?php

declare(strict_types=1);

namespace Asup;

use Asup\Interfaces\VcsProviderInterface;
use Asup\Plugins\Vcs\GitlabProvider;
use Asup\Plugins\Vcs\GithubProvider;

/**
 * Factory for creating VCS provider instances
 */
class VcsProviderFactory
{
    private const PROVIDERS = [
        'gitlab' => GitlabProvider::class,
        'github' => GithubProvider::class,
    ];

    /**
     * Create a VCS provider instance
     *
     * @param string $providerName Name of the VCS provider (gitlab, github, etc.)
     * @param array $config Configuration array
     * @return VcsProviderInterface
     * @throws \InvalidArgumentException If provider is not supported
     */
    public static function create(string $providerName, array $config): VcsProviderInterface
    {
        $providerName = strtolower($providerName);
        
        if (!isset(self::PROVIDERS[$providerName])) {
            throw new \InvalidArgumentException(
                "Unsupported VCS provider: {$providerName}. Supported providers: " . 
                implode(', ', array_keys(self::PROVIDERS))
            );
        }

        $providerClass = self::PROVIDERS[$providerName];
        $provider = new $providerClass();
        $provider->initialize($config);

        return $provider;
    }

    /**
     * Get list of supported providers
     *
     * @return array
     */
    public static function getSupportedProviders(): array
    {
        return array_keys(self::PROVIDERS);
    }

    /**
     * Check if a provider is supported
     *
     * @param string $providerName
     * @return bool
     */
    public static function isSupported(string $providerName): bool
    {
        return isset(self::PROVIDERS[strtolower($providerName)]);
    }
}