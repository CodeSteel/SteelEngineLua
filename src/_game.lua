local Game = {}

Game.Debugging = false

function Game.Start()
    Game.World = love.physics.newWorld(0, 9.81 * 40, true)
    Game.World:setCallbacks(Game.BeginContact, Game.EndContact, Game.PreSolve, Game.PostSolve)

    love.physics.setMeter(40)

    local defaultIcon = love.image.newImageData("engineassets/icon.png")
    love.window.setTitle("SteelEngine")
    love.window.setIcon(defaultIcon)
end

function Game.Update()
    Game.World:update(Time.DeltaTime)
end

function Game.Draw()
end

function Game.BeginContact(a, b, coll)
    if GameManager.CurrentGame and GameManager.CurrentGame.BeginContact then
        GameManager.CurrentGame.BeginContact(a, b, coll)
    end

    local objA = a:getUserData()
    local objB = b:getUserData()

    if (not objA) or (not objB) then return end

    if objA.OnCollision then
        objA:OnCollision(objB)
    end

    if objB.OnCollision then
        objB:OnCollision(objA)
    end
end

function Game.EndContact(a, b, coll)
    if GameManager.CurrentGame and GameManager.CurrentGame.EndContact then
        GameManager.CurrentGame.EndContact(a, b, coll)
    end
end

function Game.PreSolve(a, b, coll)
    if GameManager.CurrentGame and GameManager.CurrentGame.PreSolve then
        GameManager.CurrentGame.PreSolve(a, b, coll)
    end
end

function Game.PostSolve(a, b, coll, normalimpulse, tangentimpulse)
    if GameManager.CurrentGame and GameManager.CurrentGame.PostSolve then
        GameManager.CurrentGame.PostSolve(a, b, coll, normalimpulse, tangentimpulse)
    end
end

_G.Game = Game
