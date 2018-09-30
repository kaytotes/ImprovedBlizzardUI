local function Config(self)
	local Title = self:CreateTitle()
	Title:SetPoint('TOPLEFT', 16, -16)
	Title:SetText('Wasabi')

	local Description = self:CreateDescription()
	Description:SetPoint('TOPLEFT', Title, 'BOTTOMLEFT', 0, -8)
	Description:SetPoint('RIGHT', -32, 0)
	Description:SetText('This is a test implementation of an options panel using Wasabi')

	local CheckButton = self:CreateCheckButton('checkbutton')
	CheckButton:SetPoint('TOPLEFT', Description, 'BOTTOMLEFT', -2, -10)
	CheckButton:SetText('This is a CheckButton widget')
	CheckButton:SetNewFeature(true)
	CheckButton:On('Update', function(self, event, value)
		print('CheckButton received an update with value "' .. tostring(value) .. '"')
	end)
	CheckButton:On('Click', function(self, event)
		print('CheckButton received a click')
	end)

	local DropDown = self:CreateDropDown('dropdown')
	DropDown:SetPoint('TOPLEFT', CheckButton, 'BOTTOMLEFT', 0, -10)
	DropDown:SetValues('Cabbage', 'Mustard', 'Wasabi') -- Can also be a table (pairs or indexed)
	DropDown:SetText('This is a DropDown widget with three values')
	DropDown:On('Update', 'Toggle', 'ItemClick', function(self, event, ...)
		print('DropDown received "' .. event .. '" event, arguments:', ...)
	end)

	local Slider = self:CreateSlider('slider')
	Slider:SetPoint('TOPLEFT', DropDown, 'BOTTOMLEFT', 4, -14)
	Slider:SetRange(1, 10)
	Slider:SetStep(1) -- Defaults to 1
	Slider:SetText('This is a Slider widget, with an an editbox')
	Slider:SetNewFeature(true)
	Slider:On('Update', function(self, event, ...)
		print('Slider received "' .. event .. '" event, arguments:', ...)
	end)

	local ColorPicker = self:CreateColorPicker('colorpicker')
	ColorPicker:SetPoint('TOPLEFT', Slider, 'BOTTOMLEFT', 0, -22)
	ColorPicker:EnableAlpha(true)
	ColorPicker:SetText('This is a ColorPicker widget')
	ColorPicker:On('Update', function(self, event, r, g, b, a, hex)
		print('ColorPicker received and update with values', r, g, b, a, hex)
	end)
	ColorPicker:On('Open', function(self, event)
		print('ColorPicker received "' .. event .. '" event')
	end)

	local CheckButton2 = self:CreateCheckButton('checkbutton2')
	CheckButton2:SetPoint('TOPLEFT', ColorPicker, 'BOTTOMLEFT', 0, -400)
	CheckButton2:SetText('This is a CheckButton widget, showcasing a dynamic scrolling panel')
	-- CheckButton2:SetNewFeature(true)
	CheckButton2:On('Update', function(self, event, value)
		print('CheckButton2 received an update with value "' .. tostring(value) .. '"')
	end)
	CheckButton2:On('Click', function(self, event)
		print('CheckButton2 received a click')
	end)
end

local defaults = {
	checkbutton = true,
	checkbutton2 = false,
	dropdown = 3,
	slider = 1,
	colorpicker = 'ff003399', -- argb
}

local Panel = LibStub('Wasabi'):New('Wasabi', 'WasabiDB', defaults)
Panel:AddSlash('/wa')
Panel:AddSlash('/wasabi')
Panel:Initialize(Config)

local deafultsSub = {
	checkbutton = false,
	checkbutton2 = true,
	dropdown = 2,
	slider = 5,
	colorpicker = '50993300', -- argb
}

local Sub = Panel:CreateChild('Subpanel', 'WasabiSubDB', deafultsSub)
Sub:Initialize(Config)

-- Fill a table with random colors
local defaults_objects = {objects={}}
local r = math.random
for index = 1, 100 do
	defaults_objects.objects[index] = {r = r(), g = r(), b = r()}
end

local ObjectContainer = Panel:CreateChild('ObjectContainer', 'WasabiObjectsDB', defaults_objects)
ObjectContainer:Initialize(function(self)
	local Title = self:CreateTitle()
	Title:SetPoint('TOPLEFT', 10, -10)
	Title:SetFontObject('GameFontHighlight')
	Title:SetText('A basic implementation of the ObjectContainer widget')

	local Objects = self:CreateObjectContainer('objects')
	Objects:SetPoint('TOPLEFT', 0, -30)
	Objects:SetSize(self:GetWidth(), 526)
	Objects:SetObjectSize(55, 85) -- Defaults to 30, 30
	Objects:SetObjectSpacing(4) -- Defaults to 2
	Objects:On('ObjectCreate', function(self, event, Object)
		local Texture = Object:CreateTexture()
		Texture:SetAllPoints()
		Object:SetNormalTexture(Texture)
	end)
	Objects:On('ObjectUpdate', function(self, event, Object)
		Object:GetNormalTexture():SetColorTexture(Object.value.r, Object.value.g, Object.value.b)
	end)
	Objects:On('ObjectClick', function(self, event, Object, button)
		if(button == 'RightButton') then
			Object:Remove()
		end
	end)
	Objects:On('PreUpdate', 'PostUpdate', function(self, event, ...)
		print('ObjectContainer received "' .. event .. '" event, arguments:', ...)
	end)
	-- Methods not listed: AddObject(key, value), RemoveObject(key) and HasObject(key)
end)
