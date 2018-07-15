--print("Sanity Check")

local Spex = {}


local role_icon = {
	TANK	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:0:19:21:40|t",
	HEALER	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:0:19|t",
	DAMAGER	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:21:40|t",
	NONE	= "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:21:40|t"
}

local function CreateSpecTable()
	--print("entering CreateSpecTable()")
	
	Spex.numSpecs = GetNumSpecializations()
	
	for i = 1, Spex.numSpecs do
		Spex["spec"..i] = {}
		Spex["spec"..i]["id"] = i
		_, Spex["spec"..i]["name"], _, Spex["spec"..i]["icon"], Spex["spec"..i]["role"], _ = GetSpecializationInfo(i)
		Spex["spec"..i]["icon"] = "|T" .. Spex["spec"..i]["icon"] .. ":0|t"
		Spex["spec"..i]["role"] = role_icon[Spex["spec"..i]["role"]]
		--print(Spex["spec"..i]["id"],Spex["spec"..i]["role"],Spex["spec"..i]["name"],Spex["spec"..i]["icon"])
	end
	
	--print("leaving CreateSpecTable()")
end

local function HandleEvent(self, event, ...)
	print("Entering HandleEvent on "..event)
	if not Spex["spec1"] then
		CreateSpecTable()
	end
	
	--print(Spex.numSpecs)
	--print(Spex["spec1"]["id"],Spex["spec1"]["role"],Spex["spec1"]["name"],Spex["spec1"]["icon"])
	
end


local f = CreateFrame("Frame")

f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
f:RegisterEvent("SPELLS_CHANGED")
f:SetScript("OnEvent", HandleEvent)