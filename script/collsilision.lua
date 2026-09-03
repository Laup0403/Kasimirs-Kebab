boxes = {}
local Coll = {}

local function createColl(ID, x, y, w, h, isWall, onOverlap)
    boxes[ID] = {
        x = x,
        y = y,
        w = w,
        h = h,
        wall = isWall,
        overlap = onOverlap
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

--[[function collide()
    local collisions = {}

    for i = 1, #boxes - 1 do
        local b1 = boxes[i]
        for j = i + 1, #boxes do
            local b2 = boxes[j]

            if checkColl(b1.x, b1.y, b1.w, b1.h, b2.x, b2.y, b2.w, b2.h) then
                print("Collide!")
                table.insert(collisions, { boxA = i, BoxB = j })
            else
                print("Not Collide")
            end
        end
    end

    return collisions
end]]

local function collidePlayer(dir,x,y)
    local p = boxes["player"]

    for id, box in pairs(boxes) do
        if id ~= "player" then
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
end

Coll.collide = collidePlayer
Coll.create = createColl
Coll.remove = removeColl

return Coll
