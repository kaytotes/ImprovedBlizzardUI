local widgetType, widgetVersion = 'ColorPicker', 2
local Wasabi = LibStub and LibStub('Wasabi', true)
if(not Wasabi or (Wasabi:GetWidgetVersion(widgetType) or 0) >= widgetVersion) then
	return
end

local methods = {}
function methods:EnableAlpha(enabled)
	self.hasAlpha = enabled
end

local function ToHex(r, g, b, a)
	return string.format('%02X%02X%02X%02X', a * 255, r * 255, g * 255, b * 255)
end

local function ToRGBA(hex)
	return tonumber('0x' .. string.sub(hex, 3, 4), 10) / 255,
		tonumber('0x' .. string.sub(hex, 5, 6), 10) / 255,
		tonumber('0x' .. string.sub(hex, 7, 8), 10) / 255,
		tonumber('0x' .. string.sub(hex, 1, 2), 10) / 255
end

function methods:Update(value)
	local r, g, b, a
	if(type(value) == 'table' and r.GetRGB) then
		r, g, b, a = value:GetRGBA()
	else
		r, g, b, a = ToRGBA(value)
	end

	self.Swatch:SetVertexColor(r, g, b, a)
	self.panel:SetVariable(self.key, value)
	self:Fire('Update', r, g, b, a, value)
end

function methods:SetColor(r, g, b, a)
	if(type(r) == 'table' and r.GetRGB) then
		self:Update(r:GenerateHexColor())
	else
		self:Update(ToHex(r, g, b, a or 1))
	end
end

local function OnClick(self)
	self:Fire('Open')

	local r, g, b, a = ToRGBA(self.panel:GetVariable(self.key))
	ColorPickerFrame:SetColorRGB(r or 1, g or 1, b or 1)
	ColorPickerFrame.hasOpacity = self.hasAlpha
	ColorPickerFrame.opacity = 1 - (a or 1)
	ColorPickerFrame.func = function()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		local a = self.hasAlpha and (1 - OpacitySliderFrame:GetValue()) or 1
		self:Update(ToHex(r, g, b, a))
	end

	ColorPickerFrame.opacityFunc = ColorPickerFrame.func
	ColorPickerFrame.cancelFunc = function()
		self:Update(ToHex(r, g, b, a))
	end

	ShowUIPanel(ColorPickerFrame)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

local function OnEnter(self)
	self:GetParent().Background:SetTexture(1, 1, 0)
end

local function OnLeave(self)
	self:GetParent().Background:SetTexture(1, 1, 1)
end

local function OnClickPass(self, ...)
	local Button = self:GetParent()
	Button:GetScript('OnClick')(Button, ...)
end

Wasabi:RegisterWidget(widgetType, widgetVersion, function(panel, key)
	local _NAME = panel:GetName() .. key:gsub('^%l', string.upper) .. widgetType

	local Button = CreateFrame('Button', _NAME, panel)
	Button:SetSize(20, 20)
	Button:SetScript('OnClick', OnClick)
	Button.panel = panel
	Button.key = key

	local Hover = CreateFrame('Button', nil, Button)
	Hover:SetAllPoints()
	Hover:SetScript('OnEnter', OnEnter)
	Hover:SetScript('OnLeave', OnLeave)
	Hover:SetScript('OnClick', OnClickPass)
	Button.Hover = Hover

	local Swatch = Button:CreateTexture(nil, 'OVERLAY')
	Swatch:SetPoint('CENTER')
	Swatch:SetSize(19, 19)
	Swatch:SetTexture([[Interface\ChatFrame\ChatFrameColorSwatch]])
	Button.Swatch = Swatch

	local Background = Button:CreateTexture(nil, 'BACKGROUND', nil, 1)
	Background:SetPoint('CENTER', Swatch)
	Background:SetSize(16, 16)
	Background:SetTexture(1, 1, 1)
	Button.Background = Background

	local Checkers = Button:CreateTexture(nil, 'BACKGROUND', nil, 2)
	Checkers:SetPoint('CENTER', Swatch)
	Checkers:SetSize(14, 14)
	Checkers:SetTexture([[Tileset\Generic\Checkers]])
	Checkers:SetTexCoord(1/4, 0, 1/2, 1/4)
	Checkers:SetDesaturated(true)
	Checkers:SetVertexColor(1, 1, 1, 3/4)
	Button.Checkers = Checkers

	for method, func in next, methods do
		Button[method] = func
	end

	Wasabi:InjectBaseWidget(Button, 'Text')
	Wasabi:InjectBaseWidget(Button, 'Events')

	panel:AddObject(key, Button)

	return Button
end)
