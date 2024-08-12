--=======================================================================================================>
--!strict
--=======================================================================================================>

-- Grab the ZonerModule Reference:
local ZonerModule = script:FindFirstAncestor('ZonerModule')

-- Require the Types:
local Trove = require(ZonerModule.Utility.Trove);
-- Require the Types:
local Enums = require(ZonerModule.Utility.Enums);

--=======================================================================================================>

-- Create and Export Type:
export type TrackableItem = Model | BasePart

--=======================================================================================================>
-- Create the Object Types:


-- Create and Export Object Type:
export type TrackedItem = typeof(
	setmetatable({} :: TrackedItemMetaData, {} :: TrackedItemModule)
)

-- Create and Export MetaData Type:
export type TrackedItemMetaData = {
	--===========================================>
	_Trove: Trove.Trove;
	--===========================================>
	_Item: TrackableItem;
	--===========================================>
	_IsAModel: boolean;
	--===========================================>
	_Parts: {[BasePart]: boolean};
	--===========================================>
	_CenterPart: BasePart;
	--===========================================>
	InZone: boolean;
	--===========================================>
	_Detection: number;
	--===========================================>
}

-- Create and Export Module Type:
export type TrackedItemModule = {
	--===========================================>

	New: 
		(Item: TrackableItem, Detection: number?) -> TrackedItem,
	Destroy: 
		(self: TrackedItem) -> (),

	_Initialize: 
		(self: TrackedItem) -> (),
	_SetData: 
		(self: TrackedItem) -> (),
	_SetEvents: 
		(self: TrackedItem) -> (),

	_GetCenterPart: 
		(self: TrackedItem) -> BasePart,
	_GetDetection: 
		(self: TrackedItem) -> number,
	_GetFilterDescendants: 
		(self: TrackedItem, Parts: {[BasePart]: boolean}) -> {BasePart},

	_IsPartValidForItem: 
		(self: TrackedItem, Part: BasePart) -> boolean,

	GetPosition: 
		(self: TrackedItem, Part: BasePart?) -> Vector3,

	IsInsideRegion: 
		(self: TrackedItem, Region: Region3?, RegionCFrame: CFrame?, RegionSize: Vector3?) -> boolean,
	IsInsideBoundBox: 
		(self: TrackedItem, BoundMin: Vector3, BoundMax: Vector3) -> boolean,


	DictionaryHasTrackedParts: 
		(self: TrackedItem, Dictionary: {[BasePart]: boolean}) -> boolean,

	ArrayHasTrackedParts: 
		(self: TrackedItem, Array: {BasePart}) -> boolean,

	SetDetection: 
		(self: TrackedItem, NameOrId: (number | Enums.Detections)) -> (),

	FindPartInParts: 
		(self: TrackedItem, Part: BasePart, Array: {BasePart}) -> number?,

	--===========================================>

	__index: TrackedItemModule,

	--===========================================>
}

--=======================================================================================================>

-- Clear from memory:
Trove = nil :: any

--=======================================================================================================>

-- Return an empty table:
return table.freeze({})

--=======================================================================================================>