local fight = {}

Player.actions = {
    {
        name = "Swing",
        damage = 10,
    },
    {
        name = "Throw",
        damage = 20,
    },
    {
        name = "Feed",
        damage = -10
    },
    {
        name = "Fart",
        damage = 99,
    }
}

local function load(enemyhealth)
    if not fight.enemyhealth then
        fight.enemyhealth = enemyhealth
        fight.maxenemyhealth = fight.enemyhealth
        fight.playerhealth = Player.health
        fight.maxplayerhealth = fight.playerhealth

        fight.attack = 0

        fight.font = love.graphics.newFont("sprites/EnterCommand.ttf", 16)
        fight.font:setFilter("nearest", "nearest")
        fight.font:setLineHeight(0.6)
        fight.healthbar = love.graphics.newImage("sprites/Fight/Healthbar.png")
        fight.healthG = love.graphics.newImage("sprites/Fight/HealthbarGreen.png")
        fight.healthR = love.graphics.newImage("sprites/Fight/HealthbarRed.png")

        fight.switchsound = love.audio.newSource("audio/Effekte/switch.wav", "static")
        fight.damagesound = love.audio.newSource("audio/Effekte/Schaden.wav", "static")

        fight.state = "player"
        fight.menu = "main"
        fight.page = 1
        fight.action = 1
    end
end

local function getCurrentList()
    if fight.menu == "main" then
        return Player.actions

    elseif fight.menu == "special" then
        return Player.specials

    elseif fight.menu == "item" then
        return Player.items
    end

    return nil
end

local function drawActions(list)
    local start = (fight.page - 1) * 3 + 1
    local finish = math.min(start + 2, #list)

    local areaWidth = 50

    love.graphics.setColor(0.0,1.0,0.0,1.0)

    -- immer 3 Actions drawen

    for i = 1, 3 do
        local index = start + i - 1
        local name = ""

        if list[index] then
            name = list[index].name
        end

        local text = "  " .. name

        if i == fight.action then
            text = "$ " .. name
        end

        local tw = fight.font:getWidth(text)

        local x = 5 + (i - 1) * areaWidth + (areaWidth - tw) / 2

        love.graphics.print(
            text,
            fight.font,
            x,
            77
        )
    end

    -- Arrows

    if fight.page > 1 then
        love.graphics.print("<", fight.font, -1, 77)
    end

    if finish < #list then
        love.graphics.print(">", fight.font, 155, 77)
    end
end

local function ui()
    -- Health --
    love.graphics.draw(fight.healthbar, 0, 0)
    love.graphics.draw(fight.healthR, 98 + ((1-(fight.enemyhealth/fight.maxenemyhealth)) * 62) , 2)
    love.graphics.draw(fight.healthG, 0 - ((1-(fight.playerhealth/fight.maxplayerhealth)) * 62) , 2)

    -- Fight Menu --
    if fight.state == "player" then
        Player.canmove = false
        love.graphics.setColor(0.0,0.0,0.0)
        love.graphics.rectangle("fill", 0,79,160, 11)
        love.graphics.setColor(1.0,1.0,1.0)

        if getCurrentList() then
            drawActions(getCurrentList())
        end

    end
end

local function input(key)

    if fight.state == "player" then

    -- maxaction --

    local list = getCurrentList()

    if list then
        local start = (fight.page - 1) * 3 + 1
        fight.maxaction = math.min(3, #list - start + 1)
    else
        fight.maxaction = 3
    end


    -- switch within pages --

    if key == Keys.left then
        if fight.action > 1 then
            fight.switchsound:play()
            fight.action = fight.action - 1
        end


    elseif key == Keys.right then
        if fight.action < fight.maxaction then
            fight.switchsound:play()
            fight.action = fight.action + 1
        end


    -- previous page --

    elseif key == Keys.up then
        if list then
            local maxpage = math.ceil(#list / 3)

            if fight.page > 1 then
                fight.switchsound:play()
                fight.page = fight.page - 1
                fight.action = 1
            end
        end


    -- next page --

    elseif key == Keys.down then
        if list then
            local maxpage = math.ceil(#list / 3)

            if fight.page < maxpage then
                fight.switchsound:play()
                fight.page = fight.page + 1
                fight.action = 1
            end
        end

    elseif key == Keys.action1 then
        if fight.menu == "main" then
            local index = (fight.page - 1) * 3 + fight.action
            local action = Player.actions[index]

            if action then
                    fight.enemyhealth = fight.enemyhealth - action.damage
                    fight.state = "enemy"
            end
        end
    end
    end
end


local function newAttack(allAttacks)
    if fight.attack == nil or fight.attack == 0 then
        fight.attack = math.random(1,allAttacks)
    end
end


fight.ui = ui
fight.load = load
fight.input = input
fight.newAttack = newAttack

return fight
