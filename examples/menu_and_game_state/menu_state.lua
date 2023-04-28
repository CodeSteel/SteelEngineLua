local MenuState = CreateNewState()

function MenuState:Enter()
    print("\n+ Menu State Entered!")

    self.menu = {
        { label = "Play", action = function() Game.StateMachine:Change(require('game_state')) end },
        { label = "Quit", action = function() love.event.quit() end }
    }

    self.Music = Sound.GetSound("MenuMusic")
    self.Music:SetLooping(true)
    self.Music:SetVolume(0.01)
    self.Music:Play()

    self.currentSelection = 1
end

function MenuState:Exit()
    self.Music:Stop()
end

function MenuState:Update()
    if Input.GetKey("up") then
        self.currentSelection = math.max(self.currentSelection - 1, 1)
    elseif Input.GetKey("down") then
        self.currentSelection = math.min(self.currentSelection + 1, #self.menu)
    end

    if Input.GetKey("return") then
        self.menu[self.currentSelection].action()
    end
end

function MenuState:Draw()
    local titleW, titleH = Font.GetTextSize(GameManager.CurrentGame.Name, "UILargeB")

    Draw.RoundedBox(10, 70, 85, titleW + 20, titleH, color_red)
    Draw.SimpleText(GameManager.CurrentGame.Name, "UILargeB", 80, 85, color_black, TEXT_ALIGN_LEFT, 500)

    for i, item in ipairs(self.menu) do
        local x = 90
        local y = 150 + (i - 1) * 50

        local labelW, labelH = Font.GetTextSize(item.label, "UISmall")

        Draw.RoundedBox(6, x - 10, y, labelW + 20, labelH, i == self.currentSelection and color_green or color_black)
        Draw.SimpleText(item.label, "UISmall", x, y, i == self.currentSelection and color_black or color_white,
            TEXT_ALIGN_LEFT, 100)
    end
end

return MenuState
