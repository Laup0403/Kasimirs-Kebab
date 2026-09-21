local chapter = {}
chapter.state = "fightintro"
local cx, cy = 0, 0
local rx, ry = 0, 0
local nervigkeit = 1
local speak = false
local timer = 0
local projectiles = 0


local intro = love.audio.newSource("audio/CyberJungleIntro.ogg", "stream")
local normal = love.audio.newSource("audio/CyberJungleIntro.ogg", "stream")
local loop = false
local started = false

local function loadColl()
    Coll.create("walldown", -90, 170, 800, 1, true)
    Coll.create("wallmitte", 474, 102, 230, 1, true)
    Coll.create("wallrechts", 474, -112, 1, 214, true)
    Coll.create("wallup", -91, -113, 565, 1, true)
    Coll.create("walllinks", -91, -112, 1, 282, true)
    Coll.create("walleingin", 690, 102, 1, 68, true)
    Coll.create("MsMauer", 112, -112, 112, 42, false, function() chapter.state = "msmauer" end)
end

local function loadAssets()
    wall = {}
    wall.sprite = love.graphics.newImage("sprites/Chapter1/Lüppen.png")
    wall.grid =  Anim8.newGrid(32, 16, 64, 16)
    wall.anim = Anim8.newAnimation(wall.grid('1-2', 1), 0.3)
    wall.elbombo = love.graphics.newImage("sprites/Chapter1/BumBum.png")
end


local function checkCollision(dt)
    if Player.x >= 680 then
        Player.x = 679
        Textbox.output(">Laupi", "Sorry but you\ncan't go back.\nGreetings - the dev")

    elseif speak then

        wall.anim:update(dt)

    elseif chapter.state == "fight" then

        Textbox.output("Your Thougts", "You hear something\nyou can identify", function () chapter.state = "fight1"; Textbox.text = {} end)

    ------------------------------------
    elseif chapter.state == "fightintro" then
    ------------------------------------

        intro:setLooping(false)
        normal:setLooping(true)

        -- if not started then
            -- intro:play()
            -- started = true
        -- elseif not intro:isPlaying() and not normal:isPlaying() then
            -- normal:play()
            -- loop = true
        -- end

        if not boxes["bossdown"] then
            Coll.create("bossdown", 62, 2, 220, 1, true)
            Coll.create("bossleft", 62, -110, 1, 110, true)
            Coll.create("bossright", 273, -110, 1, 110, true)
            Player.x = 168
            Player.y = -62
            Player.dir = 'u'
            Coll.remove("MsMauer")
            Camera.setScale(0.4)
        end

        Camera.setTarget(168, -96)

        if Fight.state == "enemy" then
            Player.canmove = true
            Fight.newAttack(2)

            if Fight.attack then

            -- Spawn --
            if not Fight.projectile then Fight.projectile = {} end

            local sx = 0

            if Fight.attack == 1 then

                sx = -50
                for i, p in ipairs(Fight.projectile) do
                    if p.x >= 400 then
                        table.remove(Fight.projectile, i)
                    end
                    p.x = p.x + 3
                end

            elseif Fight.attack == 2 then

                sx = 400
                for i, p in ipairs(Fight.projectile) do
                    if p.x <= -50 then
                        table.remove(Fight.projectile, i)
                    end
                    p.x = p.x - 3
                end

            end

            -- Move --
            if timer <= 0 and projectiles ~= 20 then
                table.insert(Fight.projectile, {x=sx,y=math.random(-100,10)})
                timer = 0.5
                projectiles = projectiles + 1
            elseif projectiles == 20 and not Fight.projectile[1] then
                Fight.state = "player"
                Fight.projectile = {}
                projectiles = 0
                Fight.attack = nil
            end

            timer = timer - dt

            -- Collide --
            for i,p in ipairs(Fight.projectile) do
                if not p.c then
                    Coll.create("P:"..i, p.x,p.y,16,5,false,
                        function()
                            if not Fight.damagesound:isPlaying() then
                                Fight.playerhealth = Fight.playerhealth - 5
                                Fight.damagesound:play()
                            end
                        end
                    )
                    p.c = true
                elseif boxes["P:"..i] then
                    boxes["P:"..i].x = p.x
                    boxes["P:"..i].y = p.y
                    if Coll.collide("playerHurtbox", "P:"..i) then
                        boxes["P:"..i].overlap()
                    end
                end
            end

            end
        end

    -------------------------------------------------------
    elseif nervigkeit == 5 and chapter.state == "rock" then
    -------------------------------------------------------

        Player.canmove = false
        rx = Player.x - 16
        if ry <= Player.y - 60 then ry = ry + 6
        else chapter.state = "dead" end

    -----------------------------------------
    elseif chapter.state == "chapterend" then
    -----------------------------------------

        if Player.area == "chapterend" then
            Camera.setScale(0.4)
        else
            Camera.setScale(1.0)
        end

    -------------------------------------
    elseif chapter.state == "mauer2" then
    -------------------------------------

        if not Textbox.text[1] then
            Textbox.output("Ms. Mauer", "Hello young man!")
            Textbox.output("Ms. Mauer", "Do you wan't to enter\nthe valley?")
            Textbox.question("Klaus", "Yes (" .. Keys.action1 .. ")\nNo (" .. Keys.action2 .. ")",
                function()
                    Textbox.output("MsMauer", "It's not easy in there, yk?"); Textbox.output("MsMauer",
                        "If you want to get in...\nTHEN SHOW ME YOUR\nSKILLS!", function() chapter.state = "fight" end)
                end,
                function()
                    Textbox.output("MsMauer", "Then go away!\nThis isn't a playground!"); Coll.create("MsMauer", 112,
                        -112, 112, 42, false, function() Player.area = "chapterend" end); chapter.state = "chapterend";
                            cx, cy = 0, 0
                end)
        end
        wall.anim:update(dt)

    --------------------------------------
    elseif chapter.state == "msmauer" then
    --------------------------------------

        Player.canmove = false

        if Player.x + cx > 168 then
            cx = cx - 1
        elseif Player.x + cx < 168 then
            cx = cx + 1
        end

        if Player.y + cy > -120 then
            cy = cy - 1
        end

        if Camera.getScale() > 0.4 then
            Camera.setScale(Camera.getScale() - 0.04)
        end

        if math.abs((Player.x + cx) - 168) <= 1
           and math.abs((Player.y + cy) - (-120)) <= 1
           and Camera.getScale() <= 0.401 then

            Coll.remove("MsMauer")
            chapter.state = "mauer2"
        end

    end
