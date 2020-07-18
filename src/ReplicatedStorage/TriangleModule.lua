local TriangleModule = {
    --[[
    Vector3 A, B, and C
    DataModel Parent 
    [optional] Vector3 center
    ]]	
        DrawTriangle = function(a, b, c, parent, width)
            local width = width and width or 0.2
            local wedge = Instance.new("WedgePart") -- Make the wedge we'll need later
            wedge.Anchored = true
            wedge.TopSurface = Enum.SurfaceType.Smooth
            wedge.BottomSurface = Enum.SurfaceType.Smooth
            wedge.Material = "SmoothPlastic"
            --wedge.Color = Color3.new(0, 110/255, 255/255)
            wedge.Transparency = 0
            wedge.CanCollide = true
            local edges = {
                {longest = (c - b), other = (a - b), position = b},
                {longest = (a - c), other = (b - c), position = c},
                {longest = (b - a), other = (c - a), position = a},
            }
            table.sort(edges, function(a, b) return a.longest.magnitude > b.longest.magnitude end)
            local edge = edges[1]
            -- get angle between two vectors
            local theta = math.acos(edge.longest.unit:Dot(edge.other.unit)) -- angle between two vectors
            -- SOHCAHTOA
            local s1 = Vector2.new(edge.other.magnitude * math.cos(theta), edge.other.magnitude * math.sin(theta))
            local s2 = Vector2.new(edge.longest.magnitude - s1.x, s1.y)
            -- positions
            local p1 = edge.position + edge.other * 0.5 -- wedge1's position
            local p2 = edge.position + edge.longest + (edge.other - edge.longest) * 0.5 -- wedge2's position
            -- rotation matrix facing directions
            local right = edge.longest:Cross(edge.other).unit
            local up = right:Cross(edge.longest).unit
            local back = edge.longest.unit
            -- put together the cframes
            local cf1 = CFrame.new( -- wedge1 cframe
                p1.x + (-right.x * (width/2)), p1.y + (-right.y * (width/2)), p1.z + (-right.z * (width/2)),
                -right.x, up.x, back.x,
                -right.y, up.y, back.y,
                -right.z, up.z, back.z
            )
            local cf2 = CFrame.new( -- wedge2 cframe
                p2.x + (right.x * (-width/2)), p2.y + (right.y * (-width/2)), p2.z + (right.z * (-width/2)),
                right.x, up.x, -back.x,
                right.y, up.y, -back.y,
                right.z, up.z, -back.z
            )
            --]]
            --[[
            local cf1 = CFrame.new( -- wedge1 cframe
            p1.x, p1.y, p1.z,
            -right.x, up.x, back.x,
            -right.y, up.y, back.y,
            -right.z, up.z, back.z
            )
            local cf2 = CFrame.new( -- wedge2 cframe
                p2.x, p2.y, p2.z,
                right.x, up.x, -back.x,
                right.y, up.y, -back.y,
                right.z, up.z, -back.z
            )
            --]]
            -- cf1 = cf1 + cf1.RightVector * (width/2)
            -- cf2 = cf2 + cf2.RightVector * (-width/2)
            -- put it all together by creating the wedges
            local model = Instance.new("Model")
            model.Parent = parent
            model.Name = "Triangle"
            local w1 = wedge:Clone()
            w1.Name = "Wedge1"
            local w2 = wedge:Clone()
            w2.Name = "Wedge2"
            w1.Size = Vector3.new(width, s1.y, s1.x)
            w2.Size = Vector3.new(width, s2.y, s2.x)
            w1.CFrame = cf1
            w2.CFrame = cf2
            w1.Parent = model
            w2.Parent = model
            
            return model
        end,
        
    --[[
    Vector3 A, B, and C
    Model Triangle 
    ]]	
        UpdateTriangle = function(a, b, c, triangle)
            local edges = {
                {longest = (c - b), other = (a - b), position = b},
                {longest = (a - c), other = (b - c), position = c},
                {longest = (b - a), other = (c - a), position = a},
            }
            table.sort(edges, function(a, b) return a.longest.magnitude > b.longest.magnitude end)
            local edge = edges[1]
            -- get angle between two vectors
            local theta = math.acos(edge.longest.unit:Dot(edge.other.unit)) -- angle between two vectors
            -- SOHCAHTOA
            local s1 = Vector2.new(edge.other.magnitude * math.cos(theta), edge.other.magnitude * math.sin(theta))
            local s2 = Vector2.new(edge.longest.magnitude - s1.x, s1.y)
            -- positions
            local p1 = edge.position + edge.other * 0.5 -- wedge1's position
            local p2 = edge.position + edge.longest + (edge.other - edge.longest) * 0.5 -- wedge2's position
            -- rotation matrix facing directions
            local right = edge.longest:Cross(edge.other).unit
            local up = right:Cross(edge.longest).unit
            local back = edge.longest.unit
            -- put together the cframes
            local cf1 = CFrame.new( -- wedge1 cframe
                p1.x, p1.y, p1.z,
                -right.x, up.x, back.x,
                -right.y, up.y, back.y,
                -right.z, up.z, back.z
            )
            local cf2 = CFrame.new( -- wedge2 cframe
                p2.x, p2.y, p2.z,
                right.x, up.x, -back.x,
                right.y, up.y, -back.y,
                right.z, up.z, -back.z
            )
            -- put it all together by creating the wedges
            local w1 = triangle:FindFirstChild("Wedge1")
            local w2 = triangle:FindFirstChild("Wedge2")
            w1.Size = Vector3.new(0.2, s1.y, s1.x)
            w2.Size = Vector3.new(0.2, s2.y, s2.x)
            w1.CFrame = cf1
            w2.CFrame = cf2
        end
        
    }
    
    return TriangleModule