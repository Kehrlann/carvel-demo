#@!/usr/bin/env bash

git checkout $(git rev-list --topo-order HEAD..demo | tail -1)
