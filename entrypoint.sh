#!/bin/sh -l
bash ./gradlew test --stacktrace
bash ./gradlew assembleDebug --stacktrace
echo $1
output=$(curl --location --request POST 'http://appbrickie.herokuapp.com/api/sendPackage' \
  --form 'file=@app/build/outputs/apk/debug/app-debug.apk' \
  --form 'id='$1'' \
  --form 'msg=Automated File!')
echo "::set-output name=result::$output"
