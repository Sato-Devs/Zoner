--=======================================================================================================>
--!strict
--=======================================================================================================>

-- Grab the ZonerModule Reference:
local ZonerModule = script:FindFirstAncestor('ZonerModule')

-- Require the Types:
local TrackedItemTypes = require(ZonerModule.Types.TrackedItemTypes);

--=======================================================================================================>

-- Create and Export Type:
export type TrackableItem = TrackedItemTypes.TrackableItem

--=======================================================================================================>
-- Create the Object Types:


-- Create and Export Object Type:
export type TrackedItem         = TrackedItemTypes.TrackedItem
-- Create and Export MetaData Type:
export type TrackedItemMetaData = TrackedItemTypes.TrackedItemMetaData
-- Create and Export Module Type:
export type TrackedItemModule   = TrackedItemTypes.TrackedItemModule

--=======================================================================================================>

-- Clear from memory:
TrackedItemTypes = nil :: any

--=======================================================================================================>

-- Return an empty table:
return table.freeze({})

--=======================================================================================================>