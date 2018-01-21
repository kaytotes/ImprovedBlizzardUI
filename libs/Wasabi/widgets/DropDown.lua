local widgetType, widgetVersion = 'DropDown', 1
local Wasabi = LibStub and LibStub('Wasabi', true)
if(not Wasabi or (Wasabi:GetWidgetVersion(widgetType) or 0) >= widgetVersion) then
	return
end

local BACKDROP = {
	bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
	edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]], edgeSize = 32,
	insets = {top = 12, bottom = 9, left = 11, right = 12}
}

local methods = {}
function methods:Enable()
	local Button = self.Button
	Button:Enable()
	Button:GetFontString():SetTextColor(1, 1, 1)
end

function methods:Disable()
	local Button = self.Button
	Button:Disable()
	Button:GetFontString():SetTextColor(1/2, 1/2, 1/2)
end

function methods:SetEnabled(enabled)
	if(enabled) then
		self:Enable()
	else
		self:Disable()
	end
end

function methods:Update(value)
	self.Button:SetText(self.values[value])
	self:Fire('Update', value)
end

function methods:SetValues(...)
	if(type((...)) == 'table') then
		self.values = ...
	else
		self.values = {...}
	end
end

local function OnValueClick(self)
	local parent = self.parent
	parent.panel:SetVariable(parent.key, self.key)
	parent.Button:SetText(self:GetText())
	parent:Fire('ItemClick', self.key, self.value)
	self:GetParent():Hide()
end

local function OnClick(self)
	local parent = self:GetParent()
	local Menu = parent.Menu
	parent:Fire('Toggle', not Menu:IsShown())

	if(Menu:IsShown()) then
		Menu:Hide()
	else
		if(not Menu.buttons) then
			Menu.buttons = {}

			local index, width = 0, 0
			for key, value in next, parent.values do
				local Button = CreateFrame('Button', nil, Menu)
				Button:SetPoint('TOPLEFT', 14, -(14 + (18 * index)))
				Button:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
				Button:GetHighlightTexture():SetBlendMode('ADD')
				Button:SetScript('OnClick', OnValueClick)
				Button.key = key
				Button.value = value
				Button.parent = parent

				local Check = CreateFrame('CheckButton', nil, Button)
				Check:SetPoint('LEFT')
				Check:SetSize(16, 16)
				Check:SetNormalTexture([[Interface\Common\UI-DropDownRadioChecks]])
				Check:GetNormalTexture():SetTexCoord(1/2, 1, 1/2, 1)
				Check:SetCheckedTexture([[Interface\Common\UI-DropDownRadioChecks]])
				Check:GetCheckedTexture():SetTexCoord(0, 1/2, 1/2, 1)
				Check:EnableMouse(false)
				Check:SetText(value)
				Button.Check = Check

				local Text = Button:CreateFontString(nil, nil, 'GameFontHighlightSmall')
				Text:SetPoint('LEFT', Check, 'RIGHT', 4, -1)
				Text:SetText(value)
				Button:SetFontString(Text)

				local textWidth = Button:GetTextWidth()
				if(textWidth > width) then
					width = textWidth
				end

				Menu.buttons[key] = Button
				index = index + 1
			end

			for _, Button in next, Menu.buttons do
				Button:SetSize(32 + width, 18)
			end

			Menu:SetSize(60 + width, 28 + 18 * index)
		end

		for key, Button in next, Menu.buttons do
			Button.Check:SetChecked(key == parent.panel:GetVariable(parent.key))
		end

		Menu:Show()
	end

	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

local function OnHide(self)
	self.Menu:Hide()
end

Wasabi:RegisterWidget(widgetType, widgetVersion, function(panel, key)
	local _NAME = panel:GetName() .. key:gsub('^%l', string.upper) .. widgetType

	local Frame = CreateFrame('Frame', _NAME, panel)
	Frame:SetSize(110, 32)
	Frame:SetScript('OnHide', OnHide)
	Frame.panel = panel
	Frame.key = key

	local LeftTexture = Frame:CreateTexture()
	LeftTexture:SetPoint('TOPLEFT', -14, 17)
	LeftTexture:SetSize(25, 64)
	LeftTexture:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]])
	LeftTexture:SetTexCoord(0, 0.1953125, 0, 1)
	Frame.LeftTexture = LeftTexture

	local RightTexture = Frame:CreateTexture()
	RightTexture:SetPoint('TOPRIGHT', 14, 17)
	RightTexture:SetSize(25, 64)
	RightTexture:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]])
	RightTexture:SetTexCoord(0.8046875, 1, 0, 1)
	Frame.RightTexture = RightTexture

	local CenterTexture = Frame:CreateTexture()
	CenterTexture:SetPoint('TOPLEFT', LeftTexture, 'TOPRIGHT')
	CenterTexture:SetPoint('TOPRIGHT', RightTexture, 'TOPLEFT')
	CenterTexture:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]])
	CenterTexture:SetTexCoord(0.1953125, 0.8046875, 0, 1)
	Frame.CenterTexture = CenterTexture

	local Button = CreateFrame('Button', nil, Frame)
	Button:SetPoint('TOPRIGHT', RightTexture, -16, -18)
	Button:SetSize(24, 24)
	Button:SetNormalTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]])
	Button:SetPushedTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]])
	Button:SetDisabledTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]])
	Button:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]])
	Button:GetHighlightTexture():SetBlendMode('ADD')
	Button:SetScript('OnClick', OnClick)
	Frame.Button = Button

	local Value = Button:CreateFontString(nil, nil, 'GameFontHighlightSmall')
	Value:SetPoint('RIGHT', Button, 'LEFT')
	Value:SetSize(0, 10)
	Button:SetFontString(Value)
	Button.Value = Value

	local Menu = CreateFrame('Frame', nil, Frame)
	Menu:SetPoint('TOPLEFT', Frame, 'BOTTOMLEFT', 0, 4)
	Menu:SetBackdrop(BACKDROP)
	Menu:SetFrameStrata('DIALOG')
	Menu:Hide()
	Frame.Menu = Menu

	for method, func in next, methods do
		Frame[method] = func
	end

	Wasabi:InjectBaseWidget(Frame, 'Text')
	Wasabi:InjectBaseWidget(Frame, 'Events')

	panel:AddObject(key, Frame)

	return Frame
end)
