---
layout: default
title: API Documentation
nav_order: 6
---

# API Documentation

ASUP provides several integration points and APIs for extending its functionality.

## VCS Provider API

### Interface Definition

```php
interface VcsProviderInterface
{
    public function authenticate(): bool;
    public function cloneRepository(): bool;
    public function createBranch(string $name): bool;
    public function pushChanges(): bool;
    public function createMergeRequest(array $options): array;
    public function autoMerge(int $requestId): bool;
}
```

### Implementation Example

```php
use Asup\VCS\VcsProviderInterface;

class GitLabProvider implements VcsProviderInterface
{
    public function authenticate(): bool
    {
        // Implementation
    }
    
    // Other method implementations...
}
```

## Notification API

### Interface Definition

```php
interface NotificationProviderInterface
{
    public function send(string $message): bool;
    public function formatMessage(array $data): string;
    public function validateConfig(): bool;
}
```

### Usage Example

```php
$notifier = new MattermostNotifier($webhookUrl);
$notifier->send('Update completed successfully');
```

## Update Strategy API

### Interface Definition

```php
interface UpdateStrategyInterface
{
    public function analyze(): array;
    public function planUpdates(): array;
    public function applyUpdates(): bool;
    public function validate(): bool;
}
```

### Custom Strategy Example

```php
class ConservativeStrategy implements UpdateStrategyInterface
{
    public function analyze(): array
    {
        // Implementation
    }
    
    // Other method implementations...
}
```

## Event System

### Available Events

```php
const EVENTS = [
    'pre.update',
    'post.update',
    'pre.merge',
    'post.merge',
    'error',
    'notification'
];
```

### Event Listener Example

```php
$asup->on('pre.update', function($event) {
    // Handle pre-update event
});
```

## HTTP Endpoints

When running in server mode, ASUP provides these HTTP endpoints:

### Status Endpoint

```http
GET /api/status
```

Response:
```json
{
    "status": "active",
    "version": "1.0.0",
    "lastUpdate": "2025-04-14T12:00:00Z",
    "pendingUpdates": 0
}
```

### Trigger Update

```http
POST /api/trigger
Content-Type: application/json

{
    "repository": "org/repo",
    "branch": "main",
    "options": {
        "autoMerge": true
    }
}
```

### Configuration

```http
GET /api/config
Authorization: Bearer <token>
```

Response:
```json
{
    "vcsProvider": "gitlab",
    "updateStrategy": "conservative",
    "notifications": ["mattermost"],
    "autoMerge": false
}
```

## CLI Interface

ASUP can be controlled via CLI:

```bash
# Check status
asup status

# Trigger update
asup update --repo=org/repo --branch=main

# Configure
asup config set autoMerge true
```

## Extension Points

### Custom VCS Provider

```php
// Register custom VCS provider
Asup::registerVcsProvider('custom', CustomVcsProvider::class);

// Use in configuration
VCS_PROVIDER=custom
```

### Custom Notifier

```php
// Register custom notifier
Asup::registerNotifier('slack', SlackNotifier::class);

// Use in configuration
NOTIFICATION_PROVIDER=slack
```

### Custom Update Strategy

```php
// Register custom strategy
Asup::registerStrategy('careful', CarefulStrategy::class);

// Use in configuration
UPDATE_STRATEGY=careful
```

## Error Handling

### Error Codes

| Code | Description |
|------|-------------|
| 1000 | Authentication Failed |
| 1001 | Network Error |
| 1002 | Update Conflict |
| 1003 | Validation Failed |

### Error Response Format

```json
{
    "error": {
        "code": 1000,
        "message": "Authentication failed",
        "details": {
            "provider": "gitlab",
            "reason": "Invalid token"
        }
    }
}
```

## Rate Limiting

API endpoints are rate limited:

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1618408800
```

## Webhook Integration

### Incoming Webhooks

Configure external services to notify ASUP:

```http
POST /webhook/github
Content-Type: application/json

{
    "ref": "refs/heads/main",
    "repository": {
        "full_name": "org/repo"
    }
}
```

### Outgoing Webhooks

ASUP can notify external services:

```php
// Register webhook
Asup::registerWebhook('https://api.example.com/webhook', [
    'events' => ['update.complete', 'error'],
    'secret' => 'webhook-secret'
]);
```

## API Versioning

The API is versioned through the URL:

```
/api/v1/status
/api/v2/status
```

Current stable version: v1

## Authentication

### Token Authentication

```http
Authorization: Bearer <token>
```

### SSH Authentication

```php
// Register SSH key
Asup::registerSshKey('/path/to/key');
```

## Testing

### Mock Classes

```php
use Asup\Testing\MockVcsProvider;
use Asup\Testing\MockNotifier;

// Use in tests
$asup = new Asup(new MockVcsProvider());
```

### Test Helpers

```php
use Asup\Testing\TestHelper;

// Create test environment
TestHelper::createTestEnv();

// Clean up
TestHelper::cleanup();
```

## Best Practices

1. **Error Handling**
   - Always check return values
   - Use try-catch blocks
   - Log errors appropriately

2. **Rate Limiting**
   - Implement exponential backoff
   - Cache responses
   - Respect API limits

3. **Security**
   - Validate all inputs
   - Use secure tokens
   - Implement timeouts

4. **Performance**
   - Use batch operations
   - Cache where possible
   - Implement retry logic