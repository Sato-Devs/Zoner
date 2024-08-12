--=======================================================================================================>
--!strict
--=======================================================================================================>


export type Accuracies = 
	| 'Automatic' | 'VoxelBoxRegion' | 'VoxelBoxRaycast' 
	| 'ExactBoxRegion' | 'ExactBoxRaycast' | 'PerPartRegion' 
	| 'PerPartInsidePart' | 'PerPartRaycast'
	
-- Create and Export Object Type:
type Accuracy_Enum = typeof(
	setmetatable({} :: Accuracy_EnumMetaData, {} :: Accuracy_Enum2Table)
)

-- Create and Export MetaData Type:
type Accuracy_EnumMetaData = {
	--===========================================>
	Name: string;

	--===========================================>
	Properties: {};
	Values: {
		['1']: number;
		['2']: number;
		['3']: number;
		['4']: number;
		['5']: number;
		['6']: number;
		['7']: number;
		['8']: number;
	};
	Names: {
		['Automatic']:        number;
		['VoxelRegion']:      number;
		['VoxelShape']:       number;
		['ExactRegion']:      number;
		['ExactShape']:       number;
		['PerPartRegion']:    number;
		['PerPartCollision']: number;
		['PerPartShape']:     number;
	};

	--===========================================>
	Automatic:        number;
	VoxelRegion:      number;
	VoxelShape:       number;
	ExactRegion:      number;
	ExactShape:       number;
	PerPartRegion:    number;
	PerPartCollision: number;
	PerPartShape:     number;
	--===========================================>
}

-- Create and Export Module Type:
type Accuracy_Enum2Table = {
	--===========================================>
	GetName: 
		(self: Accuracy_Enum, ValueOrProperty: any) -> Accuracies,
	GetValue: 
		(self: Accuracy_Enum, NameOrProperty: any) -> number,
	GetProperty: 
		(self: Accuracy_Enum, NameOrValue: any) -> number?,

	--===========================================>

	__index: Accuracy_Enum2Table,

	--===========================================>
}

--=======================================================================================================>

export type Rates = 
	| 'Slow' | 'Moderate' | 'Fast' | 'Immediate' 

-- Create and Export Object Type:
type Rate_Enum = typeof(
	setmetatable({} :: Rate_EnumMetaData, {} :: Rate_Enum2Table)
)

-- Create and Export MetaData Type:
type Rate_EnumMetaData = {
	--===========================================>
	Name: string;

	--===========================================>
	Properties: {
		['0']:   number;
		['0.1']: number;
		['0.5']: number;
		['1']:   number;
	};
	Values: {
		['1']: number;
		['2']: number;
		['3']: number;
		['4']: number;
	};
	Names: {
		['Slow']:      number;
		['Moderate']:  number;
		['Fast']:      number;
		['Immediate']: number;
	};
	--===========================================>
	Slow:      number;
	Moderate:  number;
	Fast:      number;
	Immediate: number;
	--===========================================>
}

-- Create and Export Module Type:
type Rate_Enum2Table = {
	--===========================================>
	GetName: 
		(self: Rate_Enum, ValueOrProperty: any) -> Rates,
	GetValue: 
		(self: Rate_Enum, NameOrProperty: any) -> any,
	GetProperty: 
		(self: Rate_Enum, NameOrValue: any) -> number?,

	--===========================================>

	__index: Rate_Enum2Table,

	--===========================================>
}

--=======================================================================================================>

export type Simulations = 
	| 'PreRender' | 'PostSimulation' | 'PreSimulation'

-- Create and Export Object Type:
type Simulation_Enum = typeof(
	setmetatable({} :: Simulation_EnumMetaData, {} :: Simulation_Enum2Table)
)

-- Create and Export MetaData Type:
type Simulation_EnumMetaData = {
	--===========================================>
	Name: string;
	--===========================================>
	Values: {
		['1']: number;
		['2']: number;
		['3']: number;
	};
	Names: {
		['PreRender']:      number;
		['PostSimulation']: number;
		['PreSimulation']:  number;
	};
	--===========================================>
	PreRender:      number;
	PostSimulation: number;
	PreSimulation:  number;
	--===========================================>
}

-- Create and Export Module Type:
type Simulation_Enum2Table = {

	--===========================================>
	GetName: 
		(self: Simulation_Enum, ValueOrProperty: any) -> Simulations,
	GetValue: 
		(self: Simulation_Enum, NameOrProperty: any) -> any,
	GetProperty: 
		(self: Simulation_Enum, NameOrValue: any) -> string?,

	--===========================================>

	__index: Simulation_Enum2Table,

	--===========================================>
}

--=======================================================================================================>

