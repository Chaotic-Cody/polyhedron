local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

function PlacePoint()
	local point = Instance.new("Part")
	point.Name = "Point"
	point.Anchored = true
	point.Size = Vector3.new(0.2,0.2,0.2)
	point.BrickColor = BrickColor.new("Really red")
	point.CFrame = mouse.hit
	point.Parent = workspace
end

function GetNormal()
	print(mouse.Target)
	print(mouse.TargetSurface)

end

mouse.Button1Down:connect(PlacePoint)