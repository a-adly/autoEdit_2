# https://www.electron.build/multi-platform-build#docker
matrix:
  include:
    - os: osx
      osx_image: xcode9.4
      language: node_js
      node_js: "10"
      env:
        - ELECTRON_CACHE=$HOME/.cache/electron
        - ELECTRON_BUILDER_CACHE=$HOME/.cache/electron-builder

    - os: linux
      services: docker
      language: generic

cache:
  directories:
    - node_modules
    - $HOME/.cache/electron
    - $HOME/.cache/electron-builder

script:
  - |
    if [ "$TRAVIS_OS_NAME" == "linux" ]; then
      docker run --rm \
        --env-file <(env | grep -iE 'DEBUG|NODE_|ELECTRON_|YARN_|NPM_|CI|CIRCLE|TRAVIS|APPVEYOR_|CSC_|_TOKEN|_KEY|AWS_|STRIP|BUILD_') \
        -v ${PWD}:/project \
        -v ~/.cache/electron:/root/.cache/electron \
        -v ~/.cache/electron-builder:/root/.cache/electron-builder \
        electronuserland/builder:wine \
        /bin/bash -c "yarn --link-duplicates --pure-lockfile && yarn release --linux --win"
    else
      yarn release
    fi
before_cache:
  - rm -rf $HOME/.cache/electron-builder/wine

branches:
  except:
    - "/^v\\d+\\.\\d+\\.\\d+$/"