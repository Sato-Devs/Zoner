--===========================================================================================================================>
--!optimize 2
--!native
--!strict
--===========================================================================================================================>

-- Define Module table
local RegionsModule: RegionsModule = {}
RegionsModule.__index = RegionsModule

--===========================================================================================================================>
--[ GLOBAL VARIABLES: ]


local MAX_PART_SIZE = 2024

--===========================================================================================================================>
--[ DEFINE TYPES: ]


-- Insert the Object Types:
export type RegionsModule = typeof(RegionsModule)

--===========================================================================================================================>
--[ FUNCTIONS: ]


-- Function to create Parts to a certain size and scale and parented to the Model Container:
function RegionsModule.CreateCube(self: RegionsModule, Container: Model, CubeCFrame: CFrame, CubeSize: Vector3)
	--=======================================================================================================>
	if CubeSize.X > MAX_PART_SIZE or CubeSize.Y > MAX_PART_SIZE or CubeSize.Z > MAX_PART_SIZE then
		local quarterSize = CubeSize * 0.25
		local halfSize = CubeSize * 0.5
		self:CreateCube(Container, CubeCFrame * CFrame.new(-quarterSize.X, -quarterSize.Y, -quarterSize.Z), halfSize)
		self:CreateCube(Container, CubeCFrame * CFrame.new(-quarterSize.X, -quarterSize.Y, quarterSize.Z), halfSize)
		self:CreateCube(Container, CubeCFrame * CFrame.new(-quarterSize.X, quarterSize.Y, -quarterSize.Z), halfSize)
		self:CreateCube(Container, CubeCFrame * CFrame.new(-quarterSize.X, quarterSize.Y, quarterSize.Z), halfSize)
		self:CreateCube(Container, CubeCFrame * CFrame.new(quarterSize.X, -quarterSize.Y, -quarterSize.Z), halfSize)
		self:CreateCube(Container, CubeCFrame * CFrame.new(quarterSize.X, -quarterSize.Y, quarterSize.Z), halfSize)
		self:CreateCube(Container, CubeCFrame * CFrame.new(quarterSize.X, quarterSize.Y, -quarterSize.Z), halfSize)
		self:CreateCube(Container, CubeCFrame * CFrame.new(quarterSize.X, quarterSize.Y, quarterSize.Z), halfSize)
	else
		local Part = Instance.new("Part")
		Part.CFrame = CubeCFrame
		Part.Size = CubeSize
		Part.Anchored = true
		Part.Parent = Container
	end
	--=======================================================================================================>
end

-- Optimized function to get the corners of a BasePart
function RegionsModule.GetCorners(self: RegionsModule, CFrame1: CFrame, Size2: Vector3, Half: boolean?): {Vector3}
	--=======================================================================================================>
	-- Create an empty array for corner vectors
	local Corners = {}

	-- If the part is a simple box (Part) or a MeshPart with no mesh ID
	if Half == true then
		-- Only calculate the 4 necessary corners

		-- Top-Left Front
		table.insert(Corners, CFrame1 * Vector3.new(-Size2.X, Size2.Y, Size2.Z))
		-- Bottom-Right Front
		table.insert(Corners, CFrame1 * Vector3.new(Size2.X, -Size2.Y, Size2.Z))
		-- Top-Left Back
		table.insert(Corners, CFrame1 * Vector3.new(-Size2.X, Size2.Y, -Size2.Z))
		-- Bottom-Right Back
		table.insert(Corners, CFrame1 * Vector3.new(Size2.X, -Size2.Y, -Size2.Z))
	else
		-- Calculate all 8 corners for more complex parts
		table.insert(Corners, (CFrame1 * Vector3.new(Size2.X, Size2.Y, Size2.Z)))
		table.insert(Corners, (CFrame1 * Vector3.new(-Size2.X, Size2.Y, Size2.Z)))
		table.insert(Corners, (CFrame1 * Vector3.new(Size2.X, -Size2.Y, Size2.Z)))
		table.insert(Corners, (CFrame1 * Vector3.new(Size2.X, Size2.Y, -Size2.Z)))
		table.insert(Corners, (CFrame1 * Vector3.new(-Size2.X, -Size2.Y, Size2.Z)))
		table.insert(Corners, (CFrame1 * Vector3.new(Size2.X, -Size2.Y, -Size2.Z)))
		table.insert(Corners, (CFrame1 * Vector3.new(-Size2.X, Size2.Y, -Size2.Z)))
		table.insert(Corners, (CFrame1 * Vector3.new(-Size2.X, -Size2.Y, -Size2.Z)))
	end

	-- Return the corners array
	return Corners
	--=======================================================================================================>
end

