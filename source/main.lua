import "CoreLibs/graphics"

local gfx = playdate.graphics

local choices = {"Rock", "Paper", "Scissors"}
local playerChoice = 1
local computerChoice = nil
local result = ""
local showResult = false

function getResult(player, computer)
    if player == computer then
        return "Draw!"
    elseif (player == 1 and computer == 3) or
           (player == 2 and computer == 1) or
           (player == 3 and computer == 2) then
        return "You Win!"
    else
        return "You Lose!"
    end
end

function playdate.update()
    gfx.clear()
    gfx.drawText("Rock-Paper-Scissors", 60, 30)
    gfx.drawText("Use Left and Right to choose", 80, 60)
    gfx.drawText("Press A to play", 90, 80)

    -- Draw choices
    for i=1, #choices do
        local y = 120
        local x = 60 + (i-1)*70
        if i == playerChoice then
            gfx.drawText("*"..choices[i].."*", x, y)
        else
            gfx.drawText(choices[i], x, y)
        end
    end

    if showResult then
        gfx.drawText("Computer: "..choices[computerChoice], 80, 160)
        gfx.drawText(result, 110, 190)
        gfx.drawText("Press B to play again", 65, 210)
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
    if not showResult then
        computerChoice = math.random(1, #choices)
        result = getResult(playerChoice, computerChoice)
        showResult = true
    end
end

function playdate.BButtonDown()
    if showResult then
        showResult = false
        computerChoice = nil
        result = ""
    end
end