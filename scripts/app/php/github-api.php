<?php

include '/code/api/vendor/autoload.php';
include '/code/api/variables.php';

$client = new \Github\Client();

$token = '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';

$client->authenticate($token, null, Github\AuthMethod::CLIENT_ID);
$base_path = GITHUB_HOST . '/' . GITHUB_OWNER . '/' . GITHUB_REPO;

// @todo: Add logic to remove any "old" open MR's.

$pull_request = $client->api('pull_request')->create(GITHUB_OWNER, GITHUB_REPO, [
  'base'  => GIT_BRANCH_TARGET,
  'head'  => GIT_BRANCH_SOURCE,
  'title' => MERGE_REQUEST_TITLE,
  'body' => MERGE_REQUEST_DESCRIPTION,
]);

$pull_id = $pull_request['number'];
$sha = $pull_request['head']['sha'];
$web_path = $base_path . '/pull/' . $pull_id;

// @todo: Labels not working yet, probably because GitHub requires it to exists before you can label it.
$issue = $client->api('issue')->update(GITHUB_OWNER, GITHUB_REPO, $pull_id, [
  'labels' => 'asup',
]);

echo '# Created pull request "' . MERGE_REQUEST_TITLE . '"' . PHP_EOL;
echo '# Pull request URL: ' . $web_path . PHP_EOL;

if (GIT_AUTO_MERGE === 1) {
  echo 'GIT_AUTO_MERGE is true, continuing.'. PHP_EOL;
  // We need to wait a little before merging. If we do it too fast, GitHub didn't have time to
  // calculate if there are any conflicts.
  sleep(5);

  // Merge it.
  try {
    $client->api('pull_request')->merge(GITHUB_OWNER, GITHUB_REPO, $pull_id, 'Automerging.', $sha, $mergeMethod = 'merge', $title = null);
  }
  catch (Exception $e) {
    echo '# Something went wrong here... Could not merge: ' . $e->getMessage() . PHP_EOL;

    if ($e->getCode() === 405) {
      echo '=> Verify the MR manually. This could indicate that there are no differences or automerge is not possible.' . PHP_EOL;
      echo '=> This error should not be happening in any normal case.' . PHP_EOL;
      echo '=> Closing this MR as part of my cleanup.' . PHP_EOL;
      $client->api('pull_request')->update(GITHUB_OWNER, GITHUB_REPO, $pull_id, [
        'state' => 'closed',
        'body' => 'Could not automatically merge. Closing.',
        ]);
      # Check to add label 'asup_error_closure' to the issue (GitHub doesn't allow labels on the actual pull request).
    }

    throw new Exception();
  }
}
else {
  echo 'GIT_AUTO_MERGE is not true, stopping here.' . PHP_EOL;
}