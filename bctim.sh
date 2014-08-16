#!/bin/bash
# Copyright 2014 by SyneArt <sa@syneart.com>
copyFile () {
	DIRPATHS=null
	CPPATHS=null
	for lori in `ls -R /dev/null $(dirname "$0")/$1 2>/dev/null`
	do
		if [ "${lori##*:}" == "" ]; then
			DIRPATHS=${lori//:/}
		else
			CPPATHS=$DIRPATHS/$lori
			sudo cp -f $CPPATHS $installPATH/${DIRPATHS//$(dirname "$0")/} >/dev/null 2>&1
		fi
	done
}
clear
echo "Info: Install Theme Now .."
OS=`uname -s`
if [ "${OS}" == "Darwin" ] ; then
	installPATH=`tlmgr --version | grep 'tlmgr using installation:' | cut -d " " -f 4`/texmf-dist/tex/latex/beamer/
elif [ "${OS}" == "Linux" ] ; then
	if [ -f /etc/lsb-release ] ; then
		installPATH=/usr/share/texmf/tex/latex/beamer/base/
	else
		installPATH=/dev/null
	fi
fi
if [[ $installPATH == /dev/null ]]; then
	clear
	echo "Error: 不支援此 Linux 版本, 請回報以獲得支援！"
	exit 0
elif [ ! -d $installPATH ]; then
	clear
	echo "Error: 請先安裝 Beamer, 再執行本安裝"
	exit 0
fi
echo "Info: 複製檔案需要權限, 請先輸入密碼 .."
sudo -v
if [ $? -eq 1 ]; then
	clear
	echo "Error: 未輸入正確密碼, 無法繼續執行"
	sleep 3
	exit 0
fi
clear
echo "Info: Install Theme Now .."
copyFile themes .sty
copyFile art .jpg
sudo texhash >/dev/null 2>&1
clear
echo "Info: Install Theme Successful !"
sleep 3
exit 0
