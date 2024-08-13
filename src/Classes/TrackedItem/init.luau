--===========================================================================================================================>
--!strict
--===========================================================================================================================>
-- TrackedItem

-- Author:
-- IISato

-- 7/31/2024
--===========================================================================================================================>

-- Define Module table:
local TrackedItemModule: TrackedItemModule = {} -- :: TrackedItemModule

-- Set the MetaIndex:
TrackedItemModule.__index = TrackedItemModule

--===========================================================================================================================>

-- Reference the Top Level Module so that we can easily Index our Modules
-- Use direct parenting instead of Ancestor in case someone changes the Module's name:
local ZonerModule = script.Parent.Parent

-- Require the Trove Module for Cleanup:
local Utility = require(ZonerModule.Utility.Utility);
-- Require the Enum2 Module for Custom Enums:
local Enums   = require(ZonerModule.Utility.Enums);
-- Require the Trove Module for Cleanup:
local Trove   = require(ZonerModule.Utility.Trove);

-- Require the Trove Module for Cleanup:
local Regions = require(ZonerModule.Utility.Regions);

-- Require the Trove Module for Cleanup:
local Constants = require(ZonerModule.Children.Constants);
-- Require the Trove Module for Cleanup:
local WorldModel = require(ZonerModule.Classes.WorldModel);

--===========================================================================================================================>
--[ DEFINE TYPES: ]


-- This will inject all types into this context.
local TypeDefinitions = require(script.TypeDefinitions)

-- Insert Object type:
export type TrackedItemMetaData = TypeDefinitions.TrackedItemMetaData
export type TrackedItemModule   = TypeDefinitions.TrackedItemModule
export type TrackedItem         = TypeDefinitions.TrackedItem

export type TrackableItem       = TypeDefinitions.TrackableItem

--===========================================================================================================================>
--[ CONSTRUCTOR FUNCTIONS: ]


-- @Public
-- Constructor Function for this individual object:
function TrackedItemModule.New(Item: TrackableItem, Detection: number?): TrackedItem
	--=======================================================================================================>
	-- Assert that the Trackable Item must be an Instance:
	assert(typeof(Item) == "Instance",                                Constants.Logs.TrackedItem.ItemType)
	-- Assert the Specifics of the Instance Type:
	assert(Item:IsA('BasePart') == true or Item:IsA('Model') == true, Constants.Logs.TrackedItem.InstanceType)
	-- Assert that the Accuracy Number sent is the right Enum value:
	assert((Detection == nil or (math.floor(Detection) >= 1 and math.floor(Detection) <= 12)), Constants.Logs.TrackedItem.Detection)
	--=======================================================================================================>

	-- Set a Memory Category for this Zoner:
	debug.setmemorycategory('Zoner: TrackedItem')

	--=======================================================================================================>

	-- Define Enum2 Data
	local TrackedItemData: TrackedItemMetaData = {
		--==========================>
		_Item = Item;
		--==========================>
		_Trove = Trove.New();
		--==========================>
		_IsAModel = Item:IsA('Model');
		--==========================>
		_Parts = {};
		--==========================>
		_CenterPart = false :: any;
		--==========================>
		InZone = false;
		--==========================>
		-- Set Default Detection to Center:
		_Detection = Detection or Enums.Enums.Detection.Automatic
		--==========================>
	} :: TrackedItemMetaData

	--=======================================================================================================>

	-- Set Metatable to the MetaTable and the current Enum2Table:
	setmetatable(TrackedItemData, TrackedItemModule)

	-- Initialize the Object:
	TrackedItemData:_Initialize()

	--=======================================================================================================>

	-- Return the MetaTable Data
	return TrackedItemData

	--=======================================================================================================>
end

-- @Public
-- Destroyer Function which clears the entirity of the Data for the Object:
function TrackedItemModule.Destroy(self: TrackedItem)
	--=======================================================================================================>

	if self._Trove then self._Trove:Destroy() end

	-- Clear all self data:
	for Index, Data in pairs(self) do self[Index] = nil end

	-- Set the Metatable to nil
	setmetatable(self :: any, nil)	

	--=======================================================================================================>
