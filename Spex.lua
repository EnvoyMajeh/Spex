local Spex = {}

local function pline(string, ...)
	print("[Spex]: ",string, ...)
end

local function CreateSpecTable()
	--pline("entering CreateSpecTable()")
	
	local role_icon = {
	TANK	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:0:19:21:40|t",
	HEALER	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:0:19|t",
	DAMAGER	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:21:40|t",
	NONE	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:21:40|t"
	}
	
	Spex.numSpecs = GetNumSpecializations()
	
	for i = 1, Spex.numSpecs do
		Spex["spec"..i] = {}
		Spex["spec"..i]["id"] = i
		
		local _, name, _, icon, role, _ = GetSpecializationInfo(i)
		
		--pline(name,icon,role)
		
		Spex["spec"..i]["text"] = role_icon[role] .. name .. "|T" .. icon .. ":0|t"
		
		--Spex["spec"..i]["icon"] = "|T" .. icon .. ":0|t"
		--Spex["spec"..i]["role"] = role_icon[role]+
		
		pline(Spex["spec"..i]["id"],Spex["spec"..i]["text"])
	end
	
	--pline("leaving CreateSpecTable()")
end

local function HandleEvent(self, event, ...)
	pline("Entering HandleEvent on "..event)
	if not Spex["spec1"] then
		CreateSpecTable()
	end
	
	--pline(Spex.numSpecs)
	--pline(Spex["spec1"]["id"],Spex["spec1"]["role"],Spex["spec1"]["name"],Spex["spec1"]["icon"])
	
end

--pline("Sanity Check")

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
events:RegisterEvent("SPELLS_CHANGED")
events:SetScript("OnEvent", HandleEvent)