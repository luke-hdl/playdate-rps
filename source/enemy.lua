local gfx = playdate.graphics

local Enemy = {}
Enemy.__index = Enemy

function newEnemy(x, y, rockWeight, paperWeight, scissorsWeight, imagePath)
    local self = setmetatable({}, Enemy)
    self.rockWeight = rockWeight or 1
    self.paperWeight = paperWeight or 1
    self.scissorsWeight = scissorsWeight or 1
    self.sprite = gfx.sprite.new(gfx.image.new(imagePath))
    self.sprite:moveTo(x, y)
    self.sprite:add()
    return self
end

function Enemy:getSprite()
    return self.sprite
end

function Enemy:getMove()
    local total = self.rockWeight + self.paperWeight + self.scissorsWeight
    local r = math.random() * total
    if r < self.rockWeight then
        return 1 --rock
    elseif r < self.rockWeight + self.paperWeight then
        return 2 --paper
    else
        return 3
    end
end

return Enemy