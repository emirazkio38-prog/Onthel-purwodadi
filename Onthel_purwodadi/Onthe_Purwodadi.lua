-- KERJA HUB LITE (TANPA mini game) | Onthel Purwadadi | By Azk & Claude
-- Isi: duit live, auto kurir, TP gerobak, auto layani bakso, AUTO MISI LABU, AUTO CLAIM MEME,
--      ANTI GAMEPLAY PAUSED, buka/tutup JobGui, delay bisa diatur
-- Tombol buka/tutup bulat berlogo (bisa digeser), window bisa digeser, animasi buka/tutup, GUI tahan hilang
-- TARUH DI: StarterPlayer > StarterPlayerScripts (LocalScript) atau jalankan lewat executor

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

------------------------------------------------------------
-- PENGATURAN
------------------------------------------------------------
local LOGO = "rbxassetid://109621974209211"
local PAKAI_COREGUI = true -- true = GUI di gethui/CoreGui supaya tidak ikut hilang saat animasi/cutscene game
local FONT = Enum.Font.Arcade

local function C(r, g, b) return Color3.fromRGB(r, g, b) end
local THEMES = { Biru = C(80, 170, 255) }
local data = { theme = "Biru" }

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do o[k] = v end
	o.Parent = parent
	return o
end

local function accent(parent, th)
	return new("UIStroke", {
		Thickness = th or 2, Color = THEMES[data.theme],
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border, LineJoinMode = Enum.LineJoinMode.Miter,
	}, parent)
end

local function label(parent, text, size, pos, dim, color, align)
	return new("TextLabel", {
		BackgroundTransparency = 1, Text = text, Font = FONT, TextSize = size,
		TextColor3 = color or Color3.new(1, 1, 1), Position = pos, Size = dim,
		TextXAlignment = align or Enum.TextXAlignment.Left, TextWrapped = true,
	}, parent)
end

local function outline(l)
	new("UIStroke", { Thickness = 1.5, Color = Color3.new(0, 0, 0) }, l)
end

local function mkBtn(parent, text, pos, size, color)
	local b = new("TextButton", {
		Text = text, Font = FONT, TextSize = 14, TextColor3 = Color3.new(1, 1, 1),
		BackgroundColor3 = color or C(40, 40, 40), BorderSizePixel = 0, Position = pos, Size = size,
	}, parent)
	new("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 2, LineJoinMode = Enum.LineJoinMode.Miter }, b)
	return b
end

------------------------------------------------------------
-- GUI (tombol bulat + window)
------------------------------------------------------------
local gui, guiHome = nil, nil
do
	local pgui = player:WaitForChild("PlayerGui")
	local function cleanup(parent)
		if not parent then return end
		for _, nm in ipairs({ "ThrowFarm", "MiniGameHub", "ThrowFarmHub", "KerjaHub", "KerjaHubLite" }) do
			local old = parent:FindFirstChild(nm)
			if old then pcall(function() old:Destroy() end) end
		end
	end
	local function make(parent)
		return new("ScreenGui", {
			Name = "KerjaHubLite", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999999,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		}, parent)
	end
	cleanup(pgui)
	local target = nil
	if PAKAI_COREGUI then
		local okH, h = pcall(function() return gethui and gethui() end)
		if okH and typeof(h) == "Instance" then target = h end
		if not target then
			local okC, cg = pcall(function() return game:GetService("CoreGui") end)
			if okC and typeof(cg) == "Instance" then target = cg end
		end
	end
	if target then
		cleanup(target)
		local ok, res = pcall(make, target)
		if ok and res and res.Parent then
			gui, guiHome = res, target
		elseif ok and res then
			pcall(function() res:Destroy() end)
		end
	end
	if not gui then
		gui, guiHome = make(pgui), pgui
	end
	gui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not gui.Enabled then gui.Enabled = true end
	end)
end

