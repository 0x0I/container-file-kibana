#!/bin/bash

set -euo pipefail

# Print all commands executed if DEBUG mode enabled
[ -n "${DEBUG:-""}" ] && set -x

# Ensure we gracefully stop containers when exiting the Dock container
exit_handler='trap "docker stop test-es; docker rm test-es; exit" EXIT INT QUIT TERM'
eval "$exit_handler"

# [Test-Setup]
es_id=$(docker run --detach --name test-es --publish 9200:9200 --env CONFIG_network.host=0.0.0.0 --env CONFIG_discovery.type=single-node 0labs/0x01.elasticsearch:7.6.1_centos-7)

# [Test-Run+Validate]
export GOSS_FILES_PATH=test
export GOSS_WAIT_OPTS='-r 60s -s 1s'
dgoss run --network container:test-es --env-file test/config-test.env testing-kibana:$1
unset GOSS_FILES_PATH
unset GOSS_WAIT_OPTS
