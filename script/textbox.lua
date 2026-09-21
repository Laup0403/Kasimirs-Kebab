local player = require 'script/player'
love.graphics.setDefaultFilter("nearest","nearest")
local textbox = {}
textbox.visible = false
textbox.sprite = love.graphics.newImage('sprites/Textbox.png')
textbox.buffer = love.graphics.newImage('sprites/Textboxbuffer.png')
textbox.text = {}
textbox.choice = {}

local textSpeed = 0.03
local textTimer = 0
local textIndex = 0
local readState = "ready"
local inputBuffer = 0
local bufferTime = 0.3

local function outputText(name ,newtext, afterCall)
    textbox.visible = true
    table.insert(textbox.text, { n = name, t = newtext, c = false, after = afterCall, index = 0, timer = 0})
end

local function question(name, newtext, ifYes, ifNo)
    textbox.visible = true
    table.insert(textbox.text, { n = name, t = newtext, c=true, yes = ifYes, no = ifNo, index = 0, timer = 0 })
end

local function showTextbox()
    if textbox.visible and textbox.text[1] ~= nil then
        local text = textbox.text[1]
        player.canmove = false
        love.graphics.draw(textbox.sprite, 0, 0)
        love.graphics.setColor(0, 0, 0)

        if text.n and text.t then
            love.graphics.print(">" .. text.n, 34, 55, 0, 0.5)
            local visibleText = string.sub(text.t, 1, text.index)
            love.graphics.print(visibleText, 34, 59, 0, 0.7)
        end

        if readState == "ready" then
            love.graphics.draw(textbox.buffer, 80, 83)
        end
    end
end

local function checkInput(key)
    if not textbox.visible or textbox.text[1] == nil then
            return
    elseif textbox.visible then

        local text = textbox.text[1]

        if readState == "reading" then

            if key == Keys.action1 then
                text.index = #text.t
                readState = "ready"
                inputBuffer = bufferTime
            end

        elseif readState == "ready" then
            -- Choice
            if text.c == true then
                if key == Keys.action2 or key == Keys.action2 then
                    text.no()
                elseif key == Keys.action1 then
                    text.yes()
                else
                    return
                end
            end

        if text.c ~= true then
            if key ~= Keys.action1 then
                return
            end
            inputBuffer = bufferTime
            if text.after then text.after() end
        end

            table.remove(textbox.text, 1)

            if #textbox.text == 0 then
                textbox.visible = false
                Player.canmove = true
            end
        end
    end
end

local function update(dt)
    if not textbox.visible or textbox.text[1] == nil then
        return
    end

    local text = textbox.text[1]

    if text.index < #text.t then
        readState = "reading"
        text.timer = text.timer + dt

        if text.timer >= textSpeed then
            text.timer = 0
            text.index = text.index + 1

            local c = string.sub(text.t, text.index, text.index)

            if c == "," then
                text.timer = -0.1
            elseif c == "." or c == "?" or c == "!" then
                text.timer = -0.3
            end

        end
    else
        readState = "ready"
    end

    if inputBuffer > 0 then
    inputBuffer = inputBuffer - dt
    end
end

textbox.show = showTextbox
textbox.output = outputText
textbox.question = question
textbox.input = checkInput
textbox.update = update
return textbox
