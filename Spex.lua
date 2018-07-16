--------------------------------------------------------------------------------
-- Spex(Spex.lua) --
--------------------------------------------------------------------------------
--[[ Creating the overarching table for storing
		 all necessary info for the addon. ]]--
local Spex = {}
--------------------------------------------------------------------------------
-- Functions --
--------------------------------------------------------------------------------
local function pline(line, ...)
	--[[ Prints all parameters given prefixed with [Spex]:
		 Primarily used for debugging purposes. ]]--
	print("[Spex]: ",line, ...)
end -- end pline()

local function CreateSpecTable()
	--[[ Creates the tables for each specX where X is the spec number.
		 Tables contain a spec ID number and a text line
		 to be used in the DropDownMenu. ]]--

	--pline("entering CreateSpecTable()")

	local role_icon = {
	--[[ Table of role icons for use in creating the text line. ]]--
	TANK	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:0:19:21:40|t",
	HEALER	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:0:19|t",
	DAMAGER	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:21:40|t",
	NONE	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:21:40|t"
	} -- end role_icon{}

	--[[ Set the number of specs the current player class has.
		 Used as an iteration limit for creating
		 the spec tables and drop down items. ]]--
	Spex.numSpecs = GetNumSpecializations()

	for i = 1, Spex.numSpecs do
		--[[ looping through total number of specs in player class ]]--

		--[[ initialize spec table for current spec number ]]--
		Spex["spec"..i] = {}

		--[[ Sets ["id"] value to current spec number ]]--
		Spex["spec"..i]["id"] = i

		--[[ Retrieving name, icon, and role information from
				 blizz api for current spec number ]]--
		local _, name, _, icon, role, _ = GetSpecializationInfo(i)

		--pline(name,icon,role)

		--[[ combines icon/role/name into text snippet ]]--
		Spex["spec"..i]["text"] = role_icon[role] .. name .. "|T" .. icon .. ":0|t"

		--[[ Currently unused table entries ]]--
		--Spex["spec"..i]["icon"] = "|T" .. icon .. ":0|t"
		--Spex["spec"..i]["role"] = role_icon[role]+

		--pline(Spex["spec"..i]["id"],Spex["spec"..i]["text"])
	end -- end for i, numSpecs

	--pline("leaving CreateSpecTable()")
end -- end CreateSpecTable()

local function CreateDropDown(self, level)
	--[[ Creates the DropDownMenuItems and
			 enables spec switching functionality ]]--

	--pline("entering CreateDropDown()")

	for i = 1, Spex.numSpecs do
		--[[ looping through total number of specs in player class ]]--
		--pline(level)

		--[[ initialize a blank DropDownMenuItem ]]--
		local dropDownMenuItem = UIDropDownMenu_CreateInfo()

		--[[ Sets the DropDownMenuItem text and value equal to the
			 spec table ["text"] and ["id"] entries respectively ]]--
		dropDownMenuItem.text = Spex["spec"..i]["text"]
		--pline(dropDownMenuItem.text)
		dropDownMenuItem.value = Spex["spec"..i]["id"]


		dropDownMenuItem.func = function(self)
			--[[ Sets the DropDownMenuItem function to call
					 SetSpecialization on the selected spec if it is
					 not the currently selected spec when clicked ]]--
			if GetSpecialization() ~= i then
			--[[ Checks if the current spec is the same as the selection then
				 changes the spec to match the selection ]]--
				SetSpecialization(i)
			end -- end if
		end -- end dropDownMenuItem.func

		--[[ Adds the customized button to the DropDownMenu ]]--
		UIDropDownMenu_AddButton(dropDownMenuItem, level)
		--UIDropDownMenu_AddButton(dropDownMenuItem, 1)
	end -- end for i, numSpecs

	--pline("exiting CreateDropDown()")
end -- end CreateDropDown()

