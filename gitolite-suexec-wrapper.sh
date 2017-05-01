#!/bin/bash
#
# Suexec wrapper for gitolite-shell
#

export GIT_PROJECT_ROOT="/git/repositories"
export GITOLITE_HTTP_HOME="/home/git"

exec ${GITOLITE_HTTP_HOME}/gitolite/src/gitolite-shell
