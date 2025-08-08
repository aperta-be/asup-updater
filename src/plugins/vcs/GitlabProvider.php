<?php

declare(strict_types=1);

namespace Asup\Plugins\Vcs;

use Asup\Interfaces\VcsProviderInterface;
use Gitlab\Client;

/**
 * GitLab VCS provider implementation
 */
class GitlabProvider implements VcsProviderInterface
{
    private Client $client;
    private array $config;
    private string $projectPath;

    public function initialize(array $config): void
    {
        $this->config = $config;
        $this->projectPath = $config['namespace'] . '/' . $config['project'];
        
        $this->client = new Client();
        $this->client->setUrl($config['host']);
        $this->client->authenticate($config['token'], Client::AUTH_HTTP_TOKEN);
    }

    public function createBranch(string $branchName, string $fromBranch): bool
    {
        try {
            $this->client->repositories()->createBranch(
                $this->projectPath,
                $branchName,
                $fromBranch
            );
            return true;
        } catch (\Exception $e) {
            error_log("Failed to create branch: " . $e->getMessage());
            return false;
        }
    }

    public function createMergeRequest(
        string $sourceBranch,
        string $targetBranch,
        string $title,
        string $description,
        array $labels = []
    ): array {
        $mergeRequest = $this->client->mergeRequests()->create(
            $this->projectPath,
            $sourceBranch,
            $targetBranch,
            $title,
            [
                'description' => $description,
                'add_labels' => implode(',', $labels),
            ]
        );

        return [
            'id' => $mergeRequest['iid'],
            'url' => $mergeRequest['web_url'],
            'title' => $mergeRequest['title'],
        ];
    }

    public function closeExistingRequests(array $labels = ['asup']): int
    {
        $closed = 0;
        $mergeRequests = $this->client->mergeRequests()->all(
            $this->projectPath,
            ['labels' => implode(',', $labels)]
        );

        foreach ($mergeRequests as $mergeRequest) {
            if ($mergeRequest['state'] === 'closed') {
                continue;
            }

            // Close the merge request
            $this->client->mergeRequests()->update(
                $this->projectPath,
                $mergeRequest['iid'],
                ['state_event' => 'close']
            );

            // Delete the source branch if it exists
            $sourceBranch = $mergeRequest['source_branch'];
            $branches = $this->client->repositories()->branches(
                $this->projectPath,
                ['search' => $sourceBranch]
            );

            if (!empty($branches)) {
                $this->deleteBranch($sourceBranch);
            }

            $closed++;
        }

        return $closed;
    }

    public function mergeRequest(int $requestId, string $commitMessage = 'Auto-merge'): bool
    {
        try {
            // Wait a bit before merging to allow GitLab to calculate conflicts
            sleep(5);
            
            $this->client->mergeRequests()->merge(
                $this->projectPath,
                $requestId,
                $commitMessage
            );
            return true;
        } catch (\Exception $e) {
            error_log("Failed to merge request: " . $e->getMessage());
            return false;
        }
    }

    public function deleteBranch(string $branchName): bool
    {
        try {
            $this->client->repositories()->deleteBranch($this->projectPath, $branchName);
            return true;
        } catch (\Exception $e) {
            error_log("Failed to delete branch: " . $e->getMessage());
            return false;
        }
    }

    public function getAuthenticatedCloneUrl(): string
    {
        $cloneUrl = "https://{$this->config['host']}/{$this->projectPath}.git";
        
        // Add authentication to URL
        return str_replace(
            'https://',
            "https://{$this->config['user']}:{$this->config['token']}@",
            $cloneUrl
        );
    }

    public function isAccessible(): bool
    {
        try {
            $this->client->projects()->show($this->projectPath);
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    public function getProviderName(): string
    {
        return 'gitlab';
    }
}