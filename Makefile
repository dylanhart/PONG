run: pong.love
	@echo "Running pong.love"
	@/Applications/love.app/Contents/MacOS/love pong.love

pong.love: main.lua conf.lua
	@echo "Generating pong.love"
	zip -r pong.love . -x Makefile -x *.git* -x .gitignore

clean:
	@echo "Removing pong.love"
	rm pong.love