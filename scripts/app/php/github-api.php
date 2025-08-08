<?php

include '/code/api/vendor/autoload.php';
include '/code/api/variables.php';

$client = new \Github\Client();

$client->authenticate(GIT_TOKEN, null, Github\AuthMethod::CLIENT_ID);
$base_path = GIT_HOST . '/' . GIT_NAMESPACE . '/' . GIT_PROJECT;

// @todo: Add logic to remove any "old" open MR's.
// This doesn't seem to easy since the GitHub API doesn't allow much flexibility in "listing/searching".

$pull_request = $client->api('pull_request')->create(GIT_NAMESPACE, GIT_PROJECT, [
  'base'  => GIT_BRANCH_TARGET,
  'head'  => GIT_BRANCH_SOURCE,
  'title' => MERGE_REQUEST_TITLE,
  'body' => MERGE_REQUEST_DESCRIPTION,
]);

$pull_id = $pull_request['number'];
$sha = $pull_request['head']['sha'];
$web_path = $base_path . '/pull/' . $pull_id;


$issue = $client->api('issue')->update(GIT_NAMESPACE, GIT_PROJECT, $pull_id, [
  'labels' => ['asup'],
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
    $client->api('pull_request')->merge(GIT_NAMESPACE, GIT_PROJECT, $pull_id, 'Automerging.', $sha, $mergeMethod = 'merge', $title = null);
  }
  catch (Exception $e) {
    echo '# Something went wrong here... Could not merge: ' . $e->getMessage() . PHP_EOL;

    if ($e->getCode() === 405) {
      echo '=> Verify the MR manually. This could indicate that there are no differences or automerge is not possible.' . PHP_EOL;
      echo '=> This error should not be happening in any normal case.' . PHP_EOL;
      echo '=> Closing this MR as part of my cleanup.' . PHP_EOL;

      $issue = $client->api('issue')->update(GIT_NAMESPACE, GIT_PROJECT, $pull_id, [
        'labels' => ['asup_error_closure'],
      ]);

      $client->api('pull_request')->update(GIT_NAMESPACE, GIT_PROJECT, $pull_id, [
        'state' => 'closed',
        'body' => 'Could not automatically merge. Closing.',
        ]);
    }

    throw new Exception();
  }
}
else {
  echo 'GIT_AUTO_MERGE is not true, stopping here.' . PHP_EOL;
}
