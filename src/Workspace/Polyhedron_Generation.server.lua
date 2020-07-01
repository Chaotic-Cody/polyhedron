--[[
Topology stored as set of faces.  Each face is list of n vertex indices
corresponding to one oriented, n-sided face.  Vertices listed clockwise as seen from outside.
this.faces = [ [vidx1, vidx2, vidx3] ]
--]]
local Icosahedron = require(game:GetService("ReplicatedStorage"):WaitForChild("icosahedron"));
local Polyops = require(game:GetService("ReplicatedStorage"):WaitForChild("polyops"));

-- Testing icosahedron seed
local planet = Icosahedron();
planet.Position = planet.Position + Vector3.new(0, 100, 0);
--planet:Scale(5);
--planet:Draw();
--]]
--[[ Testing structural integrity (distance of points from center)
for i, v in ipairs(planet:Centers()) do
    print(v.magnitude);
end
--]]

--[[ Testing kis
local newPlanet = Polyops.kis(planet);
newPlanet:Scale(8);
newPlanet:Draw();
--]]

--[[ Testing dual
local newPlanet = Polyops.dual(planet);
newPlanet:Scale(8);
newPlanet:Draw();
--]]

--[[ Testing truncate
local newPlanet = Polyops.truncate(planet);
newPlanet:Scale(25);
newPlanet:Draw();
--]]

-- Testing nested truncate
local level = 3;
local newPlanet = Polyops.truncate(planet);
for i = 1, level-1 do
    newPlanet = Polyops.truncate(Polyops.dual(newPlanet));
end
newPlanet:Scale(100);
newPlanet:Draw();
--]]
--[[
local faces = newPlanet.Faces;
local centers = newPlanet:Centers();
for i, face in ipairs(faces) do
    print("new face");
    for j, index in ipairs(face) do
        print((centers[i] - newPlanet.Vertices[index]).magnitude);
    end
end
--]]
