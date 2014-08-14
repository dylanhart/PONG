run: pong.love
	@echo "Running pong.love"
	@/Applications/love.app/Contents/MacOS/love pong.love

#build love project
pong.love: main.lua conf.lua
	@echo "Generating pong.love"
	zip -r pong.love . -x Makefile -x *.git* -x .gitignore -x *build* -x pong-dist-win64.zip

#build windows exe
love-0.9.1-win64.zip:
	wget https://bitbucket.org/rude/love/downloads/love-0.9.1-win64.zip

build/love.exe: love-0.9.1-win64.zip
	unzip love-0.9.1-win64.zip
	mv love-0.9.1-win64 build

exe: pong.love build/love.exe
	cat build/love.exe pong.love > build/pong.exe
	zip -r pong-dist-win64.zip build -x build/love.exe

#clean files
clean-build:
	@echo "Removing pong.love"
	rm pong.love
	@echo "Removing build files"
	rm -r build
	rm pong-dist-win64.zip

clean: clean-build
	@echo "Removing love"
	rm love-0.9.1-win64.zip