local tog = new("ImageButton", {
	Size = UDim2.fromOffset(52, 52), Position = UDim2.new(0, 16, 0.5, -26), BackgroundColor3 = C(25, 85, 210),
	Image = LOGO, ScaleType = Enum.ScaleType.Crop, AutoButtonColor = false,
}, gui)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, tog)
new("UIAspectRatioConstraint", { AspectRatio = 1 }, tog)
new("UIStroke", { Color = C(40, 125, 255), Thickness = 3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, tog)
local togScale = new("UIScale", {}, tog)

local window = new("Frame", {
	Size = UDim2.fromOffset(310, 400), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1, Visible = false,
}, gui)
local winScale = new("UIScale", { Scale = 0.05 }, window)
accent(window, 3)

local header = new("Frame", {
	Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = C(30, 90, 215), BorderSizePixel = 0, Active = true,
}, window)
new("UIGradient", { Color = ColorSequence.new(C(60, 135, 245), C(15, 55, 160)), Rotation = 90 }, header)
local logoImg = new("ImageLabel", {
	Size = UDim2.fromOffset(34, 34), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = C(20, 60, 160),
	Image = LOGO, ScaleType = Enum.ScaleType.Crop, BorderSizePixel = 0,
}, header)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, logoImg)
accent(logoImg, 2)
local title = label(header, "KERJA HUB", 16, UDim2.fromOffset(48, 4), UDim2.fromOffset(150, 20))
local sub = label(header, "Onthel Purwadadi (Lite)", 10, UDim2.fromOffset(49, 26), UDim2.fromOffset(190, 14), C(255, 235, 140))
for _, l in ipairs({ title, sub }) do
	l.ZIndex = 2
	outline(l)
end
local closeBtn = mkBtn(header, "X", UDim2.new(1, -36, 0, 9), UDim2.fromOffset(28, 28), C(200, 40, 40))
closeBtn.ZIndex = 3

local farmPage = new("ScrollingFrame", {
	Position = UDim2.fromOffset(0, 46), Size = UDim2.new(1, 0, 1, -46), BackgroundColor3 = C(10, 28, 78),
	BackgroundTransparency = 0.2, BorderSizePixel = 0, ScrollBarThickness = 5,
	AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
}, window)

------------------------------------------------------------
-- DRAG + ANIMASI BUKA/TUTUP + PENJAGA
------------------------------------------------------------
local function makeDraggable(handle, target)
	local drag, moved, start, startPos = false, false, nil, nil
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag, moved = true, false
			start = i.Position
			startPos = target.AbsolutePosition + target.AbsoluteSize * target.AnchorPoint
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local dx, dy = i.Position.X - start.X, i.Position.Y - start.Y
			if not moved and math.abs(dx) + math.abs(dy) < 6 then return end
			moved = true
			local vp, sz, ap = gui.AbsoluteSize, target.AbsoluteSize, target.AnchorPoint
			local x = math.clamp(startPos.X + dx, sz.X * ap.X, math.max(sz.X * ap.X, vp.X - sz.X * (1 - ap.X)))
			local y = math.clamp(startPos.Y + dy, sz.Y * ap.Y, math.max(sz.Y * ap.Y, vp.Y - sz.Y * (1 - ap.Y)))
			target.Position = UDim2.fromOffset(x, y)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
	end)
	return function()
		local m = moved
		moved = false
		return m
	end
end
local tbMoved = makeDraggable(tog, tog)
makeDraggable(header, window)

local isOpen = false
local winTween, togTween = nil, nil
local function setOpen(open)
	if open == isOpen then return end
	isOpen = open
	if winTween then winTween:Cancel() end
	if togTween then togTween:Cancel() end
	togTween = TweenService:Create(tog, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Rotation = open and 360 or 0 })
	togTween:Play()
	if open then
		local vp = gui.AbsoluteSize
		if vp.X < 50 and workspace.CurrentCamera then vp = workspace.CurrentCamera.ViewportSize end
		window.Size = UDim2.fromOffset(math.clamp(vp.X * 0.9, 280, 320), math.clamp(vp.Y * 0.88, 260, 440))
		window.Visible = true
		winScale.Scale = 0.05
		winTween = TweenService:Create(winScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
		winTween:Play()
	else
		local tw = TweenService:Create(winScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.05 })
		winTween = tw
		tw:Play()
		tw.Completed:Connect(function()
			if not isOpen then window.Visible = false end
		end)
	end
