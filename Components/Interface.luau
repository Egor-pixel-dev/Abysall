-- Components/Interface.luau
local maclib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

-- Адаптер для объектов, которые возвращают Toggle/Slider
local function createAdapter(macSection)
    return {
        AddToggle = function(self, id, args)
            return macSection:Toggle({Name = args.Text, Default = args.Default, Callback = args.OnChanged})
        end,
        AddSlider = function(self, id, args)
            return macSection:Slider({Name = args.Text, Min = args.Min, Max = args.Max, Default = args.Default, Callback = args.OnChanged})
        end,
        AddButton = function(self, args)
            return macSection:Button({Name = args.Text, Callback = args.Func})
        end,
        AddDropdown = function(self, id, args)
            return macSection:Dropdown({Name = args.Text, Options = args.Values, Default = args.Default, Callback = args.Callback})
        end,
        AddDivider = function(self) end,
        AddLabel = function(self, text) end
    }
end

-- Адаптер для вкладок
local function WrapTab(macTab)
    return {
        AddLeftGroupbox = function(self, name)
            local s = macTab:Section({Side = "Left"})
            s:Header({Name = name})
            return createAdapter(s)
        end,
        AddRightGroupbox = function(self, name)
            local s = macTab:Section({Side = "Right"})
            s:Header({Name = name})
            return createAdapter(s)
        end
    }
end

-- Инициализация окна
local Window = maclib:Window({Title = "Abysall Hub", Subtitle = "Doors", DragStyle = 1})
local tabGroup = Window:TabGroup()

return {
    Library = {
        CreateWindow = function(args)
            return {
                AddTab = function(self, name, icon)
                    return WrapTab(tabGroup:Tab({Name = name, Image = icon and "rbxassetid://"..icon or nil}))
                end,
                Notify = function(d) maclib:Notification({Title = "Abysall", Description = d.Title or d.Body}) end
            }
        end,
        Toggles = getgenv().Toggles,
        Options = getgenv().Options
    },
    ApplyInfoTab = function() end,
    ApplySettingsTab = function() end
}