end

--===========================================================================================================================>
--[ METHODS: ]


-- @Private
-- Initialization function to start/setup the Object's initial data:
function TrackedItemModule._Initialize(self: TrackedItem)
	for Index: number, Function: string in ipairs({'_SetData', '_SetEvents'}) do self[Function](self) end
end

-- @Private
-- Initialization function to start/setup the Object's initial data:
function TrackedItemModule._SetData(self: TrackedItem)
	--=======================================================================================================>


	if self._IsAModel then
		--============================================================================================>

		local ModelDescendants: {Instance} = self._Item:GetDescendants()

		for Index: number, Child: Instance in ipairs(ModelDescendants) do
			--=====================================================================>
			if Child:IsA('BasePart') and self:_IsPartValidForItem(Child) then self._Parts[Child] = true end
			--=====================================================================>
		end

		-- Clear Variable:
		ModelDescendants = nil :: any

		--============================================================================================>
	else
		--============================================================================================>

		self._Parts[self._Item :: BasePart] = true

		--============================================================================================>
	end


	self._CenterPart = self:_GetCenterPart()


	local FilterDescendants: {BasePart} = self:_GetFilterDescendants(self._Parts)

	self._OverlapParamaters = OverlapParams.new()
	self._OverlapParamaters.FilterDescendantsInstances = FilterDescendants
	self._OverlapParamaters.FilterType = Enum.RaycastFilterType.Include
	self._OverlapParamaters.MaxParts   = #FilterDescendants

	self._RaycastParamaters = RaycastParams.new()
	self._RaycastParamaters.FilterDescendantsInstances = FilterDescendants
	self._RaycastParamaters.FilterType = Enum.RaycastFilterType.Include


	--self._Trove:Connect(self._Item.AncestryChanged, function()
	--	if not self._Item:IsDescendantOf(game) then
	--		if self._Item.Parent == nil then self._Trove:Destroy() end
	--	end
	--end)


	print('Detection Before:', Enums.Enums.Detection:GetName(self._Detection))

	-- Set the new Detection in the Setting Table:
	-- If the Detection is Automatic, calculate what Detection the Item should have Automatically:
	self._Detection = if self._Detection == Enums.Enums.Detection.Automatic then self:_GetDetection() else self._Detection

	print('Detection After:', Enums.Enums.Detection:GetName(self._Detection))

	--=======================================================================================================>
end

-- @Private
-- Initialization function to start/setup the Object's initial events:
function TrackedItemModule._SetEvents(self: TrackedItem)
	--=======================================================================================================>

	if self._IsAModel then
		--============================================================================================>

		self._Trove:Connect(self._Item.DescendantAdded, function(Descendant: BasePart)

			if not Descendant:IsA('BasePart') then return end

			if not self:_IsPartValidForItem(Descendant) then return end

			if not self._Parts[Descendant] then self._Parts[Descendant] = true end

			self._RaycastParamaters:AddToFilter(Descendant)
			self._OverlapParamaters:AddToFilter(Descendant)

			self._CenterPart = self:_GetCenterPart()


		end)

		self._Trove:Connect(self._Item.DescendantRemoving, function(Descendant: BasePart)

			if not self._Parts[Descendant] then return end

			self._Parts[Descendant] = nil

			self._RaycastParamaters.FilterDescendantsInstances = {}
			self._OverlapParamater.FilterDescendantsInstances  = {}

			for Part: BasePart, State: boolean in pairs(self._Parts) do
				self._RaycastParamaters:AddToFilter(Part)
				self._OverlapParamaters:AddToFilter(Part)
			end

			self._CenterPart = self:_GetCenterPart()

		end)

		--============================================================================================>
	else
		--============================================================================================>


		--============================================================================================>
	end

	--=======================================================================================================>
end

--===========================================================================================================================>