-- Optimized function to get the corners of a BasePart
function RegionsModule.GetCornersFromPart(self: RegionsModule, Part: BasePart): {Vector3}
	--=======================================================================================================>
	-- Get the CFrame of the part
	local CFrame1 = Part.CFrame
	-- Get the size of the part, divided by half
	local Size = Part.Size * 0.5

	-- If the part is a simple box (Part) or a MeshPart with no mesh ID
	if (Part:IsA('Part') and Part.Shape == Enum.PartType.Block) or (Part:IsA('MeshPart') and Part.MeshId == "") then
		return self:GetCorners(CFrame1, Size, true)
	else
		return self:GetCorners(CFrame1, Size, false)
	end

	--=======================================================================================================>
end

--===========================================================================================================================>

-- Function to return the Bounding Box Min and Max from CFrame and Size:
function RegionsModule.GetBoundingBox(self: RegionsModule, CFrame1: CFrame, Size1: Vector3): (Vector3, Vector3)
	--=======================================================================================================>
	local Min = CFrame1.Position - (Size1 * 0.5)
	local Max = CFrame1.Position + (Size1 * 0.5)
	return Min, Max
	--=======================================================================================================>
end

-- Function to check if a Vector3 is inside a Region3
function RegionsModule.IsPointInsideRegion(self: RegionsModule, Point: Vector3, Region: Region3): boolean
	--=======================================================================================================>
	local Min = Region.CFrame.Position - (Region.Size * 0.5)
	local Max = Region.CFrame.Position + (Region.Size * 0.5)

	return Point.X >= Min.X and Point.X <= Max.X and
		Point.Y >= Min.Y and Point.Y <= Max.Y and
		Point.Z >= Min.Z and Point.Z <= Max.Z
	--=======================================================================================================>
end

-- Function to check if a Vector3 is inside a Region3
function RegionsModule.IsPointInsideBoundBox(self: RegionsModule, Point: Vector3, BoundMin: Vector3, BoundMax: Vector3): boolean
	--=======================================================================================================>
	return Point.X >= BoundMin.X and Point.X <= BoundMax.X and
		Point.Y >= BoundMin.Y and Point.Y <= BoundMax.Y and
		Point.Z >= BoundMin.Z and Point.Z <= BoundMax.Z
	--=======================================================================================================>
end

-- Check if the BasePart is fully inside the Region3
function RegionsModule.IsPartFullyInsideBoundBox(self: RegionsModule, Part: BasePart, BoundMin: Vector3, BoundMax: Vector3): boolean
	--=======================================================================================================>

	local Corners: {Vector3} = self:GetCornersFromPart(Part)

	for Index: number, Corner: Vector3 in ipairs(Corners) do
		if not self:IsPointInsideBoundBox(Corner, BoundMin, BoundMax) then return false end
	end

	--=======================================================================================================>

	-- Return True:
	return true

	--=======================================================================================================>
end

-- Check if the BasePart has at least  inside the Region3
function RegionsModule.IsPartTouchingBoundBox(self: RegionsModule, Part: BasePart, BoundMin: Vector3, BoundMax: Vector3): boolean
	--=======================================================================================================>
	-- Grab the Corners of the Part:
	local Corners: {Vector3} = self:GetCornersFromPart(Part)
	-- Loop through the Corners, checking each Corner Vector3 and seeing if its within the BoundBox.
	-- If just one Corner is in the BoundBox, then its touching, so return true:
	for Index: number, Corner: Vector3 in ipairs(Corners) do
		if self:IsPointInsideBoundBox(Corner, BoundMin, BoundMax) then return true end
	end
	-- Return False:
	return false
	--=======================================================================================================>
end

-- Check if the BasePart is fully inside the Region3
function RegionsModule.IsPartFullyInsideRegion(self: RegionsModule, Part: BasePart, Region: Region3): boolean
	--=======================================================================================================>
	-- Grab the Corners of the Part:
	local Corners: {Vector3} = self:GetCornersFromPart(Part)
	-- Loop through the Corners, checking each Corner Vector3 and seeing if its within the Region.
	for Index: number, Corner: Vector3 in ipairs(Corners) do
		if not self:IsPointInsideRegion(Corner, Region) then return false end
	end
	-- Return True:
	return true
	--=======================================================================================================>
end

-- Function to check if a Model is fully inside a Region3
function RegionsModule.IsModelFullyInsideRegion(self: RegionsModule, Model: Model, Region: Region3): boolean
	--=======================================================================================================>

	-- Get Descendants of Model:
	local ModelDescendants: {Instance} = Model:GetDescendants()

	-- Loop through the Descendants of the Model:
	for Index: number, Part: Instance in ipairs(ModelDescendants) do
		--=============================================================================>
		-- If Part is not a BasePart continue:
		if not Part:IsA("BasePart") then continue end
		--=============================================================================>
		-- Check if Part is FullyInsideRegion, if it isnt, return false:
		if not self:IsPartFullyInsideRegion(Part, Region) then ModelDescendants = nil :: any return false end
		--=============================================================================>
	end

	-- Clear from memory:
	ModelDescendants = nil :: any

	--=======================================================================================================>

	-- Return True:
	return true

	--=======================================================================================================>
