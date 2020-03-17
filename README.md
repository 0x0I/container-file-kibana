<p><img src="https://avatars1.githubusercontent.com/u/12563465?s=200&v=4" alt="OCI logo" title="oci" align="left" height="70" /></p>
<p><img src="https://seeklogo.com/images/K/kibana-logo-3CB40921E7-seeklogo.com.png" alt="kibana logo" title="kibana" align="right" height="60" /></p>

Container File :microscope: :stars: Kibana
=========
![GitHub release (latest by date)](https://img.shields.io/github/v/release/0x0I/container-file-kibana?color=yellow)
[![Build Status](https://travis-ci.org/0x0I/container-file-kibana.svg?branch=master)](https://travis-ci.org/0x0I/container-file-kibana)
[![Docker Pulls](https://img.shields.io/docker/pulls/0labs/0x01.kibana?style=flat)](https://hub.docker.com/repository/docker/0labs/0x01.kibana)
[![License: MIT](https://img.shields.io/badge/License-MIT-blueviolet.svg)](https://opensource.org/licenses/MIT)

**Table of Contents**
  - [Supported Platforms](#supported-platforms)
  - [Requirements](#requirements)
  - [Environment Variables](#environment-variables)
      - [Config](#config)
      - [Launch](#launch)
  - [Dependencies](#dependencies)
  - [Example Run](#example-run)
  - [License](#license)
  - [Author Information](#author-information)

Container file that installs, configures and launches Kibana: an analytics and visualization platform designed to operate with Elasticsearch.

##### Supported Platforms:
```
* Redhat(CentOS/Fedora)
* Ubuntu
* Debian
```

Requirements
------------

None

Environment Variables
--------------
Variables are available and organized according to the following software & machine provisioning stages:
* _config_
* _launch_

#### Config

**Kibana** supports specification of various options controlling aspects of its operational behavior and profile. Each configuration can be expressed within a `YAML` configuration file, `kibana.yml` by default, composed of **key=vaue** pairs representing configuration properties available. Each of these configurations can be expressed using environment variables prefixed with `CONFIG_` organized according to the following:

For additional details and to get an idea how each config should look, reference Kibana's official [configuration](https://www.elastic.co/guide/en/kibana/current/settings.html) documentation.

_The following variables can be customized to manage the location and content of these configurations:_

Each configuration applied to the operational behavior of the server can be expressed using environment variables prefixed with `CONFIG_` organized according to the following:
* **kibana(server) settings** - various settings related to server operational in addition to local/remote identity broadcasting behavior
* **elasticsearch connectivity** - settings which manage connectivity parameters with an Elasticsearch cluster as well Kibana index sharding/replication management
* **operations** - controls output level and frequency of operational data (e.g. logs, metrics)

`$CONFIG_<config-property> = <property-value (string)>` **default**: *None*

* Any configuration setting/value key-pair supported by `kibana` should be expressible within each `CONFIG_` environment variable and properly rendered within the associated `kibana.yml`. **Note:** `<config-property>` along with the `property-value` specifications should be written as expected to be rendered within the associated *properties* config (**e.g.** `CONFIG_server.name=example_kibana` or  `CONFIG_server.host=0.0.0.0`).

Furthermore, configuration is not constrained by hardcoded author defined defaults or limited by pre-baked templating. If the config section, setting and value are recognized by your `Kibana` version, :thumbsup: to define within an environnment variable according to the following syntax.

  `<config-property>` -- represents a specific configuration property to set:

  ```bash
  # Property: elasticsearch.hosts (URLs of the Elasticsearch instances to use for all your queries)
  CONFIG_elasticsearch.hosts=<property-value>
  ```

  `<property-value>` -- represents property value to configure:
  ```bash
  # Property: elasticsearch.hosts
  # Value: list of Elasticsearch instances ['es1.cluster.domain', 'es2.cluster.domain']
  CONFIG_elasticsearch.hosts="['es1.cluster.domain', 'es2.cluster.domain']"
  ```

  A list of configurable *Kibana* settings can be found [here](https://github.com/elastic/kibana/blob/master/config/kibana.yml).

#### Launch

Running a `kibana` instance is accomplished utilizing official **Kibana** binaries published and available [here](https://www.elastic.co/downloads/past-releases#kibana). Launched subject to the configuration and execution potential provided by the underlying application, a `Kibana` instance can be set to adhere to system administrative policies right for your environment and organization.

_The following variables can be customized to manage Kibana's execution profile/policy:_

`$EXTRA_RUN_ARGS: <kibana-cli-options>` (**default**: *NONE*)
- list of `kibana` commandline arguments to pass to the binary at runtime for customizing launch.

Supporting full expression of `kibana`'s cli, this variable enables the role of target hosts to be customized according to the user's specification; whether to specify a particular port for the Node server to listen on, running an instance in a verbose or silent logging mode or passing a list of Elasticsearch instances to connect to.

  A list of available command-line options can be found [here](https://gist.github.com/0x0I/ac0becf96aa6d18fd8f8f29c3a1d0c1c).

##### Examples

  Prevent all logging or most logging with the exception of errors:
  ```bash
  EXTRA_RUN_ARGS=--silent  # prevent all logging
  # ...or...
  EXTRA_RUN_ARGS=--quiet  # turn off logging with exception of errors
  ```

  Modify bind host to accept connections from remote clients
  ```
  EXTRA_RUN_ARGS="--host 0.0.0.0"
  ```
  
  Specify custom set of Elasticsearch instances to connect to:
  ```bash
  EXTRA_RUN_ARGS="--elasticsearch http://es1.cluster.domain:9200,http://es2.cluster.doman:9200"
  ```

  Update path to scan for plugins
  ```
  EXTRA_RUN_ARGS="--plugin-dir /path/to/plugins"
  ```

Dependencies
------------

None

Example Run
----------------
default example:
```
podman run --publish 5601:5601 0labs/0x01.kibana:7.6.1_centos-7
```

provision hybrid master/data node with customized data and logging directories:
```
podman run --env CONFIG_cluster.name=example-cluster \
           --env CONFIG_node.master=true \
           --env CONFIG_node.data=true \
           --env CONFIG_path.data=/mnt/data/elasticsearch \
           --env CONFIG_path.logs=/mnt/logs/elasticsearch \
           --volume es_data:/mnt \
           0labs/0x01.elasticsearch:7.6.1_centos-7
```

adjust JVM heap settings and enable verbose logging for cluster debugging/troubleshooting:
```
podman run --env ES_JAVA_OPTS='-Xms16g -Xmx16g' \
           --env LOG4J_logger.action.name=org.elasticsearch.action \
           --env LOG4J_logger.action.level=debug \
           --env EXTRA_RUN_ARGS=--verbose \
           0labs/0x01.elasticsearch:7.6.1_centos-7
```

License
-------

MIT

Author Information
------------------

This Containerfile was created in 2020 by O1.IO.
