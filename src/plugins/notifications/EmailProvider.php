<?php

declare(strict_types=1);

namespace Asup\Plugins\Notifications;

use Asup\Interfaces\NotificationProviderInterface;

/**
 * Email notification provider
 */
class EmailProvider implements NotificationProviderInterface
{
    private array $config;

    public function initialize(array $config): void
    {
        $this->config = $config;

        $required = ['to', 'from'];
        foreach ($required as $key) {
            if (empty($config[$key])) {
                throw new \InvalidArgumentException("Email {$key} is required");
            }
        }
    }

    public function send(string $message, array $options = []): bool
    {
        $subject = $options['subject'] ?? 'ASUP Notification';
        $headers = $this->buildHeaders($options);
        
        return mail($this->config['to'], $subject, $message, $headers);
    }

    public function sendRich(array $payload): bool
    {
        $subject = $payload['subject'] ?? 'ASUP Notification';
        $message = $payload['text'] ?? '';
        
        // Convert rich content to HTML if provided
        if (isset($payload['html'])) {
            $message = $payload['html'];
            $headers = $this->buildHeaders(['content_type' => 'text/html']);
        } else {
            $headers = $this->buildHeaders();
        }
        
        return mail($this->config['to'], $subject, $message, $headers);
    }

    public function test(): bool
    {
        return $this->send(
            'ASUP notification test - connection successful! 🚀',
            ['subject' => 'ASUP Test Notification']
        );
    }

    public function getProviderName(): string
    {
        return 'email';
    }

    public function supportsRichNotifications(): bool
    {
        return true; // Supports HTML emails
    }

    /**
     * Build email headers
     *
     * @param array $options Header options
     * @return string
     */
    private function buildHeaders(array $options = []): string
    {
        $headers = [];
        
        $headers[] = 'From: ' . $this->config['from'];
        
        if (!empty($this->config['reply_to'])) {
            $headers[] = 'Reply-To: ' . $this->config['reply_to'];
        }
        
        $contentType = $options['content_type'] ?? 'text/plain';
        $headers[] = 'Content-Type: ' . $contentType . '; charset=UTF-8';
        $headers[] = 'X-Mailer: ASUP/1.0';
        
        return implode("\r\n", $headers);
    }
}