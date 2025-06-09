import "CoreLibs/graphics"
import "player.lua"
import "enemy.lua"

local gfx = playdate.graphics

local StateEnum = {
    PLAYING = 1,
    RESULT = 2,
    WON = 3,
    LOST = 4
}

local ResultEnum = {
    WIN = 1,
    LOSE = 2,
    DRAW = 3
}

local choices = {"Rock", "Paper", "Scissors"}
local playerChoice = 1
local computerChoice = nil
local totalWins = 0
local result = ""
local showResult = false

local player = newPlayer(100, 100, "images/player/punchy", 5)
local enemy = newEnemy(200, 100, 11, 10, 10, "images/enemy/rattock") --Rattock likes Rock just a little more than the others...
local state = StateEnum.PLAYING

function getResult(playerPick, computer)
    if playerPick == computer then
        return ResultEnum.DRAW
    elseif (playerPick == 1 and computer == 3) or
           (playerPick == 2 and computer == 1) or
           (playerPick == 3 and computer == 2) then
        return ResultEnum.WIN
    else
        return ResultEnum.LOSE
    end
end

function playdate.update()
    gfx.clear()
    gfx.sprite.update()
    gfx.drawText("Rock-Paper-Scissors", 60, 30)

    -- Draw choices

    if state == StateEnum.RESULT then
        gfx.drawText("Computer: "..choices[computerChoice], 20, 160)
        if result == ResultEnum.WIN then
            resultText = "You Win! Total Wins: " .. totalWins..  "! Press B to continue."
        elseif result == ResultEnum.LOSE then
            resultText = "You Lose! Retries left: " .. player.retries .. ". Press B to retry."
        else
            resultText = "It's a Draw! Press B to continue."
        end
        gfx.drawText(resultText, 20, 190)

    elseif state == StateEnum.WON then
        gfx.drawText("You win! Press B to play again!", 20, 160)
    
    elseif state == StateEnum.LOST then
        gfx.drawText("You Lose! No retries left. Press B to play again.", 20, 160)

    elseif state == StateEnum.PLAYING then
        gfx.drawText("You can retry a loss up to: " ..player.retries.. " more time(s)!", 20, 190)
        gfx.drawText("Press A to play. You've won "..totalWins.. "/3 times!", 20, 220)
        
        for i=1, #choices do
            local y = 150
            local x = 60 + (i-1)*70
            if i == playerChoice then
                gfx.drawText("*"..choices[i].."*", x, y)
            else
                gfx.drawText(choices[i], x, y)
            end
        end
    end
end

function playdate.leftButtonDown()
    if not showResult then
        playerChoice = playerChoice - 1
        if playerChoice < 1 then playerChoice = #choices end
    end
end

function playdate.rightButtonDown()
    if not showResult then
        playerChoice = playerChoice + 1
        if playerChoice > #choices then playerChoice = 1 end
    end
end

function playdate.AButtonDown()
    if state == StateEnum.PLAYING then
        state = StateEnum.RESULT
        computerChoice = enemy:getMove()
        result = getResult(playerChoice, computerChoice)
        if result == ResultEnum.WIN then
            totalWins = totalWins + 1
            if totalWins >= 3 then
                state = StateEnum.WON
            end
        elseif result == ResultEnum.LOSE then
            if not player:useRetry() then
                state = StateEnum.LOST
            end
        end
    end
end

function playdate.BButtonDown()
    if state == StateEnum.RESULT then
        state = StateEnum.PLAYING
    end

    if state == StateEnum.WON or state == StateEnum.LOST then
        totalWins = 0
        state = StateEnum.PLAYING
        player:resetRetries()
    end
end