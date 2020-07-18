--[[
Topology stored as set of faces.  Each face is list of n vertex indices
corresponding to one oriented, n-sided face.  Vertices listed clockwise as seen from outside.
this.faces = [ [vidx1, vidx2, vidx3] ]
--]]
local Polyhedron = require(game:GetService("ReplicatedStorage"):WaitForChild("polyhedron"))

function icosahedron()
    local faces = {
        {1, 2, 3}, {1, 3, 4}, {1, 4, 5}, {1, 5, 6},
        {1, 6, 2}, {2, 6, 8}, {2, 8, 7}, {2, 7, 3},
        {3, 7, 9}, {3, 9, 4}, {4, 9, 10}, {4, 10, 5},
        {5, 10, 11}, {5, 11, 6}, {6, 11, 8}, {7, 8, 12},
        {7, 12, 9}, {8, 11, 12}, {9, 12, 10}, {10, 12, 11},
    }
    local vertices = {
        Vector3.new(0,0,1.176), Vector3.new(1.051,0,0.526),
        Vector3.new(0.324,1.0,0.525), Vector3.new(-0.851,0.618,0.526),
        Vector3.new(-0.851,-0.618,0.526), Vector3.new(0.325,-1.0,0.526),
        Vector3.new(0.851,0.618,-0.526), Vector3.new(0.851,-0.618,-0.526),
        Vector3.new(-0.325,1.0,-0.526), Vector3.new(-1.051,0,-0.526),
        Vector3.new(-0.325,-1.0,-0.526), Vector3.new(0,0,-1.176),
    }
    local name = "I"
    local poly = Polyhedron.new(faces, vertices, name)
    poly:Scale(1.075269) -- make all vertices approx 1 unit away from center so scaling in the future is predictable
    return poly
end

return icosahedron