end

local function update(dt)
    if Switch then
        map = Sti('tilemaps/chapter1.lua', { "spritebatch" })
        Player.setup(549,137,'l')
        loadColl()
        loadAssets()
        Switch = false
        Player.canmove = true
    end
    Player.area = "none"
    Camera.setTarget(Player.x + cx, Player.y + cy - 16)
    if chapter.area ~= "fight" then Player.update(dt) end
    checkCollision(dt)
    Camera.update(dt)
end

local function draw()
    if chapter.state == "fight1" then
        love.graphics.draw(love.graphics.newImage("sprites/Spookyman.png"), 0, 0)
    else
        Camera:attach()
        map:drawLayer(map.layers["Floor"])
        map:drawLayer(map.layers["Flowers"])
        map:drawLayer(map.layers["Black Pink in your Area"])

        wall.anim:draw(wall.sprite, 152, -140)

        local drawables = {}
        table.insert(drawables,
            { y = Player.y - 32, draw = function() Player.anim:draw(Player.sprite, Player.x - 8 + Player.offsetX, Player.y - 32) end })
        table.sort(drawables, function(a, b) return a.y < b.y end)
        for _, item in ipairs(drawables) do item.draw() end

        if chapter.state == "rock" or chapter.state == "dead" then love.graphics.draw(love.graphics.newImage('sprites/Chapter1/BösiSteini.png'), rx, ry, 0 , 2, 2) end

        if Fight.attack == 1 or Fight.attack == 2 then
                for i, p in ipairs(Fight.projectile) do
                    love.graphics.draw(wall.elbombo, p.x, p.y)
                end
        end

        Camera:detach()

        if chapter.state == "fightintro" then
            Fight.load(100)
            Fight.ui()
        end
    end
end

local function input(key)
    if Textbox.visible then
        Textbox.input(key)

    -----------------------------------------
    elseif chapter.state == "fightintro" then
    -----------------------------------------

        Fight.input(key)

    ------------------------------------
    elseif chapter.state == "fight1" and key == Keys.action1 then
    ------------------------------------

        Textbox.output("???", "Yo, wassup")
        Textbox.output("???", "I'm the Spookyman.")
        Textbox.output("Spookyman", "Normally, you should'nt\nmeet me")
        Textbox.output("Spookyman","but I saw you had no\nweapon and how will you\nfight without a weapon?")
        Textbox.output("Spookyman", "Let me check if I have\nsome weapon...\nHere's a blue plastic nife.")
        Textbox.output("Spookyman", "Sorry I have nothing else")
        Textbox.output("Spookyman", "I wanted to explain the\nfight system to you but\nno one likes my tutorials")
        Textbox.output("Spookyman", "so good luck!\nor bad luck! (if you\ndon't like good luck)", function() Textbox.text = {}; chapter.state = "fightintro" end)

    -----------------------------------
    elseif chapter.state == "dead" and key == Keys.action1 then
    -----------------------------------

        Switch = true
        Camera.setScale(1.0)
        boxes = {}
        wall = nil
        collectgarbage("collect")

    -------------------------------------------------------------------------------------
    elseif Player.area == "chapterend" and Player.dir == 'u' and key == Keys.action1 then
    ---------------------------------------------------------------------------------

        speak = true
        Textbox.question("MsMauer", "Did you change your mind?\nYes (" .. Keys.action1 .. ")  No (" .. Keys.action2 .. ")",
            function()
                Textbox.output("MsMauer", "It's not easy in there, yk?"); Textbox.output("MsMauer",
                    "If you want to get in...\nTHEN SHOW ME YOUR\nSKILLS!", function() chapter.state = "fight" end)
            end,
            function()
                speak = false
                if nervigkeit == 1 then
                    Textbox.output("MsMauer", "THEN GO AWAY!")
                    nervigkeit = 2
                elseif nervigkeit == 2 then
                    Textbox.output("MsMauer", "really?")
                    nervigkeit = 3
                elseif nervigkeit == 3 then
                    Textbox.output("MsMauer", "do you think you are\nfunny?")
                    nervigkeit = 4
                elseif nervigkeit == 4 then
                    Textbox.output("MsMauer", "Enough!", function() chapter.state = "rock"; rx = Player.x; ry = Player.y - 200 end)
                    nervigkeit = 5
                end
            end)
    end

    if key == Keys.action2 then
        Player.attack = true
    end
end

chapter.update = update
chapter.draw = draw
chapter.input = input

return chapter