end

-- Function to check if a Vector3 is inside a BasePart
function RegionsModule.IsPointInsidePart(self: RegionsModule, Point: Vector3, Part: BasePart): boolean
	--=======================================================================================================>
	local CFrame1 = Part.CFrame
	local Size   = Part.Size * 0.5

	local Min = CFrame1.Position - Size
	local Max = CFrame1.Position + Size

	return Point.X >= Min.X and Point.X <= Max.X and
		Point.Y >= Min.Y and Point.Y <= Max.Y and
		Point.Z >= Min.Z and Point.Z <= Max.Z
	--=======================================================================================================>
end

-- Check if the BasePart1 is fully inside BasePart2
function RegionsModule.IsPartFullyInsidePart(self: RegionsModule, Part1: BasePart, Part2: BasePart): boolean
	--=======================================================================================================>

	local Corners: {Vector3} = self:GetCornersFromPart(Part1)

	for Index: number, Corner: Vector3 in ipairs(Corners) do
		if not self:IsPointInsidePart(Corner, Part2) then return false end
	end

	return true

	--=======================================================================================================>
end

-- Check if the BasePart is fully inside the Region3
function RegionsModule.IsBoundBoxFullyInsideBoundBox(self: RegionsModule, BoundMin1: Vector3, BoundMax1: Vector3, BoundMin2: Vector3, BoundMax2: Vector3): boolean
	--=======================================================================================================>
	-- Loop through the two Corners of the First BoundBox to check if each Corner Is inside the Second BoundBox:
	for Index: number, Corner: Vector3 in ipairs({BoundMin1, BoundMax1}) do
		if not self:IsPointInsideBoundBox(Corner, BoundMin2, BoundMax2) then return false end
	end
	-- Return True:
	return true
	--=======================================================================================================>
end


-- Check if the Array of Corners denoting a Box is fully inside the Corners of Box 2:
function RegionsModule.IsBox1CornersFullyInsideBox2Corners(self: RegionsModule, Box1Corners: {Vector3}, Box2Corners: {Vector3}): boolean
	--=======================================================================================================>
	-- Loop through the two Corners of the First BoundBox to check if each Corner Is inside the Second BoundBox:
	for Index: number, Corner: Vector3 in ipairs(Box1Corners) do
		
	end
	-- Return True:
	return true
	--=======================================================================================================>
end


-- Check if the BasePart is fully inside the Region3
function RegionsModule.IsBoundBoxTouchingBoundBox(self: RegionsModule, BoundMin1: Vector3, BoundMax1: Vector3, BoundMin2: Vector3, BoundMax2: Vector3): boolean
	--=======================================================================================================>
	-- Loop through the two Corners of the First BoundBox to check if each Corner Is inside the Second BoundBox:
	for Index: number, Corner: Vector3 in ipairs({BoundMin1, BoundMax1}) do
		if not self:IsPointInsideBoundBox(Corner, BoundMin2, BoundMax2) then return true end
	end
	-- Return False:
	return false
	--=======================================================================================================>
end


--===========================================================================================================================>

-- Get the Center Position Of the Array of Parts:
function RegionsModule.GetCenterPointOfParts(self: RegionsModule, Parts: {[BasePart]: boolean}): Vector3
	--=======================================================================================================>

	local TotalPosition = Vector3.new(0, 0, 0)
	local PartCount = 0

	for Part, State in pairs(Parts) do
		TotalPosition += Part.Position
		PartCount += 1
	end

	if PartCount > 0 then
		return TotalPosition / PartCount
	else
		return Vector3.new(0, 0, 0)
	end
	
	--=======================================================================================================>
end

-- Get the Center Part Of the Array of Parts:
function RegionsModule.GetCenterPartOfParts(self: RegionsModule, Parts: {[BasePart]: boolean}): BasePart
	--=======================================================================================================>

	local CenterPoint = self:GetCenterPointOfParts(Parts)
	local ClosestDistance = math.huge
	local ClosestPart = nil

	for Part, State in pairs(Parts) do
		local Distance = (Part.Position - CenterPoint).Magnitude
		if Distance < ClosestDistance then
			ClosestDistance = Distance
			ClosestPart = Part
		end
	end

	return ClosestPart

	--=======================================================================================================>
end

--===========================================================================================================================>

-- Return a Frozen Module Table:
return table.freeze(RegionsModule) :: RegionsModule

--===========================================================================================================================>