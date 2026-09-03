local Coll = require 'script/collsilision'
local player = {}

local function setupPlayer(newX,newY,direction)
    player.x = newX
    player.y = newY
    player.speed = 3
    player.sprite = love.graphics.newImage('sprites/Sohnemann.png')
    player.dir = direction
    player.moving = false
    player.area = "none"
    player.canmove = true

    player.grid = Anim8.newGrid(16, 32, player.sprite:getWidth(), player.sprite:getHeight())
    player.animations = {
        idledown  = Anim8.newAnimation(player.grid(1, 1), 0.2),
        idleup    = Anim8.newAnimation(player.grid(1, 2), 0.2),
        idleright = Anim8.newAnimation(player.grid(1, 3), 0.2),
        idleleft  = Anim8.newAnimation(player.grid(1, 4), 0.2),
        walkdown  = Anim8.newAnimation(player.grid('2-9', 1), 1/12),
        walkup    = Anim8.newAnimation(player.grid('2-9', 2), 1/12),
        walkright = Anim8.newAnimation(player.grid('1-8', 3), 1/12),
        walkleft  = Anim8.newAnimation(player.grid('1-8', 4), 1/12)
    }
    player.anim = player.animations.idledown

        Coll.create("player", player.x - 6, player.y - 7, 12, 6, true)
end


local function updatePlayer(dt)
    player.moving = false

    if love.keyboard.isDown(Keys.up, Keys.down, Keys.left, Keys.right) and player.canmove then
        player.moving = true
        if love.keyboard.isDown(Keys.up) then
            player.y = player.y - player.speed
            player.anim = player.animations.walkup
            player.dir = 'u'
        elseif love.keyboard.isDown(Keys.down) then
            player.y = player.y + player.speed
            player.anim = player.animations.walkdown
            player.dir = 'd'
        elseif love.keyboard.isDown(Keys.left) then
            player.x = player.x - player.speed
            player.anim = player.animations.walkleft
            player.dir = 'l'
        elseif love.keyboard.isDown(Keys.right) then
            player.x = player.x + player.speed
            player.anim = player.animations.walkright
            player.dir = 'r'
        end
    elseif player.dir == 'u' then
        player.anim = player.animations.idleup
    elseif player.dir == 'd' then
        player.anim = player.animations.idledown
    elseif player.dir == 'l' then
        player.anim = player.animations.idleleft
    elseif player.dir == 'r' then
        player.anim = player.animations.idleright
    end

    boxes["player"].x = player.x - 6
    boxes["player"].y = player.y - 7

    Coll.collide(player.dir, player.x, player.y)

    player.x = boxes["player"].x + 6
    player.y = boxes["player"].y + 7

    player.anim:update(dt)
end

player.setup = setupPlayer
player.update = updatePlayer

return player
