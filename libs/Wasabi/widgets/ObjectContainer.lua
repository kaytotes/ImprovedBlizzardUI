local widgetType, widgetVersion = 'ObjectContainer', 1
local Wasabi = LibStub and LibStub('Wasabi', true)
if(not Wasabi or (Wasabi:GetWidgetVersion(widgetType) or 0) >= widgetVersion) then
	return
end

local BACKDROP = {
	bgFile = [[Interface\ChatFrame\ChatFrameBackground]], tile = true, tileSize = 16,
	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
	insets = {left = 4, right = 4, top = 4, bottom = 4}
}

local objectMethods = {}
function objectMethods:Remove()
	self.parent:RemoveObject(self.key)
end

function objectMethods:Click(button)
	self.parent:Fire('ObjectClick', self, button)
end

local function CreateOrUpdateObject(self, key, value)
	local Object = self.objects[key]
	if(not Object) then
		Object = CreateFrame('Button', nil, self.ScrollChild)
		Object:SetSize(self.objectWidth, self.objectHeight)
		Object:RegisterForClicks('AnyUp')
		Object.parent = self

		for method, func in next, objectMethods do
			Object[method] = func
		end

		Object:SetScript('OnClick', Object.Click)

		self.objects[key] = Object
		self:Fire('ObjectCreate', Object)
	end

	Object.key = key
	Object.value = value

	self:Fire('ObjectUpdate', Object)
end

local methods = {}
function methods:Update(objectValues)
	self:Fire('PreUpdate')

	for key, value in next, objectValues do
		CreateOrUpdateObject(self, key, value)
	end

	for key, Object in next, self.objects do
		if(not self.panel:GetVariable(key, self.key)) then
			Object:Remove()
		end
	end

	self:UpdatePositions()
	self:Fire('PostUpdate')
end

function methods:UpdateSlider()
	local containerWidth, containerHeight = self.Container:GetSize()
	local _, _, _, childHeight = self.ScrollChild:GetBoundsRect()

	local overflow = childHeight > containerHeight
	if(overflow ~= self.overflow) then
		self.overflow = overflow
		self:UpdatePositions(true)

		if(overflow) then
			if(not self.Slider) then
				Wasabi.__createSlider(self)
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

function methods:UpdatePositions(positionOnly)
	local containerWidth = self.Container:GetWidth()
	if(self.overflow) then
		containerWidth = containerWidth - 16
	end

	local objectWidth = self.objectWidth + self.objectSpacing
	local objectHeight = self.objectHeight + self.objectSpacing
	local cols = math.floor(containerWidth / objectWidth)

	local index = 1
	for key, Object in next, self.objects do
		local x = (index - 1) % cols * objectWidth
		local y = math.floor((index - 1) / cols) * -objectHeight

		Object:ClearAllPoints()
		Object:SetPoint('TOPLEFT', x, y)

		index = index + 1
	end

	if(not positionOnly) then
		self.ScrollChild:SetWidth(self.Container:GetWidth())
		self:UpdateSlider()
	end
end

function methods:SetObjectSize(width, height)
	self.objectWidth = width
	self.objectHeight = height or width
end

function methods:SetObjectSpacing(spacing)
	self.objectSpacing = spacing
end

function methods:AddObject(key, value)
	self.panel:SetVariable(key, value or true, self.key)
	CreateOrUpdateObject(self, key, value)
	self:UpdatePositions()
end

function methods:RemoveObject(key)
	local Object = self.objects[key]
	if(Object) then
		Object:Hide()
		self.panel:DeleteVariable(key, self.key)
		self.objects[key] = nil
	end

	self:UpdatePositions()
end

function methods:HasObject(key)
	return self.objects[key]
end

Wasabi:RegisterWidget(widgetType, widgetVersion, function(panel, key)
	local _NAME = panel:GetName() .. key:gsub('^%l', string.upper) .. widgetType

	local Frame = CreateFrame('Frame', _NAME, panel)
	Frame:SetBackdrop(BACKDROP)
	Frame:SetBackdropColor(0, 0, 0, 1/2)
	Frame.panel = panel
	Frame.key = key
	Frame.objects = {}

	local ScrollChild = CreateFrame('Frame', nil, Frame)
	ScrollChild:SetHeight(1)
	Frame.ScrollChild = ScrollChild

	local Container = CreateFrame('ScrollFrame', nil, Frame)
	Container:SetPoint('TOPLEFT', 8, -8)
	Container:SetPoint('BOTTOMRIGHT', -8, 8)
	Container:SetScrollChild(ScrollChild)
	Frame.Container = Container

	for method, func in next, methods do
		Frame[method] = func
	end

	Wasabi:InjectBaseWidget(Frame, 'Events')

	-- Defaults
	Frame:SetObjectSize(30)
	Frame:SetObjectSpacing(2)

	panel:AddObject(key, Frame)

	return Frame
end)
