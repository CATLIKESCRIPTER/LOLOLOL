--// Modern Win Panel Part 1
--// UI + Tabs + Teleport System Setup

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local Event = game:GetService("ReplicatedStorage"):WaitForChild("IncreaseSpeed")

local auto = false


--// Screen GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "UltimateWinPanel"
Gui.ResetOnSpawn = false
Gui.Parent = game:GetService("CoreGui")


--// Main Window
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,520,0,400)
Main.Position = UDim2.new(0.5,-260,0.5,-200)
Main.BackgroundColor3 = Color3.fromRGB(18,18,26)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = Gui


local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,22)
MainCorner.Parent = Main


local Border = Instance.new("UIStroke")
Border.Color = Color3.fromRGB(90,120,255)
Border.Thickness = 2
Border.Parent = Main



--// Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-70,0,55)
Title.Position = UDim2.new(0,20,0,5)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Ultimate Win Panel"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main



--// Close Button
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,40,0,40)
Close.Position = UDim2.new(1,-55,0,12)
Close.Text = "×"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 30
Close.BackgroundColor3 = Color3.fromRGB(220,60,70)
Close.TextColor3 = Color3.new(1,1,1)
Close.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1,0)
CloseCorner.Parent = Close


Close.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)



--// Tabs
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1,-40,0,45)
TabFrame.Position = UDim2.new(0,20,0,65)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Main



local function CreateTab(text,pos)

	local button = Instance.new("TextButton")

	button.Size = UDim2.new(0.5,-5,1,0)
	button.Position = UDim2.new(pos,0,0,0)
	button.BackgroundColor3 = Color3.fromRGB(35,35,50)
	button.Text = text
	button.Font = Enum.Font.GothamBold
	button.TextSize = 16
	button.TextColor3 = Color3.new(1,1,1)
	button.Parent = TabFrame


	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,12)
	corner.Parent = button


	return button
end


local TeleTab = CreateTab("🏆 Teleports",0)
local AutoTab = CreateTab("⚡ Auto",0.5)



--// Pages
local function CreatePage()

	local page = Instance.new("Frame")
	page.Size = UDim2.new(1,-40,1,-130)
	page.Position = UDim2.new(0,20,0,120)
	page.BackgroundTransparency = 1
	page.Parent = Main

	return page
end


local TelePage = CreatePage()
local AutoPage = CreatePage()

AutoPage.Visible = false



--// Search Box
local Search = Instance.new("TextBox")
Search.Size = UDim2.new(1,0,0,35)
Search.BackgroundColor3 = Color3.fromRGB(30,30,42)
Search.PlaceholderText = "🔍 Search teleport..."
Search.Text = ""
Search.Font = Enum.Font.Gotham
Search.TextSize = 15
Search.TextColor3 = Color3.new(1,1,1)
Search.Parent = TelePage


local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0,10)
SearchCorner.Parent = Search



--// Scrolling List
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,0,1,-45)
Scroll.Position = UDim2.new(0,0,0,45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 5
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.Parent = TelePage


local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = Scroll
--// Modern Win Panel Part 2
--// Teleports + Auto + Dragging


-- Teleport locations
local Spots = {

	{"🏆 1 Win #1",452,0,10770},
	{"🏆 1 Win #2",451,0,8488},
	{"🏆 1 Win #3",579,414,11767},
	{"🏆 1 Win #4",579,0,8948},

	{"🏆 2 Wins #1",1475,0,10642},
	{"🏆 2 Wins #2",1582,0,9120},
	{"🏆 2 Wins #3",1495,0,10653},
	{"🏆 2 Wins #4",1598,0,10857},

	{"🏆 3 Wins #1",2619,0,11516},
	{"🏆 3 Wins #2",2498,408,10230},
	{"🏆 3 Wins #3",2625,18,11506},
	{"🏆 3 Wins #4",2624,15,9416},

	{"🏆 5 Wins #1",3634,21,10736},
	{"🏆 5 Wins #2",3532,7,11130},
	{"🏆 5 Wins #3",3649,372,8772},
	{"🏆 5 Wins #4",3525,14,9302},

	{"🏁 Race Finish",-1535,0,391},

	{"🏆 350 Wins",0,0,0},

}



local Buttons = {}


local function CreateTeleportButton(data)

	local button = Instance.new("TextButton")

	button.Size = UDim2.new(1,-10,0,38)
	button.BackgroundColor3 = Color3.fromRGB(35,35,50)
	button.Text = data[1]
	button.Font = Enum.Font.GothamMedium
	button.TextSize = 15
	button.TextColor3 = Color3.new(1,1,1)
	button.Parent = Scroll


	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,10)
	corner.Parent = button


	button.MouseEnter:Connect(function()

		TweenService:Create(
			button,
			TweenInfo.new(.15),
			{
				BackgroundColor3 =
				Color3.fromRGB(70,100,220)
			}
		):Play()

	end)


	button.MouseLeave:Connect(function()

		TweenService:Create(
			button,
			TweenInfo.new(.15),
			{
				BackgroundColor3 =
				Color3.fromRGB(35,35,50)
			}
		):Play()

	end)


	button.MouseButton1Click:Connect(function()

		local char = player.Character

		if char and char:FindFirstChild("HumanoidRootPart") then

			char.HumanoidRootPart.CFrame =
			CFrame.new(
				data[2],
				data[3],
				data[4]
			)

		end

	end)


	table.insert(Buttons,{
		Button = button,
		Name = string.lower(data[1])
	})

end



for _,spot in ipairs(Spots) do
	CreateTeleportButton(spot)
end



Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

	Scroll.CanvasSize =
	UDim2.new(
		0,
		0,
		0,
		Layout.AbsoluteContentSize.Y + 10
	)

end)



-- Search filter
Search:GetPropertyChangedSignal("Text"):Connect(function()

	local text = string.lower(Search.Text)

	for _,item in ipairs(Buttons) do

		if text == "" or string.find(item.Name,text) then
			item.Button.Visible = true
		else
			item.Button.Visible = false
		end

	end

end)



-- Auto page

local AutoTitle = Instance.new("TextLabel")
AutoTitle.Size = UDim2.new(1,0,0,40)
AutoTitle.BackgroundTransparency = 1
AutoTitle.Text = "⚡ Automation"
AutoTitle.Font = Enum.Font.GothamBold
AutoTitle.TextSize = 22
AutoTitle.TextColor3 = Color3.new(1,1,1)
AutoTitle.Parent = AutoPage



local AutoButton = Instance.new("TextButton")
AutoButton.Size = UDim2.new(1,0,0,45)
AutoButton.Position = UDim2.new(0,0,0,60)
AutoButton.BackgroundColor3 = Color3.fromRGB(35,35,50)
AutoButton.Text = "Auto Clicker: OFF"
AutoButton.Font = Enum.Font.GothamBold
AutoButton.TextSize = 16
AutoButton.TextColor3 = Color3.new(1,1,1)
AutoButton.Parent = AutoPage


local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0,12)
AutoCorner.Parent = AutoButton



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

		task.wait(.1)

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
local startPosition



Title.InputBegan:Connect(function(input)

	if input.UserInputType ==
	Enum.UserInputType.MouseButton1 then

		dragging = true
		dragStart = input.Position
		startPosition = Main.Position

	end

end)



UserInputService.InputChanged:Connect(function(input)

	if dragging and input.UserInputType ==
	Enum.UserInputType.MouseMovement then

		local delta = input.Position - dragStart


		Main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)

	end

end)



UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType ==
	Enum.UserInputType.MouseButton1 then

		dragging = false

	end

end)
