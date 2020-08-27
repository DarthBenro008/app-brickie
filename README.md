# Welcome to AppBrickie 👋

<p>
  <a href="https://github.com/DarthBenro008/app-brickie/blob/master/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green.svg" />
  </a>
</p>

**AppBrickie** - _Your Friendly App Builder Action._

> _Automate your android builds and get your APK delivered to you on Telegram Groups, Chat, Channels, any of them!_

#### What can you do with AppBrickie?

- Get your APK delievred to you on telegram with just a push of commit !
- Automated Android APK Builds
- Unit Tests on Android Builds
- Forget wires , patches and building pull requests manually!

## Installation

Step 1: Add the following yaml file as build.yml in .github/workflows folder of your app repository

```yaml
name: CI

on:
  push:
    branches: [master]
  pull_request:
    branches: [master]

jobs:
  build:
    runs-on: ubuntu-latest
    name: App Builder
    steps:
      - uses: actions/checkout@v2
      - name: AppBrickie
        id: appBrickieBuild
        uses: DarthBenro008/app-brickie@v1.0-alpha03
        with:
          chatid: "Your Unique ID Goes here"
      - name: Get Automated Result
        run: echo "${{ steps.appBrickieBuild.outputs.result }}"
```

Step 2 : Go To [@AppBrickieBot](https://t.me/appbrickiebot) on Telegram to generate your unique id.

Step 3: Replace your UniqueID from the bot in the YAML File above besides chatid **in quotes**
for eg:

```yaml
chatid: "qwerty12345"
```

Step 4: Add name constraints of your app

Step 5: Sit back and enjoy :D get your build delivered to telegram automatically on pull requests and commits on master branch!

## Upcoming Features

- Firebase apps build
- Flutter Build Support
- React Native Build Support

## Disclaimer
You automatically agree to accept the default android-sdk license by using this github action. For more info refer [Android SDK T&C](https://developer.android.com/studio/terms)


## Author
🧔 Hemanth Krishna [@DarthBenro008](http://github.com/DarthBenro008)

## Show your support

Give a ⭐ if this project helped you out!

Spread the word!

## Contributions

- Feel Free to Open a PR/Issue for any feature or bug
- Make sure you follow the community guidelines !
- Feel free to open an issue to ask a question/discuss anything about AppBrickie

## License

Copyright 2020 Hemanth Krishna

Licensed under MIT License : https://opensource.org/licenses/MIT
