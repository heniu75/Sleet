#!/usr/bin/env bash

RESULTCODE=0

# increase open file limit for osx
ulimit -n 2048

# install dnx rc1
if ! type dnvm > /dev/null 2>&1; then
	curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_BRANCH=dev sh && source ~/.dnx/dnvm/dnvm.sh
fi

if ! type dnx > /dev/null 2>&1; then
    dnvm install 1.0.0-rc1-update1 -runtime coreclr -alias default
fi

dnvm use 1.0.0-rc1-update1 -runtime coreclr

# restore
dnu restore

for testProj in `find test -type f -name project.json`
do
    echo "Running tests for $testProj"

    dnx --project $testProj test

    if [ $? -ne 0 ]; then
        echo "$testProj FAILED"
        RESULTCODE=1
    fi
done

exit $RESULTCODE
