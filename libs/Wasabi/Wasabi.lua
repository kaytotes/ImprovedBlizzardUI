local MAJOR, MINOR = 'Wasabi', 7
assert(LibStub, MAJOR .. ' requires LibStub')

local lib, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if(not lib) then
	return
end

local databases = {}

local function OnEvent(self, event, arg1)
	if(event == 'ADDON_LOADED' and arg1 == (self.parent or self.name)) then
		if(not _G[self.glob]) then
			_G[self.glob] = CopyTable(self.defaults)
		end

		self.db = _G[self.glob]
		for key, value in next, self.defaults do
			if(self.db[key] == nil) then
				self.db[key] = value
			end
		end

		self.temp = CopyTable(self.db)

		self:UnregisterEvent(event)
	end
end

local methods = {}
local function CreatePanelProto(name, glob, defaults)
	assert(not databases[glob], 'Savedvariables "' .. glob .. '" is already in use')

	local panel = CreateFrame('Frame', name .. 'OptionsPanel', InterfaceOptionsFramePanelContainer)
	panel:RegisterEvent('ADDON_LOADED')
	panel:HookScript('OnEvent', OnEvent)
	panel:Hide()

	panel.name = name
	panel.defaults = defaults
	panel.glob = glob

	panel.temp = {}
	panel.objects = {}

	for method, func in next, methods do
		panel[method] = func
	end

	databases[glob] = true

	return panel
end

function methods:CreateChild(name, glob, defaults)
	assert(not self.parent, 'Cannot create child panel on a child panel.')

	local panel = CreatePanelProto(name, glob, defaults)
	panel.parent = self.name

	InterfaceOptions_AddCategory(panel)
	return panel
end

function methods:AddSlash(slash)
	if(not self.slashIndex) then
		self.slashIndex = 1
		SlashCmdList[self.name] = function() self:ShowOptions() end
	else
		self.slashIndex = self.slashIndex + 1
	end

	_G['SLASH_' .. self.name .. self.slashIndex] = slash
end

function methods:ShowOptions()
	-- BUG: On first load IOF doesn't select the right category or panel.
	InterfaceOptionsFrame_OpenToCategory(self.name)
	InterfaceOptionsFrame_OpenToCategory(self.name)
end

local internalMethods = {}
function methods:Initialize(constructor)
	self:SetScript('OnShow', function()
		local _NAME = self:GetName()
		local ScrollChild = CreateFrame('Frame', _NAME .. 'ScrollChild', self)
		ScrollChild:SetHeight(1)
		ScrollChild.panel = self
		self.ScrollChild = ScrollChild

		for method, func in next, internalMethods do
			ScrollChild[method] = func
		end

		local Container = CreateFrame('ScrollFrame', _NAME .. 'Container', self)
		Container:SetPoint('TOPLEFT', 6, -6)
		Container:SetPoint('BOTTOMRIGHT', -6, 6)
		Container:SetScrollChild(ScrollChild)
		self.Container = Container

		ScrollChild:SetWidth(Container:GetWidth())
		constructor(setmetatable(ScrollChild, {__index = lib.widgets}))

		self:UpdateSlider()

		self:refresh()
		self:SetScript('OnShow', nil)
	end)
end

function internalMethods:GetVariable(key, nested)
	if(nested) then
		return self.panel.temp[nested][key]
	else
		return self.panel.temp[key]
	end
end

function internalMethods:SetVariable(key, value, nested)
	if(nested) then
		self.panel.temp[nested][key] = value
	else
		self.panel.temp[key] = value
	end
end

function internalMethods:DeleteVariable(key, nested)
	if(nested) then
		self.panel.temp[nested][key] = nil
	else
		self.panel.temp[key] = nil
	end
end

function internalMethods:GetAllVariables(nested)
	if(nested) then
		return self.panel.temp[nested]
	else
		return self.panel.temp
	end
end

function internalMethods:AddObject(key, object)
	self.panel.objects[key] = object
end

function methods:refresh()
	for key, object in next, self.objects do
		object:Update(self.temp[key])
	end

	self:Fire('Refresh', self.temp)
end

function methods:okay()
	for key, value in next, self.temp do
		if(self.db[key] ~= value) then
			self.db[key] = value
		end
	end

	self:Fire('Okay', self.temp)
end

function methods:default()
	table.wipe(self.temp)
	self.temp = CopyTable(self.defaults)

	self:Fire('Default', self.defaults)
end

function methods:cancel()
	table.wipe(self.temp)
	self.temp = CopyTable(self.db)

	self:Fire('Cancel', self.temp)
end

