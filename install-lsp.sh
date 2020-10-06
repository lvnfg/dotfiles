# Microsoft Python Language Server
# ----------------------------------------------------------------
if [[ $1 = "pyls-ms" ]]; then
	# Microsoft python language server
	echo Installing .Net core SDK
	url="https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb"
	fileName="dotnet.deb"
	wget -O $fileName $url
	sudo dpkg -i $fileName
	sudo apt-get update
	sudo apt-get install -y apt-transport-https
	sudo apt-get update
	sudo apt-get install -y dotnet-sdk-3.1
	rm $fileName
	echo Add python interpreter to nvim
	nvim.appimage --headless -c 'LspInstall pyls_ms' +qall
	pip3 install pynvim
fi
