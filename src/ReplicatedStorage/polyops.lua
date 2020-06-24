local Polyflag = require(game:GetService("ReplicatedStorage"):WaitForChild("polyflag"));
Polyops = {};
-- Conway's polyhedron operations
--[[
Kis(N)

Kis (abbreviated from triakis) transforms an N-sided face into an N-pyramid rooted at the
same base vertices.
only kis n-sided faces, but n==0 means kis all.
--]]
function Polyops.kis(poly, apexdist)
    local i = 1;
    local n = 0;
    local apexdist = apexdist and apexdist or 0.1;

    local flag = Polyflag.new();

    print("taking kis of ", poly.Name);

    for i = 1, #poly.Vertices do
        local p = poly.Vertices[i];
        flag:newV("v"..tostring(i), p);
    end

    local normals = poly:Normals();
    local centers = poly:Centers();
    for i = 1, #poly.Faces do
        local f = poly.Faces[i];
        local v1 = "v"..tostring(f[#f]);
        for _, v in pairs(f) do
            local v2 = "v"..tostring(v);
            if (#f == n or n == 0) then -- in case we want Kis(n) functionality later down the line
                local apex = "apex"..tostring(i);
                local fname = tostring(i)..tostring(v1);
                -- new vertices in centers of face
                flag:newV(apex, normals[i]*apexdist+centers[i]);
                flag:newFlag(fname, v1, v2); -- old edge of original face
                flag:newFlag(fname, v2, apex); -- up to apex of pyramid
                flag:newFlag(fname, apex, v1); -- back down from apex
            else
                flag:newFlag(tostring(i), v1, v2); -- same flag if non-n
            end
            -- current becomes previous
            v1 = v2;
        end
    end

    local newpoly = flag:topoly();
    newpoly.Name = "k"..(n==0 and "" or tostring(n))..poly.Name;

    return newpoly;
end

--[[
Dual

The dual of a polyhedron is another mesh wherein:
    - every face in the original becomes a vertex in the dual
    - every vertex in the original becomes a face in the dual

So N_faces, N_vertices = N_dualfaces, N_dualvertices

The new vertex coordinates are convenient to set to the original face centroids.
--]]
function Polyops.dual(poly)
    local f, i, v1, v2;

    local flag = Polyflag.new();

    local face = {}; -- make table of face as function of edge
    for i = 1, #poly.Vertices do
        face[i] = {};
    end -- create empty associative table

    for i = 1, #poly.Faces do
        f = poly.Faces[i];
        
    end
   
end

return Polyops;