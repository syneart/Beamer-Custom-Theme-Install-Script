#!/bin/bash
# Copyright 2014-2016 by SyneArt <sa@syneart.com>
clear
echo "INFO: 複製檔案需要權限, 請先輸入密碼 .."
sudo -v
if [ $? -eq 1 ]; then
	clear
	echo "Error: 未輸入正確密碼, 無法繼續執行"
	exit 0
fi
clear

copyFile () {
	DIRPATHS=/dev/null
	CPPATHS=/dev/null
	for lori in `ls -R /dev/null $(dirname "$0")/$1`
	do
		if [ "${lori##*:}" == "" ]; then
			DIRPATHS=${lori//:/}
		else
			CPPATHS=$DIRPATHS/$lori
			sudo cp -f $CPPATHS $texPath/${DIRPATHS//$(dirname "$0")/} >/dev/null 2>&1
		fi
	done
}

pushBeamerError () {
	echo "ERROR: Please install Beamer on MiKTeX first."
}

pushCopyError () {
	echo "INFO: Not Found Path, please feedback."
}

pushCompileError () {
	echo "INFO: Please stop LaTeX Compile first."
}

pushProgress () {
	echo "INFO: Installing Theme , Wait .. [ $1 of 4 ]"
}

texPath=/dev/null
# For TeXLive
pushProgress 1 & (tlmgr --version) >/dev/null 2>&1 && {
	texPath=`tlmgr --version | grep 'tlmgr using installation:' | cut -d " " -f 4`/texmf-dist/tex/latex/beamer/
	copyFile themes .sty & copyFile art .jpg
	if [ $? -eq 1 ]; then pushCopyError; exit; fi
	pushProgress 2 & sudo texhash >/dev/null 2>&1
	if [ $? -eq 1 ]; then pushCompileError; exit; fi
}

# For MiKTeX
pushProgress 3 & (initexmf --version) >/dev/null 2>&1 && {
	$texPath=`initexmf --report | grep '?' | cut -d " " -f 4`/usr/share/texmf/tex/latex/beamer/base/
	if [ $? -eq 1 ]; then pushBeamerError; exit; fi
	copyFile themes .sty & copyFile art .jpg
	if [ $? -eq 1 ]; then pushCopyError; exit; fi
	pushProgress 4 & sudo initexmf --admin --update-fndb >/dev/null 2>&1
	if [ $? -eq 1 ]; then pushCompileError; exit; fi
}

if [ ! -d $texPath ]; then
	clear
	echo "ERROR: Please install LaTeX first."
	exit 0
fi
echo "INFO: Install Theme Successful !"
exit 0
