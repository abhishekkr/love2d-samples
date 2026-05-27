--- GAME WINDOW NFO
WINDOW_WIDTH = 1150
WINDOW_HEIGHT = 700

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

GAME_HEIGHT = VIRTUAL_HEIGHT
GAME_WIDTH = VIRTUAL_WIDTH
HALF_GAME_HEIGHT = GAME_HEIGHT / 2
HALF_GAME_WIDTH = GAME_WIDTH / 2

--- GAME SPRITE NFO
PADDLE_A_X = 30
PADDLE_A_Y = 10

PADDLE_B_X = GAME_WIDTH - 30
PADDLE_B_Y = GAME_HEIGHT - 30

BALL_X = (GAME_WIDTH/2) - 2
BALL_Y = (GAME_HEIGHT/2) - 2

PADDLE_LENGTH = 20
PADDLE_BREADTH = 5
BALL_RADIUS = 4

PADDLE_SPEED = 150

PLAYER_A_SCORE = 0
PLAYER_B_SCORE = 0

--- LIBs
push = require 'push'     -- https://github.com/Ulydev/push


--- love
function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')  -- best for pixel art

  pixel_font = love.graphics.newFont('datagoblin-monogram-cc0.ttf', 16)
  pixel_font_big = love.graphics.newFont('datagoblin-monogram-cc0.ttf', 32)
  pixel_font_small = love.graphics.newFont('datagoblin-monogram-cc0.ttf', 8)

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
      resizable = false,
      vsync = true,
      fullscreen = false,
    })

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {upscale = "normal"})
end


function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end


function love.update(dt)
  if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
    PADDLE_B_Y = math.max(0, PADDLE_B_Y - (PADDLE_SPEED * dt))
  elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
    PADDLE_B_Y = math.min(GAME_HEIGHT-PADDLE_LENGTH, PADDLE_B_Y + (PADDLE_SPEED * dt))
  end

  local DIFF_A_BALL_Y = BALL_Y - PADDLE_A_Y
  if DIFF_A_BALL_Y > 15 then
    PADDLE_A_Y = math.min(GAME_HEIGHT-PADDLE_LENGTH, PADDLE_A_Y + (PADDLE_SPEED * dt))
  elseif DIFF_A_BALL_Y < -15 then
    PADDLE_A_Y = math.max(0, PADDLE_A_Y - (PADDLE_SPEED * dt))
  end
end


function love.draw()
  push:start()

  sayHello()
  drawPongSprites()

  push:finish()
end


--- custom
function sayHello()
  local text = "PONG\n[ESC] to Quit."
  love.graphics.clear(40/255, 30/255, 50/255, 1)    -- RGBA
  love.graphics.setFont(pixel_font_big)
  -- love.graphics.print( text, x, y, r, sx, sy, ox, oy, kx, ky )
  --
  love.graphics.printf(text, 0, HALF_GAME_HEIGHT+(HALF_GAME_HEIGHT/2), GAME_WIDTH, 'center')
end


function drawPongSprites()
  -- left paddle
  love.graphics.rectangle('fill', PADDLE_A_X, PADDLE_A_Y, PADDLE_BREADTH, PADDLE_LENGTH)
  -- right paddle
  love.graphics.rectangle('fill', PADDLE_B_X, PADDLE_B_Y, PADDLE_BREADTH, PADDLE_LENGTH)
  -- ball
  love.graphics.rectangle('fill', BALL_X, BALL_Y, BALL_RADIUS, BALL_RADIUS)

  printGameScores()
end


function printGameScores()
  love.graphics.print(tostring(PLAYER_A_SCORE), 15, HALF_GAME_HEIGHT-16)
  love.graphics.print(tostring(PLAYER_B_SCORE), GAME_WIDTH-20, HALF_GAME_HEIGHT-16)
end
