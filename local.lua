local Rayfield = loadstring(readfile("rfsrc.lua"))()

local execname = {
    exec = identifyexecutor()
}

print("Creating window...")
local Window = Rayfield:CreateWindow({
    DisableRecreate = true,
    Name = "Minimal Hub",
    LoadingTitle = "Minimal Hub",
    LoadingSubtitle = "by minimal",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MinimalHub",
        FileName = "Game"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
})
print("Window created:", Window)

local Tab = Window:CreateTab("Main", 4483362458)
local Section = Tab:CreateSection("Main")

Tab:CreateLabel("Executor: "..execname.exec)

local Button = Tab:CreateButton({
    Name = "Button Example",
    Callback = function()
        Rayfield:Notify({
            Title = "Button Pressed",
            Content = "You pressed the button!",
            Duration = 5,
            Image = 4384403532
        })
    end,
})

local Toggle = Tab:CreateToggle({
    Name = "Toggle Example",
    Flag = "Toggle1",
    CurrentValue = false,
    Callback = function(Value)
        print("Toggle changed to:", Value)
    end,
})

local Slider = Tab:CreateSlider({
    Name = "Slider Example",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 50,
    Flag = "Slider1",
    Callback = function(Value)
        print("Slider changed to:", Value)
    end,
})

local Dropdown = Tab:CreateDropdown({
    Name = "Dropdown Example",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = {"Option 1"},
    Flag = "Dropdown1",
    Callback = function(Option)
        print("Dropdown changed to:", Option)
    end,
})

local ColorPicker = Tab:CreateColorPicker({
    Name = "Color Picker Example",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ColorPicker1",
    Callback = function(Color)
        print("Color changed to:", Color)
    end,
})

local Input = Tab:CreateInput({
    Name = "Input Example",
    PlaceholderText = "Enter text here",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        print("Input changed to:", Text)
    end,
})

local Keybind = Tab:CreateKeybind({
    Name = "Keybind Example",
    CurrentKeybind = "B",
    HoldToInteract = false,
    Flag = "Keybind1",
    Callback = function(Keybind)
        print("Keybind changed to:", Keybind)
    end,
})