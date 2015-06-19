enviroment:
	sudo gem uninstall cocoapods
	sudo gem install cocoapods 
	pod update
	cp -r -f ~/.cocoapods/repos/master-1 /tmp/cocoapods_backup
	rm -r -f ~/.cocoapods/repos/master-1 
	sudo gem uninstall  cocoapods 
	sudo gem install cocoapods -v 0.33.1
