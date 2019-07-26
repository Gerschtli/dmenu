#!/usr/bin/env bash

VERSION="${1}"
FILE="${2:-patch-"${1}".diff}"

git diff "${VERSION}" -- . ':!*.diff' ':!.git*' ':!.travis.yml' ':!.create-patch.sh' > "${FILE}"
