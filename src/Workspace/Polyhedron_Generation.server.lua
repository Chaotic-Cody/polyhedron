--[[
Topology stored as set of faces.  Each face is list of n vertex indices
corresponding to one oriented, n-sided face.  Vertices listed clockwise as seen from outside.
this.faces = [ [vidx1, vidx2, vidx3] ]
--]]
local icosahedron = require(game:GetService("ReplicatedStorage"):WaitForChild("icosahedron"));

local planet = icosahedron();
print(unpack(planet:Normals()));
--planet:Scale(5);
planet:Scale(1.075269);
planet:Draw();
for i, v in pairs(planet:Centers()) do
    print(v.magnitude);
end