-- @Private
-- Initialization function to start/setup the Object's initial data:
function TrackedItemModule._GetDetection(self: TrackedItem): number
	--=======================================================================================================>

	local Detection: number

	if self._IsAModel then
		--=====================================================================================>
		-- Get the Total Amount of Parts:
		local AmountOfParts: number = Utility.Table.Length(self._Parts)

		-- Redefine the Item as the Type its supposed to be:
		local Item: Model = self._Item :: Model

		if AmountOfParts > 1 then

			local Size = Item:GetExtentsSize()

			if AmountOfParts > 20 then

				-- If the Item is bigger than 5 studs, do a more accurate check:
				-- If its less, then just check the Item's Center Position:
				if Size.Magnitude > Vector3.new(7, 7, 7).Magnitude then
					Detection = Enums.Enums.Detection.ItemCenterFull
				else
					Detection = Enums.Enums.Detection.ItemCenterPoint
				end	

			else

				-- If the Item is bigger than 5 studs, do a more accurate check:
				-- If its less, then just check the Item's Center Position:
				if Size.Magnitude > Vector3.new(7, 7, 7).Magnitude then
					Detection = Enums.Enums.Detection.ItemAllPoint
				else
					Detection = Enums.Enums.Detection.ItemCenterFull
				end	

			end

		else

			for Part: BasePart, State: boolean in pairs(self._Parts) do

				-- If the Item is bigger than 5 studs, do a more accurate check:
				-- If its less, then just check the Item's Center Position:
				if Part.Size.Magnitude > Vector3.new(5, 5, 5).Magnitude then
					Detection = Enums.Enums.Detection.ItemCenterFull
				else
					Detection = Enums.Enums.Detection.ItemCenterPoint
				end

			end

		end

		--=====================================================================================>
	else
		--=====================================================================================>

		-- Redefine the Item as the Type its supposed to be:
		local Item: BasePart = self._Item :: BasePart

		-- If the Item is bigger than 5 studs, do a more accurate check:
		-- If its less, then just check the Item's Center Position:
		if Item.Size.Magnitude > Vector3.new(5, 5, 5).Magnitude then
			Detection = Enums.Enums.Detection.ItemCenterFull
		else
			Detection = Enums.Enums.Detection.ItemCenterPoint
		end

		--=====================================================================================>
	end

	-- Return the new Detection in the Setting Table:
	return Detection :: number

	--=======================================================================================================>
end

-- @Private
-- Initialization function to start/setup the Object's initial data:
function TrackedItemModule._GetCenterPart(self: TrackedItem): BasePart
	--=======================================================================================================>
	-- Define the CenterPart Variable:
	local CenterPart: BasePart

	-- If its a Model find it via all the Parts:
	if self._IsAModel then
		-- Redefine the Item as the Type its supposed to be:
		local Item: Model = self._Item :: Model
		-- Set the CenterPart:
		CenterPart = Item.PrimaryPart or Regions:GetCenterPartOfParts(self._Parts)
	else
		-- Set the CenterPart:
		CenterPart = self._Item :: BasePart
	end

	-- Warn if its CanQuery is false:
	if CenterPart.CanQuery == false then warn(`CenterPart for TrackedItem: {self._Item} has its CanQuery to false!`) end

	-- Return the CenterPart:
	return CenterPart
	--=======================================================================================================>
end

-- @Private
-- Initialization function to start/setup the Object's initial data:
function TrackedItemModule._GetFilterDescendants(self: TrackedItem, Parts: {[BasePart]: boolean}): {BasePart}
	--=======================================================================================================>

	-- Define the FilterDescendants Array:
	local FilterDescendants: {BasePart} = {}

	if self._Detection == Enums.Enums.Detection.CenterItemPart or self._Detection == Enums.Enums.Detection.CenterItemPoint then
		table.insert(FilterDescendants, self._CenterPart)
	else 
		
		-- Loop through the Parts Dictionary:
		for Part: BasePart, State: boolean in pairs(Parts) do
			if Part.CanQuery == false then continue end
			table.insert(FilterDescendants, Part)
		end

	end

	return FilterDescendants

	--=======================================================================================================>
