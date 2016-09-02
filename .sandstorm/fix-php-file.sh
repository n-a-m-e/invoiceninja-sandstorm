#!/bin/bash

#go to root project directory
cd "$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
cd ..

sed --in-place='' \
        --expression="s/throw new Exception(sprintf('Impossible to create the root directory/#throw new Exception(sprintf('Impossible to create the root directory/" \
        $PWD/vendor/league/flysystem/src/Adapter/Local.php

