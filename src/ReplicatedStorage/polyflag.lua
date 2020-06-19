--[[ 
Polyflag class

Polyhedron Flagset Construct

A Flag is an associative triple of a face index and two adjacent vertex vertidxs,
listed in geometric clockwise order (staring into the normal)

Face_i -> V_i -> V_j

They are a useful abstraction for defining topological transformations of the polyhedral mesh, as
one can refer to vertices and faces that don't yet exist or haven't been traversed yet in the
transformation code.

A flag is similar in concept to a directed halfedge in halfedge data structures.

--]]

local Polyhedron = require(game:GetService("ReplicatedStorage"):WaitForChild("polyhedron"));

local Polyflag = {};
Polyflag.__index = Polyflag;

function Polyflag.new()

    local newPolyflag = {}
    setmetatable(newPolyflag, Polyflag);

    newPolyflag.Flags = {}; -- Flags[face][vertex] = next vertex of flag; symbolic triples
    newPolyflag.Vertidxs = {}; -- [symbolic names] holds vertex index
    newPolyflag.Vertices = {}; -- Vector3 coordinates

end
--[[
    Polyflag.newV(string vertName, Vector3 coordinates)
    returns void
--]]
function Polyflag.newV(vertName, coordinates)
    if (not self.Vertidxs[vertName]) then
        self.Vertidxs[vertName] = 0;
        self.Vertices[vertName] = coordinates;
    end
end
--[[
    Polyflag.newFlag(string faceName, string vertName1, string vertName2)
    returns void
--]]
function Polyflag.newFlag(faceName, vertName1, vertName2)
    self.Flags[faceName][vertName1] = vertName2
end
--[[
    Polyflag.topoly()
    returns new Polyhedron
    stub
--]]
function Polyflag.topoly()
    local i, v;
    local poly = Polyhedron.new();

    local ctr = 0; -- first number the vertices, and store them in an array
    for i, _ in pairs(self.Vertidxs) do
        v = self.Vertidxs[i];
        poly.Vertices[ctr] = self.Vertices[i];
        self.Vertidxs[i] = ctr;
        ctr = ctr + 1;
    end

    ctr = 0;
    for i, _ in pairs(self.Flags) do
        local v0;
        local face = self.Flags[i];
        poly.Faces[ctr] = {}; -- new face
        -- grab any vertex as starting point
        for j, _ in pairs(face) do
            v0 = face[j];
            break;
        end
        -- build face out of all the edge relations in the flag association table
        v = v0; -- v moves around the face
        table.insert(poly.Faces[ctr], self.Vertidxs[v]); -- record index
        v = self.Flags[i][v]; -- go to next vertex
        local faceCTR = 0;
        while (v ~= v0) do
            table.insert(poly.Faces[ctr], self.Vertidxs[v]);
            v = self.Flags[i][v];
            faceCTR = faceCTR + 1;
        end
        ctr = ctr + 1;
    end
    poly.Name = "Unknown Polyhedron";
    return poly; 
end

return Polyflag;