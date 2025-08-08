<?php

declare(strict_types=1);

namespace Asup\Interfaces;

/**
 * Interface for notification providers (Mattermost, Slack, Discord, etc.)
 */
interface NotificationProviderInterface
{
    /**
     * Initialize the notification provider with configuration
     *
     * @param array $config Configuration array containing provider-specific settings
     */
    public function initialize(array $config): void;

    /**
     * Send a notification message
     *
     * @param string $message The message content
     * @param array $options Additional options (title, level, etc.)
     * @return bool True if notification was sent successfully
     */
    public function send(string $message, array $options = []): bool;

    /**
     * Send a rich notification with structured content
     *
     * @param array $payload Structured notification payload
     * @return bool True if notification was sent successfully
     */
    public function sendRich(array $payload): bool;

    /**
     * Test the notification provider connection
     *
     * @return bool True if provider is accessible
     */
    public function test(): bool;

    /**
     * Get the provider name
     *
     * @return string Provider name
     */
    public function getProviderName(): string;

    /**
     * Check if the provider supports rich notifications
     *
     * @return bool True if rich notifications are supported
     */
    public function supportsRichNotifications(): bool;
}