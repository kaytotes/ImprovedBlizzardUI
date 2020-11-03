--[[
    modules\bars\castbar.lua
    Styles and Positions the Cast Bar.
]]
ImpUI_CastBar = ImpUI:NewModule('ImpUI_CastBar', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI');

-- Local Functions

-- Local Variables
local dragFrame;

--[[
    Actually shows the timers for casting bars.
    @ return void
]]
function ImpUI_CastBar:ShowTimer(self, elapsed)
    if not self.timer then return end

    if (self.timer.updateDelay and self.timer.updateDelay < elapsed) then
        if (self.casting) then
            self.timer:SetText(format('%.1f', max(self.maxValue - self.value, 0)));
        elseif (self.channeling) then
            self.timer:SetText(format('%.1f', max(self.value, 0)));
        else
            self.timer:SetText('');
        end
        self.timer.updateDelay = 0.1;
    else
        self.timer.updateDelay = self.timer.updateDelay - elapsed;
    end
end

--[[
	Creates and attaches a timer to a Casting Bar.
]]
local function CreateCastingTimer(frame, pos)
    local updateDelay = 0.1;

    frame.timer = nil;

    -- Get Font
    local font = Helpers.get_styled_font(ImpUI.db.profile.primaryInterfaceFont);

    -- Create Timers
    frame.timer = frame:CreateFontString(nil);
    frame.timer:SetFont(font.font, ImpUI.db.profile.castBarFontSize, font.flags);
    frame.timer:SetPoint(pos.point, frame, pos.relativePoint, pos.x, pos.y);
    frame.timer:SetTextColor(font.r, font.g, font.b, font.a);
    frame.timer.updateDelay = updateDelay;

    -- Hook Timers
    if (ImpUI_CastBar:IsHooked(frame, 'OnUpdate')) then return end;

    ImpUI_CastBar:HookScript(frame, 'OnUpdate', 'ShowTimer');
end

--[[
	Destroys an existing timer.
]]
local function KillTimer(frame)
    frame.timer = nil;
end

--[[
	Actually does the heavy lifting of styling the bars.
]]
function ImpUI_CastBar:StyleFrame()
    -- Kill If Needed
    KillTimer(CastingBarFrame);

    if (Helpers.IsRetail()) then
        KillTimer(TargetFrameSpellBar);
        KillTimer(FocusFrameSpellBar);
    end

    -- Get Font
    font = Helpers.get_styled_font(ImpUI.db.profile.primaryInterfaceFont);

    -- Set Font
    CastingBarFrame.Text:SetFont(font.font, ImpUI.db.profile.castBarFontSize, font.flags);
    CastingBarFrame.Text:SetTextColor(font.r, font.g, font.b, font.a);

    -- Cast Bar
    if (ImpUI.db.profile.castBarPlayerTimer) then
        CreateCastingTimer(CastingBarFrame, Helpers.pack_position('TOP', nil, 'BOTTOM', 0, 35));
    end

    -- Anything else is Retail
    if (Helpers.IsClassic()) then return end
    
    -- Target Frame
    if (ImpUI.db.profile.castBarTargetTimer) then
        CreateCastingTimer(TargetFrameSpellBar, Helpers.pack_position('TOP', nil, 'BOTTOM', 0, 28));
    end

    -- Focus Frame
    if (ImpUI.db.profile.castBarFocusTimer) then
        CreateCastingTimer(FocusFrameSpellBar, Helpers.pack_position('TOP', nil, 'BOTTOM', 0, -8));    
    end
end

--[[
	Called when unlocking the UI.
]]
function ImpUI_CastBar:Unlock()
    dragFrame:Show();
end

--[[
	Called when locking the UI.
]]
function ImpUI_CastBar:Lock()
    local point, relativeTo, relativePoint, xOfs, yOfs = dragFrame:GetPoint();

    ImpUI.db.profile.castBarPosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    dragFrame:Hide();
end

--[[
	Loads the position of the Focus Frame from SavedVariables.
]]
function ImpUI_CastBar:LoadPosition()
    local pos = ImpUI.db.profile.castBarPosition;
    local scale = ImpUI.db.profile.castBarScale;
    
    -- Set Drag Frame Position
    dragFrame:ClearAllPoints();
    dragFrame:SetPoint(pos.point, pos.relativeTo, pos.relativePoint, pos.x, pos.y);

    -- Parent Focus Frame to the Drag Frame.
    CastingBarFrame:SetMovable(true);
    CastingBarFrame:ClearAllPoints();
    CastingBarFrame:SetPoint('CENTER', dragFrame, 'CENTER', 0, 0);
    CastingBarFrame:SetScale(scale);
    CastingBarFrame:SetUserPlaced(true);
    CastingBarFrame:SetMovable(false);
end


--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_CastBar:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_CastBar:OnEnable()
    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_CastBar_DragFrame', 250, 50, L['Cast Bar']);

    ImpUI_CastBar:LoadPosition();

    ImpUI_CastBar:StyleFrame();
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_CastBar:OnDisable()
end