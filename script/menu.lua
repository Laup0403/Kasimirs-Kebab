local menu = {}
menu.state = "main"
local buttons = {}
local vars = {
    h = 12,
    w = 50,
    x = 0,
    y = 0,
    button = love.graphics.newImage("sprites/Menu/button.png"),
    buttonh = love.graphics.newImage("sprites/Menu/buttonhover.png"),
    exit = love.graphics.newImage("sprites/Menu/exit.png"),
    exith = love.graphics.newImage("sprites/Menu/exithover.png"),
    bg = love.graphics.newImage("sprites/Menu/TitelBild.png"),
    settings = love.graphics.newImage("sprites/Menu/Settings.png"),
    settingsbutton = love.graphics.newImage("sprites/Menu/settingsbutton.png"),
    settingsbuttonh = love.graphics.newImage("sprites/Menu/settingsbuttonhover.png"),
    selected = 1,
    lastselected = 2,
    hover = "Start",
    kdown = false,
    recording = false,
}


local function newButton(text, func)
    return {
        text = text,
        func = func,
    }
end

local function load()
    if Switch and menu.state == "main" then
        buttons = {}
        vars.selected = 1
        vars.hover = "Start"
        vars.kdown = false
        vars.x = 10
        vars.y = 40
        table.insert(buttons, newButton("Start", function()
            Gamestate = "intro"
            Switch = true
        end))
        table.insert(buttons, newButton("Load", function() menu.state = "load"; Switch = true end))
        table.insert(buttons, newButton("Settings", function() menu.state = "settings"; Switch = true end))
        table.insert(buttons, newButton("Exit", function() love.event.quit(0) end))
        Switch = false
    elseif Switch and menu.state == "load" then
        buttons = {}
        vars.selected = 1
        vars.hover = "Chapter1"
        vars.kdown = false
        table.insert(buttons, newButton("Chapter1", function()
        Gamestate = "chapter1"
            Switch = true
        end))
        table.insert(buttons, newButton("back", function() menu.state = "main"; Switch = true end))
        Switch = false
    elseif Switch and menu.state == "settings" then
        buttons = {}
        vars.selected = 1
        vars.hover = "Up"
        vars.kdown = false
        vars.x = 9
        vars.y = 11
        table.insert(buttons, newButton("Up", function() vars.recording = true end))
        table.insert(buttons, newButton("Down", function() vars.recording = true end))
        table.insert(buttons, newButton("Left", function() vars.recording = true end))
        table.insert(buttons, newButton("Right", function() vars.recording = true end))
        table.insert(buttons, newButton("Action 1", function() vars.recording = true end))
        table.insert(buttons, newButton("Action 2", function() vars.recording = true end))
        table.insert(buttons, newButton("back", function() menu.state = "main"; Switch = true end))
        Switch = false
    end
end

local function checkInput(key)
    vars.kdown = false
    local s = vars.selected
    local h = vars.hover

    if key == Keys.action1 then
        vars.kdown = true
    end

    if menu.state == "main" then
        if key == Keys.left or key == Keys.right then
            if s == 4 then
                s = vars.lastselected
            else
                vars.lastselected = s
                s = 4
            end
        elseif key == Keys.up and s ~= 4 then
            if s == 1 then
                s = 3
            else
                s = s - 1
            end
        elseif key == Keys.down and s ~= 4 then
            if s == 3 then
                s = 1
            else
                s = s + 1
            end
        end

        if s==1 then h="Start"
        elseif s==2 then h="Load"
        elseif s==3 then h="Settings"
        elseif s==4 then h="Exit"
        end
    elseif menu.state == "load" then
        if key == Keys.up then
            if s == 1 then
                s = 2
            else
                s = s - 1
            end
        elseif key == Keys.down then
            if s == 2 then
                s = 1
            else
                s = s + 1
            end
        end

        if s==1 then h="Chapter1"
        elseif s==2 then h="back"
        end
    elseif menu.state == "settings" then

        if not vars.recording then
            if key == Keys.left or key == Keys.right then
                if s <= 4 then
                    s = 5
                else
                    s = 1
                end
            elseif s <= 4 then
                if key == Keys.up then
                    if s == 1 then
                        s = 4
                    else
                        s = s - 1
                    end
                elseif key == Keys.down then
                    if s == 4 then
                        s = 1
                    else
                        s = s + 1
                    end
                end
            elseif s > 4 then
                if key == Keys.up then
                    if s == 5 then
                        s = 7
                    else
                        s = s - 1
                    end
                elseif key == Keys.down then
                    if s == 7 then
                        s = 5
                    else
                        s = s + 1
                    end
                end
            end
        elseif vars.recording then
            vars.kdown = false
            Keys[(string.lower(h):gsub(" ", ""))] = key
            vars.recording = false
        end

        if s == 1 then h = "Up"
        elseif s == 2 then h = "Down"
        elseif s == 3 then h = "Left"
        elseif s == 4 then h = "Right"
        elseif s == 5 then h = "Action 1"
        elseif s == 6 then h = "Action 2"
        elseif s == 7 then h = "back"
        end
    end

    vars.selected = s
    vars.hover = h
end

local function draw()
    love.graphics.draw(vars.bg, 0, 0)
    if menu.state == "settings" then
        love.graphics.draw(vars.settings, 0, 0)
    end

    local maxHeigth = (vars.h + 4) * #buttons
    local cy = 0
    local sx = vars.x
    local sy = vars.y

    for i, button in ipairs(buttons) do

        if menu.state == "settings" then
            if i == 5 or cy > 80 then
                sx = 82
                cy = 0
            end
            local bx = sx
            local by = sy + cy

            local currentSprite = vars.settingsbutton
            if vars.hover == button.text then currentSprite = vars.settingsbuttonh end
            if vars.kdown and vars.hover == button.text then
                button.func()
            end

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(currentSprite, bx, by)

            local key = Keys[(string.lower(button.text):gsub(" ", ""))]
            local text = button.text
            if key then text = button.text .. ": " .. key end
            if vars.recording and button.text == vars.hover then text = "recording" end
            local tw = Font:getWidth(text)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(text ,bx + (69 - tw) / 2, by - 2)

            cy = cy + (vars.h + 6)

        elseif button.text == "Exit" then
            --local mx, my = Push:toGame(love.mouse.getPosition())
            --local hover = false
            --if mx and my then hover = mx > 62 and mx < 62 + 12 and my > 72 and my < 72 + 12 end
            local currentSprite = vars.exit
            if vars.hover == button.text then currentSprite = vars.exith end
            if vars.kdown and vars.hover == button.text then
                button.func()
            end

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(currentSprite, 62, 72)

            love.graphics.setColor(0, 0, 0)
            love.graphics.print("©", 66, 70)
        else
            local bx = vars.x
            local by = vars.y + cy

            local currentSprite = vars.button
            if vars.hover == button.text then currentSprite = vars.buttonh end
            if vars.kdown and vars.hover == button.text then
                button.func()
            end

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(currentSprite, bx, by)

            local tw = Font:getWidth(button.text)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(button.text, bx + (vars.w - tw) / 2, by - 2)

            cy = cy + (vars.h + 4)
        end
    end
end

menu.input = checkInput
menu.load = load
menu.draw = draw
return menu
