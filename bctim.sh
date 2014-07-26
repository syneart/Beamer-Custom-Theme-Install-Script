# Copyright 2014 by SyneArt <sa@syneart.com>
#!/bin/bash
function copyFile() {
	DIRPATHS=null
	CPPATHS=null
	for ori in `ls -R $(dirname "$0")/$1`
	do
		if [ "${ori##*:}" == "" ]; then
			DIRPATHS=${ori/:/}
		else
			CPPATHS=$DIRPATHS/$ori
			sudo cp $CPPATHS "/usr/share/texmf/tex/latex/beamer/base"${DIRPATHS/$(dirname "$0")/} >/dev/null 2>&1
		fi
	done
}
clear
echo "Info: Install Theme Now .."
echo "Info: 複製檔案需要權限, 請先輸入密碼 .."
sudo -v
if [ $? -eq 1 ]; then
	clear
	echo "Error: 未輸入正確密碼, 無法繼續執行"
	sleep 3
	exit 0
fi
if [ ! -d "/usr/share/texmf/tex/latex/beamer" ]; then
	clear
	echo "Error: 請先安裝 Beamer, 再執行本安裝"
	exit 0
fi
clear
copyFile "themes" ".sty"
copyFile "art" ".jpg"
sudo texhash >/dev/null 2>&1
echo "Info: Install Theme Successful !"
sleep 3
exit 0