end


-- @Private
-- Initialization function to start/setup the Object's initial data:
function TrackedItemModule._IsPartValidForItem(self: TrackedItem, Part: BasePart): boolean
	--=======================================================================================================>
	-- Dont allow Accessory Parts to be registered and checked:
	if Part.Parent and Part.Parent:IsA('Accessory') then return false end
	-- If the Part is found in the IgnoreParts Dictionary, then we should not add it to the Parts Registry,
	-- and therefore we should not check it:
	if Constants.TrackerData.CharacterIgnoreParts[Part.Name] then return false end
	-- Return true:
	return true
	--=======================================================================================================>
end

-- possible idea:

-- The zone does one overlap call
-- but the zone loops through all trackers and creates a new filterdescendant, adding all the FilterDescendant Arrays 
-- of every trackeritem object, so that it can do one PartsInPart or PartsInRegion call
-- then once theres an Array of all the Parts that it intersected with

-- we loop through all the trackers checking if they have parts in the results array
-- then we check the trackers individually if they have all of them inside of the zone or whatevre depending on the 
-- detection type of the tracker item

-- @Private
-- Initialization function to start/setup the Object's initial data:
function TrackedItemModule.GetFilterDescendants(self: TrackedItem): {BasePart}
	--=======================================================================================================>

	-- Define the FilterDescendants Array:
	local FilterDescendants: {BasePart} = {}

	return FilterDescendants

	--=======================================================================================================>
end

--===========================================================================================================================>

-- @Public
-- Initialization function to start/setup the Object's initial data:
@native
function TrackedItemModule.DictionaryHasTrackedParts(self: TrackedItem, Dictionary: {[BasePart]: boolean}): boolean
	--=======================================================================================================>
	-- Loop through the Tracked Item Parts Dictionary checking each to see if they are in the passed Dictionary:
	-- If one is, break the loop by returning true:
	for Part: BasePart, State: boolean in pairs(self._Parts) do
		if Dictionary[Part] then return true end
	end
	--=======================================================================================================>
	-- Return False because no Part of this Item is in the passed Dictionary:
	return false
	--=======================================================================================================>
end

-- @Public
-- Initialization function to start/setup the Object's initial data:
@native
function TrackedItemModule.ArrayHasTrackedParts(self: TrackedItem, Array: {BasePart}): boolean
	--=======================================================================================================>
	-- Loop through the Array checking each to see if they are in the Tracked Parts Dictionary:
	-- If one is, break the loop by returning true:
	for Index: number, Part: BasePart in ipairs(Array) do
		if self._Parts[Part] then return true end
	end
	--=======================================================================================================>
	-- Return False because no Part of this Item is in the passed Array:
	return false
	--=======================================================================================================>
end

--===========================================================================================================================>



-- @Public
-- Initialization function to start/setup the Object's initial data:
@native
function TrackedItemModule.GetBoundingBox(self: TrackedItem, Array: {BasePart}): boolean
	--=======================================================================================================>


	if self._IsAModel then

		local Item: Model = self._Item :: Model


		--Item:
		--local CFrame1: CFrame, Size1: Vector3 = Item:GetBoundingBox()


		--Regions:


	end


	--=======================================================================================================>
end


-- @Public
-- Initialization function to start/setup the Object's initial data:
@native
function TrackedItemModule.GetZonePartResults(self: TrackedItem, ZonePart: BasePart): RaycastResult?
	--=======================================================================================================>
	return workspace:Shapecast(ZonePart, Vector3.zero, self._RaycastParamaters)
	--=======================================================================================================>
end

-- @Public
-- Initialization function to start/setup the Object's initial data:
@native
function TrackedItemModule.GetZonePartParts(self: TrackedItem, ZonePart: BasePart): {Instance}
	--=======================================================================================================>
	return WorldModel:GetPartsInPart(ZonePart, self._OverlapParamaters)
	--=======================================================================================================>
