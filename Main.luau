-- // VARIABLES \\ --

local plr = game:GetService("Players").LocalPlayer
local msg = Instance.new("Hint", workspace)

local buttons = nil

-- // NOTIFICATION HANDLER \\


-- // BUTTONS \\ --

local buttonsClicked = {
	[1] = false;
	[7] = false;
}

local function newNotification(forcedParent : Object, v : SharedTable, info : SharedTable, msg : string)
	pcall(function()
		task.spawn(function()
			repeat 
				if not plr.PlayerGui:FindFirstChild("Notifications") then
					local g = Instance.new("ScreenGui", plr.PlayerGui);

					g.Name = "Notifications";
				end

				task.wait() 
			until plr.PlayerGui:FindFirstChild("Notifications")

			local newFrame = Instance.new("Frame", plr.PlayerGui:WaitForChild("Notifications"))

			if forcedParent ~= nil then
				newFrame.Size = UDim2.new(0.3, 0, 0.1, 0)
				newFrame.Position = UDim2.new(1, 0, (0.1 * #forcedParent:GetChildren()), 0)
				newFrame.Name = "MainFrame";
			else
				newFrame.Size = UDim2.new(0.3, 0, 0.1, 0)
				newFrame.Position = UDim2.new(1, 0, (0.1 * #plr.PlayerGui:WaitForChild("Notifications"):GetChildren()), 0)
				newFrame.Name = "MainFrame";
			end

			local textLabel = Instance.new("TextLabel", newFrame);

			textLabel.Name = "Title";
			textLabel.Text = "CUBEWARE";
			textLabel.Size = UDim2.new(1, 0, 0.4, 0);
			textLabel.Position = UDim2.new(0, 0, 0, 0);
			textLabel.TextScaled = true;
			textLabel.TextStrokeTransparency = 0;
			textLabel.BackgroundTransparency = 1;

			local textLabel2 = Instance.new("TextLabel", newFrame);

			textLabel2.Name = "_Text";

			if msg == nil then
				if v["Index"] then
					if buttonsClicked[tonumber(v["Index"])] == true then
						textLabel2.Text = "Enabled "..tostring(v["Name"])
					else
						textLabel2.Text = "Disabled "..tostring(v["Name"])
					end
				end
			else
				textLabel2.Text = tostring(msg)
			end

			textLabel2.Size = UDim2.new(1, 0, 0.6, 0);
			textLabel2.Position = UDim2.new(0, 0, 0.4, 0);
			textLabel2.TextScaled = true;
			textLabel2.TextStrokeTransparency = 0;
			textLabel2.BackgroundTransparency = 1;

			local removeButton = Instance.new("TextButton", newFrame);

			removeButton.Size = UDim2.new(1, 0, 1, 0);
			removeButton.Position = UDim2.new(0, 0, 0, 0);
			removeButton.AnchorPoint = Vector2.zero;
			removeButton.Text = "";
			removeButton.BackgroundTransparency = 1;
			removeButton.ZIndex = 2

			Instance.new("UICorner", newFrame) -- Add rounder corners

			game:GetService("TweenService"):Create(newFrame, TweenInfo.new(0.25), {Position = UDim2.new(0.7, 0, (0.75 - (0.1 * #plr.PlayerGui:WaitForChild("Notifications"):GetChildren())), 0)}):Play()

			removeButton.MouseButton1Down:Connect(function()
				game:GetService("TweenService"):Create(newFrame, TweenInfo.new(0.25), {Size = UDim2.new(0, 0, 0, 0)}):Play()

				delay(0.25, function()
					newFrame:Destroy()
				end)
			end)

			plr.PlayerGui:WaitForChild("Notifications").ChildRemoved:Connect(function()
				task.spawn(function()
					game:GetService("TweenService"):Create(newFrame, TweenInfo.new(0.25), {Position = newFrame.Position + UDim2.new(0, 0, 0.1, 0)}):Play()

					delay(0.5, function()
						if (newFrame.Position.Height.Scale >= 0.95) then
							game:GetService("TweenService"):Create(newFrame, TweenInfo.new(0.25), {Size = UDim2.new(0, 0, 0, 0)}):Play()

							delay(0.25, function()
								newFrame:Destroy()
							end)
						end
					end)
				end)
			end)
		end)
	end)
end

buttons = {
	[1] = {		
		Index = 1,
		Name = "Passive-Agressive",
		Description = "If you lose / gain hp near a player, you will be at their body until they die or leave!";
		OnClicked = function()
			local c = nil
			local target = nil

			if c == nil then
				c = plr.Character:FindFirstChildOfClass("Humanoid").HealthChanged:Connect(function(health)				
					for _, v in pairs(game:GetService("Players"):GetPlayers()) do
						if v.Character ~= nil then
							if v.Character.PrimaryPart ~= nil then
								if (v.Character.PrimaryPart.Position - plr.Character.PrimaryPart.Position).Magnitude <= 40 then
									if v.Character == nil then
										target = nil
									end
									
									if target ~= nil then
										target = v.Character
									end

									pcall(function()
										plr.Character.PrimaryPart.CFrame = target.PrimaryPart.CFrame
									end)
								end
							end
						end
					end
				end)
			else
				if c then
					c:Disconnect()
				end
			end
		end,
	};
	
	[2] = {
		Index = 2,
		Name = "'Locked-In'",
		Description = "When a player is near you, you are locked into them until they leave.",
		OnClicked = function()
			local c = nil
			local target = nil
			
			if c == nil then
				c = game:GetService("RunService").Heartbeat:Connect(function()
					if plr.Character then
						if plr.Character.PrimaryPart ~= nil then
							for _, v in pairs(game:GetService("Players"):GetPlayers()) do
								if (v.Character.PrimaryPart.Position - plr.Character.PrimaryPart.Position).Magnitude <= 25 then
									target = v.Name
								end
							end
							
							if not game:GetService("Players"):FindFirstChild(tostring(target)) then
								target = ""
							end
							
							if target ~= nil and target ~= "" then
								local t : Player = game:GetService("Players"):WaitForChild(tostring(target))
								
								plr.Character.PrimaryPart.Position:Lerp(t.Character.PrimaryPart.Position, 0.25)
							end
						end
					end
				end)
			end
		end,
	};
	
	[3] = {
		Index = 3;
		Name = "BTools";
		Description = "Building-Tool(s)!",
		OnClicked = function()
			local t = Instance.new("Tool", plr.Backpack);
			
			t.Name = "Destroy";
			t.RequiresHandle = false;
			
			t.Activated:Connect(function()
				if plr then
					if plr:GetMouse() then
						if plr:GetMouse().Target ~= nil then
							if plr.Character:FindFirstChild(tostring(t.Name)) then
								plr:GetMouse().Target:Destroy()
							end
						end
					end
				end
			end)
			
			local t2 = Instance.new("Tool", plr.Backpack)
			local t2_holding = false
			
			t2.Name = "Clone";
			t2.RequiresHandle = false;
			
			t2.Activated:Connect(function()
				t2_holding = true
				task.wait(0.5)
				
				if t2_holding == true then
					if plr then
						if plr:GetMouse() then
							if plr:GetMouse().Target ~= nil then
								local c = plr:GetMouse().Target:Clone()	
								local s = Instance.new("Vector3Value", plr:GetMouse().Target);
								
								s.Name = "size";
								s.Value = c.Size;
								
								local t_ = Instance.new("NumberValue", plr:GetMouse().Target);
								
								t_.Name = "transparency";
								t_.Value = c.Transparency
								
								local c_ = Instance.new("BoolValue", plr:GetMouse().Target);
								
								c_.Name = "CanCollide";
								c_.Value = c.CanCollide
								
								repeat 
									task.wait()

									c.CFrame = plr:GetMouse().Hit + Vector3.new(0, 0.5, 0);
									c.Parent = workspace;
									c.Anchored = true;
									c.Transparency = 0.8;
									c.CanCollide = false;
									c.Size = Vector3.new(0.5, 0.5, 0.5)

									task.wait()
								until t2_holding == false
								
								c.CanCollide = c_.Value;
								c.Transparency = t_.Value;
								c.Size = s.Value;
								
								task.spawn(function()
									pcall(function()
										if c_ then
											c_:Destroy()
										end

										if t_ then
											t_:Destroy()
										end

										if s then
											s:Destroy()
										end
									end)
								end)
							end
						end
					end
				end
			end)
			
			t2.Deactivated:Connect(function()
				t2_holding = false
			end)
			
			local t3 = Instance.new("Tool", plr.Backpack);
			local t3_holding = false
			
			t3.Name = "Move";
			t3.RequiresHandle = false;
			
			t3.Activated:Connect(function()
				t3_holding = true
				
				if plr then
					if plr:GetMouse() then
						if plr:GetMouse().Target then
							repeat
								task.wait()
								plr:GetMouse().Target.CFrame = plr:GetMouse().Hit
								task.wait()
							until t3_holding == false
						end
					end
				end
			end)
			
			t3.Deactivated:Connect(function()
				t3_holding = false
			end)
		end,
	}
}

-- // Main Code \\ --

msg.Text = "Loading... Please wait!"

repeat task.wait() until game:IsLoaded()

if msg then
	msg:Destroy()
end

pcall(function()
	task.spawn(function()
		pcall(function()
			local b = Instance.new("BlurEffect", game:GetService("Lighting"))

			b.Name = "CubewareBlur"
			b.Size = 0;
			game:GetService("TweenService"):Create(b, TweenInfo.new(0.5), {Size = 40}):Play()
		end)
	end)

	local screenGui = Instance.new("ScreenGui", plr.PlayerGui)

	screenGui.Name = "ExploitGui"
	screenGui.IgnoreGuiInset = true
	screenGui.Enabled = true
	screenGui.ResetOnSpawn = false;

	local frame = Instance.new("Frame", screenGui)

	frame.Size = UDim2.new(0, 0, 0, 0) --UDim2.new(0.5, 0, 0.5, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Name = "MainFrame";

	Instance.new("UICorner", frame) -- Add rounder corners

	local text = Instance.new("TextLabel", frame)

	text.ZIndex = 10;
	text.Size = UDim2.new(0.9, 0, 0.25, 0)
	text.Position = UDim2.new(0.5, 0, 0.2, 0)
	text.AnchorPoint = Vector2.new(0.5, 0.5)
	text.BackgroundTransparency = 1
	text.TextScaled = true;
	text.RichText = true
	text.Text = "CubeWare! (<font color='#00ff00'>BEST</font> Closet Cheating Script)!"
	text.Name = "-1_Title";

	local scrollingFrame = Instance.new("ScrollingFrame", frame);

	scrollingFrame.Size = UDim2.new(1, 0, 1, 0);
	scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.XY;
	scrollingFrame.BackgroundTransparency = 1;
	scrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
	scrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5);

	text.Parent = scrollingFrame;
	text.Name = text.Name.."_scroll"

	local uiList = Instance.new("UIListLayout", scrollingFrame);

	uiList.Wraps = true;
	uiList.Padding = UDim.new(0, 10);
	uiList.SortOrder = Enum.SortOrder.LayoutOrder;
	uiList.VerticalAlignment = Enum.VerticalAlignment.Center;
	uiList.FillDirection = Enum.FillDirection.Horizontal;

	game:GetService("TweenService"):Create(frame, TweenInfo.new(1), {Size = UDim2.new(0.5, 0, 0.5, 0)}):Play()
	task.wait(1.5)
	
	task.spawn(function()
		local f = Instance.new("Folder", game:GetService("ReplicatedStorage"));
		
		f.Name = "CubewareRemotes";
		
		task.spawn(function()
			local r = Instance.new("BindableEvent", f);

			r.Name = "Kick";

			r.Event:Connect(function(plr, reason)
				plr:Kick(tostring(reason) or "No reason inserted.")
			end)
		end)
		
		task.spawn(function()
			local r = Instance.new("BindableEvent", f);

			r.Name = "WalkSpeed";

			r.Event:Connect(function(plr, walkspeed : number)
				while task.wait() do
					if plr then
						if plr.Character then
							if plr.Character.PrimaryPart then
								if plr.Character:FindFirstChildOfClass("Humanoid") then
									if plr.Character:FindFirstChildOfClass("Humanoid").MoveDirection.Magnitude > 0 then
										plr.Character.PrimaryPart.AssemblyLinearVelocity = plr.Character.PrimaryPart.CFrame.LookVector * tonumber(walkspeed)
									end
								end
							end
						end
					end
				end
			end)
		end)
		
		task.spawn(function()
			local b = Instance.new("BindableEvent", f);
			
			b.Name = "Un-inject";
			b.Event:Connect(function()
				if plr then
					pcall(function()
						screenGui:Destroy()
						
						if game:GetService("Lighting"):WaitForChild("CubewareBlur") then
							game:GetService("Lighting"):WaitForChild("CubewareBlur"):Destroy()
						end
						
						task.wait(0.5)
						game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
					end)
				end
			end)
		end)
	end)
	
	task.spawn(function()
		for i, _ in pairs(buttons) do
			local v = buttons[i]

			if not v["Section"] then
				local button = Instance.new("TextButton", scrollingFrame);

				local s, err = pcall(function()
					button.Size = UDim2.new(0.25, 0, 0.1, 0);
					button.Text = tostring(v["Name"]);
					button.Name = tostring(v["Index"]).."_"..tostring(button.Text)
					button.BackgroundColor3 = (v["Color"] == nil and Color3.new(1, 1, 1) or v["Color"] ~= nil and v["Color"]);
					button.TextScaled = true;

					button.Size = UDim2.new(0, 0, 0, 0);

					game:GetService("TweenService"):Create(button, TweenInfo.new(0.5), {Size = UDim2.new(0.25, 0, 0.1, 0)}):Play()
				end)

				if s == false then
					for i = 1, 150 do
						warn("CUBEWARE: Error while loading button: "..tostring(err), tostring(v["Name"]))
					end
				end

				if v["Icon"] then
					local imageLabel = Instance.new("ImageLabel", button);

					imageLabel.Size = UDim2.new(0.16, 0, 0.6, 0);
					imageLabel.Position = UDim2.new(0, 0, 0.4, 0);
					imageLabel.AnchorPoint = Vector2.new(0, 0.5);
					imageLabel.BackgroundTransparency = 1;
					imageLabel.Image = tostring(v["Icon"]);
				end

				if v["RichText"] then
					button.RichText = v["RichText"]
				end

				button.MouseButton1Down:Connect(function()
					plr.Character.PrimaryPart = plr.Character:WaitForChild("HumanoidRootPart");
					task.wait()

					task.spawn(function()
						pcall(function()
							if v["OnClicked"] then
								if v["CanBeDisabled"] then
									newNotification(nil, v, nil, nil)
								end
							end
						end)
					end)

					task.spawn(function()
						if v["IsClicked"] then
							if not button:FindFirstChild("EnabledStroke") then
								local UIStroke = Instance.new("UIStroke", button);

								UIStroke.Name = "EnabledStroke"
								UIStroke.Color = Color3.new(1, 0, 0);
								UIStroke.Thickness = 0;
								UIStroke.Transparency = 0.6;
								UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Outer;
								UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
								UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;

								game:GetService("TweenService"):Create(UIStroke, TweenInfo.new(0.3), {Thickness = 5}):Play()
							else
								if button:FindFirstChild("EnabledStroke") then
									game:GetService("TweenService"):Create(button:FindFirstChild("EnabledStroke"), TweenInfo.new(0.3), {Thickness = 0}):Play()

									delay(0.3, function()
										pcall(function()
											button:FindFirstChild("EnabledStroke"):Destroy()
										end)
									end)
								end
							end
						end
					end)

					if v["IsClicked"] then
						v["IsClicked"] = not v["IsClicked"]
					end

					buttonsClicked[tonumber(v["Index"])] = not buttonsClicked[tonumber(v["Index"])]

					pcall(function()
						v["OnClicked"]()
					end)
				end)

				if v["Options"] then
					button.MouseButton2Up:Connect(function()
						if not button:FindFirstChild("OptionsFrame") then
							local f = Instance.new("Frame", button);

							f.Name = "OptionsFrame";
							f.Position = UDim2.new(0, 0, 1.5, 0);
							f.Size = UDim2.new(1, 0, 1.5, 0);
							f.AnchorPoint = Vector2.new(0, 0.2);
							f.BackgroundColor3 = Color3.new(1, 1, 1)
							f.ZIndex = 355;
							f.Size = UDim2.new(0, 0, 0, 0);

							local scroll = Instance.new("ScrollingFrame", f)

							scroll.Size = UDim2.new(1, 0, 1, 0);
							scroll.AutomaticSize = Enum.AutomaticSize.XY;
							scroll.AutomaticCanvasSize = Enum.AutomaticSize.XY;
							scroll.BackgroundTransparency = 1;
							scroll.Position = UDim2.new(0, 0, 0, 0);
							scroll.ZIndex = 356;
							scroll.ScrollingDirection = Enum.ScrollingDirection.Y;

							local list = Instance.new("UIListLayout", scroll);

							list.Wraps = true;
							list.SortOrder = Enum.SortOrder.Name;
							list.FillDirection = Enum.FillDirection.Horizontal;
							list.Padding = UDim.new(0, 10);

							game:GetService("TweenService"):Create(f, TweenInfo.new(1), {Size = UDim2.new(1, 0, 2, 0)}):Play()
							Instance.new("UICorner", f)

							for _, option in pairs(v["Options"]) do
								local textBox = Instance.new("TextBox", scroll);

								textBox:SetAttribute("Default", tostring(option["Value"]))
								textBox.PlaceholderText = tostring(option["Name"]).."(Default Value: "..tostring(option["Value"])..")"
								textBox.Size = UDim2.new(0, 0, 0, 0);
								textBox.Name = tostring(option["Name"])
								textBox.ZIndex = 357;
								textBox.TextScaled = true;
								textBox.TextColor3 = Color3.new(1, 1, 1);
								textBox.TextStrokeTransparency = 0;
								textBox.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6);
								textBox.Text = ""

								game:GetService("TweenService"):Create(textBox, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0.4, 0)}):Play()
								Instance.new("UICorner", textBox);

								task.wait(0.2)

								textBox.Changed:Connect(function(Text)
									if textBox.Text ~= "" then
										option["Value"] = tostring(textBox.Text)
										print("CUBEWARE: Changed "..tostring(option["Name"]).." to "..tostring(option["Value"]))
									else
										option["Value"] = tostring(textBox:GetAttribute("Default"))
										print("CUBEWARE: Changed "..tostring(option["Name"]).." to 'Default'")
									end
								end)
							end
						else
							if button:FindFirstChild("OptionsFrame") then
								game:GetService("TweenService"):Create(button:WaitForChild("OptionsFrame"), TweenInfo.new(0.25), {Size = UDim2.new(0, 0, 0, 0)}):Play()

								delay(0.25, function()
									button:WaitForChild("OptionsFrame"):Destroy()
								end)
							end
						end
					end)
				end

				button.MouseEnter:Connect(function()
					if v["Description"] then
						local f = Instance.new("Frame", button);

						f.Name = "InfoFrame";
						f.Position = UDim2.new(0, 0, 1, 0);
						f.Size = UDim2.new(1, 0, 1.5, 0);
						f.AnchorPoint = Vector2.new(0, 0.2);
						f.BackgroundColor3 = Color3.new(1, 1, 1)
						f.ZIndex = 300;

						f.Size = UDim2.new(0, 0, 0, 0);

						local t = Instance.new("TextLabel", f);

						t.TextScaled = true;
						t.BackgroundTransparency = 1;
						t.Text = tostring(v["Description"]);
						t.Name = "InfoText";
						t.TextColor3 = Color3.fromRGB(255, 255, 255);
						t.TextStrokeTransparency = 0;
						t.Size = UDim2.new(1, 0, 1, 0)
						t.Parent = f
						t.ZIndex = 301;

						game:GetService("TweenService"):Create(f, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 1.5, 0)}):Play();

						Instance.new("UICorner", f);

						button.MouseLeave:Wait()
						game:GetService("TweenService"):Create(f, TweenInfo.new(0.25), {Size = UDim2.new(0, 0, 0, 0)}):Play()

						delay(0.25, function()
							if f then
								f:Destroy()
							end
						end)
					end
				end)

				Instance.new("UICorner", button);
			else
				local textLabel = Instance.new("TextLabel", scrollingFrame);

				textLabel.Name = v["Section"]["SectionIndex"].."_Section"
				textLabel.Text = v["Section"]["Text"];
				textLabel.BackgroundTransparency = 1;
				textLabel.Size = UDim2.new(0.9, 0, 0.125, 0);
				textLabel.TextScaled = true;
				textLabel.TextColor3 = v["Section"]["Color"]
			end
		end
	end)

	game:GetService("UserInputService").InputBegan:Connect(function(key)
		if key.KeyCode == Enum.KeyCode.RightShift then
			screenGui.Enabled = not screenGui.Enabled

			if not game:GetService("Lighting"):FindFirstChild("CubewareBlur") then
				local b = Instance.new("BlurEffect", game:GetService("Lighting"))

				b.Name = "CubewareBlur"
				b.Size = 0;
				game:GetService("TweenService"):Create(b, TweenInfo.new(0.5), {Size = 40}):Play()
				
				repeat task.wait() until game:GetService("Lighting"):FindFirstChild("CubewareBlur")
			else
				local b : BlurEffect = game:GetService("Lighting"):WaitForChild("CubewareBlur")

				b.Size = 40;
				game:GetService("TweenService"):Create(b, TweenInfo.new(0.5), {Size = 0}):Play()

				task.spawn(function()
					delay(0.5, function()
						if b then
							b:Destroy()
						end
					end)
				end)
				
				repeat task.wait() until not game:GetService("Lighting"):FindFirstChild("CubewareBlur")
			end
		end
	end)
end)
