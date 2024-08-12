--=======================================================================================================>
--!strict
--=======================================================================================================>

-- Grab the ZonerModule Reference:
local ZonerModule = script:FindFirstAncestor('ZonerModule')

-- Require the Types:
local WorldModelTypes = require(ZonerModule.Types.WorldModelTypes);

--=======================================================================================================>

-- Create and Export Module Type:
export type WorldModelModule = WorldModelTypes.WorldModelModule

-- Create and Export Module Type:
export type ZonerFolder = WorldModelTypes.ZonerFolder

--=======================================================================================================>

-- Return an empty table:
return table.freeze({})

--=======================================================================================================>