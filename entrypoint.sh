#!/bin/bash
bash ./gradlew test --stacktrace
bash ./gradlew assembleDebug --stacktrace

packageName="app-debug.apk"

sendpackage(){
  echo "Package Name to $packageName"
  output=$(curl --location --request POST 'http://appbrickie.herokuapp.com/api/sendPackage' \
    --form 'file=@app/build/outputs/apk/debug/'$packageName'' \
    --form 'id='$INPUT_CHATID'' \
    --form 'msg=Build Successful https://www.github.com/'$GITHUB_REPOSITORY'/commit/'$GITHUB_SHA'')
  echo "::set-output name=result::$output"
}

renamePackage(){
  {
    mv app/build/outputs/apk/debug/app-debug.apk app/build/outputs/apk/debug/"$packageName"
  }||{
    echo "File Renaming Error Trying , reverting to normal name"
    packageName="app.apk"
  }

}

if [ -z "$INPUT_PACKAGENAME" ]
then
  sendpackage 
else
  packageName="$INPUT_PACKAGENAME.apk"
  renamePackage
  sendpackage
fi 
