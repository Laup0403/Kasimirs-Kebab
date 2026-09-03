local player = require 'script/player'
love.graphics.setDefaultFilter("nearest","nearest")
local textbox = {}
textbox.visible = false
textbox.sprite = love.graphics.newImage('sprites/Textbox.png')
textbox.text = {}
textbox.choice = {}

local function outputText(name ,newtext, afterCall)
    textbox.visible = true
    table.insert(textbox.text, { n = name, t = newtext, c = false, after = afterCall})
end

local function question(name, newtext, ifYes, ifNo)
    textbox.visible = true
    table.insert(textbox.text, { n = name, t = newtext, c=true, yes = ifYes, no = ifNo })
end

local function showTextbox()
    if textbox.visible and textbox.text[1] ~= nil then
        local text = textbox.text[1]
        player.canmove = false
        love.graphics.draw(textbox.sprite, 0, 0)
        love.graphics.setColor(0, 0, 0)

        if text.n and text.t then
            love.graphics.print(">" .. text.n, 34, 55, 0, 0.5)
            love.graphics.print(text.t, 34, 59, 0, 0.7)
        end
    end
end

local function checkInput(key)
    if not textbox.visible or textbox.text[1] == nil then
            return
    elseif textbox.visible then

        local text = textbox.text[1]

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

        -- Bei jeder normalen Textbox nur K/Y/Z akzeptieren
    if text.c ~= true then
        if key ~= Keys.action1 then
            return
        end
        if text.after then text.after() end
    end

        table.remove(textbox.text, 1)

        if #textbox.text == 0 then
            textbox.visible = false
            Player.canmove = true
        end
    end
end

textbox.show = showTextbox
textbox.output = outputText
textbox.question = question
textbox.input = checkInput
return textbox
