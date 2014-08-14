run: pong.love
	@echo "Running pong.love"
	@/Applications/love.app/Contents/MacOS/love pong.love

#build love project
pong.love: main.lua conf.lua
	@echo "Generating pong.love"
	zip -r pong.love . -x Makefile -x *.git* -x .gitignore -x love-0.9.1-win64.zip -x "build/*" -x pong-dist-win64.zip -x love-0.9.1-macosx-x64.zip -x "love.app/*" -x "pong.app/*"

#build windows exe
love-0.9.1-win64.zip:
	wget https://bitbucket.org/rude/love/downloads/love-0.9.1-win64.zip

build/love.exe: love-0.9.1-win64.zip
	unzip love-0.9.1-win64.zip
	mv love-0.9.1-win64 build

exe: pong.love build/love.exe
	cat build/love.exe pong.love > build/pong.exe
	zip -r pong-dist-win64.zip build -x build/love.exe

#build osx app
love-0.9.1-macosx-x64.zip:
	wget https://bitbucket.org/rude/love/downloads/love-0.9.1-macosx-x64.zip

love.app: love-0.9.1-macosx-x64.zip
	unzip love-0.9.1-macosx-x64.zip -x "__MACOSX/*"

app: love.app pong.love
	cp -R love.app pong.app
	cp -R pong.love pong.app/Contents/Resources
	/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.dhart.pong" -c "Set :CFBundleName Pong" pong.app/Contents/Info.plist

#clean files
clean-build:
	@echo "Removing pong.love"
	-rm pong.love
	@echo "Removing build files"
	-rm -r build
	-rm pong-dist-win64.zip
	-rm -r love.app
	-rm -r pong.app

clean: clean-build
	@echo "Removing love"
	-rm love-0.9.1-win64.zip
	-rm love-0.9.1-macosx-x64.zip