end

-- @Public
-- Initialization function to start/setup the Object's initial data:
@native
function TrackedItemModule.GetPartsInRegion(self: TrackedItem, RegionCFrame: CFrame, RegionSize: Vector3): {Instance}
	--=======================================================================================================>'
	return WorldModel:GetPartBoundsInBox(RegionCFrame, RegionSize, self._OverlapParamaters)
	--=======================================================================================================>
end



-- @Public
-- Initialization function to start/setup the Object's initial data:
@native
function TrackedItemModule.GetPosition(self: TrackedItem, Part: BasePart?): Vector3
	--=======================================================================================================>

	-- If the Item is a Model, get the Position of the Model based on the PrimaryPart or Pivot, else just get the Position of the BasePart:
	if Part then
		--==============================================================================>
		-- Return the Position of the BasePart:
		return Part.Position
		--==============================================================================>
	elseif self._CenterPart then
		--==============================================================================>
		return self._CenterPart.Position
		--==============================================================================>
	elseif self._IsAModel then
		--==============================================================================>
		-- Redefine the Item as the Type its supposed to be:
		local Item: Model = self._Item :: Model
		-- If the Item has a PrimaryPart then return the Position of the PrimaryPart, else get the PivotPoint of the Model:
		return if Item.PrimaryPart then Item.PrimaryPart.Position else Item:GetPivot().Position
		--==============================================================================>
	else
		--==============================================================================>
		-- Redefine the Item as the Type its supposed to be:
		local Item: BasePart = self._Item :: BasePart
		-- Return the Position of the BasePart:
		return Item.Position
		--==============================================================================>
	end

	--=======================================================================================================>
end



-- IsInsideRegion
-- IsInsidePart
-- IsInside

-- @Public
-- Initialization function to start/setup the Object's initial data:
@native
function TrackedItemModule.IsInsideRegion(self: TrackedItem, Region: Region3?, RegionCFrame: CFrame?, RegionSize: Vector3?): boolean
	--=======================================================================================================>
	-- Return the boolean from the IsInsideBoundBox Method:
	-- Use the Passed RegionCFrame and RegionSize to get the BoundingBox if they were passed, else use the passed Region3:
	return self:IsInsideBoundBox(
		Regions:GetBoundingBox(RegionCFrame or Region :: Region3 and Region.CFrame, RegionSize or Region :: Region3 and Region.Size)
	)
	--=======================================================================================================>
end

