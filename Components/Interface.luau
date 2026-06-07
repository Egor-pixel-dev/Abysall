-- Components/Interface.luau
local maclib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()
local Window = maclib:Window({Title = "Abysall Hub", Subtitle = "Doors", DragStyle = 1})
local tabGroup = Window:TabGroup()

-- Таблица для "магического" создания секций
local Tabs = {}

local function CreateAdapter(macSection)
    return {
        AddToggle = function(self, id, args)
            macSection:Toggle({Name = args.Text, Default = args.Default, Callback = function(v) if args.OnChanged then args.OnChanged(v) end end})
        end,
        AddSlider = function(self, id, args)
            macSection:Slider({Name = args.Text, Min = args.Min, Max = args.Max, Default = args.Default, Callback = function(v) if args.Callback then args.Callback(v) end end})
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

-- Адаптер для групп (Groupboxes)
local GroupboxProxy = {}
GroupboxProxy.__index = GroupboxProxy

-- Вот здесь магия: если вызывается AddToggle у Groupbox, мы делаем секцию на лету
function GroupboxProxy:AddToggle(id, args) return CreateAdapter(self.Section):AddToggle(id, args) end
function GroupboxProxy:AddSlider(id, args) return CreateAdapter(self.Section):AddSlider(id, args) end
function GroupboxProxy:AddButton(args) return CreateAdapter(self.Section):AddButton(args) end
function GroupboxProxy:AddDropdown(id, args) return CreateAdapter(self.Section):AddDropdown(id, args) end
function GroupboxProxy:AddDivider() end

return {
    Library = {
        CreateWindow = function() return {
            AddTab = function(self, name)
                local tab = tabGroup:Tab({Name = name})
                local section = tab:Section({Side = "Left"})
                section:Header({Name = "General"})
                return setmetatable({Section = section}, GroupboxProxy)
            end,
            Notify = function(d) maclib:Notification({Title = "Abysall", Description = d.Title or d.Body}) end
        } end,
        Toggles = getgenv().Toggles,
        Options = getgenv().Options
    },
    ApplyInfoTab = function() end,
    ApplySettingsTab = function() end
}
