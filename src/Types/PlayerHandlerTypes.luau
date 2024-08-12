--=======================================================================================================>
--!strict
--=======================================================================================================>
-- Other Type Imports:

-- Grab the ZonerModule Reference:
local ZonerModule = script:FindFirstAncestor('ZonerModule')

-- Index and Require the Module From the Shared Folder:
local TroveModule  = require(ZonerModule.Utility.Trove)

--=======================================================================================================>
-- Other Type Import Defines:

type Dictionary = {[string]: any}
type Trove      = TroveModule.Trove

--=======================================================================================================>
-- Create the Object Types:


-- Create and Export Object Type:
export type PlayerHandler = typeof(
	setmetatable({} :: PlayerHandlerMetaData, {} :: PlayerHandlerModule)
)

-- Create and Export MetaData Type:
export type PlayerHandlerMetaData = {

	--===========================================>	
	-- Core:

	_BaseTrove: Trove,
	_EventTrove: Trove,

	_Players: {[Player]: {Trove: Trove; Destroy: ()->()}};

	_CharacterList: {[string]: Model};
	_PlayerList:    {[string]: Player};
	
	_Tagged: boolean?;
	
	Tags: {
		Player          : 'Player';
		ClientCharacter : 'Client:Character';
		ServerCharacter : 'Server:Character';
		LocalCharacter  : 'Client:LocalCharacter';
	};
	
	--===========================================>
	-- Meta Index Variables:
	-- Some External references to internal variable:

	_RunScope: ('Server' | 'Client'),

	--===========================================>

}

-- Create and Export Module Type:
export type PlayerHandlerModule = {

	--===========================================>

	New: 
		(Tagged: boolean?) -> PlayerHandler,
	Destroy: 
		(self: PlayerHandler) -> (),
	_Initialize: 
		(self: PlayerHandler) -> (),

	_SetObjects: 
		(self: PlayerHandler) -> (),
	_SetEvents: 
		(self: PlayerHandler) -> (),

	_AddPlayer: 
		(self: PlayerHandler, Player: Player) -> (),
	_RemovePlayer: 
		(self: PlayerHandler, Player: Player) -> (),

	_AddCharacter: 
		(self: PlayerHandler, Player: Player, Character: Model?) -> (),
	_RemoveCharacter: 
		(self: PlayerHandler, Player: Player, Character: Model) -> (),

	--===========================================>
	
	GetPlayers: 
		(self: PlayerHandler) -> {[string]: Player},
	GetCharacters: 
		(self: PlayerHandler) -> {[string]: Model},

	--===========================================>

	__index: PlayerHandlerModule,

	--===========================================>

}

--=======================================================================================================>

-- Return an empty table:
return table.freeze({})

--=======================================================================================================>