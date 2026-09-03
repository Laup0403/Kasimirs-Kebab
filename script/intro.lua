local coll = require 'script/collsilision'
local intro = {}

local doni = false
local switched = false
local warned = false
local cy, cx = 0, 0
local ticklemonster = love.graphics.newImage("sprites/intro/Kitzelmonsta.png")
local map = Sti('tilemaps/holybibi.lua')
local kebab = love.graphics.newImage('sprites/intro/DönermannOhneFlei.png')
local logo = love.graphics.newImage('sprites/intro/logo/Background.png')
local sign = love.graphics.newImage('sprites/intro/Shield.png')
local waterfall = {}
waterfall.s = love.graphics.newImage('sprites/intro/logo/Waterfall.png')
waterfall.g = Anim8.newGrid(160, 90, waterfall.s:getWidth(), waterfall.s:getHeight())
waterfall.a = Anim8.newAnimation(waterfall.g('1-3', 1), 0.1)
hans = { sprite = love.graphics.newImage('sprites/intro/HansMitHut.png'), }
hans.grid = Anim8.newGrid(16, 48, hans.sprite:getWidth(), hans.sprite:getHeight())
hans.idle = Anim8.newAnimation(hans.grid(1, 1, 1, 1, 1, 1, '1-3', 1, 3, 1, 3, 1, 3, 1, 2, 1), 0.1)
hans.y = 70
hans.r = 0

local function loadColl()
    Coll.create("Hans", 113, hans.y + 28, 10, 20, true)
    Coll.create("HansText", 113, hans.y + 48, 10, 40, false, function() Player.area = "hans" end)
    Coll.create("Döni", 384, 86, 64, 26, true)
    Coll.create("DöniText", 394, 112, 44, 20, false, function() Player.area = "döni" end)
    Coll.create("Wall1", -500, -240, 1000, 1, true)
    Coll.create("Chapter1", -350, -200, 180, 70, false, function() Player.area = "chapter1" end)
    Coll.create("sign", 56, 118, 16, 2, true)
    Coll.create("singText", 58, 120, 12, 15, false, function() Player.area = "sign" end)
end

local function game(dt)
    if Switch then
        Player.setup(-60, 139, 'd')
        loadColl()
        Switch = false
    end
    Player.area = "none"

    Player.update(dt)
    map:update(dt)
    Camera.setTarget(Player.x + cx, Player.y - 16 + cy)

    Camera.update(dt)

    hans.idle:update(dt)
    waterfall.a:update(dt)
end

local function update(dt)
    if Gamestate == "hansrakete" then
        hans.state = "hansrakete"
        hans.sprite = love.graphics.newImage('sprites/intro/HansMitHubschrauber.png')
        Gamestate = "intro"
    end
    if Gamestate == "intro" then
        game(dt)
        if (Player.x <= -200 or Player.y >= 350 or Player.x >= 550) and not warned then
            Textbox.output("???", "Turn around or\nthe tickle monster comes")
            warned = true
        end
        if Player.x <= -350 or Player.y >= 500 or Player.x >= 700 then
            Textbox.output("???", "I warned you!", function() table.remove(Textbox.text, 1); Gamestate = "ticklemonster"; print("sudo rm -rf /") end)
            warned = false
        end
        if (Player.x > -199 and Player.y < 349 and Player.x < 549) and warned then
            warned = false
        end
    end
    if Gamestate == "hans" then
        if Switch then
            hans.hand = love.graphics.newImage('sprites/intro/CooleAnimation.png')
            hans.state = "start"
            Switch = false
            hans.handgrid = Anim8.newGrid(80, 45, hans.hand:getWidth(), hans.hand:getHeight())
            hans.handanim = Anim8.newAnimation(hans.handgrid('1-15', 1), 0.07, function() hans.state = "end" end)
        end
        if hans.state == "run" then
            hans.handanim:update(dt)
        elseif hans.state == "end" then
            hans.handanim:gotoFrame(15)
        end
    end
    if hans.state == "4" and Player.area == "hans" then
        Textbox.output("Hans", "Look at that amazing view!", function()hans.sprite = love.graphics.newImage('sprites/intro/HansMitHut.png');Textbox.output("Hans","I have an Idea!");Textbox.output("Hans","Let's race!\nWhoever finds the kebab\nskewer first wins!", function() hans.state = "5" end) end)
        hans.state = "none"
    end
    if hans.state == "5" then
        hans.sprite = love.graphics.newImage('sprites/intro/HansMitHubschrauber.png')
        Player.canmove = false
        if hans.y >= -300 then
            hans.r = hans.r + 0.1
            hans.y = hans.y - 0.22
        else
            hans.state = "6"
            Coll.remove("Hans")
            Coll.remove("HansText")
            hans.y = -600
        end
    end
    if hans.state == "6" then
        if cy + Player.y ~= -264 then
            if ((cx + Player.x) % 4) ~= 0 then
                cx = cx + (4 - ((cx + Player.x) % 4))
            end
            cy = cy - 1
        else
            cy = -300 - Player.y
            cx = 180 - Player.x
            hans.state = "7"
        end
    end
    if hans.state == "7" and cy + Player.y ~= -740 then cy = cy - 1 elseif cy + Player.y == -740 then hans.state = "8" end
    if hans.state == "hansrakete" then
        Player.canmove = false
        if hans.y >= 0 then
            hans.y = hans.y - 1
        else
            hans.y = -230
            hans.sprite = love.graphics.newImage('sprites/intro/HansBack.png')
            coll.remove("Hans")
            coll.remove("HansText")
            Coll.create("Hans", 113, hans.y + 28, 10, 20, true)
            Coll.create("HansText", 60, hans.y, 100, 50, false, function() Player.area = "hans" end)
            coll["HansText"] = nil
            Player.canmove = true
            hans.state = "4"
        end
    end

    if Player.area == "chapter1" and not switched then
        Textbox.question("Laupi", "You are going to enter the\nvalley. Are you sure?\n    Yes(" .. Keys.action1 .. ") No(" .. Keys.action2 .. ")", function()
            Gamestate = "chapter1"
            Switch = true
            intro = nil
            Textbox.text = {}
            boxes = {}
            collectgarbage("collect")
            switched = true
        end, function()
            switched = true
            Textbox.text = {}
        end)
    end
