
# load dữ liệu 
lib1="lib/revanced-cli.jar"
lib2="lib/revanced-patches.jar"
lib3="lib/revanced-integrations.apk"

# Tải tool sta
pbsta(){
Vsion1="$(Xem https://github.com/ReVanced/$1 | grep -om1 'ReVanced/'$1'/releases/tag/.*\"' | sed -e 's|dev|zzz|g' -e 's|v||g' -e 's|zzz|dev|g' -e 's|\"||g')"
Taive "https://github.com/ReVanced/$1/releases/download/v${Vsion1##*/}/$1-${Vsion1##*/}$3.$2" "lib/$1.$2"; 

echo "- Url: https://github.com/ReVanced/$1/releases/download/v${Vsion1##*/}/$1-${Vsion1##*/}$3.$2
"
}
 
# tải tool dev
pbdev(){
Vsion1="$(Xem https://github.com/ReVanced/$1/releases | grep -om1 'ReVanced/'$1'/releases/tag/.*dev' | cut -d '"' -f1 | sed -e 's|dev|zzz|g' -e 's|v||g' -e 's|zzz|dev|g' -e 's|\"||g')"
Taive "https://github.com/ReVanced/$1/releases/download/v${Vsion1##*/}/$1-${Vsion1##*/}$3.$2" "lib/$1.$2"; 

echo "- Url: https://github.com/ReVanced/$1/releases/download/v${Vsion1##*/}/$1-${Vsion1##*/}$3.$2
"
}

# Tải json
if [ "$DEV" == "Develop" ];then
Vop='-DEV'
Vop2=D
vjson="$(Xem https://github.com/ReVanced/revanced-patches/releases | grep -om1 'ReVanced/revanced-patches/releases/tag/.*dev' | cut -d '"' -f1 | sed -e 's|dev|zzz|g' -e 's|v||g' -e 's|zzz|dev|g' -e 's|\"||g')"
else
vjson="$(Xem https://github.com/ReVanced/revanced-patches | grep -om1 'ReVanced/revanced-patches/releases/tag/.*\"' | sed -e 's|dev|zzz|g' -e 's|v||g' -e 's|zzz|dev|g' -e 's|\"||g')"
fi

# tải apk
TaiYT(){
urrl="https://www.apkmirror.com"
uak1="$urrl$(Xem "$urrl/apk/$2" | grep -m1 'downloadButton' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2)"
uak2="$urrl$(Xem "$uak1" | grep -m1 '>here<' | tr ' ' '\n' | grep -m1 'href=' | cut -d \" -f2 | sed 's|amp;||')"
Taive "$uak2" "apk/$1"
echo "Link: $uak2"
[ "$(file apk/$1 | grep -cm1 'Zip')" == 1 ] && echo > "apk/$1.txt"; }

# Load dữ liệu cài đặt 
. $HOME/.github/options/YouTube.md

# lấy dữ liệu phiên bản mặc định
echo "- Lấy dữ liệu phiên bản YouTube..."
#Vidon="$(
Xem "https://github.com/ReVanced/revanced-patches/releases/download/v${vjson##*/}/patches.json" > 1.json
#| jq -r .[1].compatiblePackages[0].versions[] | tac | head -n1)"

while true; do
fhjfn=$(($fhjfn + 1))
Vclass="$(jq -r ".[$fhjfn].compatiblePackages[0].name" 1.json 2>/dev/null)"
Vidon="$(jq -r ".[$fhjfn].compatiblePackages[0].versions[]" 1.json 2>/dev/null | tac | head -n1)"
if [ "$Vclass" == "com.google.android.youtube" ] && [ "$Vidon" ];then
break
fi
done

# là amoled
[ "$AMOLED" == 'true' ] && amoled2='-Amoled'
[ "$AMOLED" == 'true' ] || theme='-e Theme'
[ "$TYPE" == 'true' ] && Mro='-e "Vanced MicroG support"'

# Xoá lib dựa vào abi
if [ "$DEVICE" == "arm64-v8a" ];then
lib="lib/x86/* lib/x86_64/* lib/armeabi-v7a/*"
ach="arm64"
elif [ "$DEVICE" == "x86" ];then
lib="lib/x86_64/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x86"
elif [ "$DEVICE" == "x86_64" ];then
lib="lib/x86/* lib/arm64-v8a/* lib/armeabi-v7a/*"
ach="x64"
else
lib="lib/arm64-v8a/* lib/x86/* lib/x86_64/*"
ach="arm"
fi

