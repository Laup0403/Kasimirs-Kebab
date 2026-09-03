local chapter = {}
chapter.state = "none"
local cx, cy = 0, 0
local rx, ry = 0, 0
local nervigkeit = 1

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
end


local function checkCollision(dt)
    if Player.x >= 680 then
        Player.x = 679
        Textbox.output(">Laupi", "Sorry but you\ncan't go back.\nGreetings - the dev")

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
                        "If you want to get in...\nTHEN SHOW ME YOUR\nSKILLS!")
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
    Camera.update(dt)
    Player.update(dt)
    checkCollision(dt)
end

local function draw()
    Camera:attach()
    map:drawLayer(map.layers["Floor"])
    map:drawLayer(map.layers["Flowers"])

    wall.anim:draw(wall.sprite, 152, -140)

    local drawables = {}
    table.insert(drawables,
        { y = Player.y - 32, draw = function() Player.anim:draw(Player.sprite, Player.x - 8, Player.y - 32) end })
    table.sort(drawables, function(a, b) return a.y < b.y end)
    for _, item in ipairs(drawables) do item.draw() end

    if chapter.state == "rock" or chapter.state == "dead" then love.graphics.draw(love.graphics.newImage('sprites/Chapter1/BösiSteini.png'), rx, ry, 0 , 2, 2) end

    Camera:detach()
end

local function input(key)
    if Textbox.visible then
        Textbox.input(key)

    -----------------------------------
    elseif chapter.state == "dead" and key == Keys.action1 then
    -----------------------------------

        Switch = true
        boxes = {}
        wall = nil
        collectgarbage("collect")


    -------------------------------------------------------------------------------------
    elseif Player.area == "chapterend" and Player.dir == 'u' and key == Keys.action1 then
        ---------------------------------------------------------------------------------
        Textbox.question("MsMauer", "Did you change your mind?\nYes (" .. Keys.action1 .. ")  No (" .. Keys.action2 .. ")",
            function()
                Textbox.output("MsMauer", "It's not easy in there, yk?"); Textbox.output("MsMauer",
                    "If you want to get in...\nTHEN SHOW ME YOUR\nSKILLS!")
            end,
            function()
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
end

chapter.update = update
chapter.draw = draw
chapter.input = input

return chapter
