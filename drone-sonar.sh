#!/bin/bash

cd `find /drone/src -name *.sln -print -quit | xargs dirname`

if [ -n "$PLUGIN_PROJECT_KEY" ]
then
    PROJECT_KEY=${PLUGIN_PROJECT_KEY}
else
    PROJECT_KEY="${DRONE_REPO/\//:}"
fi

EPOCH_TIMESTAMP=`date +"%s"`

dotnet sonarscanner begin /k:"${PROJECT_KEY}" /d:sonar.host.url="${PLUGIN_SONAR_HOST}"  /d:sonar.login="${PLUGIN_SONAR_TOKEN}" /v:"${EPOCH_TIMESTAMP}"

dotnet build

dotnet sonarscanner end /d:sonar.login="${PLUGIN_SONAR_TOKEN}"

exec "$@"