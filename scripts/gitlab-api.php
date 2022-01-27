<?php
include '/code/gitlab-api/vendor/autoload.php';
include '/code/gitlab-api/variables.php';

// Token authentication
$client = new Gitlab\Client();
$client->setUrl(GITLAB_HOST);
$client->authenticate(GITLAB_TOKEN, Gitlab\Client::AUTH_HTTP_TOKEN);

// Create the MR.
$merge_request = $client->mergeRequests()
  ->create(GITLAB_PROJECT_ID,
    GIT_BRANCH_SOURCE,
    GIT_BRANCH_TARGET,
    MERGE_REQUEST_TITLE,
    [
      'description' => MERGE_REQUEST_DESCRIPTION,
      'add_labels' => 'asup',
    ]
  );

// Get the IID from the MR.
$merge_request_iid = $merge_request['iid'];

echo '# Created merge request "' . $merge_request['title'] . '"' . PHP_EOL;
echo '# Merge request URL: ' . $merge_request['web_url'] . PHP_EOL;

if (GIT_AUTO_MERGE === 1) {
  echo 'GIT_AUTO_MERGE is true, continuing.'. PHP_EOL;
  // We need to wait a little before merging. If we do it too fast, Gitlab didn't have time to
  // calculate if there are any conflicts.
  sleep(5);

  // Merge it.
  try {
    $client->mergeRequests()->merge(GITLAB_PROJECT_ID, $merge_request_iid);
  }
  catch (Exception $e) {
    echo '# Something went wrong here... Could not merge: ' . $e->getMessage() . PHP_EOL;

    if ($e->getCode() === 405) {
      echo '=> Verify the MR manually. This could indicate that there are no differences or automerge is not possible.' . PHP_EOL;
      echo '=> This error should not be happening in any normal case.' . PHP_EOL;
      echo '=> Closing this MR as part of my cleanup.' . PHP_EOL;
      $client->mergeRequests()->update(GITLAB_PROJECT_ID, $merge_request_iid, [
        'add_labels' => 'asup_error_closure',
        'state_event' => 'close',
      ]);
    }

    throw new Exception();
  }
}
else {
  echo 'GIT_AUTO_MERGE is not true, stopping here.' . PHP_EOL;
}


// Notes:
// - If the MR already exists, should we try to merge it again?
// - Should we clean up the old branch when we're done here, without failures?