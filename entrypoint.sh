#!/bin/bash


# Constants
packageName="app-debug.apk"
flutter="flutter"
native="native"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Functions
sendpackage(){
  echo -e "${GREEN}Package Name is set to $packageName${NC}"
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
    echo -e "${RED}File Renaming Error, reverting to app-debug.apk name${NC}"
    packageName="app.apk"
  }

}

nativeBuild(){
  bash ./gradlew test --stacktrace
  bash ./gradlew assembleDebug --stacktrace
  if [ -z "$INPUT_PACKAGENAME" ]
  then
    sendpackage 
  else
    rectifiedName=${INPUT_PACKAGENAME// /_}
    packageName="$rectifiedName.apk"
    renamePackage
    sendpackage
  fi 
}

flutterBuild(){
  echo "Flutter Build"
  bash flutter.sh
}

errorHandler(){
  echo -e "${RED}Error Due to : $1 ${NC}"
  exit 1
}

# Main
case $INPUT_TYPE in
  $flutter )
    flutterBuild 
    ;;
  $native )
    nativeBuild
    ;;
  * )
    errorHandler "Unkown Type in YAML Passed"
    ;;
esac

