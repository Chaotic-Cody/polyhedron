--[[
Polyhedron class

vertices = {Vector3.new(), ..}
faces = { {1, 2, 3} }

edges = { Vector3.new() }
--]]

local PolygonNames = {
	"Triangle",
	"Square",
	"Pentagon",
	"Hexagon",
	"Heptagon",
	"Octagon",
	"Nonagon",
	"Decagon"
}

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local vmath = require(ReplicatedStorage:WaitForChild("vmath"));
local trilib = require(ReplicatedStorage:WaitForChild("TriangleModule"));

Polyhedron = {};
Polyhedron.__index = Polyhedron;

function Polyhedron.new(faces, vertices, name, position)
	
	local newPolyhedron = {};
	setmetatable(newPolyhedron, Polyhedron);
	
	newPolyhedron.Faces = faces and faces or {};
	newPolyhedron.Vertices = vertices and vertices or {};
	newPolyhedron.Name = name and name or "";
	newPolyhedron.Position = position and position or Vector3.new(0, 0, 0);
	-- newPolyhedron.Radius = radius; -- stub

	-- Part metadata
	-- add private member for physical model
  
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

--[[
	scaleFactor is a reprentation of the distance from a vertex to the center of the polyhedron
--]]
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

		local polyModel = Instance.new("Model");
		polyModel.Name = PolygonNames[#face-2];
		
		if #face == 5 then
			polyModel.Parent = pentModel;
		elseif #face == 6 then
			polyModel.Parent = hexModel;
		else
			polyModel.Parent = planetModel;
		end

		for j = 2, #face-1 do
			local v1 = self.Vertices[face[1]] + self.Position;
			local v2 = self.Vertices[face[j]] + self.Position;
			local v3 = self.Vertices[face[j+1]] + self.Position;
			trilib.DrawTriangle(v1, v2, v3, polyModel, 0.2);
		end

	end
	print("Faces: ", #self.Faces);
	print("Vertices: ", #self.Vertices);

end

return Polyhedron;

