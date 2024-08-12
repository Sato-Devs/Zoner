--===========================================================================================================================>
--!strict
--===========================================================================================================================>

-- Define Module table
local PlayerHandlerModule = {}

--===========================================================================================================================>
--[ SERVICES: ]


local CollectionService   = game:GetService('CollectionService')
local RunService          = game:GetService('RunService')
local Players             = game:GetService('Players')

--===========================================================================================================================>
--[ MAIN MODULES: ]


-- Index and Require the Module From the Shared Folder:
local Trove = require(script.Parent.Parent.Utility.Trove)

--===========================================================================================================================>
--[ DEFINE TYPES: ]


-- This will inject all types into this context.
local TypeDefinitions = require(script.TypeDefinitions)

-- Insert the Object Types:
type PlayerHandlerMetaData = TypeDefinitions.PlayerHandlerMetaData
type PlayerHandlerModule   = TypeDefinitions.PlayerHandlerModule
type PlayerHandler         = TypeDefinitions.PlayerHandler

--===========================================================================================================================>

-- Function which when called will setup a new Character Object on the Server
function PlayerHandlerModule.New(Tagged: boolean?): PlayerHandler
	--=======================================================================================================>

	-- Set a Memory Category for this Zoner:
	debug.setmemorycategory('Zoner: PlayerHandler')

	--=======================================================================================================>
	
	-- Initialize Object values and tables:
	local PlayerHandlerData: PlayerHandlerMetaData = { 
		--===========================================>
		_BaseTrove = Trove.New();
		--===========================================>
		_RunScope = if RunService:IsServer() then 'Server' else 'Client';
		--===========================================>
		_Players = {};
		--===========================================>
		_PlayerList    = {};
		_CharacterList = {};
		--===========================================>
		Tags = {
			Player          = `PH:Player`;
			ClientCharacter = `PH:Client:Character`;
			ServerCharacter = `PH:Server:Character`;
			LocalCharacter  = `PH:Client:LocalCharacter`;
		};
		--===========================================>
		_Tagged = Tagged;
		--===========================================>
	} :: PlayerHandlerMetaData

	--=======================================================================================================>
	
	-- Extend the EventsTrove from the BaseTrove:
	PlayerHandlerData._EventTrove = PlayerHandlerData._BaseTrove:Extend()
	
	--=======================================================================================================>
	
	-- Only Run ONE version of this Module as non Tagged. IE using the Player.Added Events:
	-- And Make all other subsequent calls to this Module use the CollectionService Tagging:
	if Tagged == false or Tagged == nil and script:GetAttribute('CoreRun') ~= true then
		script:SetAttribute('CoreRun', true)
	else
		PlayerHandlerData._Tagged = true
	end

	--=======================================================================================================>
	
	-- Set the Object metatable:
	setmetatable(PlayerHandlerData, PlayerHandlerModule :: any)

	-- Initialize the Object:
	PlayerHandlerData:_Initialize()

	-- Return the Object:
	return PlayerHandlerData

	--=======================================================================================================>
end

-- Function which whell called will destroy all the local data for this Character Instance
function PlayerHandlerModule.Destroy(self: PlayerHandler)

	--=======================================================================================================>

	-- Clean with Trove
	if self._BaseTrove then self._BaseTrove:Destroy() self._BaseTrove = nil :: any end

	-- Clear all self data:
	for Index, Data in pairs(self) do self[Index] = nil end

	-- Set the Metatable to nil
	setmetatable(self :: any, nil)	

	--=======================================================================================================>

end

--===========================================================================================================================>

-- Initialization function to start/setup the Object's initial data:
function PlayerHandlerModule._Initialize(self: PlayerHandler)
	for Index: number, Function: string in ipairs({'_SetObjects', '_SetEvents'}) do self[Function](self) end
end

-- Function to Set up initial Player Object Data:
function PlayerHandlerModule._SetObjects(self: PlayerHandler)
	--=======================================================================================================>

	-- Get all the Current Players in Game:
	-- If Tagged is true, then get the players from the Player Tag, else get the Players from the Players Service:
	local PlayersGot: {Player} = if self._Tagged then
		Players:GetPlayers(CollectionService:GetTagged(self.Tags.Player)) else Players:GetPlayers()

	-- Loop through all the Current In Game Players and Add them to the Data Object:
	for Index: number, Player: Player in ipairs(PlayersGot) do self:_AddPlayer(Player) end

	-- Clear from Memory
	PlayersGot = nil :: any

	--=======================================================================================================>
end

-- Function to Set up Initial Events:
function PlayerHandlerModule._SetEvents(self: PlayerHandler)
	--=======================================================================================================>

	if self._Tagged then 
		--==========================================================================================>

		-- Connect to the Instance Added Event:
		self._EventTrove:Connect(CollectionService:GetInstanceAddedSignal(self.Tags.Player), function(Player: Player)
			--==================================================================================>
			self:_AddPlayer(Player)
			--==================================================================================>
		end)

		-- Connect to the Instance Removing Event:
		self._EventTrove:Connect(CollectionService:GetInstanceRemovedSignal(self.Tags.Player), function(Player: Player)
			--==================================================================================>
			self:_RemovePlayer(Player)
			--==================================================================================>
		end)

		-- Connect to the Instance Added Event:
		self._EventTrove:Connect(CollectionService:GetInstanceAddedSignal(self.Tags.ServerCharacter), function(Character: Model)
			--==================================================================================>
			self:_AddCharacter(self._PlayerList[Character.Name], Character)
			--==================================================================================>
		end)

		-- Connect to the Instance Removing Event:
		self._EventTrove:Connect(CollectionService:GetInstanceRemovedSignal(self.Tags.ServerCharacter), function(Character: Model)
			--==================================================================================>
			self:_RemoveCharacter(self._PlayerList[Character.Name], Character)
			--==================================================================================>
		end)

		--==========================================================================================>
	else
		--==========================================================================================>
		-- Connect to the PlayerAdded Event:
		self._EventTrove:Connect(Players.PlayerAdded, function(Player: Player)
			--==================================================================================>
			self:_AddPlayer(Player)
			--==================================================================================>
		end)

		-- Connect to the PlayerRemoving Event:
		self._EventTrove:Connect(Players.PlayerRemoving, function(Player: Player)
			--==================================================================================>
			self:_RemovePlayer(Player)
			--==================================================================================>
		end)
		--==========================================================================================>
	end

	--=======================================================================================================>
