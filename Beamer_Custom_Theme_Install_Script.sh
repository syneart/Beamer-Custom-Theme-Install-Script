#!/bin/bash
# Copyright 2014-2016 by SyneArt <sa@syneart.com>
copyFile () {
	DIRPATHS=/dev/null
	CPPATHS=/dev/null
	for lori in `ls -R /dev/null $(dirname "$0")/$1`
	do
		if [ "${lori##*:}" == "" ]; then
			DIRPATHS=${lori//:/}
		else
			CPPATHS=$DIRPATHS/$lori
			sudo cp -f $CPPATHS $installPATH/${DIRPATHS//$(dirname "$0")/} >/dev/null 2>&1
		fi
	done
}

pushBeamerError () {
	echo "ERROR: Please install Beamer on MiKTeX first."
	exit 1
}

pushCopyError () {
	echo "INFO: Not Found Path, please feedback."
	exit 2
}

pushCompileError () {
	echo "INFO: Please stop LaTeX Compile first."
	exit 2
}

pushProgress () {
	echo "INFO: Installing Theme , Wait .. [ $0 of 4 ]"
}

clear
echo "INFO: 複製檔案需要權限, 請先輸入密碼 .."
sudo -v
if [ $? -eq 1 ]; then
        clear
        echo "Error: 未輸入正確密碼, 無法繼續執行"
        sleep 3
        exit 0
fi

texPath=/dev/null
# For TeXLive
pushProgress 1 & (tlmgr --version) >/dev/null 2>&1 && (
	texPath=`tlmgr --version | grep 'tlmgr using installation:' | cut -d " " -f 4`/texmf-dist/tex/latex/beamer/
	copyFile themes .sty & copyFile art .jpg
	if [ $? -eq 1 ]; then pushCopyError; fi
	pushProgress 2 & sudo texhash >/dev/null 2>&1
	if [ $? -eq 1 ]; then pushCompileError; fi
)
# For MiKTeX
pushProgress 3 & (initexmf --version) >/dev/null 2>&1 && (
        texPath=`initexmf --report | grep '?' | cut -d " " -f 4`/usr/share/texmf/tex/latex/beamer/base/
        if [ $? -eq 1 ]; then pushBeamerError; fi
	copyFile themes .sty & copyFile art .jpg
	if [ $? -eq 1 ]; then pushCopyError; fi
	pushProgress 4 & sudo initexmf --admin --update-fndb >/dev/null 2>&1
	if [ $? -eq 1 ]; then pushCompileError; fi
)

if [ ! -d $texPath ]; then
        clear
        echo "ERROR: Please install LaTeX first."
        exit 0
fi
echo "INFO: Install Theme Successful !"
sleep 3
exit 0
