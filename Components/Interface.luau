local maclib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()
local Window = maclib:Window({Title = "Aerohack", Subtitle = "Doors", DragStyle = 1})
local tabGroup = Window:TabGroup()

-- Таблицы для хранения всего
local Adapters = {}

local function AdaptSection(macSection, name)
    macSection:Header({Name = name})
    return {
        AddToggle = function(self, id, args)
            macSection:Toggle({Name = args.Text, Default = args.Default, Callback = function(v) if args.OnChanged then args.OnChanged(v) end end})
        end,
        AddSlider = function(self, id, args)
            macSection:Slider({Name = args.Text, Min = args.Min, Max = args.Max, Default = args.Default, Callback = function(v) if args.OnChanged then args.OnChanged(v) end end})
        end,
        AddButton = function(self, args)
            macSection:Button({Name = args.Text, Callback = args.Func})
        end,
        AddDropdown = function(self, id, args)
            macSection:Dropdown({Name = args.Text, Options = args.Values, Default = args.Default, Callback = args.Callback})
        end,
        AddDivider = function(self) end,
        AddLabel = function(self, text) end
    }
end

return {
    Library = {
        CreateWindow = function(args)
            return {
                AddTab = function(self, name, icon)
                    print("DEBUG: Creating tab:", name)
                    local macTab = tabGroup:Tab({Name = name, Image = icon and "rbxassetid://"..icon or nil})
                    
                    -- Возвращаем объект, который умеет делать секции
                    return {
                        AddLeftGroupbox = function(self, gName)
                            print("DEBUG: Creating Groupbox (Left):", gName)
                            return AdaptSection(macTab:Section({Side = "Left"}), gName)
                        end,
                        AddRightGroupbox = function(self, gName)
                            print("DEBUG: Creating Groupbox (Right):", gName)
                            return AdaptSection(macTab:Section({Side = "Right"}), gName)
                        end,
                        AddLeftTabbox = function(self, name) return self:AddLeftGroupbox(name) end,
                        AddRightTabbox = function(self, name) return self:AddRightGroupbox(name) end
                    }
                end,
                Notify = function(d) maclib:Notification({Title = "Abysall", Description = d.Title or d.Body}) end,
                Toggles = getgenv().Toggles,
                Options = getgenv().Options
            }
        end,
        ApplyInfoTab = function() end,
        ApplySettingsTab = function() end
    }
}
