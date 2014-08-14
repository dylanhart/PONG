function love.load()

	config = {
		psize = 50,
		poffset = 20,
		pwidth = 10,
		pspeed = 200,
		bspeed = 400,
		swidth = love.window.getWidth(),
		sheight = love.window.getHeight()
	}

	ball = {
		x = config.swidth/2,
		y = config.sheight/2,
		angle = math.pi
	}

	paddles = {
		a = {
			y = config.sheight/2,
			score = 0
		},
		b = {
			y = config.sheight/2,
			score = 0
		}
	}

	love.graphics.setNewFont("8bit-wonder/8bit-wonder.ttf", 48)

	distortion = love.graphics.newShader([[
	extern number time;
	extern number size;
	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
	{
		vec2 p = tc;
		p.y = p.y + sin(p.x * size + time) * 0.03;
		return Texel(tex, p);
	}
	]])
	distortion:send("size", 5)
	size = 5

	canvas = love.graphics.newCanvas()

end

time = 0

function love.update(delta)
	time = time + delta
	distortion:send("time", time)

	-- player paddle

	local top = config.psize/2
	local bot = config.sheight - top

	local up = love.keyboard.isDown("up")
	local down = love.keyboard.isDown("down")

	if (up ~= down) then
		if (up) then
			paddles.a.y = paddles.a.y - config.pspeed * delta
		else
			paddles.a.y = paddles.a.y + config.pspeed * delta
		end

		if (paddles.a.y < top) then
			paddles.a.y = top
		end
		if (paddles.a.y > bot) then
			paddles.a.y = bot
		end

	end

	-- ai paddle

	local pdist = delta * config.pspeed
	if (math.abs(ball.y - paddles.b.y) < pdist) then
		paddles.b.y = ball.y
	else
		if (paddles.b.y > ball.y) then
			paddles.b.y = paddles.b.y - pdist
		else
			paddles.b.y = paddles.b.y + pdist
		end
	end

	if (paddles.b.y < top) then
		paddles.b.y = top
	end
	if (paddles.b.y > bot) then
		paddles.b.y = bot
	end

	-- ball

	local dist = delta * config.bspeed
	ball.x = ball.x + dist * math.cos(ball.angle)
	ball.y = ball.y - dist * math.sin(ball.angle)

	if (ball.y < 0) then
		ball.y = 0
		ball.angle = math.atan2(-math.sin(ball.angle), math.cos(ball.angle))
	end
	if (ball.y > config.sheight) then
		ball.y = config.sheight
		ball.angle = math.atan2(-math.sin(ball.angle), math.cos(ball.angle))
	end
	
	if (ball.x < config.poffset + config.pwidth and ball.x > config.poffset) then
		if (math.abs(ball.y - paddles.a.y) < config.psize / 2) then
			size = size + 1
			distortion:send("size", size)
			ball.x = config.poffset + config.pwidth
			ball.angle = math.atan2(math.sin(ball.angle), -math.cos(ball.angle))
			ball.angle = ball.angle + math.pi/2 * (paddles.a.y - ball.y)/config.psize
		end
	end

	if (ball.x > config.swidth - (config.poffset + config.pwidth) and ball.x < config.swidth - config.poffset) then
		if (math.abs(ball.y - paddles.b.y) < config.psize / 2) then
			size = size + 1
			distortion:send("size", size)
			ball.x = config.swidth - (config.poffset + config.pwidth)
			ball.angle = math.atan2(math.sin(ball.angle), -math.cos(ball.angle))
			ball.angle = ball.angle + math.pi/3 * (ball.y - paddles.b.y)/config.psize
		end
	end

	if (ball.x < 0) then
		size = 5
		distortion:send("size", size)
		ball = {
			x = config.swidth/2,
			y = config.sheight/2,
			angle = math.pi
		}
		paddles.b.score = paddles.b.score + 1
	end

	if (ball.x > config.swidth) then
		size = 5
		distortion:send("size", size)
		ball = {
			x = config.swidth/2,
			y = config.sheight/2,
			angle = 0
		}
		paddles.a.score = paddles.a.score + 1
	end
end

function love.draw()
	canvas:clear()
	love.graphics.setCanvas(canvas)

	love.graphics.circle("fill", ball.x, ball.y, 5, 8)

	local w = config.pwidth
	local h = config.psize
	local off = config.poffset

	local y = paddles.a.y
	love.graphics.rectangle("fill", off, y - h/2, w, h)

	y = paddles.b.y
	love.graphics.rectangle("fill", config.swidth-off-w, y - h/2, w, h)

	love.graphics.setCanvas()

	love.graphics.setShader(distortion)
	love.graphics.draw(canvas)
	love.graphics.setShader()

	love.graphics.printf(paddles.a.score, 10, 10, config.swidth/2 - 10, "right")
	love.graphics.printf(paddles.b.score, config.swidth/2 + 10, 10, config.swidth - 10, "left")

end

function love.quit()
end

function love.focus(f)
end

function love.mousepressed(x, y, btn)
end

function love.mousereleased(x, y, btn)
end

function love.keypressed(key)
end

function love.keyreleased(key)
end