echo "  $Vidon"
if [ "$VERSION" == 'Auto' ];then
VER="$Vidon"
Kad=Build$Vop
V=V$Vop2
elif [ "$VERSION" == 'Autu' ];then
VER="$Vidon"
Kad=Auto$Vop
V=U$Vop2
if [ "$(Xem https://github.com/$GITHUB_REPOSITORY/releases/download/Up/Up-Z${V}notes.json | grep -cm1 "${VER//./}")" == 1 ];then
echo "! Là phiên bản mới nhất."
exit 0
fi
else
VER="$VERSION"
Kad=Edit$Vop
V=N$Vop2
fi

echo
# Tải tool cli
echo "- Tải tool cli, patches, integrations..."
if [ "$DEV" == "Develop" ];then
echo "  Dùng Dev"
echo
pbdev revanced-cli jar -all
pbdev revanced-patches jar
pbdev revanced-integrations apk
else
echo "  Dùng Sta"
echo
pbsta revanced-cli jar -all
pbsta revanced-patches jar
pbsta revanced-integrations apk
fi

# kiểm tra tải tool
checkzip "lib/revanced-cli.jar"
checkzip "lib/revanced-patches.jar"
checkzip "lib/revanced-integrations.apk"

Upenv V "$V"
Upenv Kad "$Kad"
Upenv VER "$VER"
echo

echo "- Tải YouTube $VER apk, apks..."
# Tải YouTube apk
kkk1="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-2-android-apk-download"
kkk2="google-inc/youtube/youtube-${VER//./-}-release/youtube-${VER//./-}-android-apk-download"

# Tải
TaiYT 'YouTube1' "$kkk1" & TaiYT 'YouTube2' "$kkk2"

# Chờ tải xong
Loading apk/YouTube1.txt apk/YouTube2.txt

# Xem xét apk
[ "$(file apk/YouTube1 | grep -cm1 Zip)" == 1 ] || rm -fr apk/YouTube1
[ "$(file apk/YouTube2 | grep -cm1 Zip)" == 1 ] || rm -fr apk/YouTube2

if [ -e apk/YouTube1 ];then
if [ "$(unzip -l apk/YouTube1 | grep -cm1 'base.apk')" == 1 ];then
echo "- apk1 thành apks."
mv apk/YouTube1 apk/YouTube.apks
else
echo "- apk1 thành apk."
mv apk/YouTube1 apk/YouTube.apk
fi
fi

if [ -e apk/YouTube2 ];then
if [ "$(unzip -l apk/YouTube2 | grep -cm1 'base.apk')" == 1 ];then
echo "- apk2 thành apks."
mv apk/YouTube2 apk/YouTube.apks
else
echo "- apk2 thành apk."
mv apk/YouTube2 apk/YouTube.apk
fi
fi


if [ "$TYPE" == 'true' ];then
lib='lib/*/*'
if [ -e apk/YouTube.apks ];then
echo "- Giải nén base.apk"
unzip -qo apk/YouTube.apks 'base.apk' -d Tav
unzip -qo apk/YouTube.apk lib/$DEVICE/* -d Tav
mv -f Tav/lib/$DEVICE Tav/lib/$ach
else
cp apk/YouTube.apk Tav/base.apk
fi
fi

# Copy 
echo > $HOME/.github/Modun/common/$ach
cp -rf $HOME/.github/Tools/sqlite3_$ach $HOME/.github/Modun/common/sqlite3

echo "- Xoá lib thừa."
zip -qr apk/YouTube.apk -d $lib

# Xử lý revanced patches
if [ "$Vidon" != "$VER" ];then
echo "- Chuyển đổi phiên bản $VER"
unzip -qo "$lib2" -d $HOME/jar
for vak in $(grep -Rl "$Vidon" $HOME/jar); do
cp -rf $vak test
XHex test | sed -e "s/$(echo -n "$Vidon" | XHex)/$(echo -n "$VERSION" | XHex)/" | ZHex > $vak
done
cd $HOME/jar
rm -fr $lib2
zip -qr "$HOME/$lib2" *
cd $HOME
fi

# MOD YouTube 
(

echo "▼ Bắt đầu quá trình xây dựng..."
eval "java -Djava.io.tmpdir=$HOME -jar $lib1 patch -b $lib2 -m $lib3 apk/YouTube.apk -o YT.apk "$Tof $Ton $Mro $theme $feature" > Log.txt 2>> Log.txt"
sed '/WARNING: warn: removing resource/d' Log.txt
echo '- Quá trình xây dựng apk xong.' | tee 2.txt

) & (

sleep 5
zip -qr apk/YouTube.apk -d res/*

checklog 'Decoding resources' Log.txt
sleep 3

for kvc in $(ls $HOME/.github/Language); do
Tmk="$(echo $HOME/*/res/${kvc%.*})"
mkdir -p $Tmk
[ -e $Tmk/strings.xml ] && sed -i "/<\/resources>/d" $Tmk/strings.xml
[ -e $Tmk ] && cat $HOME/.github/Language/$kvc | sed -e 's|<?xml version="1.0" encoding="utf-8"?>||g' -e "/<\/resources>/d" -e "/<resources>/d" >> $Tmk/strings.xml || cat $HOME/.github/Language/$kvc | sed "/<\/resources>/d" >> $Tmk/strings.xml
echo '</resources>' >> $Tmk/strings.xml
done

echo '- Quá trình ghép string xong' | tee 1.txt


)

# Chờ xây dựng xong
Loading "1.txt" "2.txt" >/dev/null
if [ "$TYPE" == 'true' ];then
mv YT.apk $HOME/Tav/YouTube.apk
else
apksign YT.apk $HOME/Up/YT-$VER-$ach${amoled2}.apk
ls Up
exit 0
fi
cd Tav
tar -cf - * | xz -9kz > $HOME/.github/Modun/common/lib.tar.xz
cd $HOME

# Tạo module.prop
echo 'id=YouTube
name=YouTube PiP '$Kad'
author=kakathic
description=Build '$(date)', YouTube edited tool by Revanced mod added disable play store updates, mod rounded pip window.
version='$VER'
versionCode='${VER//./}'
updateJson=https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/Up-Z'$V$ach$amoled2'.json
' > $HOME/.github/Modun/module.prop

# Tạo json
echo '{
"version": "'$VER'",
"versionCode": "'${VER//./}'",
"zipUrl": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/Z'$V$VER'/YT-Magisk-'$VER'-'$ach$amoled2'.Zip",
"changelog": "https://github.com/'$GITHUB_REPOSITORY'/releases/download/Up/Up-Z'$V'notes.json"
}' > Up-Z$V$ach$amoled2.json

echo -e 'Update '$(date)' \nYouTube: '$VER' \nVersion: '${VER//./}' \nAuto by kakathic' > Up-Z${V}notes.json

# Tạo module magisk
cd $HOME/.github/Modun
zip -qr $HOME/Up/YT-Magisk-$VER-$ach$amoled2.zip *
cd $HOME
ls Up