export type Detections = 
	| 'Automatic' 
	| 'ItemCenterFull' | 'ItemCenterTouch' | 'ItemCenterPoint' 
	| 'ItemAllFull'    | 'ItemAllTouch'    | 'ItemAllPoint' 
	| 'ItemAnyFull'    | 'ItemAnyTouch'    | 'ItemAnyPoint' 
	| 'ItemBoxFull'    | 'ItemBoxTouch'    | 'ItemAnyPoint' 


-- Create and Export Object Type:
type Detection_Enum = typeof(
	setmetatable({} :: Detection_EnumMetaData, {} :: Detection_Enum2Table)
)

-- Create and Export MetaData Type:
type Detection_EnumMetaData = {
	--===========================================>
	Name: string;
	--===========================================>
	Values: {
		['1']: number;
		['2']: number;
		['3']: number;
		['4']: number;
		['5']: number;
		['6']: number;
		['7']: number;
		['8']: number;
		['9']: number;
		['10']: number;
		['11']: number;
		['12']: number;
	};
	Names: {
		['Automatic']: number;
		['ItemCenterFull']:  number;
		['ItemCenterTouch']: number;
		['ItemCenterPoint']: number;
		['ItemAllFull']:  number;
		['ItemAllTouch']: number;
		['ItemAllPoint']: number;
		['ItemAnyFull']:  number;
		['ItemAnyTouch']: number;
		['ItemAnyPoint']: number;
		['ItemBoxFull' ]: number;
		['ItemBoxTouch']: number;
		['ItemAnyPoint']: number;
	};
	--===========================================>
	['Automatic']: number;
	['ItemCenterFull']:  number;
	['ItemCenterTouch']: number;
	['ItemCenterPoint']: number;
	['ItemAllFull']:  number;
	['ItemAllTouch']: number;
	['ItemAllPoint']: number;
	['ItemAnyFull']:  number;
	['ItemAnyTouch']: number;
	['ItemAnyPoint']: number;
	['ItemBoxFull' ]: number;
	['ItemBoxTouch']: number;
	['ItemAnyPoint']: number;
	--===========================================>
};

-- Create and Export Module Type:
type Detection_Enum2Table = {

	--===========================================>
	GetName: 
		(self: Detection_Enum, ValueOrProperty: any) -> Detections,
	GetValue: 
		(self: Detection_Enum, NameOrProperty: any) -> any,
	GetProperty: 
		(self: Detection_Enum, NameOrValue: any) -> string?,

	--===========================================>

	__index: Detection_Enum2Table,

	--===========================================>
}

--=======================================================================================================>

-- Create and Export Type:
export type Enums = {
	['Accuracy']:   Accuracy_Enum;
	['Detection']:  Detection_Enum;
	['Simulation']: Simulation_Enum;
	['Rate']:       Rate_Enum;
};

-- Create and Export Type:
export type EnumDetails = {{string|number}}

--=======================================================================================================>
-- Create the Object Types:


-- Create and Export Object Type:
export type Enum2 = typeof(
	setmetatable({} :: Enum2MetaData, {} :: Enum2Table)
)

-- Create and Export MetaData Type:
export type Enum2MetaData = {
	--===========================================>
	Name: string;
	--===========================================>
	_Type: 'Enum2';
	--===========================================>
	Properties: {[string]: number};
	Values:     {[string]: number};
	Names:      {[string]: number};
	--===========================================>
	Enums: {{Name: string, Value: number | string, Property: string?}};
	--===========================================>
}

-- Create and Export Module Type:
export type Enum2Table = {
	--===========================================>
	
	New: 
		(EnumName: string, Details: EnumDetails) -> Enum2,
	Destroy: 
		(self: Enum2) -> (),

	--===========================================>
	GetName: 
		(self: Enum2, ValueOrProperty: any) -> string,
	GetValue: 
		(self: Enum2, NameOrProperty: any) -> any,
	GetProperty: 
		(self: Enum2, NameOrValue: any) -> string?,

	--===========================================>

	__index: Enum2Table,

	--===========================================>
}

--=======================================================================================================>

-- Create and Export Module Type:
export type EnumsModule = {
	--===========================================>

	GetEnums: 
		(self: EnumsModule) -> Enums,
	CreateEnum: 
		(self: EnumsModule, EnumName: string, Details: EnumDetails) -> (),
	Start: 
		(self: EnumsModule) -> (),

	--===========================================>

	Enums:   Enums;
	Started: boolean;
	
	--===========================================>

	__index: EnumsModule,

	--===========================================>
}

--=======================================================================================================>

-- Return an empty table:
return table.freeze({})

--=======================================================================================================>