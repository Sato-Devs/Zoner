--=======================================================================================================>
--!strict
--=======================================================================================================>

-- Grab the ZonerModule Reference:
local ZonerModule = script:FindFirstAncestor('ZonerModule')

-- Import the Types:
local ZoneTypes = require(ZonerModule.Types.ZoneTypes);

--=======================================================================================================>

-- Create and Export Object Type:
export type ZoneMetaData = ZoneTypes.ZoneMetaData
export type ZoneModule   = ZoneTypes.ZoneModule
export type Zone         = ZoneTypes.Zone

-- Create and Export Object Type:
export type ZoneCoreMetaData = ZoneTypes.ZoneCoreMetaData
export type ZoneCoreModule   = ZoneTypes.ZoneCoreModule
export type ZoneCore         = ZoneTypes.ZoneCore

-- Create and Export Type:
export type ZoneContainer    = ZoneTypes.ZoneContainer
export type ZonerFolder      = ZoneTypes.ZonerFolder

--=======================================================================================================>

-- Return an empty table:
return table.freeze({})

--=======================================================================================================>