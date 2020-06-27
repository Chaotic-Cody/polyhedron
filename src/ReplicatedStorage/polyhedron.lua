--[[
Polyhedron class

vertices = {Vector3.new(), ..}
faces = { {1, 2, 3} }

edges = { Vector3.new() }
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local vmath = require(ReplicatedStorage:WaitForChild("vmath"));
local trilib = require(ReplicatedStorage:WaitForChild("TriangleModule"));

local hexagon = ReplicatedStorage:WaitForChild("Hexagon");
local pentagon = ReplicatedStorage:WaitForChild("Pentagon");

Polyhedron = {};
Polyhedron.__index = Polyhedron;

print("waitforchilds done");

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
	planetCenter.BrickColor = BrickColor.new("Lime green");
	planetCenter.CFrame = CFrame.new(self.Position);
	planetCenter.Parent = planetModel;

	local centers = self:Centers();

	for i, face in pairs(self.Faces) do
		if #face == 5 then

			local pentagon = Instance.new("Model");
			pentagon.Name = "Pentagon";
			pentagon.Parent = pentModel;

			local v1 = self.Vertices[face[1]] + self.Position;
			local v2 = self.Vertices[face[2]] + self.Position;
			local v3 = self.Vertices[face[3]] + self.Position;
			local v4 = self.Vertices[face[4]] + self.Position;
			local v5 = self.Vertices[face[5]] + self.Position;

			trilib.DrawTriangle(v1, v2, v3, pentagon);
			trilib.DrawTriangle(v1, v3, v4, pentagon);
			trilib.DrawTriangle(v1, v4, v5, pentagon);

		elseif #face == 6 then

			local hexagon = Instance.new("Model");
			hexagon.Name = "Hexagon";
			hexagon.Parent = hexModel;

			local v1 = self.Vertices[face[1]] + self.Position;
			local v2 = self.Vertices[face[2]] + self.Position;
			local v3 = self.Vertices[face[3]] + self.Position;
			local v4 = self.Vertices[face[4]] + self.Position;
			local v5 = self.Vertices[face[5]] + self.Position;
			local v6 = self.Vertices[face[6]] + self.Position;

			trilib.DrawTriangle(v1, v2, v3, hexagon);
			trilib.DrawTriangle(v1, v3, v4, hexagon);
			trilib.DrawTriangle(v1, v4, v6, hexagon);
			trilib.DrawTriangle(v4, v5, v6, hexagon);

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

