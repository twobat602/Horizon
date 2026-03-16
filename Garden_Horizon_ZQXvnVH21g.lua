local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")

Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(0.1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
print("Anti-AFK")
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Garden Horizon",
    ToggleKey = Enum.KeyCode.C,
    Icon = "cat",
    Author = "Twobat",
    Folder = "MyTestHub",

Size = UDim2.fromOffset(400, 300),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = true
})

local Dialog = Window:Dialog({
    Icon = "cat",
    Title = "What's New?",
    Content = "- Added New Harvest\n\n- Added New Seed\n\n- Added New Gear\n",
    Buttons = {
        {
            Title = "Copy Discord Link",
            Callback = function()
                setclipboard("https://discord.gg/9Rxn9uSdFT")
                print("Discord link copied to clipboard!")
            end,
        },
    },
})

Window:Tag({
    Title = "V1",
    Color = Color3.fromHex("#fa0a42")
})

Window:Tag({
    Title = "KEYLESS",
    Color = Color3.fromHex("#03fc52")
})

--TAB

local Main = Window:Tab({
    Title = "Main",
    Icon = "house",
    Locked = false,
})

local Esp = Window:Tab({
    Title = "Esp",
    Icon = "eye",
    Locked = false,
})

local Farm = Window:Tab({
    Title = "Farm",
    Icon = "tractor",
    Locked = false,
})

local Sell = Window:Tab({
    Title = "Sell",
    Icon = "badge-dollar-sign",
    Locked = false,
})

local Shop = Window:Tab({
    Title = "Shop",
    Icon = "shopping-cart",
    Locked = false,
})
local Tp = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
    Locked = false,
})

local Report = Window:Tab({
    Title = "Found Bugs?",
    Icon = "bug",
    Locked = false,
})

--script
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera


