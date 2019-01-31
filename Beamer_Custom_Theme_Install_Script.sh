#!/bin/bash
# Copyright 2014-2019 by SyneArt <sa@syneart.com>
clear
echo "INFO: 複製檔案需要權限, 請先輸入密碼 .."
sudo -v
if [ $? -eq 1 ]; then
	clear
	echo "Error: 未輸入正確密碼, 無法繼續執行"
	exit 0
fi
source /etc/profile
clear

copyFile () {
	for lori in `find $(dirname "$0")/$1/ -name *$2`
	do
		themesPath=$(dirname $texPath${lori/$(dirname "$0")})/
		sudo mkdir -p ${themesPath}; sudo cp ${lori} ${themesPath} >/dev/null 2>&1
	done
}

pushCopyError () {
	echo "INFO: Not Found Path, please feedback."
}

pushCompileError () {
	echo "INFO: Please stop LaTeX Compile first."
}

pushProgress () {
	echo "INFO: Installing Theme , Wait .. [ $1 of 2 ]"
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
# Not Support MiKTeX

if [ ! -d $texPath ]; then
	clear
	echo "ERROR: Please install LaTeX first."
	exit 0
fi
echo "INFO: Install Theme Successful !"
exit 0
