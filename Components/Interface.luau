-- Components/Interface.luau
local maclib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

-- Адаптер для контролов (Toggle, Slider и т.д.)
local function ControlAdapter(macSection)
    return {
        AddToggle = function(self, id, args)
            local item = {Value = args.Default}
            local toggle = macSection:Toggle({Name = args.Text, Default = args.Default, Callback = function(v) 
                item.Value = v
                if args.Callback then args.Callback(v) end
                if args.OnChanged then args.OnChanged(v) end
            end})
            getgenv().Toggles[id] = item
            local mt = {AddKeyPicker = function(s, kid, kargs) return end, AddColorPicker = function(s, cid, cargs) return end}
            return setmetatable(item, {__index = mt})
        end,
        AddSlider = function(self, id, args)
            local item = {Value = args.Default}
            macSection:Slider({Name = args.Text, Min = args.Min, Max = args.Max, Default = args.Default, Callback = function(v) 
                item.Value = v
                if args.Callback then args.Callback(v) end
                if args.OnChanged then args.OnChanged(v) end
            end})
            getgenv().Options[id] = item
            return item
        end,
        AddButton = function(self, args)
            macSection:Button({Name = args.Text, Callback = args.Func})
        end,
        AddDropdown = function(self, id, args)
            local item = {Value = args.Default}
            macSection:Dropdown({Name = args.Text, Options = args.Values, Default = args.Default, Callback = function(v) 
                item.Value = v
                if args.Callback then args.Callback(v) end
            end})
            getgenv().Options[id] = item
            return item
        end,
        AddInput = function(self, id, args)
            macSection:Input({Name = args.Text, Placeholder = args.Placeholder, Callback = args.OnChanged})
        end,
        AddDivider = function(self) end,
        AddLabel = function(self, text) macSection:Label(text) end
    }
end

-- Адаптер для секций (Groupboxes)
local function GroupboxAdapter(macTab)
    return {
        AddLeftGroupbox = function(self, name) 
            local s = macTab:Section({Side = "Left"})
            s:Header({Name = name})
            return ControlAdapter(s)
        end,
        AddRightGroupbox = function(self, name) 
            local s = macTab:Section({Side = "Right"})
            s:Header({Name = name})
            return ControlAdapter(s)
        end,
        AddLeftTabbox = function(self, name) return self:AddLeftGroupbox(name) end,
        AddRightTabbox = function(self, name) return self:AddRightGroupbox(name) end,
        AddTab = function(self, name) return self:AddLeftGroupbox(name) end
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
                    return WrapTab(tabGroup:Tab({Name = name, Image = icon}))
                end,
                Notify = function(d) maclib:Notification({Title = "Abysall", Description = d.Title or d.Body}) end,
                Toggles = getgenv().Toggles,
                Options = getgenv().Options
            }
        end,
        ToggleKeybind = nil
    },
    ApplyInfoTab = function(win) end,
    ApplySettingsTab = function(win) end
}
