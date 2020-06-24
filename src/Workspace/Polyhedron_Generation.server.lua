--[[
Topology stored as set of faces.  Each face is list of n vertex indices
corresponding to one oriented, n-sided face.  Vertices listed clockwise as seen from outside.
this.faces = [ [vidx1, vidx2, vidx3] ]
--]]
local Icosahedron = require(game:GetService("ReplicatedStorage"):WaitForChild("icosahedron"));
local Polyops = require(game:GetService("ReplicatedStorage"):WaitForChild("polyops"));

local planet = Icosahedron();
print(unpack(planet:Normals()));
--planet:Scale(5);
planet:Scale(1.075269);
--planet:Draw();
for i, v in pairs(planet:Centers()) do
    print(v.magnitude);
end
--[[ Testing kis
local newPlanet = Polyops.kis(planet);
newPlanet.Position = newPlanet.Position + Vector3.new(0, 5, 0);
newPlanet:Scale(2);
newPlanet:Draw();
--]]

--[[ Testing dual
local newPlanet = Polyops.dual(planet);
newPlanet.Position = newPlanet.Position + Vector3.new(0, 5, 0);
newPlanet:Scale(2);
newPlanet:Draw();
--]]

-- Testing truncate
local newPlanet = Polyops.truncate(planet);
newPlanet.Position = newPlanet.Position + Vector3.new(0, 5, 0);
newPlanet:Scale(4);
newPlanet:Draw();
--]]
