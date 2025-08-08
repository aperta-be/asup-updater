<?php

declare(strict_types=1);

namespace Asup\Interfaces;

/**
 * Interface for VCS (Version Control System) providers
 * 
 * This interface defines the common operations that all VCS providers
 * (GitLab, GitHub, Bitbucket, etc.) must implement.
 */
interface VcsProviderInterface
{
    /**
     * Initialize the VCS provider with configuration
     *
     * @param array $config Configuration array containing:
     *                     - host: VCS provider host URL
     *                     - token: Authentication token
     *                     - user: Username for authentication
     *                     - namespace: Organization/group name
     *                     - project: Repository name
     */
    public function initialize(array $config): void;

    /**
     * Create a new branch from the target branch
     *
     * @param string $branchName Name of the new branch to create
     * @param string $fromBranch Base branch to create from
     * @return bool True if branch was created successfully
     */
    public function createBranch(string $branchName, string $fromBranch): bool;

    /**
     * Create a merge/pull request
     *
     * @param string $sourceBranch Source branch name
     * @param string $targetBranch Target branch name  
     * @param string $title Title of the merge/pull request
     * @param string $description Description/body of the merge/pull request
     * @param array $labels Labels to add to the request
     * @return array Request details including ID and URL
     */
    public function createMergeRequest(
        string $sourceBranch,
        string $targetBranch,
        string $title,
        string $description,
        array $labels = []
    ): array;

    /**
     * Close existing merge/pull requests with specific labels
     *
     * @param array $labels Labels to filter requests by
     * @return int Number of requests closed
     */
    public function closeExistingRequests(array $labels = ['asup']): int;

    /**
     * Merge a merge/pull request
     *
     * @param int $requestId ID of the request to merge
     * @param string $commitMessage Optional commit message for merge
     * @return bool True if merge was successful
     */
    public function mergeRequest(int $requestId, string $commitMessage = 'Auto-merge'): bool;

    /**
     * Delete a branch
     *
     * @param string $branchName Name of branch to delete
     * @return bool True if branch was deleted successfully
     */
    public function deleteBranch(string $branchName): bool;

    /**
     * Get the clone URL with authentication for the repository
     *
     * @return string Authenticated clone URL
     */
    public function getAuthenticatedCloneUrl(): string;

    /**
     * Check if the provider is properly configured and accessible
     *
     * @return bool True if provider is accessible
     */
    public function isAccessible(): bool;

    /**
     * Get provider-specific name (gitlab, github, etc.)
     *
     * @return string Provider name
     */
    public function getProviderName(): string;
}