end

tog.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		TweenService:Create(togScale, TweenInfo.new(0.1), { Scale = 0.9 }):Play()
	end
end)
tog.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		TweenService:Create(togScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	end
end)
tog.Activated:Connect(function()
	if tbMoved() then return end
	setOpen(not isOpen)
end)
closeBtn.Activated:Connect(function() setOpen(false) end)

-- PENJAGA: GUI tidak boleh hilang walau game memutar animasi / cutscene
do
	local dead = false
	gui.Destroying:Connect(function() dead = true end)
	tog:GetPropertyChangedSignal("Visible"):Connect(function()
		if not tog.Visible then tog.Visible = true end
	end)
	task.spawn(function()
		while not dead do
			task.wait(0.4)
			if gui.Parent ~= guiHome then
				pcall(function() gui.Parent = guiHome end)
			end
			if not gui.Enabled then gui.Enabled = true end
			if not tog.Visible then tog.Visible = true end
		end
	end)
end

------------------------------------------------------------
-- KERJA HUB: Onthel Purwadadi (Kurir + Bakso) - menggantikan Throw Farm
------------------------------------------------------------
local function startKerjaHub()
	local lp = Players.LocalPlayer
	local kurirOn, baksoOn = false, false
	local pumpkinOn, memeOn, antiPause = false, false, true
	local kurirRun, pumpkinRun, memeRun = 0, 0, 0
	local pauseJobs = false -- true saat klaim meme (job lain menunggu sebentar)
	local memeInterval = 5
	local delayTP, delayAfter = 0.25, 0.2
	local lastServe = 0
	local houses = {
		"Rumah Pak Joko",
		"Rumah Bu Wati",
		"Rumah Pak Budi",
	}

	------------------------------------------------------------
	-- UI
	------------------------------------------------------------
	new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, farmPage)
	new("UIPadding", {
		PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 10),
	}, farmPage)
	local ord = 0
	local function nextOrd()
		ord = ord + 1
		return ord
	end

	local st = label(farmPage, "GUI OK", 12, UDim2.new(), UDim2.new(1, 0, 0, 16), C(140, 225, 255))
	st.LayoutOrder = nextOrd()
	outline(st)

	-- DUIT: membaca PlayerGui.MoneyGui.MoneyContainer.Amount, naik otomatis saat dapat duit
	local moneyRow = new("Frame", {
		Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = C(14, 34, 80), BackgroundTransparency = 0.1,
		BorderSizePixel = 0, LayoutOrder = nextOrd(),
	}, farmPage)
	accent(moneyRow, 1)
	local moneyTitle = label(moneyRow, "DUIT KAMU", 11, UDim2.fromOffset(10, 3), UDim2.fromOffset(100, 14), C(160, 200, 255))
	local moneyLbl = label(moneyRow, "...", 20, UDim2.fromOffset(10, 17), UDim2.new(1, -20, 0, 24), C(255, 225, 70))
	local gainLbl = label(moneyRow, "", 11, UDim2.new(1, -150, 0, 3), UDim2.fromOffset(140, 14), C(120, 220, 255), Enum.TextXAlignment.Right)
	outline(moneyTitle)
	outline(moneyLbl)
	outline(gainLbl)

	local amountObj, lastMoney, sessionGain = nil, nil, 0
	local function fmtNum(n)
		local str = tostring(math.floor(n))
		local out = str:reverse():gsub("(%d%d%d)", "%1,"):reverse()
		if string.sub(out, 1, 1) == "," then out = string.sub(out, 2) end
		return out
	end
	local function updateMoney()
		local o = amountObj
		if not o or not o.Parent then return end
		local raw
		if o:IsA("ValueBase") then
			raw = o.Value
		else
			raw = o.Text
		end
		moneyLbl.Text = tostring(raw)
		local digits = string.gsub(tostring(raw), "[^%d]", "")
		local n = tonumber(digits)
		if n then
			if lastMoney and n > lastMoney then
				local add = n - lastMoney
				sessionGain = sessionGain + add
				gainLbl.Text = "+" .. fmtNum(add) .. "  (total +" .. fmtNum(sessionGain) .. ")"
			elseif not lastMoney then
				gainLbl.Text = "naik sesi: +0"
			end
			lastMoney = n
		end
	end
	task.spawn(function()
		local conn = nil
		while true do
			local pgui = lp:FindFirstChild("PlayerGui")
			local mg = pgui and pgui:FindFirstChild("MoneyGui")
			local mc = mg and mg:FindFirstChild("MoneyContainer")
			local o = mc and mc:FindFirstChild("Amount")
			if o ~= amountObj then
				amountObj = o
				if conn then
					conn:Disconnect()
					conn = nil
				end
				if o then
					local prop = o:IsA("ValueBase") and "Value" or "Text"
					conn = o:GetPropertyChangedSignal(prop):Connect(updateMoney)
				else
					moneyLbl.Text = "GUI uang tidak ditemukan"
				end
			end
			updateMoney()
			task.wait(1)
		end
	end)

	local function section(text)
		local l = label(farmPage, "-- " .. text .. " --", 12, UDim2.new(), UDim2.new(1, 0, 0, 16), C(255, 225, 90))
		l.LayoutOrder = nextOrd()
		outline(l)
		return l
	end

	local switches = {}
	local function mkSwitch(text, getFn, onClick)
		local row = new("TextButton", {
			Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = C(14, 34, 80), BackgroundTransparency = 0.1,
			BorderSizePixel = 0, Text = "", AutoButtonColor = false, LayoutOrder = nextOrd(),
		}, farmPage)
		accent(row, 1)
		local lbl = label(row, "", 14, UDim2.fromOffset(10, 0), UDim2.new(1, -66, 1, 0), Color3.new(1, 1, 1))
		lbl.TextYAlignment = Enum.TextYAlignment.Center
		local pill = new("Frame", {
			Size = UDim2.fromOffset(40, 18), Position = UDim2.new(1, -50, 0.5, -9), BackgroundColor3 = C(70, 80, 100), BorderSizePixel = 0,
		}, row)
		new("UICorner", { CornerRadius = UDim.new(1, 0) }, pill)
		local knob = new("Frame", {
			Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
		}, pill)
		new("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)
		row.Activated:Connect(onClick)
		switches[#switches + 1] = { text = text, get = getFn, lbl = lbl, pill = pill, knob = knob }
	end

	local function paint()
		for _, s in ipairs(switches) do
			local on = s.get()
			s.lbl.Text = s.text .. ": " .. (on and "ON" or "OFF")
			TweenService:Create(s.pill, TweenInfo.new(0.18), { BackgroundColor3 = on and C(45, 130, 255) or C(70, 80, 100) }):Play()
			TweenService:Create(s.knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Position = on and UDim2.fromOffset(24, 2) or UDim2.fromOffset(2, 2) }):Play()
		end
	end

	local function mkWide(text, color, onClick)
		local b = mkBtn(farmPage, text, UDim2.new(), UDim2.new(1, 0, 0, 34), color)
		b.LayoutOrder = nextOrd()
		b.TextSize = 13
		b.Activated:Connect(onClick)
		return b
	end

	local function mkPair(textA, colA, onA, textB, colB, onB)
		local holder = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = nextOrd() }, farmPage)
		local a = mkBtn(holder, textA, UDim2.fromOffset(0, 0), UDim2.new(0.5, -3, 1, 0), colA)
		local b = mkBtn(holder, textB, UDim2.new(0.5, 3, 0, 0), UDim2.new(0.5, -3, 1, 0), colB)
		a.TextSize, b.TextSize = 12, 12
		a.Activated:Connect(onA)
		b.Activated:Connect(onB)
		return a, b
	end

	-- pengatur angka (tombol - / + atau ketik)
	local function mkStepper(text, getFn, setFn, lo, hi, step)
		local row = new("Frame", {
			Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = C(14, 34, 80), BackgroundTransparency = 0.1,
			BorderSizePixel = 0, LayoutOrder = nextOrd(),
		}, farmPage)
		accent(row, 1)
		local lbl = label(row, text, 12, UDim2.fromOffset(10, 0), UDim2.new(1, -144, 1, 0), Color3.new(1, 1, 1))
		lbl.TextYAlignment = Enum.TextYAlignment.Center
		local minus = mkBtn(row, "-", UDim2.new(1, -132, 0.5, -12), UDim2.fromOffset(28, 24), C(60, 100, 190))
		local plus = mkBtn(row, "+", UDim2.new(1, -34, 0.5, -12), UDim2.fromOffset(28, 24), C(60, 100, 190))
		local box = new("TextBox", {
			Position = UDim2.new(1, -100, 0.5, -12), Size = UDim2.fromOffset(62, 24), BackgroundColor3 = C(8, 22, 62), BorderSizePixel = 0,
			Text = string.format("%.2f", getFn()), Font = FONT, TextSize = 14, TextColor3 = C(255, 225, 90), ClearTextOnFocus = false,
			PlaceholderText = "dtk", PlaceholderColor3 = C(130, 150, 190),
		}, row)
		accent(box, 1)
		local function apply(v)
			v = math.clamp(math.floor(v * 100 + 0.5) / 100, lo, hi)
			setFn(v)
			box.Text = string.format("%.2f", v)
		end
		minus.Activated:Connect(function() apply(getFn() - step) end)
		plus.Activated:Connect(function() apply(getFn() + step) end)
		box.FocusLost:Connect(function()
			apply(tonumber(box.Text) or getFn())
		end)
	end

	------------------------------------------------------------
	-- fungsi bantu
	------------------------------------------------------------
	local function getRoot()
		return lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	end

	local function posOf(obj)
		if not obj then return nil end
		if obj:IsA("Attachment") then return obj.WorldPosition end
		if obj:IsA("BasePart") then return obj.Position end
		if obj:IsA("Model") then
			local ok, p = pcall(function() return obj:GetPivot().Position end)
			if ok then return p end
		end
		local p = obj:FindFirstChildWhichIsA("BasePart", true)
		return p and p.Position
	end

	-- TP; stream = true -> minta game memuat area sekitar tujuan (kalau StreamingEnabled)
	local function tp(pos, stream)
		local root = getRoot()
		if root and pos then
			if stream and workspace.StreamingEnabled then
				pcall(function() lp:RequestStreamAroundAsync(pos, 1.5) end)
			end
			root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
		end
	end

	local function waitPause()
		while pauseJobs do task.wait(0.1) end
	end

	local function firePrompt(prompt)
		if not prompt or not prompt:IsA("ProximityPrompt") then return false end
		if typeof(fireproximityprompt) == "function" then
			local ok = pcall(function() fireproximityprompt(prompt) end)
			if ok then return true end
		end
		return pcall(function()
			local old = prompt.HoldDuration
			prompt.HoldDuration = 0
			prompt:InputHoldBegin()
			task.wait(0.05)
			prompt:InputHoldEnd()
			prompt.HoldDuration = old
		end)
	end

	local function fireOnce(container)
		if not container then return end
		local deliver = container:FindFirstChild("DeliverPrompt", true)
		if deliver and deliver:IsA("ProximityPrompt") then
			firePrompt(deliver)
			return
		end
		for _, d in ipairs(container:GetDescendants()) do
			if d:IsA("ProximityPrompt") then
				firePrompt(d)
				return
			end
		end
	end

	-- buka GUI milik game (JobGui / AdminPanelGui)
	local function openGui(name)
		local pgui = lp:FindFirstChild("PlayerGui")
		local gui2 = pgui and pgui:FindFirstChild(name)
		if not gui2 then
			st.Text = name .. " tidak ada"
			return
		end
		pcall(function()
			if gui2:IsA("ScreenGui") then
				gui2.Enabled = true
			elseif gui2:IsA("GuiObject") then
				gui2.Visible = true
			end
		end)
		for _, d in ipairs(gui2:GetDescendants()) do
			if d:IsA("Frame") and (d.Name == "Main" or d.Name == "MainFrame" or d.Name == "Panel") then
				pcall(function() d.Visible = true end)
			end
		end
		st.Text = name .. " dibuka"
	end

	local function closeGui(name)
		local pgui = lp:FindFirstChild("PlayerGui")
		local gui2 = pgui and pgui:FindFirstChild(name)
		if not gui2 then
			st.Text = name .. " tidak ada"
			return
		end
		pcall(function()
			if gui2:IsA("ScreenGui") then
				gui2.Enabled = false
			elseif gui2:IsA("GuiObject") then
				gui2.Visible = false
			end
		end)
		for _, d in ipairs(gui2:GetDescendants()) do
			if d:IsA("Frame") and (d.Name == "Main" or d.Name == "MainFrame" or d.Name == "Panel") then
				pcall(function() d.Visible = false end)
			end
		end
		st.Text = name .. " ditutup"
	end

	------------------------------------------------------------
	-- KURIR
	------------------------------------------------------------
	local function goOffice()
		waitPause()
		local job = workspace:FindFirstChild("JobLocations")
		local kantor = job and job:FindFirstChild("KantorKurir")
		local main = kantor and kantor:FindFirstChild("MainPart")
		st.Text = "Kurir: Kantor..."
		tp(posOf(main) or posOf(kantor))
		task.wait(delayTP)
		fireOnce(main or kantor)
		task.wait(delayAfter)
	end

	local function goHouse(name)
		waitPause()
		local job = workspace:FindFirstChild("JobLocations")
		local points = job and job:FindFirstChild("DeliveryPoints")
		local house = points and points:FindFirstChild(name)
		local door = house and house:FindFirstChild("Door")
		st.Text = "Kurir: " .. name
		tp(posOf(door) or posOf(house))
		task.wait(delayTP)
		fireOnce(door or house)
		task.wait(delayAfter)
	end

	local function toggleKurir()
		kurirOn = not kurirOn
		if kurirOn then baksoOn, pumpkinOn = false, false end
		paint()
		if not kurirOn then return end
		kurirRun = kurirRun + 1
		local my = kurirRun
		task.spawn(function()
			while kurirOn and kurirRun == my do
				goOffice()
				if not kurirOn or kurirRun ~= my then break end
				for _, name in ipairs(houses) do
					if not kurirOn or kurirRun ~= my then break end
					goHouse(name)
				end
				st.Text = "Kurir: ulang..."
				task.wait(0.15)
			end
			if kurirRun == my then st.Text = "Kurir OFF" end
		end)
	end

	------------------------------------------------------------
	-- BAKSO
	------------------------------------------------------------
	local function tpGerobak()
		local job = workspace:FindFirstChild("JobLocations")
		local gerobak = job and job:FindFirstChild("GerobakBakso")
		local pos = posOf(gerobak)
		if pos then
			tp(pos)
			st.Text = "Gerobak - pencet prompt manual"
		else
			st.Text = "Gerobak tidak ketemu"
		end
	end

	local function serveAll()
		local n = 0
		for _, inst in ipairs(workspace:GetDescendants()) do
			if inst:IsA("ProximityPrompt") and inst.Name == "ServePrompt" then
				local p = inst.Parent
				local ok = false
				while p and p ~= workspace do
					if string.sub(p.Name, 1, 9) == "Customer_" then
						ok = true
						break
					end
					p = p.Parent
				end
				if ok and firePrompt(inst) then
					n = n + 1
				end
			end
		end
		st.Text = n > 0 and ("Bakso layani x" .. n) or "Tidak ada customer"
	end

	local function toggleBakso()
		baksoOn = not baksoOn
		if baksoOn then kurirOn, pumpkinOn = false, false end
		paint()
	end

	------------------------------------------------------------
	-- MISI LABU: PenjagaLabu (TP + pencet prompt) -> PUMPKIN (TP + pencet prompt)
	------------------------------------------------------------
	-- kunjungi semua ProximityPrompt di dalam sebuah objek (TP ke objek, pindah kalau promptnya jauh)
	local function visitPrompts(container)
		if not container then return 0 end
		local list = {}
		if container:IsA("ProximityPrompt") then list[1] = container end
		for _, d in ipairs(container:GetDescendants()) do
			if d:IsA("ProximityPrompt") and d.Enabled then list[#list + 1] = d end
		end
		local base = posOf(container)
		local cur = base
		if base then
			tp(base, true)
			task.wait(delayTP)
		end
		local n = 0
		for _, p in ipairs(list) do
			local pp = posOf(p.Parent)
			if pp and (not cur or (pp - cur).Magnitude > 15) then
				tp(pp, true)
				cur = pp
				task.wait(delayTP)
			end
			if firePrompt(p) then n = n + 1 end
			task.wait(delayAfter)
		end
		return n
	end

	local function pumpkinCycle()
		waitPause()
		local penjaga = workspace:FindFirstChild("PenjagaLabu")
		if not penjaga then
			st.Text = "Labu: PenjagaLabu tidak ketemu"
			task.wait(1)
			return
		end
		st.Text = "Labu: ke PenjagaLabu..."
		local n = visitPrompts(penjaga)
		if not pumpkinOn then return end
		waitPause()
		local pk = workspace:FindFirstChild("PUMPKIN")
		if not pk then
			st.Text = "Labu: PUMPKIN tidak ketemu"
			task.wait(1)
			return
		end
		st.Text = (n > 0) and "Labu: ke PUMPKIN..." or "Labu: (tanpa prompt) ke PUMPKIN..."
		local m = visitPrompts(pk)
		st.Text = "Labu: selesai (" .. m .. " prompt)"
		task.wait(0.4)
	end

	local function togglePumpkin()
		pumpkinOn = not pumpkinOn
		if pumpkinOn then kurirOn, baksoOn = false, false end
		paint()
		if not pumpkinOn then return end
		pumpkinRun = pumpkinRun + 1
		local my = pumpkinRun
		task.spawn(function()
			while pumpkinOn and pumpkinRun == my do
				pumpkinCycle()
			end
			if pumpkinRun == my then st.Text = "Misi labu OFF" end
		end)
	end

	------------------------------------------------------------
	-- AUTO CLAIM MEME: TP ke meme -> pencet prompt -> TP balik ke tempat semula
	------------------------------------------------------------
	local function claimMeme()
		local meme = workspace:FindFirstChild("meme baru 8")
		if not meme then
			st.Text = "Meme tidak ketemu"
			return false
		end
		pauseJobs = true
		task.wait(0.5) -- biar langkah job yang sedang jalan selesai dulu
		local root = getRoot()
		if not root then
			pauseJobs = false
			return false
		end
		local back = root.CFrame
		st.Text = "Meme: klaim..."
		local n = visitPrompts(meme)
		root = getRoot()
		if root then root.CFrame = back end
		pauseJobs = false
		st.Text = (n > 0) and "Meme diklaim, kembali" or "Meme: tidak ada prompt"
		return n > 0
	end

	local function toggleMeme()
		memeOn = not memeOn
		paint()
		if not memeOn then return end
		memeRun = memeRun + 1
		local my = memeRun
		task.spawn(function()
			while memeOn and memeRun == my do
				claimMeme()
				local t0 = tick()
				while memeOn and memeRun == my and tick() - t0 < memeInterval do task.wait(0.2) end
			end
			if memeRun == my then st.Text = "Auto meme OFF" end
		end)
	end

	------------------------------------------------------------
	-- ANTI GAMEPLAY PAUSED (hanya untuk mencegah game "pause" karena streaming)
	------------------------------------------------------------
	local function applyAntiPause()
		pcall(function()
			if typeof(sethiddenproperty) == "function" then
				sethiddenproperty(workspace, "StreamingPauseMode", Enum.StreamingPauseMode.Disabled)
			else
				workspace.StreamingPauseMode = Enum.StreamingPauseMode.Disabled
			end
		end)
	end

	local function hidePauseUi()
		local roots = {}
		local pgui = lp:FindFirstChild("PlayerGui")
		if pgui then roots[#roots + 1] = pgui end
		pcall(function() roots[#roots + 1] = game:GetService("CoreGui") end)
		for _, r in ipairs(roots) do
			pcall(function()
				for _, d in ipairs(r:GetDescendants()) do
					if (d:IsA("TextLabel") or d:IsA("TextButton")) and not d:IsDescendantOf(gui) then
						local t = string.lower(d.Text)
						if string.find(t, "gameplay paused", 1, true) or string.find(t, "gameplay is paused", 1, true) then
							local top = d
							while top.Parent and top.Parent ~= r and not top.Parent:IsA("ScreenGui") do
								top = top.Parent
							end
							if top:IsA("GuiObject") then top.Visible = false end
						end
					end
				end
			end)
		end
	end

	local function toggleAnti()
		antiPause = not antiPause
		if antiPause then applyAntiPause() end
		paint()
	end

	task.spawn(function()
		applyAntiPause()
		while true do
			task.wait(0.5)
			if antiPause then
				local paused = false
				pcall(function() paused = lp.GameplayPaused end)
				if paused then
					applyAntiPause()
					local root = getRoot()
					if root then pcall(function() lp:RequestStreamAroundAsync(root.Position, 2) end) end
					hidePauseUi()
				end
			end
		end
	end)

	local function stopAll()
		kurirOn, baksoOn, pumpkinOn, memeOn = false, false, false, false
		paint()
		st.Text = "Semua OFF"
	end

	------------------------------------------------------------
	-- susun tampilan
	------------------------------------------------------------
	section("KURIR")
	mkSwitch("AUTO KURIR", function() return kurirOn end, toggleKurir)
	section("BAKSO")
	mkWide("TP GEROBAK (manual)", C(60, 120, 215), tpGerobak)
	mkSwitch("AUTO LAYANI BAKSO", function() return baksoOn end, toggleBakso)
	section("MISI LABU")
	mkSwitch("AUTO MISI LABU", function() return pumpkinOn end, togglePumpkin)
	section("MEME")
	mkSwitch("AUTO CLAIM MEME", function() return memeOn end, toggleMeme)
	mkWide("CLAIM MEME SEKARANG", C(190, 120, 40), function() task.spawn(claimMeme) end)
	mkStepper("JEDA CLAIM MEME (dtk)", function() return memeInterval end, function(v) memeInterval = v end, 1, 300, 1)
	section("ANTI PAUSE")
	mkSwitch("ANTI GAMEPLAY PAUSED", function() return antiPause end, toggleAnti)
	section("PENGATURAN")
	mkStepper("DELAY TP (dtk)", function() return delayTP end, function(v) delayTP = v end, 0.05, 5, 0.05)
	mkStepper("DELAY AKSI (dtk)", function() return delayAfter end, function(v) delayAfter = v end, 0.05, 5, 0.05)
	section("GUI GAME")
	mkPair("BUKA JOB GUI", C(70, 110, 200), function() openGui("JobGui") end, "TUTUP JOB GUI", C(190, 80, 90), function() closeGui("JobGui") end)
	mkWide("STOP SEMUA", C(170, 60, 60), stopAll)

	RunService.Heartbeat:Connect(function()
		if not baksoOn then return end
		if tick() - lastServe < 0.3 then return end
		lastServe = tick()
		serveAll()
	end)

	paint()
	print("[Kerja Hub] Onthel Purwadadi OK")
end

task.spawn(startKerjaHub)

-- buka window dengan animasi saat script jalan
task.defer(function()
	task.wait(0.3)
	setOpen(true)
end)
