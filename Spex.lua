--------------------------------------------------------------------------------
-- Spex(Spex.lua) --
--------------------------------------------------------------------------------
local settings
local SpexFrame = CreateFrame("Button", "SpexFrame", UIParent, "UIDropDownMenuTemplate")

--------------------------------------------------------------------------------
-- Functions --
--------------------------------------------------------------------------------
-- returns text snippet for the given spec number --
local function makeText(specID)
  local role_icon = {
	-- Table of role icons for use in creating the text line. --
	TANK	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:0:19:21:40|t",
	HEALER	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:0:19|t",
	DAMAGER	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:21:40|t",
	NONE	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:21:40|t"
  } -- end of role_icon{} --
  local _, name, _, icon, role, _ = GetSpecializationInfo(specID)
  return role_icon[role] .. name .. "|T" .. icon .. ":0|t"
end -- end of makeText(specID) --

-- Creates drop down menu entries based on player specializations --
local function CreateDropDown(self, level)
	-- Create drop down item for each spec --
  for i = 1, GetNumSpecializations() do
    local item = UIDropDownMenu_CreateInfo()
    item.text = makeText(i)
    item.value = i
    item.func = function(self)
			-- clicking switches to selected spec, if not already in it --
      if GetSpecialization() ~= i then
        SetSpecialization(i)
      end -- end of if GetSpecialization() ~= i --
    end -- end of function(self) --
    UIDropDownMenu_AddButton(item, level)
  end -- end of for i = 1, GetNumSpecializations() --
end -- end of CreateDropDown(self, level) --

-- updates the selected menu item to the active spec --
local function Update()
  UIDropDownMenu_SetSelectedID(SpexFrame, GetSpecialization())
  UIDropDownMenu_SetText(SpexFrame, makeText(GetSpecialization()))
end -- end of Update() --

-- sets initial frame, dropdown and event settings --
local function init()
	-- load in saved variables to settings --
  SpexDB = SpexDB or {}
  settings = SpexDB

	-- set up frame appearance and functionality --
  SpexFrame:ClearAllPoints()
  if settings.Xpos then
    SpexFrame:SetPoint("BOTTOMLEFT", settings.Xpos, settings.Ypos)
  else	-- else of if settings.Xpos --
    SpexFrame:SetPoint("CENTER", 0, 0)
  end -- end of if settings.Xpos --

  -- default frame settings --
  SpexFrame:SetAlpha(0.75)
  SpexFrame:SetMovable(true)
  SpexFrame:EnableMouse(true)
  SpexFrame:EnableMouse(true)
  SpexFrame:RegisterForDrag("LeftButton")
  SpexFrame:SetScript("OnDragStart", SpexFrame.StartMoving)
  SpexFrame:SetScript("OnDragStop", function(self)
    SpexFrame:StopMovingOrSizing()
    -- saving frame location to settings --
    settings.XPos = SpexFrame:GetLeft()
    settings.YPos = SpexFrame:GetBottom()
  end) -- end of function(self)/SpexFrame:SetScript --
	SpexFrame:Show()

	-- create the dropdown --
  UIDropDownMenu_Initialize(SpexFrame, CreateDropDown)
  UIDropDownMenu_SetWidth(SpexFrame, 120)
  UIDropDownMenu_SetButtonWidth(SpexFrame, 124)
  UIDropDownMenu_JustifyText(SpexFrame, "LEFT")
  UIDropDownMenu_SetSelectedID(SpexFrame, 1)

	-- register events & set update script --
  SpexFrame:RegisterEvent("PLAYER_ALIVE")
  SpexFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  SpexFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
  SpexFrame:SetScript("OnEvent", Update)
end -- end of init() --

--------------------------------------------------------------------------------
-- Initialize --
--------------------------------------------------------------------------------
init()