local function CreateSlider(Frame)
	local _NAME = Frame:GetName()
	local Slider = CreateFrame('Slider', _NAME .. 'Slider', Frame.Container)
	Slider:SetPoint('TOPRIGHT', 2, -14)
	Slider:SetPoint('BOTTOMRIGHT', 2, 13)
	Slider:SetWidth(16)
	Frame.Slider = Slider

	local Thumb = Frame.Container:CreateTexture(_NAME .. 'Thumb')
	Thumb:SetSize(16, 24)
	Thumb:SetTexture([[Interface\Buttons\UI-ScrollBar-Knob]])
	Thumb:SetTexCoord(1/4, 3/4, 1/8, 7/8)
	Slider:SetThumbTexture(Thumb)

	local Up = CreateFrame('Button', _NAME .. 'Up', Slider)
	Up:SetPoint('BOTTOM', Slider, 'TOP')
	Up:SetSize(16, 16)
	Up:SetNormalTexture([[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Up]])
	Up:SetDisabledTexture([[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Disabled]])
	Up:SetHighlightTexture([[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Highlight]])
	Up:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	Up:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	Up:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	Up:GetHighlightTexture():SetBlendMode('ADD')
	Up:SetScript('OnClick', function()
		Slider:SetValue(Slider:GetValue() - Slider:GetHeight() / 3)
	end)

	local Down = CreateFrame('Button', _NAME .. 'Down', Slider)
	Down:SetPoint('TOP', Slider, 'BOTTOM')
	Down:SetSize(16, 16)
	Down:SetScript('OnClick', ScrollClick)
	Down:SetNormalTexture([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Up]])
	Down:SetDisabledTexture([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Disabled]])
	Down:SetHighlightTexture([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Highlight]])
	Down:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	Down:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	Down:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	Down:GetHighlightTexture():SetBlendMode('ADD')
	Down:SetScript('OnClick', function()
		Slider:SetValue(Slider:GetValue() + Slider:GetHeight() / 3)
	end)

	Slider:SetScript('OnValueChanged', function(self, value)
		local min, max = self:GetMinMaxValues()
		if(value == min) then
			Up:Disable()
		else
			Up:Enable()
		end

		if(value == max) then
			Down:Disable()
		else
			Down:Enable()
		end

		self:GetParent():SetVerticalScroll(value)
		Frame.ScrollChild:SetPoint('TOP', 0, value)
	end)

	Slider:SetScript('OnMinMaxChanged', function(self, min)
		self:SetValue(self:GetValue() or min)
	end)

	Frame.Container:SetScript('OnMouseWheel', function(self, alpha)
		if(alpha > 0) then
			Slider:SetValue(Slider:GetValue() - Slider:GetHeight() / 3)
		else
			Slider:SetValue(Slider:GetValue() + Slider:GetHeight() / 3)
		end
	end)
end
lib.__createSlider = CreateSlider

function methods:UpdateSlider()
	local containerWidth, containerHeight = self.Container:GetSize()
	local _, _, _, childHeight = self.ScrollChild:GetBoundsRect()

	local overflow = childHeight > containerHeight
	if(overflow ~= self.overflow) then
		self.overflow = overflow

		if(overflow) then
			if(not self.Slider) then
				CreateSlider(self)
			end

			self.Slider:Show()
			self.ScrollChild:SetWidth(containerWidth - 16)
		elseif(self.Slider) then
			self.Slider:Hide()
			self.ScrollChild:SetWidth(containerWidth)
		end
	end

	if(self.Slider) then
		self.Slider:SetMinMaxValues(0, math.max(0, childHeight - containerHeight))
	end
end

function lib:New(name, glob, defaults)
	local panel = CreatePanelProto(name, glob, defaults)

	InterfaceOptions_AddCategory(panel)
	return panel
end

lib.widgets = CreateFrame('Frame')
lib.widgetVersions = {}
function lib:RegisterWidget(type, version, constructor)
	local oldVersion = self.widgetVersions[type]
	if(oldVersion and oldVersion >= version) then
		return
	end

	self.widgets['Create' .. type] = constructor
	self.widgetVersions[type] = version
end

function lib:GetWidgetVersion(type)
	return self.widgetVersions[type]
end

lib.baseWidgets = CreateFrame('Frame')
lib.baseWidgetVersions = {}
function lib:RegisterBaseWidget(type, version, constructor)
	local oldVersion = self.baseWidgetVersions[type]
	if(oldVersion and oldVersion >= version) then
		return
	end

	self.baseWidgets[type] = constructor
	self.baseWidgetVersions[type] = version
end

function lib:GetBaseWidgetVersion(type)
	return self.baseWidgetVersions[type]
end

function lib:InjectBaseWidget(widget, type)
	self.baseWidgets[type](widget)
end

-- not really a fan of CallbackHandler-1.0
local callbacks = {}
function methods:Fire(event, ...)
	local eventCallbacks = callbacks[event]
	if(eventCallbacks) then
		for _, callback in next, eventCallbacks do
			callback(...)
		end
	end
end

function methods:On(event, callback)
	if(not callbacks[event]) then
		callbacks[event] = {}
	end

	table.insert(callbacks[event], callback)
end
