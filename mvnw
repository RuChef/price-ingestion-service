#!/bin/sh
#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Maven Wrapper bootstrapper, version 3.2.0
# Check if maven-wrapper.properties exists, if not or no download URL is present, no downloader is available
WRAPPER_PROPERTIES="${MAVEN_PROJECTBASEDIR}/.mvn/wrapper/maven-wrapper.properties"
if [ -f "$WRAPPER_PROPERTIES" ]; then
  wrapperUrl="$(java -jar ${MAVEN_PROJECTBASEDIR}/.mvn/wrapper/maven-wrapper.jar getProperty maven.wrapper.url)"
  if [ -n "$wrapperUrl" ]; then
    wrapperUrlIsFileUrl=$(echo "$wrapperUrl" | grep -i "file://")
    if [ "$wrapperUrlIsFileUrl" = "" ]; then
      #it's a remote URL, so download it
      printf "\r[INFO] Downloading from: %s\n" "$wrapperUrl"
      maven_wrapper_repository_url="$wrapperUrl"
      TEMP="$HOME/.m2/wrapper"
      mkdir -p "$TEMP"
      if [ ! -d "$TEMP" ]; then
        printf "\r[ERROR] Failed to create Maven wrapper directory: %s\n" "$TEMP"
        exit 1
      fi
      if [ -f "$TEMP/maven-wrapper.jar" ]; then
        printf "\r[INFO] Found Maven Wrapper: $TEMP/maven-wrapper.jar\n"
      else
        printf "\r[INFO] Downloading Maven Wrapper from: %s\n" "$maven_wrapper_repository_url"
        if [ "$osType" = "win" ]; then
          wget -q -O "$TEMP/maven-wrapper.jar" "$maven_wrapper_repository_url"
        else
          curl -s -o "$TEMP/maven-wrapper.jar" "$maven_wrapper_repository_url"
        fi
        if [ -f "$TEMP/maven-wrapper.jar" ]; then
          printf "\r[INFO] Maven Wrapper downloaded to: %s\n" "$TEMP/maven-wrapper.jar"
        else
          printf "\r[ERROR] Failed to download Maven Wrapper: %s\n" "$maven_wrapper_repository_url"
          exit 1
        fi
      fi
      # Build and execute with the downloaded wrapper
      printf "\r[INFO] Using Maven Wrapper: %s\n" "$TEMP/maven-wrapper.jar"
      "$JAVACMD" -jar "$TEMP/maven-wrapper.jar" "$@"
    else
      #it's a file URL, so no download is required
      printf "\r[INFO] Using Maven Wrapper: %s\n" "$wrapperUrl"
      "$JAVACMD" -jar "$wrapperUrl" "$@"
    fi
  else
    printf "\r[ERROR] No URL defined in maven-wrapper.properties\n"
    exit 1
  fi
else
  printf "\r[ERROR] Maven Wrapper properties file not found: %s\n" "$WRAPPER_PROPERTIES"
  exit 1
fi