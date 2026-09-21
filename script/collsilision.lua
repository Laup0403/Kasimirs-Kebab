boxes = {}
local Coll = {}

local function createColl(ID, x, y, w, h, isWall, onOverlap)
    boxes[ID] = {
        x = x,
        y = y,
        w = w,
        h = h,
        wall = isWall,
        overlap = onOverlap,
        isactive = true
    }
end

local function checkColl(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x2 < x1 + w1 and
        y1 < y2 + h2 and
        y2 < y1 + h1
end

local function removeColl(ID)
    boxes[ID] = nil
end

--[[local function collidePlayer(hitbox,dir,x,y)
    local p = boxes[hitbox]

    for id, box in pairs(boxes) do
        if id ~= "player" and box.isactive then
            if checkColl(p.x, p.y, p.w, p.h, box.x, box.y, box.w, box.h) then
                if box.wall == false then
                    box.overlap()
                elseif box.wall == true then
                    if dir == 'l' then
                        p.x = box.x + box.w
                    elseif dir == 'r' then
                        p.x = box.x - p.w
                    elseif dir == 'u' then
                        p.y = box.y + box.h
                    elseif dir == 'd' then
                        p.y = box.y - p.h
                    end
                end
            end
        end
    end
end]]

local function collidewith(box1, box2)
    local a
    if type(box1) == "table" then
        a = box1
    elseif type(box1) == "string" then
        a = boxes[box1]
    end

    local b
    if type(box2) == "table" then
        b = box2
    elseif type(box2) == "string" then
        b = boxes[box2]
    end

    if not a or not b  then
        return false
    end

    if not a.isactive or not b.isactive then
        return false
    end

    return checkColl(
        a.x, a.y, a.w, a.h,
        b.x, b.y, b.w, b.h
    )

end

local function activate(ID)
    box = boxes[ID].isactive
    if box == true then
        box = false
    elseif box == false then
        box = true
    end
    boxes[ID].isactive = box
end

Coll.collide = collidewith
Coll.create = createColl
Coll.remove = removeColl
Coll.activate = activate

return Coll
