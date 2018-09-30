local widgetType, widgetVersion = 'CheckButton', 1
local Wasabi = LibStub and LibStub('Wasabi', true)
if(not Wasabi or (Wasabi:GetWidgetVersion(widgetType) or 0) >= widgetVersion) then
	return
end

local methods = {}
function methods:Update(value)
	self:SetChecked(value)
	self:Fire('Update', value)
end

local function OnClick(self)
	self.panel:SetVariable(self.key, self:GetChecked())
	self:Fire('Click')
end

Wasabi:RegisterWidget(widgetType, widgetVersion, function(panel, key)
	local _NAME = panel:GetName() .. key:gsub('^%l', string.upper) .. widgetType

	local Button = CreateFrame('CheckButton', _NAME, panel, 'InterfaceOptionsCheckButtonTemplate')
	Button:SetScript('OnClick', OnClick)
	Button.panel = panel
	Button.key = key

	for method, func in next, methods do
		Button[method] = func
	end

	Wasabi:InjectBaseWidget(Button, 'Text')
	Wasabi:InjectBaseWidget(Button, 'Events')

	panel:AddObject(key, Button)

	return Button
end)
