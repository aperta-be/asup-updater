<?php

declare(strict_types=1);

namespace Asup;

use Asup\Interfaces\NotificationProviderInterface;
use Asup\Plugins\Notifications\MattermostProvider;
use Asup\Plugins\Notifications\SlackProvider;
use Asup\Plugins\Notifications\EmailProvider;

/**
 * Factory for creating notification provider instances
 */
class NotificationProviderFactory
{
    private const PROVIDERS = [
        'mattermost' => MattermostProvider::class,
        'slack' => SlackProvider::class,
        'email' => EmailProvider::class,
    ];

    /**
     * Create a notification provider instance
     *
     * @param string $providerName Name of the notification provider
     * @param array $config Configuration array
     * @return NotificationProviderInterface
     * @throws \InvalidArgumentException If provider is not supported
     */
    public static function create(string $providerName, array $config): NotificationProviderInterface
    {
        $providerName = strtolower($providerName);
        
        if (!isset(self::PROVIDERS[$providerName])) {
            throw new \InvalidArgumentException(
                "Unsupported notification provider: {$providerName}. Supported providers: " . 
                implode(', ', array_keys(self::PROVIDERS))
            );
        }

        $providerClass = self::PROVIDERS[$providerName];
        $provider = new $providerClass();
        $provider->initialize($config);

        return $provider;
    }

    /**
     * Create multiple notification providers from configuration
     *
     * @param array $configurations Array of provider configurations
     * @return array Array of NotificationProviderInterface instances
     */
    public static function createMultiple(array $configurations): array
    {
        $providers = [];

        foreach ($configurations as $config) {
            if (empty($config['provider']) || empty($config['config'])) {
                continue;
            }

            try {
                $providers[] = self::create($config['provider'], $config['config']);
            } catch (\Exception $e) {
                error_log("Failed to create notification provider {$config['provider']}: " . $e->getMessage());
            }
        }

        return $providers;
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