end

--===========================================================================================================================>

-- Method to Add a Player to the Data Object:
function PlayerHandlerModule._AddPlayer(self: PlayerHandler, Player: Player)
	--=======================================================================================================>

	-- If the Player is already Added to the Players Table, then return:
	if self._Players[Player] then return end

	--=======================================================================================================>

	if not self._Tagged then 
		--==============================================================================================>
		-- Create a Player Object Table:
		self._Players[Player] = {
			Trove = Trove.New();
			Destroy = function()
				self._Players[Player].Trove:Destroy()
			end,
		}
		
		-- Connect to the Player Character Added Event to Add Tags to the Character:
		self._Players[Player].Trove:Connect(Player.CharacterAdded, function(Character: Model)
			self:_AddCharacter(Player, Character)
		end)

		-- Connect to the Player Character Removing Event to Remove Tags from the Character:
		self._Players[Player].Trove:Connect(Player.CharacterRemoving, function(Character: Model)
			self:_RemoveCharacter(Player, Character)
		end)
		
		--==============================================================================================>
		
		-- Add the Player Object Table to the BaseTrove:
		self._BaseTrove:Add(self._Players[Player])

		-- Add the Tag to the Player:
		if self._RunScope == 'Server' then Player:AddTag(self.Tags.Player) end
		
		--==============================================================================================>
	end
	
	--=======================================================================================================>
	
	-- Call the AddCharacter Method incase the Player already has a Character:
	self:_AddCharacter(Player, Player.Character)

	-- Insert the Player into the PlayerList
	self._PlayerList[Player.Name] = Player

	--=======================================================================================================>
end

-- Method to Remove a Player from the Data Object:
function PlayerHandlerModule._RemovePlayer(self: PlayerHandler, Player: Player)
	--=======================================================================================================>

	-- If the Player does not have a Player Object in the table, return:
	if not self._Players[Player] then return end

	--=======================================================================================================>

	if not self._Tagged then 
		--==============================================================================================>
		-- Remove the Tag from the Player:
		if self._RunScope == 'Server' then Player:RemoveTag(self.Tags.Player) end

		-- Destroy the Player Object and Remove it from the BaseTrove:
		self._BaseTrove:Remove(self._Players[Player])

		-- Remove the Reference to the Player in the Table:
		self._Players[Player] = nil
		--==============================================================================================>
	end

	--=======================================================================================================>
	
	-- Remove the Player from the PlayerList
	self._PlayerList[Player.Name] = nil

	--=======================================================================================================>
end

--===========================================================================================================================>

-- Method to Add a tag to the Player's Character:
function PlayerHandlerModule._AddCharacter(self: PlayerHandler, Player: Player, Character: Model?)
	--=======================================================================================================>

	-- If the Character passed is nil then return:
	if Character == nil then return end

	if not self._Tagged then 

		if self._RunScope == 'Client' then
			if Player == Players.LocalPlayer then 
				Character:AddTag(self.Tags.LocalCharacter) 
			else 
				Character:AddTag(self.Tags.ClientCharacter)
			end
		else
			Character:AddTag(self.Tags.ServerCharacter)
		end

	end

	-- Insert the Character into the CharacterList:
	self._CharacterList[Player.Name] = Character

	--=======================================================================================================>
end

-- Method to Remove a tag from the Player's Character:
function PlayerHandlerModule._RemoveCharacter(self: PlayerHandler, Player: Player, Character: Model)
	--=======================================================================================================>

	-- If the Character passed is nil then return:
	if Character == nil then return end

	if not self._Tagged then 

		if self._RunScope == 'Client' then
			if Player == Players.LocalPlayer then 
				Character:RemoveTag(self.Tags.LocalCharacter) 
			else 
				Character:RemoveTag(self.Tags.ClientCharacter)
			end
		else
			Character:RemoveTag(self.Tags.ServerCharacter)
		end

	end
	
	-- Remove the Character from the CharacterList
	self._CharacterList[Character.Name] = nil

	--=======================================================================================================>
end

--===========================================================================================================================>

-- Method to get the PlayersList:
function PlayerHandlerModule.GetPlayers(self: PlayerHandler): {[string]: Player}
	return self._PlayerList
end

-- Method to get the CharacterList:
function PlayerHandlerModule.GetCharacters(self: PlayerHandler): {[string]: Model}
	return self._CharacterList
end

--===========================================================================================================================>

-- Create the MetaIndex function:
function PlayerHandlerModule.__index(self: PlayerHandler, Index: string): any
	--=======================================================================================================>
	-- Specific Indexing:
	--=======================================================================================================>

	--=======================================================================================================>
	-- If Index is in the immediate Module tree, return that value:			
	if PlayerHandlerModule[Index] then return PlayerHandlerModule[Index] end
	--=======================================================================================================>
	-- Return False if all else fails!
	return false 
	--=======================================================================================================>
end

--===========================================================================================================================>

-- Return the Module Object:
return table.freeze(PlayerHandlerModule) :: PlayerHandlerModule

--===========================================================================================================================>