# Get Flutter
export FLUTTER_ROOT="/opt/flutter"
git clone https://github.com/flutter/flutter "${FLUTTER_ROOT}"
export PATH="${FLUTTER_ROOT}/bin:${PATH}"
packageName="app-release.apk"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

sendpackage(){
  echo -e "${GREEN}Package Name is set to $packageName${NC}"
  output=$(curl --location --request POST 'http://appbrickie.herokuapp.com/api/sendPackage' \
    --form 'file=@build/app/outputs/apk/release/'$packageName'' \
    --form 'id='$INPUT_CHATID'' \
    --form 'msg=Build Successful https://www.github.com/'$GITHUB_REPOSITORY'/commit/'$GITHUB_SHA'')
      echo "::set-output name=result::$output"
}

renamePackage(){
    {
      mv build/app/outputs/apk/release/app-release.apk build/app/outputs/apk/release/"$packageName"
    }||{
      echo -e "${RED}File Renaming Error, reverting to app-debug.apk name${NC}"
          packageName="app.apk"
        }

}

# Run Flutter
flutter config --no-analytics
flutter precache
yes "y" | flutter doctor --android-licenses
flutter doctor -v
flutter upgrade
flutter build apk
if [ -z "$INPUT_PACKAGENAME" ]
then
  sendpackage
else
  rectifiedName=${INPUT_PACKAGENAME// /_}
  packageName="$rectifiedName.apk"
  renamePackage
  sendpackage
fi

