local Coll = require 'script/collsilision'
local player = {}

local function setupPlayer(newX,newY,direction)
    player.x = newX
    player.y = newY
    player.speed = 1
    player.sprite = love.graphics.newImage('sprites/Sohnemann.png')
    player.dir = direction
    player.moving = false
    player.area = "none"
    player.canmove = true
    player.offsetX = 0
    player.health = 100

    -- Animations --
    player.grid = Anim8.newGrid(16, 32, player.sprite:getWidth(), player.sprite:getHeight())
    player.animations = {
        idledown  = Anim8.newAnimation(player.grid(1, 1), 0.2),
        idleup    = Anim8.newAnimation(player.grid(1, 2), 0.2),
        idleright = Anim8.newAnimation(player.grid(1, 3), 0.2),
        idleleft  = Anim8.newAnimation(player.grid(1, 4), 0.2),
        walkdown  = Anim8.newAnimation(player.grid('2-5', 1), 1/8),
        walkup    = Anim8.newAnimation(player.grid('2-5', 2), 1/8),
        walkright = Anim8.newAnimation(player.grid('1-4', 3), 1/8),
        walkleft  = Anim8.newAnimation(player.grid('1-4', 4), 1/8),
        attackdown = Anim8.newAnimation(player.grid('6-9', 1), 1/10, function() player.attack = false end),
        attackup = Anim8.newAnimation(player.grid('6-9', 2), 1/10, function() player.attack = false end),
        attackright = Anim8.newAnimation(player.grid('6-9', 3), 1/10, function() player.attack = false end),
        attackleft = Anim8.newAnimation(player.grid('6-9', 4), 1/10, function() player.attack = false end),
    }
    player.anim = player.animations.idledown

    -- Collision boxes --
    Coll.create("player", player.x - 6, player.y - 7, 12, 6, true)
    Coll.create("playerHurtbox", player.x-4, player.y-29, 8, 28)
    -- Coll.create("playerleft", Player.x -20, Player.y - 26, 20, 22)
    -- Coll.create("playerright", Player.x, Player.y - 26, 20, 22)
    -- Coll.create("playerup", Player.x - 5, Player.y - 40, 10, 20)
    -- Coll.create("playerdown",Player.x - 5, Player.y - 10, 10, 20)

end


local function updatePlayer(dt, canMoveLeft, canMoveRight, canMoveUp, canMoveDown)
    player.moving = false

    if love.keyboard.isDown(Keys.up, Keys.down, Keys.left, Keys.right) and player.canmove then
        player.moving = true
        if love.keyboard.isDown(Keys.up) and not canMoveUp then
            player.y = player.y - player.speed
            player.anim = player.animations.walkup
            player.dir = 'u'
        elseif love.keyboard.isDown(Keys.down) and not canMoveDown then
            player.y = player.y + player.speed
            player.anim = player.animations.walkdown
            player.dir = 'd'
        elseif love.keyboard.isDown(Keys.left) and not canMoveLeft then
            player.x = player.x - player.speed
            player.anim = player.animations.walkleft
            player.dir = 'l'
        elseif love.keyboard.isDown(Keys.right) and not canMoveRight then
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

    player.offsetX = 0
    if player.attack then
        if player.dir == 'u' then
            player.anim = player.animations.attackup
        elseif player.dir == 'd' then
            player.anim = player.animations.attackdown
        elseif player.dir == 'l' then
            player.anim = player.animations.attackleft
            player.offsetX = -3
        elseif player.dir == 'r' then
            player.anim = player.animations.attackright
            player.offsetX = 3
        end
    end

    boxes["player"].x = player.x - 6
    boxes["player"].y = player.y - 7

    for id, box in pairs(boxes) do
        local p = boxes["player"]
        if box ~= p and Coll.collide("player", box) then
            if box.wall == false then
                box.overlap()
            elseif box.wall == true then
                if player.dir == 'l' then
                    p.x = box.x + box.w
                elseif player.dir == 'r' then
                    p.x = box.x - p.w
                elseif player.dir == 'u' then
                    p.y = box.y + box.h
                elseif player.dir == 'd' then
                    p.y = box.y - p.h
                end
            end
        end
    end

    player.x = boxes["player"].x + 6
    player.y = boxes["player"].y + 7

    boxes["playerHurtbox"].x = player.x - 4
    boxes["playerHurtbox"].y = player.y - 29

    player.anim:update(dt)
end

player.setup = setupPlayer
player.update = updatePlayer

return player
