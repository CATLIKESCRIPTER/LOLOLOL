local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local Event = game:GetService("ReplicatedStorage"):WaitForChild("IncreaseSpeed")

local auto = false


-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "ModernWinControl"
Gui.ResetOnSpawn = false
Gui.Parent = game:GetService("CoreGui")


local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,460,0,340)
Main.Position = UDim2.new(0.5,-230,0.5,-170)
Main.BackgroundColor3 = Color3.fromRGB(15,15,22)
Main.Active = true
Main.Parent = Gui


local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,20)
Corner.Parent = Main


local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(90,110,220)
Stroke.Thickness = 2
Stroke.Parent = Main



-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-70,0,50)
Title.Position = UDim2.new(0,20,0,5)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Win Control Panel"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.new(1,1,1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main



-- Close button
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,38,0,38)
Close.Position = UDim2.new(1,-50,0,12)
Close.Text = "×"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 28
Close.BackgroundColor3 = Color3.fromRGB(220,60,70)
Close.TextColor3 = Color3.new(1,1,1)
Close.Parent = Main

Instance.new("UICorner",Close)


Close.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)



-- Tabs
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1,-40,0,40)
Tabs.Position = UDim2.new(0,20,0,60)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Main


local function MakeTab(text,x)

	local b = Instance.new("TextButton")
	b.Size = UDim2.new(.5,-5,1,0)
	b.Position = UDim2.new(x,0,0,0)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 15
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,50)
	b.Parent = Tabs

	Instance.new("UICorner",b)

	return b
end


local TeleTab = MakeTab("🏆 Teleports",0)
local AutoTab = MakeTab("⚡ Auto",0.5)



-- Pages
local function NewPage()

	local p = Instance.new("Frame")
	p.Size = UDim2.new(1,-40,1,-120)
	p.Position = UDim2.new(0,20,0,110)
	p.BackgroundTransparency = 1
	p.Parent = Main

	return p

end


local TelePage = NewPage()
local AutoPage = NewPage()

AutoPage.Visible = false



-- Button creator
local function CreateButton(parent,text,y)

	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,35)
	b.Position = UDim2.new(0,0,0,y)
	b.Text = text
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 15
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,50)
	b.Parent = parent


	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0,10)
	c.Parent = b


	b.MouseEnter:Connect(function()
		TweenService:Create(
			b,
			TweenInfo.new(.2),
			{
				BackgroundColor3 =
				Color3.fromRGB(70,100,220)
			}
		):Play()
	end)


	b.MouseLeave:Connect(function()
		TweenService:Create(
			b,
			TweenInfo.new(.2),
			{
				BackgroundColor3 =
				Color3.fromRGB(35,35,50)
			}
		):Play()
	end)


	return b
end



-- Teleport locations
local Spots = {

	{"🏆 1 Win #1",452,0,10770},
	{"🏆 1 Win #2",451,0,8488},
	{"🏆 1 Win #3",579,414,11767},
	{"🏆 1 Win #4",579,0,8948},

	{"🏁 Race Finish",-1535,0,391},

	{"🏆 350 Wins",13755,0,-18505},

}



for i,v in ipairs(Spots) do

	local button = CreateButton(
		TelePage,
		v[1],
		(i-1)*40
	)


	button.MouseButton1Click:Connect(function()

		local char = player.Character

		if char and char:FindFirstChild("HumanoidRootPart") then

			char.HumanoidRootPart.CFrame =
			CFrame.new(v[2],v[3],v[4])

		end

	end)

end



-- Auto clicker tab
local AutoButton = CreateButton(
	AutoPage,
	"Auto Clicker: OFF",
	40
)


AutoButton.MouseButton1Click:Connect(function()

	auto = not auto

	if auto then
		AutoButton.Text = "Auto Clicker: ON 🟢"
	else
		AutoButton.Text = "Auto Clicker: OFF 🔴"
	end

end)



task.spawn(function()

	while Gui.Parent do

		if auto then
			Event:FireServer()
		end

		task.wait(0.1)

	end

end)



-- Tabs
TeleTab.MouseButton1Click:Connect(function()
	TelePage.Visible = true
	AutoPage.Visible = false
end)


AutoTab.MouseButton1Click:Connect(function()
	TelePage.Visible = false
	AutoPage.Visible = true
end)



-- Dragging
local dragging = false
local dragStart
local startPos


Title.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then

		dragging = true
		dragStart = input.Position
		startPos = Main.Position

	end

end)


UserInputService.InputChanged:Connect(function(input)

	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

		local delta = input.Position - dragStart

		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)

	end

end)


UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end

end)
