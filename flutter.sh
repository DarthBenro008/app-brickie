#Constants
packageName="app-release.apk"
builtPackageName=$packageName
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
v7a='armabi-v7a'
v8a='arm64-v8a'
x86='x86_64'


# Get Flutter
export FLUTTER_ROOT="/opt/flutter"
git clone https://github.com/flutter/flutter "${FLUTTER_ROOT}"
export PATH="${FLUTTER_ROOT}/bin:${PATH}"


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
      mv build/app/outputs/apk/release/"$builtPackageName" build/app/outputs/apk/release/"$packageName"
    }||{
      echo -e "${RED}File Renaming Error, reverting to app-debug.apk name${NC}"
          packageName="app.apk"
        }
    }

  apkSigner(){
    echo -e "${GREEN} This app is being signed with a custom key ${NC}"
    ksPassword=$INPUT_KEYSTOREPASSWORD
    kAlias=$INPUT_KEYALIAS
    echo "$INPUT_KEYSTORE" | base64 --decode > key.jks
    {
      $ANDROID_HOME/build-tools/*/zipalign -v -p 4 build/app/outputs/apk/release/$packageName build/app/outputs/apk/release/$packageName
      bash $ANDROID_HOME/build-tools/*/apksigner sign --ks key.jks --ks-key-alias $kAlias --ks-pass env:INPUT_KEYPASSWORD --out build/app/outputs/apk/release/$packageName build/app/outputs/apk/release/$packageName
    }||{
      errorHandler "Failed to sign apk!"
    }
  echo -e "${GREEN} Apk signed successfully ! ${NC}"
}

# Run Flutter
flutter config --no-analytics
flutter precache
yes "y" | flutter doctor --android-licenses
flutter doctor -v
flutter upgrade
if [ -z "$INPUT_FIREBASE" ]
then 
  :
else
  echo "$INPUT_FIREBASE" > android/app/google-services.json
  if [ -z "$INPUT_ABI" ]
  then 
    flutter build apk
  else
    flutter build apk --split-per-abi
    echo -e "${GREEN}ABI Target set to $INPUT_ABI-release ${NC}"
    case $INPUT_ABI in
      $v7a )
        builtPackageName="app-armeabi-v7a-release.apk"
        ;;
      $v8a )
        builtPackageName="app-arm64-v8a-release.apk"
        ;;
      $x86 )
        builtPackageName="app-x86_64-release.apk"
        ;;
      * )
        builtPackageName=$packageName
        ;;
    esac
  fi
fi 
if [ -z "$INPUT_KEYSTORE" ]
then 
  :
else 
  apkSigner
fi

if [ -z "$INPUT_PACKAGENAME" ]
then
  packageName=$builtPackageName
  sendpackage
else
  rectifiedName=${INPUT_PACKAGENAME// /_}
  packageName="$rectifiedName.apk"
  renamePackage
  sendpackage
fi

