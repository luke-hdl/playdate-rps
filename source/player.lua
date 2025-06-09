local gfx = playdate.graphics
local Player = {}
Player.__index = Player

function newPlayer(x, y, imagePath, maxRetries)
    local self = setmetatable({}, Player)
    self.sprite = gfx.sprite.new(gfx.image.new(imagePath))
    self.sprite:moveTo(x, y)
    self.sprite:add()
    self.maxRetries = maxRetries
    self.retries = self.maxRetries
    return self
end

function Player:useRetry()
    if self.retries > 0 then
        self.retries = self.retries - 1
        return true
    end
    return false
end

function Player:resetRetries()
    self.retries = self.maxRetries
end

function Player:draw()
    self.sprite:draw()
end