<?php

declare(strict_types=1);

require_once '/code/api/vendor/autoload.php';
require_once '/code/api/variables.php';
require_once '/code/src/VcsProviderFactory.php';
require_once '/code/src/interfaces/VcsProviderInterface.php';
require_once '/code/src/plugins/vcs/GitlabProvider.php';
require_once '/code/src/plugins/vcs/GithubProvider.php';

use Asup\VcsProviderFactory;

try {
    // Get configuration from environment variables
    $config = [
        'host' => GIT_HOST,
        'token' => GIT_TOKEN,
        'user' => GIT_USER,
        'namespace' => GIT_NAMESPACE,
        'project' => GIT_PROJECT,
    ];

    // Create the appropriate VCS provider
    $vcsProvider = VcsProviderFactory::create(VCS_PROVIDER, $config);

    // Verify provider accessibility
    if (!$vcsProvider->isAccessible()) {
        echo "# Error: Cannot access {$vcsProvider->getProviderName()} repository\n";
        exit(1);
    }

    echo "# Using {$vcsProvider->getProviderName()} provider\n";

    // Close any existing ASUP requests
    $closedCount = $vcsProvider->closeExistingRequests(['asup']);
    if ($closedCount > 0) {
        echo "# Closed {$closedCount} existing ASUP requests\n";
    }

    // Create the merge/pull request
    $requestDetails = $vcsProvider->createMergeRequest(
        GIT_BRANCH_SOURCE,
        GIT_BRANCH_TARGET,
        MERGE_REQUEST_TITLE,
        MERGE_REQUEST_DESCRIPTION,
        ['asup']
    );

    echo "# Created merge/pull request: \"{$requestDetails['title']}\"\n";
    echo "# Request URL: {$requestDetails['url']}\n";

    // Auto-merge if enabled
    if (GIT_AUTO_MERGE === 1) {
        echo "# GIT_AUTO_MERGE is enabled, attempting to merge...\n";
        
        $mergeSuccess = $vcsProvider->mergeRequest($requestDetails['id'], 'Auto-merging dependency updates');
        
        if ($mergeSuccess) {
            echo "# Successfully auto-merged the request\n";
            
            // Clean up the source branch after successful merge
            if ($vcsProvider->deleteBranch(GIT_BRANCH_SOURCE)) {
                echo "# Deleted source branch: " . GIT_BRANCH_SOURCE . "\n";
            }
        } else {
            echo "# Auto-merge failed. Manual intervention may be required.\n";
            echo "# Please review the merge/pull request manually.\n";
        }
    } else {
        echo "# GIT_AUTO_MERGE is disabled. Manual merge required.\n";
    }

} catch (\Exception $e) {
    echo "# Error: " . $e->getMessage() . "\n";
    exit(1);
}