end

local function draw()
    if Gamestate == "intro" then
        Camera.attach()
        map:drawLayer(map.layers["Boden"])
        map:drawLayer(map.layers["Unkraut"])

        local drawables = {}

        table.insert(drawables, { y = 64, draw = function() love.graphics.draw(kebab, 384, 64) end })
        table.insert(drawables,
            { y = Player.y - 32, draw = function() Player.anim:draw(Player.sprite, Player.x - 8, Player.y - 32) end })
        table.insert(drawables, { y = hans.y, draw = function() hans.idle:draw(hans.sprite, 110, hans.y, hans.r) end })
        table.insert(drawables, { y = 90, draw = function() love.graphics.draw(sign, 56, 104) end })
        love.graphics.draw(logo, 100, -803)
        waterfall.a:draw(waterfall.s, 100, -442)

        table.sort(drawables, function(a, b) return a.y < b.y end)

        for _, item in ipairs(drawables) do item.draw() end

        Camera.detach()
    end
    if Gamestate == "ticklemonster" then
        love.graphics.draw(ticklemonster, 0, 0, 0, 2, 2)
        Textbox.text = {}
    end
    if Gamestate == "hans" then hans.handanim:draw(hans.hand, 0, 0, 0, 2, 2) end
end

local function keyspressed(key)
    if Gamestate == "ticklemonster" and key == Keys.action1 then
        love.event.quit(0)
    end

    if Gamestate == "intro" then

        if key == Keys.action1 and hans.state == "8" then
               cx, cy = 0, 0
               Player.canmove = true
               hans.state = "9"
               print("Lol")

        elseif Textbox.visible == true then
            Textbox.input(key)
        elseif key == Keys.action1 then
            if Player.area == "hans" and Player.dir == 'u' then
                if hans.state == "2" then
                    Textbox.output("Hans", "What are you waiting for?")
                elseif hans.state == "3" then
                    Textbox.output("Klaus", "The kebab skewer was\nstolen by a bettle!")
                    Textbox.output("Hans", "Oh,no!\nWe're did that beetle go?")
                    Textbox.output("Klaus", "The Doner guy said\nhe went to the valley.")
                    Textbox.output("Hans", "We must find this beetle!\nLet's go after him!", function()Gamestate = "hansrakete" end)
                elseif hans.state == "hansrakete" then
                else
                    Textbox.output("Hans", "Yo Klaus!", function()Gamestate = "hans";Switch = true end)
                end
            elseif Player.area == "döni" and Player.dir == 'u' then
                if doni then
                    Textbox.output("Doner guy", "Please, get back my\nkebab skewer. You'll get a\ndoner kebab for free!")
                else
                    Textbox.output("Doner guy", "Do you wan't\na doner kebab?")
                    Textbox.output("Klaus", "Yes, please!")
                    Textbox.output("Doner guy", "Sorry but my kebab skewer\nwas stolen by some beetle\nwith a red cape")
                    Textbox.output("Doner guy", "Can you help me\nget it back, please?")
                    Textbox.output("Doner guy", "The beetle went towards \nthe valley.")
                    hans.state = "3"
                    doni = true
                end
            elseif Player.area == "chapter1" and switched then
                Textbox.question("Laupi", "You are going to enter the\nvalley. Are you sure?\n    Yes(" .. Keys.action1 .. ") No(" .. Keys.action2 .. ")",
                    function()
                        Gamestate = "chapter1"
                        Switch = true
                        intro = nil
                        Textbox.text = {}
                        boxes = {}
                        hans = {}
                        collectgarbage("collect")
                    end, function() switched = true end)
            elseif Player.area == "sign" and Player.dir == 'u' then
                Textbox.output("Sign", "< Nothing\n/ valley\n> kebab shop")
            end
        end
    end

    if Gamestate == "hans" and key == Keys.action1 then
        if hans.state == "start" then
            hans.state = "run"
        elseif hans.state == "end" then
            hans.state = "2"
            hans.handanim = nil
            hans.handgrid = nil
            hans.hand = nil
            Gamestate = "intro"
            Textbox.output("Hans", "Today a new kebab shop \nhas opened in town.")
            Textbox.output("Hans", "You MUST try it.\nGo east to the \nkebab shop.")
        end
    end
end

intro.update = update
intro.draw = draw
intro.keyspressed = keyspressed

return intro
