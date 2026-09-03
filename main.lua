function love.load()
    Push = require 'libraries/push'
    Anim8 = require 'libraries/anim8'
    Sti = require 'libraries/sti'

    setupScreen()
    Camera = require 'libraries/CameraMgr'.newManager()

    Coll = require 'script/collsilision'
    Player = require 'script/player'
    Textbox = require 'script/textbox'
    Intro = require 'script/intro'
    Chapter1 = require 'script/chapter1'
    Menu = require 'script/menu'

    Gamestate = "chapter1"
    Switch = true

    Keys = {
        up = "up",
        down = "down",
        left = "left",
        right = "right",
        action1 = "y",
        action2 = "x",
    }

end

function love.update(dt)
    if Gamestate == "menu" then Menu.load()
    elseif ({intro=true , hansrakete=true, hans=true, ticklemonster=true})[Gamestate] then Intro.update(dt)
    elseif Gamestate == "chapter1" then Chapter1.update(dt) end

    --print("X:" .. Player.x .. " Y:" .. Player.y)
end

function love.draw()
    Push:start()

    if Gamestate == "menu" then Menu.draw()
    elseif ({intro=true , h=true, hans=true, ticklemonster=true})[Gamestate] then Intro.draw()
    elseif Gamestate == "chapter1" then Chapter1.draw() end

    ---Textbox---
    Textbox.show()

    Push:finish()
    love.graphics.setColor(1, 1, 1)
end

function love.keyreleased(key)
    if Gamestate == "menu" then Menu.input(key)
    elseif ({intro=true , hansrakete=true, hans=true, ticklemonster=true})[Gamestate] then Intro.keyspressed(key)
    elseif Gamestate == "chapter1" then Chapter1.input(key)

    else Textbox.input(key) end

end

function love.resize(w, h)
    Push:resize(w, h)
end

function setupScreen()
    love.graphics.setDefaultFilter("nearest", "nearest")
    Font = love.graphics.newFont('sprites/Comicoro.ttf', 16)
    Font:setFilter("nearest", "nearest")
    Font:setLineHeight(0.70)
    love.graphics.setFont(Font)

    local windowWidth, windowHeigth = love.window.getDesktopDimensions()
    Push:setupScreen(160, 90, windowWidth * 0.8, windowHeigth * 0.8,
        { fullscreen = false, resizable = true, pixelperfect = true, canvas = false })
end
