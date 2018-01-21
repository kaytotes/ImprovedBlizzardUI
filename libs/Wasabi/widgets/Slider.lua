local widgetType, widgetVersion = 'Slider', 1
local Wasabi = LibStub and LibStub('Wasabi', true)
if(not Wasabi or (Wasabi:GetWidgetVersion(widgetType) or 0) >= widgetVersion) then
	return
end

local methods = {}
function methods:SetRange(min, max)
	self:SetMinMaxValues(min, max)
	self.Min:SetText(min)
	self.Max:SetText(max)
end

function methods:SetStep(step)
	assert(tonumber(step), 'Step must be a number')
	step = tonumber(step)
	self:SetValueStep(step)

	local _, decimals = string.split('.', step)
	self.decimals = decimals and #decimals or 0
	self.decimalFormat = string.format('%%.%df', self.decimals)
end

function methods:Update(value)
	value = tonumber(string.format(self.decimalFormat, value))

	local min, max = self:GetMinMaxValues()
	value = math.min(math.max(value, min), max)
	self:SetValue(value)
	self.EditBox:SetText(value)
	self.panel:SetVariable(self.key, value)
	self:Fire('Update', value)
end

local function OnEnable(self)
	self.EditBox:Enable()
	self.EditBox:SetTextColor(1, 1, 1)
	self.Thumb:SetVertexColor(1, 1, 1)
end

local function OnDisable(self)
	self.EditBox:Disable()
	self.EditBox:SetTextColor(1/2, 1/2, 1/2)
	self.Thumb:SetVertexColor(1/2, 1/2, 1/2)
end

local function OnMouseWheel(self, direction)
	self:Update(self:GetValue() + direction * self:GetValueStep())
end

local function OnValueChanged(self, value)
	self:Update(value)
end

local function OnEscapePressed(self)
	self:GetParent():Update(self:GetParent():GetValue())
	self:ClearFocus()
end

local function OnEnterPressed(self)
	local value = tonumber((self:GetText():gsub(',', '.')))
	self:GetParent():Update(value or self:GetParent():GetValue())
	self:ClearFocus()
end

local TestString = UIParent:CreateFontString(nil, nil, 'GameFontHighlightSmall')
local function OnTextChanged(self, ...)
	local Slider = self:GetParent()
	local _, max = Slider:GetMinMaxValues()
	TestString:SetFormattedText(Slider.decimalFormat, max .. '.' .. 2e9)
	self:SetWidth(TestString:GetStringWidth() * 3)
	self:SetText(self:GetText())
	self:SetScript('OnTextChanged', nil)
end

Wasabi:RegisterWidget(widgetType, widgetVersion, function(panel, key)
	local _NAME = panel:GetName() .. key:gsub('^%l', string.upper) .. widgetType

	local Slider = CreateFrame('Slider', _NAME, panel, 'OptionsSliderTemplate')
	Slider:SetScript('OnMouseWheel', OnMouseWheel)
	Slider:SetScript('OnValueChanged', OnValueChanged)
	Slider:SetScript('OnEnable', OnEnable)
	Slider:SetScript('OnDisable', OnDisable)
	Slider:SetObeyStepOnDrag(true)
	Slider.Min = _G[_NAME .. 'Low']
	Slider.Max = _G[_NAME .. 'High']
	Slider.Thumb = _G[_NAME .. 'Thumb']
	Slider.panel = panel
	Slider.key = key

	local EditBox = CreateFrame('EditBox', nil, Slider)
	EditBox:SetPoint('TOP', Slider, 'BOTTOM', 0, 3)
	EditBox:SetSize(100, 18)
	EditBox:SetJustifyH('CENTER')
	EditBox:SetFontObject('GameFontHighlightSmall')
	EditBox:SetAutoFocus(false)
	EditBox:SetScript('OnEnterPressed', OnEnterPressed)
	EditBox:SetScript('OnEscapePressed', OnEscapePressed)
	EditBox:SetScript('OnTextChanged', OnTextChanged)
	Slider.EditBox = EditBox

	for method, func in next, methods do
		Slider[method] = func
	end

	Wasabi:InjectBaseWidget(Slider, 'Text')
	Wasabi:InjectBaseWidget(Slider, 'Events')

	-- Defaults
	Slider:SetStep(1)

	panel:AddObject(key, Slider)

	return Slider
end)
