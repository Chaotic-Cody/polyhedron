--[[
Helper functions
--]]
-- fine the first element common to 3 sets by brute force
function intersect(set1, set2, set3)
    for _, s1 in pairs(set1) do
        for _, s2 in pairs(set2) do
            if (s1 == s2) then
                for _, s3 in pairs(set3) do
                    if (s1 == s3) then
                        return s1;
                    end
                end
            end
        end
    end
    return nil;
end

// find first element common to 3 sets by brute force search
const intersect = function(set1, set2, set3) {
  for (let s1 of set1) {
    for (let s2 of set2) {
      if (s1 === s2) {
        for (let s3 of set3) {
          if (s1 === s3) {
            return s1;
          }
        }
      }
    }
  }
  return null; // empty intersection
};

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
        v1 = f[#f]; -- previous vertex
        for _, v2 in pairs(f) do
            -- THIS ASSUMES that no 2 faces that share an edge share it in the same orientation!
            -- which of course never happens for proper manifold meshes, so get your meshes right.
            face[v1]["v"..tostring(v2)] = tostring(i);
            v1 = v2;
        end
    end -- current becomes previous
   
    local centers = poly:Centers();
    for i = 1, #poly.Faces.length do
        f = poly.Faces[i];
        v1 = f[#f]; -- pervious vertex
        for _, v2 in pairs(f) do
            flag.newFlag(v1, face[v]["v"..tostring(v1)], tostring(i));
            v1 = v2;
        end
    end -- current becomes previous

    local dpoly = flag:topoly(); -- build topological dual from flags

    -- match F index ordering to V index ordering on dual
    local sortF = {};
    for _, f in pairs(dpoly.Faces) do
        local k = intersect(poly.Faces[f[1]], poly.Faces[f[2]], poly.Faces[f[3]]);
        sortF[k] = f;
    end

    dpoly.Faces = sortF;

    if (string.sub(poly.Name, 1, 1) ~= "d") then
        dpoly.Name = "d"..poly.Name;
    else
        dpoly.Name = string.sub(dpoly.Name, 2)
    end

    return dpoly;

end

return Polyops;