-- made with love 11.5
--

loveFont = love.graphics.getFont()
gameWidth = love.graphics.getWidth()
gameHeight = love.graphics.getHeight()

-- Player Object
player = { x = 200, y = 710, speed = 150, img = nil, isAlive = true, score = 0 }
playerSpritePath = 'assets/plane.png'

-- Bullet Storage
bulletImg = nil
bulletSymbol = '!'  -- look like tiny missile
bulletSpeed = 250
bullets = {}
-- Bullet Timers
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

-- Enemy Storage
enemyImg = nil
bulletSpeed = 175
enemies = {}
enemySpritePath = 'assets/enemy-plane.png'
-- Enemy Timers
createEnemyTimerMax = 1.75
createEnemyTimer = createEnemyTimerMax


--- Custom Fn

local function restartGame()
  bullets = {}
  canShootTimer = canShootTimerMax

  enemies = {}
  createEnemyTimer = createEnemyTimerMax

  player.x = 50
  player.y = 710
  player.score = 0
  player.isAlive = true
end

local function newBullet()
  return {
    x = player.x + (player.img:getWidth()/2),
    y = player.y,
    speed = bulletSpeed,
    img = bulletImg
  }
end

local function newEnemy()
  local enemyHeight = enemyImg:getHeight()
  local randomNumber = math.random(10, gameWidth - 10)
  return {
    x = randomNumber,
    y = -10,
    speed = enemySpeed,
    img = enemyImg,
    height = enemyHeight
  }
end

local function updatePlayer(delta)
  if love.keyboard.isDown('left','a') then
    if player.x > 0 then
      player.x = player.x - (player.speed*delta)
    end
  elseif love.keyboard.isDown('right','d') then
    if player.x < (gameWidth - player.img:getWidth()) then
      player.x = player.x + (player.speed*delta)
    end
  end

  if love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot then
    table.insert(bullets, newBullet())
    canShoot = false
    canShootTimer = canShootTimerMax
  end
end

local function updateBullets(delta)
  canShootTimer = canShootTimer - (1 * delta)
  if canShootTimer < 0 then
    canShoot = true
  end

  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y - (bullet.speed * delta)
    if bullet.y < 0 then
      table.remove(bullets, i)
    end
  end
end

local function updateEnemies(delta)
  for i, enemy in ipairs(enemies) do
    enemy.y = enemy.y + (100 * delta)

    if enemy.y > gameHeight + enemy.height then
      table.remove(enemies, i)
    end
  end

  createEnemyTimer = createEnemyTimer - (1 * delta)
  if createEnemyTimer < 0 then
    createEnemyTimer = math.random(0.5, 1.0) * createEnemyTimerMax

    table.insert(enemies, newEnemy())
  end
end

local function checkCollision(entity1, entity2)
  x1, y1, w1, h1 = entity1.x, entity1.y, entity1.img:getWidth(), entity1.img:getHeight()
  x2, y2, w2, h2 = entity2.x, entity2.y, entity2.img:getWidth(), entity2.img:getHeight()
  return (
    x1 < x2 + w2 and
    x2 < x1 + w1 and
    y1 < y2 + h2 and
    y2 < y1 + h1
  )
end

local function checkForCollisions(delta)
  for i, enemy in ipairs(enemies) do
    for j, bullet in ipairs(bullets) do
      if checkCollision(bullet, enemy) then
        table.remove(enemies, i)
        table.remove(bullets, j)
        player.score = player.score + 1
      end
    end

    if checkCollision(enemy, player) and player.isAlive then
      table.remove(enemies, i)
      player.isAlive = false
    end
  end
end


--- Love overrides

function love.load(arg)
  player.img = love.graphics.newImage(playerSpritePath)
  bulletImg = love.graphics.newText(loveFont, {{1, 0.1, 0.4, 1}, bulletSymbol, {0, 0, 1, 1}})
  enemyImg = love.graphics.newImage(enemySpritePath)
  love.graphics.setColor(255, 255, 255)
end

function love.draw(dt)
  if player.isAlive then
    love.graphics.print("SCORE: " .. tostring(player.score), gameWidth/2 - 25, 10)
    love.graphics.draw(player.img, player.x, player.y)
  else
    love.graphics.printf(
      "SCORE: " .. tostring(player.score) .. "\nPress 'R' to restart",
      0,
      gameHeight / 2 - 10,
      gameWidth,
      'center'
      )
  end

  for _, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
  end

  for _, enemy in ipairs(enemies) do
    love.graphics.draw(enemy.img, enemy.x, enemy.y)
  end
end

function love.update(dt)
  if love.keyboard.isDown('escape' , 'q') then
    love.event.push('quit')
  end

  if player.isAlive then
    updatePlayer(dt)
    updateBullets(dt)
    updateEnemies(dt)
    checkForCollisions(dt)
  else
    if love.keyboard.isDown('r') then restartGame() end
  end
end
