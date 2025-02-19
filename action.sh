#!/bin/bash
if [ -n "$INPUT_USERNAME" ];
	then echo "$INPUT_PASSWORD" | docker login "$INPUT_REGISTRY" -u "$INPUT_USERNAME" --password-stdin
fi

if [ -n "$INPUT_DOCKER_NETWORK" ];
	then INPUT_OPTIONS="$INPUT_OPTIONS --network $INPUT_DOCKER_NETWORK"
fi

# get the parent directory of the runner commands location
RUNNER_TMP_DIR=$(dirname $GITHUB_OUTPUT | xargs dirname)

echo "docker run -v \"/var/run/docker.sock\":\"/var/run/docker.sock\" \
	-v "${RUNNER_TMP_DIR}":"${RUNNER_TMP_DIR}" \
	-e GITHUB_ENV -e GITHUB_OUTPUT -e GITHUB_PATH -e GITHUB_STATE -e GITHUB_STEP_SUMMARY \
	$INPUT_OPTIONS --entrypoint=\"$INPUT_SHELL\" \"$INPUT_IMAGE\" -c \"${INPUT_RUN//$'\n'/;}\""

exec docker run -v "/var/run/docker.sock":"/var/run/docker.sock" \
	-v "${RUNNER_TMP_DIR}":"${RUNNER_TMP_DIR}" \
	-e GITHUB_ENV -e GITHUB_OUTPUT -e GITHUB_PATH -e GITHUB_STATE -e GITHUB_STEP_SUMMARY \
	$INPUT_OPTIONS --entrypoint="$INPUT_SHELL" "$INPUT_IMAGE" -c "${INPUT_RUN//$'\n'/;}"
