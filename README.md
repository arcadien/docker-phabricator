# Phabricator

This is a Docker image which provides a fully configured Phabricator image, including SSH connectivity to repositories, real-time notifications via Web Sockets and all of the other parts that are normally difficult to configure done for you.

This image is a fork of a [RedpointGames image](https://github.com/RedpointGames/phabricator), with enhancements for cluster configuration.

You'll need an instance of MySQL for this Docker image to connect to, and for basic setups you can specify it with either the `MYSQL_LINKED_CONTAINER` or `MYSQL_HOST` environment variables, depending on where your instance of MySQL is.

The most basic command to run Phabricator is:

```
docker run \
    --rm -p 80:80 -p 443:443 -p 22:22 \
    --env PHABRICATOR_HOST=phabricator.mydomain.com \
    --env MYSQL_HOST=10.0.0.1 \
    --env MYSQL_USER=user \
    --env MYSQL_PASS=pass \
    --env PHABRICATOR_DAEMON_USER=phab-daemon \
    --env PHABRICATOR_VCS_USER=vcs-user \
    --env PHABRICATOR_REPOSITORY_PATH=/repos \
    -v /host/repo/path:/repos \
    pollenm/phabricator
```

Alternatively you can launch this image with Docker Compose.

To run a standalone Phabricator stack, you can custom and use the docker-compose.yml.standalone script. It contains information in its header.

## Configuration

For basic configuration in getting the image running, refer to [Basic Configuration](https://github.com/RedpointGames/phabricator/blob/master/BASIC-CONFIG.md).

For more advanced configuration topics including:

* Using different source repositories (for patched versions of Phabricator)
* Running custom commands during the boot process, and
* Baking configuration into your own derived Docker image

refer to ADVANCED-CONFIG.md.

## Support

For issues regarding environment setup, missing tools or parts of the image not starting correctly, file a GitHub issue.

For issues encountered while using Phabricator itself, report the issue with reproduction steps on the [upstream bug tracker](https://secure.phabricator.com/book/phabcontrib/article/bug_reports/).

## License

The configuration scripts provided in this image are licensed under the MIT license.  Phabricator itself and all accompanying software are licensed under their respective software licenses.
