#!/bin/bash
set -e

cd `find /drone/src -name *.sln -print -quit | xargs dirname`

if [ -n "$PLUGIN_PROJECT_KEY" ]
then
    PROJECT_KEY=${PLUGIN_PROJECT_KEY}
else
    PROJECT_KEY="${DRONE_REPO/\//:}"
fi

dotnet sonarscanner begin /k:"${PROJECT_KEY}" /d:sonar.host.url="${PLUGIN_SONAR_HOST}"  /d:sonar.login="${PLUGIN_SONAR_TOKEN}"

dotnet build

dotnet sonarscanner end /d:sonar.login="${PLUGIN_SONAR_TOKEN}"

exec "$@"
