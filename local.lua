local content = readfile("mylib.lua")
local lib = loadstring(content)()

local Window = lib:CreateWindow({
   Name = "Doors",
   LoadingTitle = "Doors",
   LoadingSubtitle = "by alriceee",
   Theme = "Ocean",
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true
})

local Tab = Window:CreateTab("Main")

local Button = Tab:CreateButton({
   Name = "Button Example",
   Callback = function()
      print("Button clicked")
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Toggle Example",
   CurrentValue = false,
   Callback = function(Value)
      print(Value)
   end,
})

local Slider = Tab:CreateSlider({
   Name = "Slider Example",
   Range = {0, 100},
   Increment = 10,
   Suffix = "Value",
   CurrentValue = 10,
   Callback = function(Value)
      print(Value)
   end,
})

local Tab = Window:CreateTab("Visuals", 4483362458)
local Section = Tab:CreateSection("ESP")

local MonsterTab = Window:CreateTab("Monsters", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local InfoTab = Window:CreateTab("Info", 4483362458)
local Section = InfoTab:CreateSection("Info")
InfoTab:CreateLabel("thx jaysterzz for helping with key esp")

local rushalive = false

local config = {}
config.dooresp = false
config.highlightmonsters = false
config.notifymonsters = false
config.fullbright = false
config.leveresptoggle = false
config.bookesptoggle = false

local highlights = {}
local monsterhighlights = {}
local leverhighlights = {}
local bookhighlights = {}

local lighting = game:GetService("Lighting")
local originals = {
    brightness = lighting.Brightness,
    clocktime = lighting.ClockTime,
    fogend = lighting.FogEnd,
    globalshad = lighting.GlobalShadows,
    outdoor = lighting.OutdoorAmbient
}

function addhighlight(part, colors)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = colors[1]
    highlight.OutlineColor = colors[2]
    highlight.Parent = part
    return highlight
end

local highlightcolors = {
    door = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 0, 0)},
    monster = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255)},
    lever = {Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 128, 0)},
    book = {Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 69, 0)},
    figure = {Color3.fromRGB(128, 0, 128), Color3.fromRGB(75, 0, 130)}
}

workspace.CurrentRooms.ChildAdded:Connect(function(room)
    if config.dooresp and room:WaitForChild("Door") and room.Door:WaitForChild("Door") then
        highlights[room.Door.Door] = addhighlight(room.Door.Door, highlightcolors.door)
    end
    if config.leveresptoggle then
        task.wait(0.5)
        local lever = room:FindFirstChild("LeverForGate", true)
        if lever then
            leverhighlights[lever] = addhighlight(lever, highlightcolors.lever)
        end
    end
end)

Tab:CreateToggle({
    Name = "Doors ESP",
    CurrentValue = false,
    Flag = "dooresp",
    Callback = function(Value)
        config.dooresp = Value
        
        if config.dooresp then
            for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
                if room.Door and room.Door.Door then
                    highlights[room.Door.Door] = addhighlight(room.Door.Door, highlightcolors.door)
                end
            end
        else
            for i, highlight in pairs(highlights) do
                highlight:Destroy()
            end
            table.clear(highlights)
        end
    end
})

MonsterTab:CreateToggle({
    Name = "Highlight Monsters",
    CurrentValue = false,
    Flag = "highlightmonsters",
    Callback = function(Value)
        config.highlightmonsters = Value
        
        if config.highlightmonsters then
            for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
                local figure = room:FindFirstChild("FigureSetup", true)
                if figure and figure:FindFirstChild("FigureRig") then
                    monsterhighlights[figure.FigureRig] = addhighlight(figure.FigureRig, highlightcolors.monster)
                end
                
                for _, model in pairs(room:GetDescendants()) do
                    if model:FindFirstChild("Lighter", true) then
                        monsterhighlights[model.Lighter] = addhighlight(model.Lighter, highlightcolors.monster)
                    end
                end
            end

            workspace.CurrentRooms.ChildAdded:Connect(function(room)
                local figure = room:WaitForChild("FigureSetup", 2)
                if figure and figure:FindFirstChild("FigureRig") then
                    monsterhighlights[figure.FigureRig] = addhighlight(figure.FigureRig, highlightcolors.monster)
                end
                
                for _, model in pairs(room:GetDescendants()) do
                    if model:FindFirstChild("Lighter", true) then
                        monsterhighlights[model.Lighter] = addhighlight(model.Lighter, highlightcolors.monster)
                    end
                end
            end)

            local function highlightmonster(instance, name)
                if workspace:WaitForChild(name, 2) then
                    monsterhighlights[instance] = addhighlight(instance, highlightcolors.monster)
                end
            end

            highlightmonster(workspace:WaitForChild("SallyWindow", 2), "SallyWindow")
            highlightmonster(workspace:WaitForChild("RushMoving", 2):WaitForChild("RushNew", 2), "RushMoving")
            highlightmonster(workspace:WaitForChild("SeekMovingNewClone", 2), "SeekMovingNewClone")
        else
            for i, highlight in pairs(monsterhighlights) do
                highlight:Destroy()
            end
            table.clear(monsterhighlights)
        end
    end
})

