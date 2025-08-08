<?php

declare(strict_types=1);

namespace Asup\Plugins\Vcs;

use Asup\Interfaces\VcsProviderInterface;
use Github\Client;
use Github\AuthMethod;

/**
 * GitHub VCS provider implementation
 */
class GithubProvider implements VcsProviderInterface
{
    private Client $client;
    private array $config;

    public function initialize(array $config): void
    {
        $this->config = $config;
        
        $this->client = new Client();
        $this->client->authenticate($config['token'], null, AuthMethod::CLIENT_ID);
    }

    public function createBranch(string $branchName, string $fromBranch): bool
    {
        try {
            // Get the SHA of the base branch
            $baseBranch = $this->client->api('repo')->branches(
                $this->config['namespace'],
                $this->config['project']
            )[$fromBranch];

            $this->client->api('git')->references()->create(
                $this->config['namespace'],
                $this->config['project'],
                [
                    'ref' => 'refs/heads/' . $branchName,
                    'sha' => $baseBranch['commit']['sha']
                ]
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
        $pullRequest = $this->client->api('pull_request')->create(
            $this->config['namespace'],
            $this->config['project'],
            [
                'base' => $targetBranch,
                'head' => $sourceBranch,
                'title' => $title,
                'body' => $description,
            ]
        );

        // Add labels if provided
        if (!empty($labels)) {
            $this->client->api('issue')->update(
                $this->config['namespace'],
                $this->config['project'],
                $pullRequest['number'],
                ['labels' => $labels]
            );
        }

        $basePath = $this->config['host'] . '/' . $this->config['namespace'] . '/' . $this->config['project'];

        return [
            'id' => $pullRequest['number'],
            'url' => $basePath . '/pull/' . $pullRequest['number'],
            'title' => $pullRequest['title'],
            'sha' => $pullRequest['head']['sha'],
        ];
    }

    public function closeExistingRequests(array $labels = ['asup']): int
    {
        $closed = 0;
        
        // GitHub doesn't have a direct way to search PRs by labels in the API
        // This is a limitation we'll document
        // For now, we'll just return 0 as this functionality is more complex on GitHub
        
        return $closed;
    }

    public function mergeRequest(int $requestId, string $commitMessage = 'Auto-merge'): bool
    {
        try {
            // Wait a bit before merging to allow GitHub to calculate conflicts
            sleep(5);
            
            // Get PR details to get the SHA
            $pullRequest = $this->client->api('pull_request')->show(
                $this->config['namespace'],
                $this->config['project'],
                $requestId
            );

            $this->client->api('pull_request')->merge(
                $this->config['namespace'],
                $this->config['project'],
                $requestId,
                $commitMessage,
                $pullRequest['head']['sha'],
                'merge'
            );
            return true;
        } catch (\Exception $e) {
            error_log("Failed to merge request: " . $e->getMessage());
            
            // Handle specific GitHub error codes
            if (strpos($e->getMessage(), '405') !== false) {
                error_log("PR may have no differences or auto-merge not possible");
                
                // Close the PR if it can't be merged
                try {
                    $this->client->api('pull_request')->update(
                        $this->config['namespace'],
                        $this->config['project'],
                        $requestId,
                        ['state' => 'closed']
                    );
                } catch (\Exception $closeException) {
                    error_log("Failed to close PR: " . $closeException->getMessage());
                }
            }
            
            return false;
        }
    }

    public function deleteBranch(string $branchName): bool
    {
        try {
            $this->client->api('git')->references()->remove(
                $this->config['namespace'],
                $this->config['project'],
                'heads/' . $branchName
            );
            return true;
        } catch (\Exception $e) {
            error_log("Failed to delete branch: " . $e->getMessage());
            return false;
        }
    }

    public function getAuthenticatedCloneUrl(): string
    {
        $cloneUrl = "https://{$this->config['host']}/{$this->config['namespace']}/{$this->config['project']}.git";
        
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
            $this->client->api('repo')->show($this->config['namespace'], $this->config['project']);
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    public function getProviderName(): string
    {
        return 'github';
    }
}