-- WalkSpeed Slider
local Slider = Main:Slider({
    Title = "WalkSpeed",
    Step = 1,
    Value = {
        Min = 16,    -- bawal bumaba sa 16
        Max = 120,   -- maximum walk speed
        Default = 16, -- default walk speed
    },
    Callback = function(value)
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

-- JumpPower Slider
local Slider = Main:Slider({
    Title = "JumpPower",
    Step = 1,
    Value = {
        Min = 50,    -- bawal bumaba sa 50
        Max = 200,   -- maximum jump power
        Default = 50, -- default jump power
    },
    Callback = function(value)
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = value
        end
    end
})

local UnliJump = false
local player = game.Players.LocalPlayer
local humanoid

-- Re-assign humanoid sa respawn
local function setupHumanoid(h)
    humanoid = h
end

if player.Character then
    setupHumanoid(player.Character:WaitForChild("Humanoid"))
end

player.CharacterAdded:Connect(function(char)
    setupHumanoid(char:WaitForChild("Humanoid"))
end)

-- Toggle para sa Infinite Jump
local Toggle = Main:Toggle({
    Title = "Unli Jump",
    Desc = "Jump anytime, even in air",
    Icon = "badge-check",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        UnliJump = state
    end
})

-- Infinite Jump Script
game:GetService("UserInputService").JumpRequest:Connect(function()
    if UnliJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local NoClip = false

-- Character references
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Update character references on respawn
player.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Noclip toggle
local Toggle = Main:Toggle({
    Title = "Noclip",
    Desc = "Pass through walls",
    Icon = "badge-check",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        NoClip = state
    end
})
-- Loop para sa Noclip
RunService.RenderStepped:Connect(function()
    if NoClip and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
--teleport to player
local Section = Tp:Section({ 
    Title = "Teleport to player",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})
local selectedPlayer = nil
local function getPlayerNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(names, plr.Name)
        end
    end
    return names
end

-- Dropdown setup
local Dropdown = Tp:Dropdown({ 
    Title = "Players",
    Values = getPlayerNames(),
    Value = "",
    Callback = function(option)
        selectedPlayer = option
        print("Player selected: " .. (selectedPlayer or "None"))
    end
})

-- Teleport Button
Tp:Button({ 
    Title = "Teleport to Player",
    Desc = "Teleport to selected player",
    Locked = false,
    Callback = function()
        if selectedPlayer then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                print("Teleported to: " .. selectedPlayer)
            else
                print("Target player not valid!")
            end
        else
            print("No player selected!")
        end
    end
})

-- Auto-refresh using Player events
Players.PlayerAdded:Connect(function()
    Dropdown:Refresh(getPlayerNames())
end)

Players.PlayerRemoving:Connect(function()
    Dropdown:Refresh(getPlayerNames())
end)
local Section = Tp:Section({ 
    Title = "Teleport to Shop",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})
local player = game.Players.LocalPlayer

local function teleportTo(position)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRoot = character:WaitForChild("HumanoidRootPart")
	humanoidRoot.CFrame = CFrame.new(position)
end

-- 🌱 Teleport to Seed
local Button = Tp:Button({ 
    Title = "Teleport to Seed", 
    Desc = "Go to Seed location",
    Locked = false,
    Callback = function()
        teleportTo(Vector3.new(177, 204, 672))
    end
})

-- ⚙️ Teleport to Gear
local Button = Tp:Button({ 
    Title = "Teleport to Gear", 
    Desc = "Go to Gear location",
    Locked = false,
    Callback = function()
        teleportTo(Vector3.new(211, 204, 608))
    end
})
--sell all
local Section = Sell:Section({ 
    Title = "Auto Sell All",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})
local player = game:GetService("Players").LocalPlayer
local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("SellItems")

local autoSellOnFull = false
local savedCFrame = nil
local selling = false
local movementWasEnabled = false

-- save player position
local function savePosition()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        savedCFrame = player.Character.HumanoidRootPart.CFrame
    end
end

-- tp back
local function tpBack()
    if savedCFrame and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = savedCFrame
    end
end

-- reconnect TP after respawn
player.CharacterAdded:Connect(function()
    task.wait(0.8)
    tpBack()
end)

-- count ALL tools (backpack + equipped)
local function getToolCount()
    local count = 0

    for _, item in player.Backpack:GetChildren() do
        if item:IsA("Tool") then
            count += 1
        end
    end

    if player.Character then
        for _, item in player.Character:GetChildren() do
            if item:IsA("Tool") then
                count += 1
            end
        end
    end

    return count
end

-- SELL FUNCTION (Integrated with movement)
local function sellAll()
    if selling then return end
    selling = true

    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        selling = false
        return
    end

    -- Save movement state
    movementWasEnabled = TPEnabled

    -- Disable movement if it was on
    if TPEnabled and autoMoveToggle then
        autoMoveToggle:Set(false)
        task.wait(0.2)
    end

    savePosition()

    -- TP to sell
    char.HumanoidRootPart.CFrame = CFrame.new(149, 204, 672)
    task.wait(0.4)

    -- Sell all
    remote:InvokeServer("SellAll")
    task.wait(1)

    -- TP back
    tpBack()
    task.wait(0.6)

    -- Restore movement
    if movementWasEnabled and autoMoveToggle then
        autoMoveToggle:Set(true)
    end

    selling = false
end

-- ONE TOGGLE
Sell:Toggle({
    Title = "Auto Sell All",
    Desc = "Auto sell all if backpack is full",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        autoSellOnFull = state
    end
})

-- AUTO CHECK LOOP (pa-pause movement)
task.spawn(function()
    while true do
        task.wait(0.5)

        if selling then continue end
        if not autoSellOnFull then continue end

        local totalTools = getToolCount()
        if totalTools >= 300 then
            print("Backpack Full")
            sellAll()
        end
    end
end)
--shop
local Section = Shop:Section({ 
    Title = "Auto Buy Seed/Gear",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})
local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Selected items
local SelectedSeeds = {}
local SelectedGear = {}

-- Toggles
local AutoBuySeeds = false
local AutoBuyGear = false

-- Movement & TP
local buying = false
local savedCFrame = nil
local movementWasEnabled = false

local SeedShopCFrame = CFrame.new(177, 204, 672)
local GearShopCFrame = CFrame.new(212, 204, 609)

-- 🔽 DROPDOWN: Select Seeds
local DropdownSeeds = Shop:Dropdown({ 
    Title = "Buy Seed", 
    Desc = "Select Seeds",
    Values = { 
        "Carrot Seed","Corn Seed","Onion Seed","Strawberry Seed","Mushroom Seed",
        "Beetroot Seed","Tomato Seed","Apple Seed","Rose Seed","Wheat Seed",
        "Banana Seed","Plum Seed","Potato Seed","Cabbage Seed","Cherry Seed",
        "Bamboo Seed","Mango Seed", "Watermelon Seed", "Pineapple Seed"
    },
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        if typeof(option) == "table" then
            SelectedSeeds = option
        else
            SelectedSeeds = {option}
        end
    end
})

-- 🔽 DROPDOWN: Select Gear
local DropdownGear = Shop:Dropdown({ 
    Title = "Buy Gear", 
    Desc = "Select Gear",
    Values = { 
        "Watering Can",
        "Basic Sprinkler",
        "Harvest Bell",
        "Turbo Sprinkler",
        "Favorite Tool",
        "Super Sprinkler",
        "Trowel",
	"Reverter"
    },
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        if typeof(option) == "table" then
            SelectedGear = option
        else
            SelectedGear = {option}
        end
    end
})

-- 🔘 TOGGLES
local ToggleSeeds = Shop:Toggle({ 
    Title = "Auto Buy Seeds", 
    Desc = "Automatically buys selected seeds",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        AutoBuySeeds = state
    end
})

local ToggleGear = Shop:Toggle({ 
    Title = "Auto Buy Gear", 
    Desc = "Automatically buys selected gear",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
        AutoBuyGear = state
    end
})

-- Helper: Get stock
local function getStock(shopName, itemName)
    local gui = player.PlayerGui:FindFirstChild(shopName)
    if not gui then return 0 end
    local frame = gui:FindFirstChild("Frame")
    if not frame then return 0 end
    local scrolling = frame:FindFirstChild("ScrollingFrame")
    if not scrolling then return 0 end

    local nameKey = shopName == "SeedShop" and itemName:gsub(" Seed","") or itemName
    local itemFrame = scrolling:FindFirstChild(nameKey)
    if not itemFrame then return 0 end

    local mainInfo = itemFrame:FindFirstChild("MainInfo")
    if not mainInfo then return 0 end

    local stockText = mainInfo:FindFirstChild("StockText")
    if not stockText then return 0 end

    local text = stockText.Text
    if text == "NO STOCK" then return 0 end
    local num = tonumber(text:match("%d+"))
    return num or 0
end

-- Combined Buy Function with Movement Control
local function buyItems()
    if buying then return end
    buying = true

    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        buying = false
        return
    end

    -- Save movement state (will restore later)
    movementWasEnabled = TPEnabled

    -- Check if any stock exists
    local shopsQueue = {}

    if AutoBuySeeds and #SelectedSeeds > 0 then
        local anyStock = false
        for _, s in ipairs(SelectedSeeds) do
            if getStock("SeedShop", s) > 0 then
                anyStock = true
                break
            end
        end
        if anyStock then table.insert(shopsQueue, {shop="SeedShop", items=SelectedSeeds, pos=SeedShopCFrame}) end
    end

    if AutoBuyGear and #SelectedGear > 0 then
        local anyStock = false
        for _, g in ipairs(SelectedGear) do
            if getStock("GearShop", g) > 0 then
                anyStock = true
                break
            end
        end
        if anyStock then table.insert(shopsQueue, {shop="GearShop", items=SelectedGear, pos=GearShopCFrame}) end
    end

    if #shopsQueue > 0 then
        -- Disable movement while buying
        if TPEnabled and autoMoveToggle then
            autoMoveToggle:Set(false)
            task.wait(0.2)
        end

        -- Save original position
        savedCFrame = char.HumanoidRootPart.CFrame

        for _, shopData in ipairs(shopsQueue) do
            char.HumanoidRootPart.CFrame = shopData.pos
            task.wait(0.4)

            while true do
                local anyStock = false
                for _, itemName in ipairs(shopData.items) do
                    local stock = getStock(shopData.shop, itemName)
                    if stock > 0 then
                        anyStock = true
                        pcall(function()
                            ReplicatedStorage.RemoteEvents.PurchaseShopItem:InvokeServer(shopData.shop, itemName)
                        end)
                        task.wait(0.1)
                    end
                end
                if not anyStock then break end
                task.wait(0.3)
            end

            task.wait(0.4)
        end

        -- TP back after all shops processed
        char.HumanoidRootPart.CFrame = savedCFrame
        task.wait(0.6)
    end

    -- Restore movement **ONLY IF no stock left in any shop**
    local seedStockLeft = false
    for _, s in ipairs(SelectedSeeds) do
        if getStock("SeedShop", s) > 0 then
            seedStockLeft = true
            break
        end
    end
    local gearStockLeft = false
    for _, g in ipairs(SelectedGear) do
        if getStock("GearShop", g) > 0 then
            gearStockLeft = true
            break
        end
    end

    if not seedStockLeft and not gearStockLeft then
        if movementWasEnabled and autoMoveToggle then
            autoMoveToggle:Set(true)
        end
    end

    buying = false
end

-- AUTO BUY LOOP (combined)
task.spawn(function()
    while true do
        task.wait(0.5)
        if (AutoBuySeeds and #SelectedSeeds > 0) or (AutoBuyGear and #SelectedGear > 0) then
            buyItems()
        end
    end
end)
--farm
local Section = Farm:Section({ 
    Title = "Auto Harvest",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local ClientPlants = workspace:WaitForChild("ClientPlants")

local selectedPlants = {}
local selectedStages = {}
local autoHarvest = false

-- Function para i-check ang Stage (Galing sa logic mo)
local function stageMatch(inst)
    if #selectedStages == 0 then return false end
    
    local stage = inst:GetAttribute("RipenessStage") 
               or (inst:FindFirstChild("RipenessStage") and inst.RipenessStage.Value)

    if not stage then return false end

    for _, selected in ipairs(selectedStages) do
        if tostring(stage) == selected then
            return true
        end
    end
    return false
end
Farm:Dropdown({
    Title = "Select Plants",
    Values = { 
    "Carrot", "Corn", "Onion", "Strawberry", "Mushroom", 
    "Beetroot", "Tomato", "Apple", "Rose", "Wheat", 
    "Banana", "Plum", "Potato", "Cabbage", "Cherry", 
    "Dawnfruit", "Sunpetal", "Goldenberry", "Amberpine", "Emberwood", 
    "Dawnblossom", "Dandelion", "Bellpepper", "Birch", "Orange", 
    "Olive", "Bamboo", "Mango", "Watermelon", "Pineapple", 
    "Biohazard Melon", "Lablush Berry", "Starvine", "Radiant Petal", "Octobranch", 
    "Twisted Sunflower", "Glowcorn", "Bluerose", "Firefern", "Titan Bloom", 
    "Glowvein", "Lostlight", "Roundmelon", "Inferno Pepper", "Glowflower"
},
    Multi = true,
    Callback = function(option) selectedPlants = option end
})

Farm:Dropdown({
    Title = "Select Stage",
    Values = { "Unripe", "Ripe", "Lush" },
    Multi = true,
    Callback = function(option) selectedStages = option end
})

-- Reset function para ibalik sa dati lahat ng prompts
local function resetAllPrompts()
    for _, v in ipairs(ClientPlants:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v.MaxActivationDistance = 0
        end
    end
end

Farm:Toggle({
    Title = "Auto Harvest",
    Value = false,
    Callback = function(state) 
        autoHarvest = state 
        if not state then
            resetAllPrompts()
        end
    end
})

-- TP & Hide Logic Loop
task.spawn(function()
    while true do
        if autoHarvest then
            for _, plant in ipairs(ClientPlants:GetChildren()) do
                -- Kunin ang base name (e.g., Corn1 -> Corn)
                local baseName = plant.Name:match("^[^%d]+")
                
                -- Check kung ang type ng plant ay selected
                local isTypeSelected = false
                for _, selected in ipairs(selectedPlants) do
                    if baseName == selected then
                        isTypeSelected = true
                        break
                    end
                end

                -- Check Ripeness (Main Model o Descendants)
                local isStageSelected = stageMatch(plant)
                if not isStageSelected then
                    for _, desc in ipairs(plant:GetDescendants()) do
                        if stageMatch(desc) then
                            isStageSelected = true
                            break
                        end
                    end
                end

                -- ACTION: Kung Match ang Type at Stage, i-TP. Kung HINDI, i-HIDE.
                if isTypeSelected and isStageSelected then
                    for _, v in ipairs(plant:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then
                            v.MaxActivationDistance = 200
                            if v.Parent:IsA("BasePart") then
                                v.Parent.CFrame = hrp.CFrame
                            end
                        end
                    end
                else
                    -- I-hide ang prompts ng hindi selected o hindi match na plants
                    for _, v in ipairs(plant:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then
                            v.MaxActivationDistance = 0
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- Auto Clicker para sa Harvest Button
task.spawn(function()
    while true do
        if autoHarvest then
            local gui = player.PlayerGui:FindFirstChild("HarvestButton")
            local btn = gui and gui:FindFirstChild("HarvestButton", true)
            if btn and btn.Visible then
                firesignal(btn.MouseButton1Down)
                task.wait(0.001)
                firesignal(btn.MouseButton1Up)
            end
        end
        task.wait(0.01)
    end
end)
--farm3
local Section = Farm:Section({ 
    Title = "Auto Plant",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlantSeedRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("PlantSeed")

local selectedSeeds = {}
local plantingMode = "Player Position"
local autoPlantEnabled = false
local currentEquippedSeed = nil

local character = nil
local hrp = nil
local humanoid = nil

local plantSpots = {} -- lahat ng Parts sa PlantableAreas ng player

-- Setup character references
local function setupCharacter(char)
    character = char
    hrp = char:WaitForChild("HumanoidRootPart", 8)
    humanoid = char:WaitForChild("Humanoid", 8)
end

if player.Character then setupCharacter(player.Character) end
player.CharacterAdded:Connect(setupCharacter)

-- Load lahat ng Parts mula sa PlantableAreas ng player
local function loadPlantSpots()
    plantSpots = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end

    for _, plot in ipairs(plots:GetChildren()) do
        local ownerValue = plot:FindFirstChild("Owner")
        if ownerValue and ownerValue:IsA("StringValue") and ownerValue.Value == player.Name then
            local area = plot:FindFirstChild("PlantableArea")
            if area then
                for _, child in ipairs(area:GetChildren()) do
                    if child:IsA("BasePart") then
                        table.insert(plantSpots, child)
                    end
                end
            end
        end
    end
end

-- Generate random position sa loob ng isang Part
local function getRandomPositionInPart(part)
    local size = part.Size
    local cf = part.CFrame
    local x = (math.random() - 0.5) * size.X
    local z = (math.random() - 0.5) * size.Z
    local y = part.Position.Y + size.Y/2
    return cf:PointToWorldSpace(Vector3.new(x, 0, z))
end

-- Equip seed tool
local function ensureToolEquipped(seedName)
    if not humanoid or not character then return false end
    
    local currentTool = character:FindFirstChildWhichIsA("Tool")
    if not currentTool or (currentEquippedSeed and not currentTool.Name:sub(-#currentEquippedSeed) == currentEquippedSeed) then
        local backpack = player:WaitForChild("Backpack")
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:sub(-#seedName) == seedName then
                humanoid:EquipTool(tool)
                task.wait(0.12)
                return true
            end
        end
        return false
    end
    
    return true
end

-- Plant seed sa given position
local function tryPlant(seedName, position)
    if not currentEquippedSeed or currentEquippedSeed ~= seedName then
        currentEquippedSeed = seedName
    end
    
    if ensureToolEquipped(seedName) then
        local seedType = seedName:gsub(" Seed$", "")
        pcall(function()
            PlantSeedRemote:InvokeServer(seedType, position)
        end)
    end
end

local plantingConnection

-- Start auto planting
local function startPlanting()
    if plantingConnection then plantingConnection:Disconnect() end
    currentEquippedSeed = nil
    
    if plantingMode == "Random" then
        loadPlantSpots()
    end
    
    plantingConnection = RunService.Heartbeat:Connect(function()
        if not autoPlantEnabled then return end
        if #selectedSeeds == 0 then return end
        if not hrp or not humanoid then return end
        
        local seedName = selectedSeeds[math.random(1, #selectedSeeds)]
        local targetPos
        
        if plantingMode == "Random" and #plantSpots >= 1 then
            local part = plantSpots[math.random(1, #plantSpots)]
            targetPos = getRandomPositionInPart(part)
        else
            targetPos = hrp.Position + Vector3.new(0, -2.8, 0)
        end
        
        tryPlant(seedName, targetPos)
        task.wait(0.1)
    end)
end

local function stopPlanting()
    autoPlantEnabled = false
    if plantingConnection then
        plantingConnection:Disconnect()
        plantingConnection = nil
    end
    currentEquippedSeed = nil
end

-- Seed selection dropdown
Farm:Dropdown({
    Title = "Select Plant",
    Values = { "Carrot Seed","Corn Seed","Onion Seed","Strawberry Seed","Mushroom Seed",
        "Beetroot Seed","Tomato Seed","Apple Seed","Rose Seed","Wheat Seed",
        "Banana Seed","Plum Seed","Potato Seed","Cabbage Seed","Cherry Seed",
        "Dawnfruit Seed","Sunpetal Seed","Goldenberry Seed","Amberpine Seed",
        "Emberwood Seed","Dawnblossom Seed","Dandelion Seed","Bellpepper Seed",
        "Birch Seed","Orange Seed","Olive Seed","Bamboo Seed","Mango Seed","Biohazard Melon Seed","Lablush Berry Seed","Starvine Seed","Radiant Petal Seed","Octobranch Seed",
"Twisted Sunflower Seed", "Glowcorn Seed", "Bluerose Seed", "Firefern Seed", "Titan Bloom Seed", "Glowvein Seed", "Lostlight Seed", "Roundmelon Seed", "Inferno Pepper Seed", "Glowflower Seed", "Bluerose"
 },
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        selectedSeeds = {}
        for _, v in ipairs(option or {}) do
            if v and v ~= "" then
                table.insert(selectedSeeds, v)
            end
        end
    end
})

-- Planting mode dropdown
Farm:Dropdown({
    Title = "Select Planting Mode",
    Values = { "Player Position", "Random"},
    Value = "Player Position",
    Callback = function(option)
        plantingMode = option
        if autoPlantEnabled and plantingMode == "Random" then
            loadPlantSpots()
        end
    end
})

-- Auto Plant toggle
Farm:Toggle({
    Title = "Auto Plant",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        autoPlantEnabled = state
        if state then
            startPlanting()
        else
            stopPlanting()
        end
    end
})
--esp
local Section = Esp:Section({ 
    Title = "Esp for Plant",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})
local RunService = game:GetService("RunService")
local Workspace = game.Workspace
local ClientPlants = Workspace:WaitForChild("ClientPlants", 10)

if not ClientPlants then return end

local selectedPlants = {}
local showInfo = false
local drawings = {}

local Dropdown = Esp:Dropdown({
    Title = "Select Plants",
    Values = {
        "Carrot", "Corn", "Onion", "Strawberry", "Mushroom", "Beetroot",
        "Tomato", "Apple", "Rose", "Wheat", "Banana", "Plum", "Potato",
        "Cabbage", "Cherry", "Dawnfruit", "Sunpetal", "Goldenberry",
        "Amberpine", "Emberwood", "Dawnblossom", "Dandelion", "Bellpepper",
        "Birch", "Orange", "Olive","Bamboo","Mango","Biohazard Melon","Lablush Berry","Starvine","Radiant Petal","Octobranch" },
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        selectedPlants = option or {}
    end
})

local Toggle = Esp:Toggle({
    Title = "Plant ESP",
    Icon = "eye",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        showInfo = state
        if not state then
            for _, txt in pairs(drawings) do
                if txt then txt.Visible = false end
            end
        end
    end
})

RunService.RenderStepped:Connect(function()
    if not showInfo or #selectedPlants == 0 then return end

    local currentKeys = {}

    for _, plantType in ipairs(selectedPlants) do
        for _, plant in ipairs(ClientPlants:GetChildren()) do
            if not plant:IsA("Model") then continue end
            if not string.match(plant.Name, "^" .. plantType .. "%d*$") then continue end

            local fruits = {}
            for _, child in ipairs(plant:GetChildren()) do
                if child.Name == "Fruit" or child.Name:match("^Fruit%d+$") then
                    table.insert(fruits, child)
                end
            end

            if #fruits > 0 then
                -- May Fruit children → per Fruit
                for _, fruit in ipairs(fruits) do
                    local key = fruit
                    currentKeys[key] = true

                    local ripeness = fruit:GetAttribute("RipenessStage") or "?"
                    local variant  = fruit:GetAttribute("Variant")
                    local mutation = fruit:GetAttribute("Mutation")
                    local weight   = fruit:GetAttribute("FruitWeight")

                    local parts = {}
                    if variant and variant ~= "" then
                        table.insert(parts, "Var: " .. tostring(variant))
                    end
                    table.insert(parts, tostring(ripeness))
                    if mutation and mutation ~= "" and mutation:lower() ~= "none" then
                        table.insert(parts, "Mut: " .. tostring(mutation))
                    end
                    if weight and typeof(weight) == "number" then
                        table.insert(parts, string.format("%.2fKg", weight))
                    end

                    local displayText = plant.Name .. " (" .. fruit.Name .. ")\n" .. table.concat(parts, "  •  ")

                    local txt = drawings[key]
                    if not txt then
                        txt = Drawing.new("Text")
                        txt.Size = 16
                        txt.Color = Color3.fromRGB(200, 255, 200)
                        txt.Outline = true
                        txt.OutlineColor = Color3.fromRGB(0, 0, 0)
                        txt.Center = true
                        txt.Font = 2
                        drawings[key] = txt
                    end

                    local rootPart = fruit:FindFirstChildWhichIsA("BasePart") or plant.PrimaryPart or plant:FindFirstChildWhichIsA("BasePart")
                    if rootPart then
                        local cam = workspace.CurrentCamera
                        local worldPos = rootPart.Position + Vector3.new(0, 3, 0)
                        local screenPos, onScreen = cam:WorldToViewportPoint(worldPos)
                        if onScreen then
                            txt.Position = Vector2.new(screenPos.X, screenPos.Y)
                            txt.Text = displayText
                            txt.Visible = true
                        else
                            txt.Visible = false
                        end
                    else
                        txt.Visible = false
                    end
                end
            else
                -- Walang Fruit → model mismo (PlantWeight)
                local key = plant
                currentKeys[key] = true

                local ripeness = plant:GetAttribute("RipenessStage") or "?"
                local variant  = plant:GetAttribute("Variant")
                local mutation = plant:GetAttribute("Mutation")
                local weight   = plant:GetAttribute("PlantWeight")

                local parts = {}
                if variant and variant ~= "" then
                    table.insert(parts, "Var: " .. tostring(variant))
                end
                table.insert(parts, tostring(ripeness))
                if mutation and mutation ~= "" and mutation:lower() ~= "none" then
                    table.insert(parts, "Mut: " .. tostring(mutation))
                end
                if weight and typeof(weight) == "number" then
                    table.insert(parts, string.format("%.2fKg", weight))
                end

                local displayText = plant.Name .. "\n" .. table.concat(parts, "  •  ")

                local txt = drawings[key]
                if not txt then
                    txt = Drawing.new("Text")
                    txt.Size = 17
                    txt.Color = Color3.fromRGB(220, 255, 220)
                    txt.Outline = true
                    txt.OutlineColor = Color3.fromRGB(10, 10, 10)
                    txt.Center = true
                    txt.Font = 2
                    drawings[key] = txt
                end

                local rootPart = plant.PrimaryPart or plant:FindFirstChildWhichIsA("BasePart")
                if rootPart then
                    local cam = workspace.CurrentCamera
                    local worldPos = rootPart.Position + Vector3.new(0, 5, 0)
                    local screenPos, onScreen = cam:WorldToViewportPoint(worldPos)
                    if onScreen then
                        txt.Position = Vector2.new(screenPos.X, screenPos.Y - 10)
                        txt.Text = displayText
                        txt.Visible = true
                    else
                        txt.Visible = false
                    end
                else
                    txt.Visible = false
                end
            end
        end
    end

    for key, txt in pairs(drawings) do
        if not currentKeys[key] then
            txt.Visible = false
        end
    end
end)
--report bugs
local HttpService = game:GetService("HttpService")
local JobId = game.JobId
local WEBHOOK_URL = "https://discord.com/api/webhooks/1414334688117522463/XDC1GAn1aafkxRcgIM8lSW7dBwhum0uQFl31iX4OD7UgErYsw-vjziBH3NBECnywePxZ"
local COOLDOWN_TIME = 30
local cooldown = false

-- store input values
local reportTitle = ""
local reportDesc = ""

-- Inputs inside Report tab
local TitleInput = Report:Input({
    Title = "Title",
    Desc = "Report Title",
    Type = "Input",
    Placeholder = "Enter title...",
    Callback = function(val)
        reportTitle = tostring(val or "")
    end
})

local DescInput = Report:Input({
    Title = "Description",
    Desc = "Report Description",
    Type = "Textarea",
    Placeholder = "Enter description...",
    Callback = function(val)
        reportDesc = tostring(val or "")
    end
})

-- Executor-compatible request
local requestFunc = request or http_request or syn and syn.request

local function SendToDiscord(message)
    if not requestFunc then
        WindUI:Notify({ Title = "Error", Content = "No HTTP request function available.", Duration = 3 })
        return false
    end

    local ok, res = pcall(function()
        return requestFunc({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ content = message })
        })
    end)

    if not ok then return false end

    if type(res) == "table" and res.StatusCode == 429 then
        WindUI:Notify({ Title = "Rate Limited", Content = "Discord rate limited.", Duration = 4 })
        return false
    end

    return true
end

-- Submit button inside Report tab
local SubmitBtn = Report:Button({
    Title = "Submit",
    Desc = "Send your report",
    Locked = false,
    Callback = function(self)
        if cooldown then
            WindUI:Notify({ Title = "Wait", Content = "Cooldown!", Duration = 3 })
            return
        end

        if reportTitle == "" or reportDesc == "" then
            WindUI:Notify({ Title = "Error", Content = "Fill in both title and description!", Duration = 3 })
            return
        end

        local message = "**Title:** " .. reportTitle .. "\n**Description:** " .. reportDesc .. "\n**JobId:** " .. JobId
        local sent = SendToDiscord(message)

        if sent then
            WindUI:Notify({ Title = "Report Sent", Content = "Successfully sent!", Duration = 3 })
            
            -- clear inputs
            reportTitle = ""
            reportDesc = ""
            TitleInput:Set("")
            DescInput:Set("")

            -- start cooldown
            cooldown = true
            self.Locked = true
            task.spawn(function()
                for i = COOLDOWN_TIME, 1, -1 do
                    SubmitBtn:SetText("Cooldown: " .. i .. "s")
                    task.wait(1)
                end
                SubmitBtn:SetText("Submit")
                self.Locked = false
                cooldown = false
            end)
        else
            WindUI:Notify({ Title = "Error", Content = "Failed to send report.", Duration = 3 })
        end
    end
})