MonsterTab:CreateToggle({
    Name = "Notify Monster Spawn",
    CurrentValue = false,
    Flag = "notifymonsters",
    Callback = function(Value)
        config.notifymonsters = Value
    end
})

PlayerTab:CreateLabel("Do not set speed higher than 6!")

PlayerTab:CreateInput({
    Name = "Move Speed",
    PlaceholderText = "Enter speed (max 6)",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local speed = tonumber(Text)
        if speed then
            game.Players.LocalPlayer.Character:SetAttribute("SpeedBoost", speed)
        end
    end
})

Tab:CreateToggle({
    Name = "Lever ESP",
    CurrentValue = false,
    Flag = "leveresptoggle",
    Callback = function(Value)
        config.leveresptoggle = Value
        
        if config.leveresptoggle then
            for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
                task.wait(0.1)
                local lever = room:FindFirstChild("LeverForGate", true)
                if lever then
                    leverhighlights[lever] = addhighlight(lever, highlightcolors.lever)
                end
            end
        else
            for i, highlight in pairs(leverhighlights) do
                highlight:Destroy()
            end
            table.clear(leverhighlights)
        end
    end
})

Tab:CreateToggle({
    Name = "Library Books ESP",
    CurrentValue = false,
    Flag = "bookesptoggle",
    Callback = function(Value)
        config.bookesptoggle = Value
        
        if config.bookesptoggle then
            for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
                for i, book in pairs(room:GetDescendants()) do
                    if book.Name == "LiveHintBook" then
                        bookhighlights[book] = addhighlight(book, highlightcolors.book)
                    end
                end
            end

            workspace.CurrentRooms.ChildAdded:Connect(function(room)
                for i, book in pairs(room:GetDescendants()) do
                    if book.Name == "LiveHintBook" then
                        bookhighlights[book] = addhighlight(book, highlightcolors.book)
                    end
                end
            end)
        else
            for i, highlight in pairs(bookhighlights) do
                highlight:Destroy()
            end
            table.clear(bookhighlights)
        end
    end
})

Tab:CreateToggle({
    Name = "Highlight Figure",
    CurrentValue = false,
    Flag = "figurehighlight",
    Callback = function(Value)
        config.figurehighlight = Value
        
        if config.figurehighlight then
            for i, room in pairs(workspace.CurrentRooms:GetChildren()) do
                local figure = room:FindFirstChild("FigureSetup", true)
                if figure and figure:FindFirstChild("FigureRig") then
                    figurehighlights[figure.FigureRig] = addhighlight(figure.FigureRig, highlightcolors.figure)
                end
            end

            workspace.CurrentRooms.ChildAdded:Connect(function(room)
                local figure = room:WaitForChild("FigureSetup", 2)
                if figure and figure:FindFirstChild("FigureRig") then
                    figurehighlights[figure.FigureRig] = addhighlight(figure.FigureRig, highlightcolors.figure)
                end
            end)
        else
            for i, highlight in pairs(figurehighlights) do
                highlight:Destroy()
            end
            table.clear(figurehighlights)
        end
    end
})

workspace.ChildAdded:Connect(function(child)
    if child.Name == "RushMoving" then
        rushalive = true
        if config.notifymonsters then
            Rayfield:Notify({
                Title = "Rush Moving",
                Content = "Rush has spawned",
                Duration = 5,
                Image = 4384403532
            })
        end
        if config.highlightmonsters then
            monsterhighlights[child] = addhighlight(child, highlightcolors.monster)
        end
    end
end)

workspace.ChildRemoved:Connect(function(child)
    if child.Name == "RushMoving" then
        rushalive = false
        if config.notifymonsters then
            Rayfield:Notify({
                Title = "Rush Moving",
                Content = "Rush has despawned",
                Duration = 5,
                Image = 4384403532
            })
        end
        if monsterhighlights[child] then
            monsterhighlights[child] = nil
        end
    end
end)

function dofullbright()
    if config.fullbright then
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
        lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        lighting.Brightness = originals.brightness
        lighting.ClockTime = originals.clocktime
        lighting.FogEnd = originals.fogend
        lighting.GlobalShadows = originals.globalshad
        lighting.OutdoorAmbient = originals.outdoor
    end
end

Tab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "fullbright",
    Callback = function(Value)
        config.fullbright = Value
        dofullbright()
    end
})