-- @Public
-- Initialization function to start/setup the Object's initial data:
@native
function TrackedItemModule.IsInsideBoundBox(self: TrackedItem, BoundMin: Vector3, BoundMax: Vector3): boolean
	--=======================================================================================================>

	-- Get the Detection String using the Objects Detection Enum:
	local Detection: Enums.Detections = Enums.Enums.Detection:GetName(self._Detection)

	
	if Detection == 'ItemCenterFull' then

		return Regions:IsPartFullyInsideBoundBox(self._CenterPart, BoundMin, BoundMax)
		
	elseif Detection == 'ItemCenterTouch' then

		return Regions:IsPartTouchingBoundBox(self._CenterPart, BoundMin, BoundMax)

	elseif Detection == 'ItemCenterPoint' then

		return Regions:IsPointInsideBoundBox(self:GetPosition(), BoundMin, BoundMax)

	elseif Detection == 'ItemAllFull' then
		
		local IsInside: boolean = true
		
		for Part: BasePart, State: boolean in pairs(self._Parts) do
	
			if Regions:IsPartFullyInsideBoundBox(Part, BoundMin, BoundMax) == false then
				IsInside = false; break
			end
	
		end
		
		return IsInside
	
	elseif Detection == 'ItemAllPoint' then

		local IsInside: boolean = true

		for Part: BasePart, State: boolean in pairs(self._Parts) do

			if Regions:IsPointInsideBoundBox(self:GetPosition(Part), BoundMin, BoundMax) == false then
				IsInside = false; break
			end

		end

		return IsInside
		
	elseif Detection == 'ItemAnyTouch' then

		local IsInside: boolean = false

		for Part: BasePart, State: boolean in pairs(self._Parts) do

			if Regions:IsPartTouchingBoundBox(Part, BoundMin, BoundMax) == true then
				IsInside = true; break
			end

		end

		return IsInside

	elseif Detection == 'ItemAnyFull' then

		local IsInside: boolean = false

		for Part: BasePart, State: boolean in pairs(self._Parts) do

			if Regions:IsPartFullyInsideBoundBox(Part, BoundMin, BoundMax) == true then
				IsInside = true; break
			end

		end

		return IsInside


	elseif Detection == 'ItemBoxFull' then

		if self._IsAModel then

			-- Redefine the Item as the Type its supposed to be:
			local Item: Model = self._Item :: Model
			
			-- Get the BoundingBox of the Model:
			local BoundMin1, BoundMin2 = Regions:GetBoundingBox(Item:GetBoundingBox())
			
			-- Pass the BoundingBox of the Model to the function to Check if the Model BoundingBox is 
			-- fully inside the Passed BoundingBox:
			return Regions:IsBoundBoxFullyInsideBoundBox(
				BoundMin1, BoundMin2, BoundMin, BoundMax
			)
			
		else
			
			-- Return CenterPart BoundBox because a Part cant really have a Bounding Box:
			return Regions:IsPartFullyInsideBoundBox(self._CenterPart, BoundMin, BoundMax)
			
		end
	
	elseif Detection == 'ItemBoxTouch' then

		if self._IsAModel then

			-- Redefine the Item as the Type its supposed to be:
			local Item: Model = self._Item :: Model

			-- Get the BoundingBox of the Model:
			local BoundMin1, BoundMin2 = Regions:GetBoundingBox(Item:GetBoundingBox())

			-- Pass the BoundingBox of the Model to the function to Check if the Model BoundingBox is 
			-- fully inside the Passed BoundingBox:
			return Regions:IsBoundBoxTouchingBoundBox(
				BoundMin1, BoundMin2, BoundMin, BoundMax
			)

		else

			-- Return CenterPart BoundBox because a Part cant really have a Bounding Box:
			return Regions:IsPartTouchingBoundBox(self._CenterPart, BoundMin, BoundMax)

		end
	else
		return false
	end

	--=======================================================================================================>
end

--===========================================================================================================================>

-- @Public
-- Method to Update/Set the Default Part/TrackedItem Detection of the TrackedItem:
function TrackedItemModule.IsInZonePart(self: TrackedItem, Properties: ZonePartProperties )
	--=======================================================================================================>


	--=======================================================================================================>
end



-- @Public
-- Method to Update/Set the Default Part/TrackedItem Detection of the TrackedItem:
function TrackedItemModule.SetDetection(self: TrackedItem, NameOrId: number | Enums.Detections)
	--=======================================================================================================>
	
	-- Grab the Detection Number Vlaue:
	local Detection: number | 'Failure' = Enums.Enums.Detection:GetValue(NameOrId)
	
	-- If Detection is Failure, then warn to User that the passed Name Or Id did not return a valid Enum.
	if Detection == 'Failure' then warn(Constants.Logs.TrackedItem.SetDetection); return end

	-- Set the new Detection in the Setting Table:
	-- If the Detection is Automatic, calculate what Detection the Item should have Automatically:
	self._Detection = if Detection == Enums.Enums.Detection.Automatic then self:_GetDetection() else Detection

	--=======================================================================================================>
end

--===========================================================================================================================>

-- @Private
-- Initialization function to start/setup the Object's initial data:
function TrackedItemModule.FindPartInArray(self: TrackedItem, Part: BasePart, Array: {BasePart}): number?
	return table.find(Array, Part)
end

--===========================================================================================================================>

-- Return a Frozen Module Table:
return table.freeze(TrackedItemModule) :: TrackedItemModule

--===========================================================================================================================>