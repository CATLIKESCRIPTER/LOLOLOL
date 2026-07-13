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
