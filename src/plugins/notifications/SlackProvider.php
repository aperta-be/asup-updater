<?php

declare(strict_types=1);

namespace Asup\Plugins\Notifications;

use Asup\Interfaces\NotificationProviderInterface;

/**
 * Slack notification provider
 */
class SlackProvider implements NotificationProviderInterface
{
    private array $config;
    private string $webhookUrl;

    public function initialize(array $config): void
    {
        $this->config = $config;
        $this->webhookUrl = $config['webhook_url'] ?? '';

        if (empty($this->webhookUrl)) {
            throw new \InvalidArgumentException('Slack webhook URL is required');
        }
    }

    public function send(string $message, array $options = []): bool
    {
        $payload = [
            'text' => $message,
            'username' => $options['username'] ?? 'ASUP Bot',
            'icon_emoji' => $options['icon'] ?? ':robot_face:',
            'channel' => $options['channel'] ?? null,
        ];

        return $this->sendRequest($payload);
    }

    public function sendRich(array $payload): bool
    {
        $slackPayload = [
            'text' => $payload['text'] ?? '',
            'username' => $payload['username'] ?? 'ASUP Bot',
            'icon_emoji' => $payload['icon'] ?? ':robot_face:',
            'channel' => $payload['channel'] ?? null,
        ];

        if (isset($payload['attachments'])) {
            $slackPayload['attachments'] = $this->formatAttachments($payload['attachments']);
        }

        if (isset($payload['blocks'])) {
            $slackPayload['blocks'] = $payload['blocks'];
        }

        return $this->sendRequest($slackPayload);
    }

    public function test(): bool
    {
        return $this->send('ASUP notification test - connection successful! 🚀');
    }

    public function getProviderName(): string
    {
        return 'slack';
    }

    public function supportsRichNotifications(): bool
    {
        return true;
    }

    /**
     * Send HTTP request to Slack webhook
     *
     * @param array $payload Request payload
     * @return bool True if request was successful
     */
    private function sendRequest(array $payload): bool
    {
        $jsonPayload = json_encode($payload);
        
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $this->webhookUrl,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => $jsonPayload,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER => [
                'Content-Type: application/json',
                'Content-Length: ' . strlen($jsonPayload)
            ],
            CURLOPT_TIMEOUT => 10,
            CURLOPT_USERAGENT => 'ASUP/1.0',
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);

        if ($response === false || !empty($error)) {
            error_log("Slack notification failed: {$error}");
            return false;
        }

        if ($httpCode !== 200) {
            error_log("Slack notification failed with HTTP {$httpCode}: {$response}");
            return false;
        }

        return true;
    }

    /**
     * Format attachments for Slack
     *
     * @param array $attachments
     * @return array
     */
    private function formatAttachments(array $attachments): array
    {
        $formatted = [];

        foreach ($attachments as $attachment) {
            $slackAttachment = [
                'color' => $attachment['color'] ?? 'good',
                'title' => $attachment['title'] ?? '',
                'text' => $attachment['text'] ?? '',
                'fields' => [],
            ];

            if (isset($attachment['fields'])) {
                foreach ($attachment['fields'] as $field) {
                    $slackAttachment['fields'][] = [
                        'title' => $field['title'] ?? '',
                        'value' => $field['value'] ?? '',
                        'short' => $field['short'] ?? false,
                    ];
                }
            }

            $formatted[] = $slackAttachment;
        }

        return $formatted;
    }
}