local function CreateSpexFrame()
	--[[ Creates the Spex Frame, loads location and shows it on screen. ]]--

	--pline("entering CreateSpexFrame()")

	--[[ Checks for pre-existing Spex Frame, prevents duplicates ]]--
	if not Spex.SpexFrame then
		--[[ creates the SpexFrame as a DropDownMenu with buttons ]]--
		Spex.SpexFrame = CreateFrame("Button", "SpexFrame", UIParent, "UIDropDownMenuTemplate")
	end -- end if not SpexFrame

	--[[ Checks for savedvariables in SpexDB and
			 loads them into Spex.settings if they exist ]]--
	SpexDB = SpexDB or {}
	Spex.settings = SpexDB

	--[[ reset frame location ]]--
	Spex.SpexFrame:ClearAllPoints()

	--[[ checks if savedvariables exist ]]--
	if Spex.settings.XPos then
		--[[ loads previous location if savedvariables exists ]]--
		Spex.SpexFrame:SetPoint("BOTTOMLEFT", Spex.settings.XPos, Spex.settings.YPos)
	else -- else if Spex.settings.XPos
		--[[ defaults location to center of screen if
				 no existing savedvariables ]]--
		Spex.SpexFrame:SetPoint("CENTER", 0, 0)
	end -- end if Spex.settings.XPos

	--[[ configures basic frame information and shows it on screen ]]--
	Spex.SpexFrame:Show()
	Spex.SpexFrame:SetAlpha(0.75)
	--[[ allows movement with the mouse via left click ]]--
	Spex.SpexFrame:SetMovable(true)
	Spex.SpexFrame:EnableMouse(true)
	Spex.SpexFrame:RegisterForDrag("LeftButton")
	Spex.SpexFrame:SetScript("OnDragStart", Spex.SpexFrame.StartMoving)
	--[[ after frame finished moving, position
			 saved to savedvariables in SpexDB ]]--
	Spex.SpexFrame:SetScript("OnDragStop",
		function(self)
			Spex.SpexFrame:StopMovingOrSizing()
			Spex.settings.XPos = Spex.SpexFrame:GetLeft()
			Spex.settings.YPos = Spex.SpexFrame:GetBottom()
		end); -- end function/SetScript

	--[[ creates the DropDownMenuItems then assigns
			 basic DropDownMenu configurations ]]--
	UIDropDownMenu_Initialize(Spex.SpexFrame, CreateDropDown)
	UIDropDownMenu_SetWidth(Spex.SpexFrame, 120)
	UIDropDownMenu_SetButtonWidth(Spex.SpexFrame, 124)
	UIDropDownMenu_JustifyText(Spex.SpexFrame, "LEFT")
	UIDropDownMenu_SetSelectedID(Spex.SpexFrame, 1)

	--pline("exiting CreateSpexFrame()")
end -- end CreateSpexFrame()

local function HandleEvent(self, event, ...)
	--[[ triggered by registered events and sets off the creation
			 of spex table & frame and triggers DropDownMenu updates ]]--

	--pline("Entering HandleEvent() on "..event)


	if not Spex["spec1"] then
		CreateSpecTable()
	end -- end if not Spex["spec1"]
	--[[ checking for existing spec table and spexframe.
	 		 if none exist, create them.  prevents duplicates ]]--
	if not Spex.SpexFrame then
		CreateSpexFrame()
	end -- end if not Spex.SpexFrame

	--[[ Updates DropDownMenu ]]--
	UIDropDownMenu_SetSelectedID(Spex.SpexFrame, GetSpecialization())

	--pline("exiting HandleEvent() on "..event)
end -- end HandleEvent()

--------------------------------------------------------------------------------
-- Initialization --
--------------------------------------------------------------------------------
--pline("Sanity Check")

--[[ creates event checker and runs
		 HandleEvent() when a registered event happens ]]--
local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
--events:RegisterEvent("SPELLS_CHANGED")
events:SetScript("OnEvent", function(self, event)
	--[[ attempting to delay the call for initial update
	 		 to prevent incorrect display immediately after fresh login ]]--
	if event == "PLAYER_ENTERING_WORLD" then
		C_Timer.After(10, HandleEvent)
	else -- else if event PLAYER_ENTERING_WORLD

	end -- end if event PLAYER_ENTERING_WORLD
end) -- end function/SetScript
