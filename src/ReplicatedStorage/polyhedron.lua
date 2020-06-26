--[[
	function positionHex(Vector3 from, Vector3 to)
	returns CFrame
	returns a CFrame matrix with orientation looking from -> to with YVector (rather than lookVector)
]]
function positionHex(from, to, vertex)
	local fVec = (to - from).unit;
	local randVec = Vector3.new(0, 1, 0);

	local upVec = (vertex - from).unit;
	local rightVec = upVec:Cross(fVec);
	--local upVec = rightVec:Cross(fVec);

	--return CFrame.fromMatrix(from, rightVec, upVec);
	--[[
	return CFrame.new(
		from.X, from.Y, from.Z, -- from
		rightVec.X, upVec.X, -fVec.X, -- right
		rightVec.Y, upVec.Y, -fVec.Y, -- up
		rightVec.Z, upVec.Z, -fVec.Z -- forward
	);
	--]]
	return CFrame.new(
		from.X, from.Y, from.Z, -- from
		rightVec.X, fVec.X, -upVec.X, -- right
		rightVec.Y, fVec.Y, -upVec.Y, -- up
		rightVec.Z, fVec.Z, -upVec.Z -- forward
	);
end

--[[
	function positionPent(Vector3 from, Vector3 to)
	returns CFrame
	returns a CFrame matrix with orientation looking from -> to with YVector (rather than lookVector)
]]
function positionPent(from, to, vertex)
	local fVec = (to - from).unit;
	--local randVec = Vector3.new(0, 1, 0);
	--local randVec = (vertex - from).unit;

	--local rightVec = fVec:Cross(randVec);
	local rightVec = (vertex - from).unit;
	local upVec = rightVec:Cross(fVec);

	--[[
	local fVec2 = (vertex - from).unit;
	local randVec = Vector3.new(0, 1, 0);

	local 
	--]]

	--return CFrame.fromMatrix(from, rightVec, upVec);
	--[[
	return CFrame.new(
		from.X, from.Y, from.Z, -- from
		rightVec.X, upVec.X, -fVec.X, -- right
		rightVec.Y, upVec.Y, -fVec.Y, -- up
		rightVec.Z, upVec.Z, -fVec.Z -- forward
	);
	--]]
	return CFrame.new(
		from.X, from.Y, from.Z, -- from
		rightVec.X, fVec.X, upVec.X, -- right
		rightVec.Y, fVec.Y, upVec.Y, -- up
		rightVec.Z, fVec.Z, upVec.Z -- forward
	);
end

--[[
Polyhedron class

vertices = {Vector3.new(), ..}
faces = { {1, 2, 3} }

edges = { Vector3.new() }
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local vmath = require(ReplicatedStorage:WaitForChild("vmath"));
local hexagon = ReplicatedStorage:WaitForChild("Hexagon");
local pentagon = ReplicatedStorage:WaitForChild("Pentagon");

Polyhedron = {};
Polyhedron.__index = Polyhedron;

function Polyhedron.new(faces, vertices, name, position)
	
	local newPolyhedron = {};
	setmetatable(newPolyhedron, Polyhedron);
	
	newPolyhedron.Faces = faces and faces or {};
	newPolyhedron.Vertices = vertices and vertices or {};
	newPolyhedron.Name = name and name or "";
	newPolyhedron.Position = position and position or Vector3.new(0, 0, 0);
  
  	return newPolyhedron;
	
end

-- Get array of face centers
function Polyhedron:Centers()
	local centersArray = {};
	for i, face in pairs(self.Faces) do
		local fcenter = Vector3.new(0, 0, 0);
		-- average vertex coords
		for j, vidx in pairs(face) do
			fcenter = fcenter + self.Vertices[vidx];
		end
		centersArray[#centersArray+1] = fcenter*(1/#face);
	end
	return centersArray;
end

function Polyhedron:Normals()

	local normalsArray = {};
	for i, face in pairs(self.Faces) do
		local threeFaceVectors = {};
		for j, vidx in pairs(face) do
			threeFaceVectors[#threeFaceVectors+1] = self.Vertices[vidx];
		end
		normalsArray[#normalsArray+1] = vmath.normal(threeFaceVectors);
	end
  	return normalsArray;
end

function Polyhedron:Scale(scaleFactor)
	for i, vert in pairs(self.Vertices) do
		self.Vertices[i] = self.Vertices[i] * scaleFactor;
	end
end

--[[
	naive implementation
	rewrite to keep track of model locally as a property of Polyhedron class
	and reuse parts instead of deleting/reinstancing
--]]
function Polyhedron:Draw()
	local planetModel = Instance.new("Model");
	planetModel.Parent = workspace;
	planetModel.Name = "Planet";
	local hexModel = Instance.new("Model");
	hexModel.Parent = planetModel;
	hexModel.Name = "Hexes";
	local pentModel = Instance.new("Model");
	pentModel.Parent = planetModel;
	pentModel.Name = "Pents";

	local planetCenter = Instance.new("Part");
	planetCenter.CanCollide = false;
	planetCenter.Anchored = true;
	planetCenter.Name = "PolygonCenter";
	planetCenter.Size = Vector3.new(0.2, 0.2, 0.2);
	planetCenter.BrickColor = BrickColor.new("Really red");
	planetCenter.CFrame = CFrame.new(self.Position);
	planetCenter.Parent = planetModel;

	local centers = self:Centers();

	for i, face in pairs(self.Faces) do
		if #face == 5 then
			
		elseif #face == 6 then
			
		end
	end
	--[[
	for i, center in pairs(centers) do
		local tile = Instance.new("Part");
		tile.CanCollide = false;
		tile.Anchored = true;
		tile.Name = "PolygonCenter";
		tile.Size = Vector3.new(0.2, 0.2, 0.2);
		tile.BrickColor = BrickColor.new("Really red");
		tile.CFrame = CFrame.new(center + self.Position);
		tile.Parent = planetModel;
	end
	  
	for i, vertex in pairs(self.Vertices) do
		local vert = Instance.new("Part");
		vert.CanCollide = false;
		vert.Anchored = true;
		vert.Name = "PolygonVertex";
		vert.Size = Vector3.new(0.2, 0.2, 0.2);
		vert.BrickColor = BrickColor.new("Lime green");
		vert.CFrame = CFrame.new(vertex + self.Position);
		vert.Parent = planetModel;
	end
	--]]
	print("Faces: ", #self.Faces);
	print("Vertices: ", #self.Vertices);

end

return Polyhedron;

