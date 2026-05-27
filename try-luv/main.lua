WINDOW_WIDTH = 1150
WINDOW_HEIGHT = 700

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
      resizable = false,
      vsync = true,
      fullscreen = false,
    })
end


function love.draw()
  local text = "Hello, World!"
  local textX = (love.graphics.getWidth()/2) - (string.len(text)/2)
  local textY = love.graphics.getHeight()/2
  -- love.graphics.print( text, x, y, r, sx, sy, ox, oy, kx, ky )
  love.graphics.print(text, textX, textY)
end
