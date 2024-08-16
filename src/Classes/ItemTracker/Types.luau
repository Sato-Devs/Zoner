--=======================================================================================================>
--!strict
--=======================================================================================================>

-- Grab the ZonerModule Reference:
local ZonerModule = script.Parent.Parent.Parent

-- Require the Types:
local TrackedItemTypes = require(ZonerModule.Types.TrackedItemTypes);

--=======================================================================================================>

-- Create and Export Type:
export type TrackableItem = TrackedItemTypes.TrackableItem

--=======================================================================================================>
-- Create the Object Types:


-- Create and Export Object Type:
export type ItemTracker         = TrackedItemTypes.ItemTracker
-- Create and Export MetaData Type:
export type ItemTrackerMetaData = TrackedItemTypes.ItemTrackerMetaData
-- Create and Export Module Type:
export type ItemTrackerModule   = TrackedItemTypes.ItemTrackerModule

--=======================================================================================================>

-- Clear from memory:
TrackedItemTypes = nil :: any

--=======================================================================================================>

-- Return an empty table:
return table.freeze({})

--=======================================================================================================>