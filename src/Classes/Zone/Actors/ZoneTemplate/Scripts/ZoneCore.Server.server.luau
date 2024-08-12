--===========================================================================================================================>
--!strict
--===========================================================================================================================>

-- Cache the Actor Instance
local Actor = script:FindFirstAncestorOfClass('Actor')

-- Bind a Message to the Actor so that this script can be communicated with via the Actor SendMessage:
Actor:BindToMessage('Construct', function(CoreModule: ModuleScript, Id: string, CoreActor: Actor, Container: any, RunScope: 'Server'|'Client')
	--==============================================================================================================>

	-- Require the UpdateModule Class:
	local ZoneCoreModule = require(CoreModule) :: any

	-- Construct the Object using the Required Module Class:
	local ZoneCore = ZoneCoreModule.New(Id, CoreActor, Container, RunScope)

	--==============================================================================================================>

	-- Initialize Signal Connection Variables:
	local AncestryChanged: RBXScriptConnection

	-- Create a Function to call when the Actor is being destroyed or cleaned:
	local function ClearActor()
		--==================================================>
		-- If there is a Object, Destroy it:
		if ZoneCore then ZoneCore:Destroy() end
		--==================================================>
		-- Disconnect Events:
		if AncestryChanged then AncestryChanged:Disconnect(); AncestryChanged = nil :: any end
		--==================================================>
		-- Destroy the Actor:
		Actor:Destroy()
		--==================================================>
	end

	--==============================================================================================================>

	-- Bind a Message to the Actor so that this script can be communicated with via the Actor SendMessage:
	Actor:BindToMessage('Destroy', ClearActor)

	-- Connect to the AncestryChanged event of the Script:
	-- We then check if the Script is still a decendent of the WorldModel, meaning it hasnt been destroyed.
	-- We do this to clear the Data in case the Script is Destroyed:
	AncestryChanged = Actor.AncestryChanged:Connect(function()
		--====================================================================================>
		if Actor.Parent == nil or Actor:IsDescendantOf(game) == false then ClearActor() end
		--====================================================================================>
	end)

	--==============================================================================================================>
end)

--===========================================================================================================================>
