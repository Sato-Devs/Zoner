--=======================================================================================================>
--!strict
--=======================================================================================================>

-- Create and Export Type:
export type ZonerFolder = Folder & {
	Ids: Configuration; 
	Zones: Folder & {[string]: any};
	WorldModel: WorldModel?
}

-- Create and Export Module Type:
export type WorldModelModule = {
	--===========================================>
	SetupWorldModel: 
		(self: WorldModelModule, ZonerFolder: ZonerFolder) -> WorldModel,
	--===========================================>
	_GetCombinedResults: 
		(self: WorldModelModule, MethodName: string, ...any) -> {Instance},
	--===========================================>
	GetPartsInPart: 
		(self: WorldModelModule, Part: BasePart, OverlapParam: OverlapParams) -> {Instance},
	GetPartBoundsInBox: 
		(self: WorldModelModule, CFrame: CFrame, Size: Vector3, OverlapParam: OverlapParams) -> {Instance},
	GetPartBoundsInRadius: 
		(self: WorldModelModule, Position: Vector3, Radius: number, OverlapParam: OverlapParams) -> {Instance},
	--===========================================>

	
	Values: {WorldModel: WorldModel};
	
	--===========================================>

	__index: WorldModelModule,

	--===========================================>
}

--=======================================================================================================>

-- Return an empty table:
return table.freeze({})

--=======================================================================================================>