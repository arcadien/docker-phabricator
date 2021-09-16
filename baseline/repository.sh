#!/bin/bash

set -e
set -x

zypper modifyrepo --enable repo-update
#zypper --non-interactive ar http://download.opensuse.org/repositories/devel:/languages:/php/openSUSE_Leap_15.0/ php
#zypper --non-interactive ar http://download.opensuse.org/repositories/devel:/languages:/python/openSUSE_Leap_15.0/ python
#zypper --non-interactive ar http://download.opensuse.org/repositories/devel:/tools:/scm/openSUSE_Leap_15.0/ scm
#zypper --non-interactive ar http://download.opensuse.org/repositories/home:/marec2000:/nodejs/openSUSE_Leap_42.3/ nodejs
zypper --non-interactive ref
