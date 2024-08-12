--=======================================================================================================>
-- Important note: Precision checks currently only for 'players' and the 'localplayer', not 'parts'.

-- EnumName, EnumValue, AdditionalProperty
return {
	--======================================================================>
	
	--[[
		[Accuracy]:
			?
		[Performance]:
			?
		[Tag]:
			?
		[Desc]:
			Will determine based on the type of Item what balance of accuracy and performance to use:
	]]
	--{"Automatic", 1}, 

	--[[
		[Accuracy]:
			Fine
		[Performance]:
			Fine Performance
		[Tag]:
			Checks if BoundingBox is FULLY inside the Zone:
		[Desc]:
			A singular check will be performed on the Model or Part's BoundingBox
			Least accurate, but most performant:
	]]
	--{"BoundingBox", 2}, 

	--[[
		[Accuracy]:
			Good
		[Performance]:
			Fine Performance
		[Tag]:
			Checks if ALL Part POSITIONS are FULLY inside the Zone:
		[Desc]:
			Will check every Part in the Model if each Position is fully inside the Zone.
	]]
	--{"WholeItemPoint", 3}, 

	--[[
		[Accuracy]:
			Least
		[Performance]:
			Best Performance
		[Tag]:
			Checks if Center POSITION is inside the Zone:
		[Desc]:
			A singular check will be performed on the Model or Part's Position
			Least accurate, but most performant:
	]]
	--{"CenterItemPoint", 4}, 

	--[[
		[Accuracy]:
			Best
		[Performance]:
			Heavy Performance
		[Tag]:
			Checks if ALL Parts are FULLY inside the Zone:
		[Desc]:
			A lot of checks will be done, especially if on a Model. 
			Every Part in a model that is able, will have each of its corners checked to 
			determine if every single part is fully inside the zone.
			More accuracy on whether the Center Part is fully inside the Zone, whilst still being performant:
	]]
	--{"WholeItemPart", 5}, 

	--[[
		[Accuracy]:
			Good
		[Performance]:
			Good Performance
		[Tag]:
			Checks if CENTER Part is FULLY inside the Zone:
		[Desc]:
			Multiple checks will be done on each corner of the Model's PrimaryPart or Part
			More accuracy on whether the Center Part is fully inside the Zone, whilst still being performant:
	]]
	
	
	{"Automatic",       1}, 
	
	{"ItemCenterFull",  2}, 
	{"ItemCenterTouch", 3}, 
	{"ItemCenterPoint", 4}, 

	{"ItemAllFull",     5}, 
	{"ItemAllTouch",    6}, 
	{"ItemAllPoint",    7}, 
	
	{"ItemAnyFull",     8}, 
	{"ItemAnyTouch",    9}, 
	{"ItemAnyPoint",    10}, 

	{"ItemBoxFull",     11}, 
	{"ItemBoxTouch",    12}, 

	--======================================================================>
}

--=======================================================================================================>