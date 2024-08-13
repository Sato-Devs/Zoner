--=======================================================================================================>
--!strict
--=======================================================================================================>
-- Other Type Imports:

-- Grab the ZonerModule Reference:
local ZonerModule = script.Parent.Parent.Parent

-- Require the Types:
local PlayerHandlerTypes = require(ZonerModule.Types.PlayerHandlerTypes);

--=======================================================================================================>
-- Create the Object Types:


-- Create and Export Object Type:
export type PlayerHandler         = PlayerHandlerTypes.PlayerHandler
-- Create and Export MetaData Type:
export type PlayerHandlerMetaData = PlayerHandlerTypes.PlayerHandlerMetaData
-- Create and Export Module Type:
export type PlayerHandlerModule   = PlayerHandlerTypes.PlayerHandlerModule

--=======================================================================================================>

-- Return an empty table:
return table.freeze({})

--=======================================================================================================>