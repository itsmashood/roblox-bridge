if not getgenv then while true do end end
if not (request or http_request or (syn and syn.request)) then while true do end end

version = "v1.9.1"
print("RUN BEGIN: Xyneria X Patuxet Revival ".. version)
local TeleportService = game:GetService("TeleportService")
local u0 = task.wait
if game:IsLoaded() then else game.Loaded:Wait() end
local TextChatService = game:GetService("TextChatService")

local ClientData
repeat
    task.wait(0.5)
    pcall(function()
        ClientData = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
    end)
until ClientData

local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
local found = false
local plr = game.Players.LocalPlayer

local genv = getgenv()
genv.patxdebug = false
if genv.patxdebug then warn("Xyneria X Patuxet Revival - House Helper is running in debug mode.")

else
    if genv.patxhousehelperrunning then
        warn("Xyneria X Patuxet Revival - House Helper is already running! Rejoin if you want to use the script.") return
        else genv.patxhousehelperrunning = true
    end
end

genv.onMinimizedChanged = (function(state) end) --empty placeholder 

local buttonExists = (function()
    local newsApp = playerGui:FindFirstChild("NewsApp")
    if newsApp and newsApp.Enabled == true then
        local button = newsApp:FindFirstChild("EnclosingFrame")
            and newsApp.EnclosingFrame:FindFirstChild("MainFrame")
            and newsApp.EnclosingFrame.MainFrame:FindFirstChild("Buttons")
            and newsApp.EnclosingFrame.MainFrame.Buttons:FindFirstChild("PlayButton")
        return button
    end
    return nil
end)

repeat task.wait(0.5) until plr.Character or buttonExists()

local button = buttonExists()
if button then
    firesignal(button.MouseButton1Down)
    task.wait(0.2)
    firesignal(button.MouseButton1Click)
    found = true
end

task.wait(0.5)
local character = plr.Character or plr.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

repeat task.wait(0.5) until game:GetService("Players").LocalPlayer.PlayerGui.ToolApp.Frame.Visible == true
task.wait(0.5)
local posOnJoin = character.HumanoidRootPart.Position
-- humanoid:MoveTo(character.HumanoidRootPart.Position - Vector3.new(0, 0, 17))
task.wait(0.3)

local VirtualUser = game:GetService("VirtualUser")
plr.Idled:Connect(function()
    print("idle ended")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local methods = {
    ["Baseless"] = 1,
    ["Frost"] = 1.176,
    ["RidePotion"] = 0.007
}

local valuesTbl = {
    ["message"] = {nil, "💫 Trading a nice looking home! 🧸 Come through the magic door to see! 👀✨"},
    ["autosendActive"] = {"xh-tab/quickfunctions", false},
    ["autoplaceDoorActive"] = {"xh-tab/quickfunctions", false},
    ["autoServerHopActive"] = {"xh-tab/quickfunctions", false},
    ["autoPutHouseOnSale"] = {"xh-tab/quickfunctions", false},
    ["timesSent"] = {"xh-tab/quickfunctions", 15},
    ["durationBetween"] = {"xh-tab/quickfunctions", 20},
    ["magicdooruid"] = {nil, {}},
    ["autoAcceptActive"] = {"xh-tab/quickfunctions", false},
    ["minimumPlayers"] = {nil, 20},
    ["minimumPlayersActive"] = {"xh-tab/quickfunctions", false},
    ["autoplaceatplot"] = {nil, {}},
    ["autoplaceatplotActive"] = {nil, false},
    ["screenPos"] = {nil, nil},
    ["autopartyActive"] = {nil, false},
    ["autopartyTitle"] = {nil, "🌸 Trading cute home 💖"},
    ["autopartyBody"] = {nil, "Looking for good offer! 🌟 Come to my house to offer"},
    ["method"] = {nil, methods["RidePotion"]},
    ["valueToAccept"] = {nil, 10},
    ["autoacceptatvalueActive"] = {nil, false},
    ["useCompactUI"] = {nil, false},
    ["minimized"] = {nil, false},
    ["useWebhook"] = {nil, false},
    ["webhook"] = {nil, nil},
    ["pingUserId"] = {nil, nil},
    ["pingOnImportant"] = {nil, false},
    ["maximumItemsInTrade"] = {nil, 18},
    ["inactivityToDecline"] = {nil, 120},
    ["inactivitydeclineActive"] = {nil, false},
    ["ignoremeganeonsActive"] = {nil, false},
    ["hideplayersandpetsActive"] = {nil, false},
    ["acceptdelay"] = {nil, 2},
    ["ignorerarities"] = {nil, {}},
    ["replies"] = {nil, {
	chats = {
        ["hi"] = {
			maxCount = 1,
			"Hii!! make an offer for my house <3, i am looking for 10 val!",
			"Hello pls make a good offer",
			function() QuickChat("lets_trade") end,
		},
		["hii"] = {
			maxCount = 1,
			"hiii! make an offer and i'll see if i like",
			"hii! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
		["hiii"] = {
			maxCount = 1,
			"hii! make an offer and i will see if i like",
			"hii! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
		["hiiii"] = {
			maxCount = 1,
			"hiii! make an offer and i'll see if i like",
			"helloo! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
		["hiiiii"] = {
			maxCount = 1,
			"helloo! make an offer and i'll see if i like",
			"hii! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
        ["pick"] = {
			maxCount = 1,
			"I don't pick sorry, pls make an offer",
		},
        ["my inv"] = {
			maxCount = 1,
			"I don't pick from inv sorry!",
			"i'm really bad at picking 😭 can you js try your best",
		},
        ["from inv"] = {
			maxCount = 1,
			"I don't pick from inv sorry",
		},
        ["lf"] = {
			maxCount = 1,
			"I'm lf for 10 value elve",
			"I'm looking for 10 val! I use elve",
		},
        ["looking for"] = {
			maxCount = 1,
			"I'm looking for 10 value elve",
		},
        ["cloned"] = {
			maxCount = 1,
			"This house isn't cloned",
			"Bruh 😭 well how am I supposed to know",
			"I dont think it is",
		},
		["bot"] = {
			maxCount = 2,
			"What?",
			"Bruh what",
			"Wdym",
		},
		["script"] = {
			maxCount = 2,
			"huh???",
			"?",
			"What is that",
		}
	},
		
	actions = {
        value_met = {
			maxCount = 2,
			function() QuickChat("lets_do_it") end,
		},
        value_not_met_accepted = {
			"i don't take underpay",
			maxCount = 2, 
			function() QuickChat("add") end,
		},
        mega_in_trade = {
			maxCount = 1,
			"Can you try not to add megas, if not its ok!",
			"can you switch megas",
		},
        blacklisted_in_trade = {
			maxCount = 1,
			"can you replace the randoms",
			"Change the randoms?",
		}
	}
}
},
    ["repliesActive"] = {nil, false},
    ["hideusernamesActive"] = {nil, false},
    ["humanizedmovementActive"] = {nil, false},
    ["movetoPos"] = {nil, {X = 0, Y = 0, Z = 17}},
    ["moveTime"] = {nil, 30},
    ["repliesSource"] = {nil, ""},
    ["hopAfterTrade"] = {nil, true},
    ["deleteall"] = {nil, false},
    ["fpscap"] = {nil, 60},
    ["ignorebelowvalue"] = {nil, 0},
    ["tradeHubActive"] = {nil, false}
}

local blacklist = {
    ["Birthday Cake"] = true,
    ["Hat"] = true
}

--------------------------------------------------------------------------------
-- STATE MANAGEMENT
--------------------------------------------------------------------------------
local TradeState = {
    Me = { items = {}, total = 0, pendingQueue = {} },
    Them = { items = {}, total = 0, pendingQueue = {} },
    Active = false,
    ReplyCounts = {} -- Tracks: [key] = count
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local API = ReplicatedStorage:WaitForChild("API")
local Fsys = require(ReplicatedStorage:WaitForChild("Fsys"))
local RouterClient = Fsys.load("RouterClient")

local getFriendlyToHashedMapping = (function()
    local mapping = {}
    local candidates = {RouterClient.init}
    for _, v in pairs(RouterClient) do
        if typeof(v) == "function" then
            table.insert(candidates, v)
        end
    end
    for _, func in ipairs(candidates) do
        local success, upvalues = pcall(debug.getupvalues, func)
        if success then
            for i, uv in ipairs(upvalues) do
                if typeof(uv) == "table" then
                    local found = false
                    for friendlyPath, remoteInst in pairs(uv) do
                        if typeof(friendlyPath) == "string"
                            and friendlyPath:find("/")
                            and typeof(remoteInst) == "Instance"
                            and (remoteInst:IsA("RemoteEvent") or remoteInst:IsA("RemoteFunction"))
                            and remoteInst.Parent == API then
                            found = true
                            mapping[friendlyPath] = remoteInst.Name
                        end
                    end
                    if found then
                        return mapping
                    end
                end
            end
        end
    end
    warn("Could not locate the mapping table in upvalues")
    return {}
end)

local remotes = getFriendlyToHashedMapping()
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local inTrade = false

u0()
if not isfolder("PatXyneria/House Helper") then
    makefolder("PatXyneria/House Helper")
end

local savePath = "PatXyneria/House Helper/data.json"

local saveValues = (function()
    local dataToSave = {}
    for key, value in pairs(valuesTbl) do
        dataToSave[key] = value[2]
    end
    writefile(savePath, HttpService:JSONEncode(dataToSave))
end)

local loadValues = (function()
    if isfile(savePath) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(savePath))
        end)
        if success and data then
            for key, value in pairs(data) do
                if valuesTbl[key] then
                    valuesTbl[key][2] = value
                end
            end
        end
    end
end)

local onValueChanged = (function(key, newValue)
    valuesTbl[key][2] = newValue
    saveValues()
end)

local countTable = (function(t)
    local count = 0
    for _, v in pairs(t) do
        count = count + 1
    end
    return count
end)

local function debugLog(text)
    -- print("⚠️ [DEBUG]:", text)
end
local getDate = (function()
    return tostring("[".. os.date("%H:%M:%S") .."]")
end)

u0()
local functionWebhook = (function(message, important)
    if not valuesTbl["useWebhook"][2] then return end
    local newMsg
    local pingId = valuesTbl["pingUserId"] and valuesTbl["pingUserId"][2]
        if important and valuesTbl["pingOnImportant"][2] == true and pingId and pingId ~= "" then
        newMsg = "<@" .. pingId .. ">\n" .. message
    else
        newMsg = message
    end
    -- print("important:", important, "pingOnImportant:", valuesTbl["pingOnImportant"][2], "pingUserId:", valuesTbl["pingUserId"][2])
    request({
        Url = valuesTbl["webhook"][2],
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({content = newMsg})
    })
end)

local hintSent = (function(txt, bool)
    task.spawn((function()
        firesignal(
            game:GetService("ReplicatedStorage")
                :WaitForChild("API")
                :WaitForChild(remotes["MsgAPI/DisplayServerMsg"])
                .OnClientEvent,
            game:GetService("TextChatService").TextChannels.RBXGeneral,
            txt,
            bool and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 85, 85)
        )
    end))
end)

-- Alert Message
task.spawn((function()
        firesignal(
            game:GetService("ReplicatedStorage")
                :WaitForChild("API")
                :WaitForChild(remotes["MsgAPI/DisplayServerMsg"])
                .OnClientEvent,
            game:GetService("TextChatService").TextChannels.RBXGeneral,
            "Xyneria x patuxet - House Helper - ".. version,
            nil
        ) task.wait(0.1)
        firesignal(
            game:GetService("ReplicatedStorage")
                :WaitForChild("API")
                :WaitForChild(remotes["MsgAPI/DisplayServerMsg"])
                .OnClientEvent,
            game:GetService("TextChatService").TextChannels.RBXGeneral,
            "In honour of patx & radia 💖",
            nil
        ) task.wait(0.1)
        firesignal(
            game:GetService("ReplicatedStorage")
                :WaitForChild("API")
                :WaitForChild(remotes["MsgAPI/DisplayServerMsg"])
                .OnClientEvent,
            game:GetService("TextChatService").TextChannels.RBXGeneral,
            "@radiawow on discord for more info! https://discord.gg/esJzMFwTBV ",
            Color3.fromRGB(255, 0, 0)
        )
    end))

-- // FUNCTIONS // --

local HttpService = game:GetService("HttpService")
local targetUsername = "Nobody"

local quickChatReplies = {
    lets_trade = 1,
    thinking = 2,
    lets_do_it = 3,
    add = 4,
    take_away = 5,
    no_thanks = 6
}

local function QuickChat(reply)
    task.wait(tonumber(valuesTbl["acceptdelay"][2]) / 1.5)
	game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild(remotes["TradeAPI/SendQuickChat"]):FireServer(game:GetService("Players"):WaitForChild(targetUsername), quickChatReplies[reply])
	-- print("replied with: ".. reply .." (".. quickChatReplies[reply] .."), to: ".. targetUsername)
	-- print(":FireServer(".. targetUsername, quickChatReplies[reply] ..")")
end

local defaultReplies = {
    { chats = {
        ["hi"] = {maxCount = 1, "Hello, make an offer and i'll see if i like it"},
        ["hello"] = {maxCount = 1, "Hello, make an offer and i'll see if i like it"},
        ["pick"] = {maxCount = 1, "I don't pick sorry, pls make an offer"},
        ["my inv"] = {maxCount = 1, "I don't pick from inv sorry"},
        ["from inv"] = {maxCount = 1, "I don't pick from inv sorry"},
        ["lf"] = {maxCount = 1,"I'm looking for 10 value elve"},
        ["looking for"] = {maxCount = 1, "I'm looking for 10 value elve"},
        ["cloned"] = {maxCount = 1, "This house isn't cloned"}, }, actions = {
        value_met = {maxCount = 1, function() QuickChat("lets_do_it") end},
        value_not_met_accepted = {maxCount = 1, function() QuickChat("add") end},
        mega_in_trade = {maxCount = 1, "Can you try not to add megas, if not its ok!"},
        blacklisted_in_trade = {maxCount = 1, "Can you switch the non legendaries for something else"} }
    }
}

local lastReplyTime = 0
local REPLY_GLOBAL_COOLDOWN = 2 -- Prevent rapid-fire messages

local autoreply = (function(text, circ)

    if not valuesTbl["repliesActive"] or valuesTbl["repliesActive"][2] == false then return end
    if not TradeState.Active then return end

    local replies = valuesTbl["replies"] and valuesTbl["replies"][2]
    if type(replies) ~= "table" then return end

    local now = tick()
    if now - lastReplyTime < REPLY_GLOBAL_COOLDOWN then return end

    local msg = (text or ""):match("^.-%:%s*(.+)$") or text
    msg = msg:match("^%s*(.-)%s*$"):lower()

    local function sendReply(trigger, replyList, maxCount)
        local count = TradeState.ReplyCounts[trigger] or 0

        if maxCount and count >= tonumber(maxCount) then
            return false
        end

        local cooldownKey = "cd_" .. trigger
        if TradeState.ReplyCounts[cooldownKey] then
            return false
        end

        TradeState.ReplyCounts[cooldownKey] = true
        TradeState.ReplyCounts[trigger] = count + 1
        lastReplyTime = tick()

        task.spawn(function()
            local delayTime = tonumber(valuesTbl["acceptdelay"][2]) or 2
            local api = ReplicatedStorage:WaitForChild("API", 5)
            local toggleTyping = api and api:FindFirstChild(remotes["TradeAPI/ToggleTyping"])

            local reply = replyList[math.random(1, #replyList)]

            if type(reply) == "function" then
            
                reply()
            else
                task.wait(delayTime / 1.5)
                if toggleTyping then toggleTyping:FireServer(true) end
                task.wait(delayTime / 2)

                TextChatService.TextChannels.RBXGeneral:SendAsync(reply)

                task.wait(0.2)
                if toggleTyping then toggleTyping:FireServer(false) end
            end

            task.wait(5)
            TradeState.ReplyCounts[cooldownKey] = nil
        end)

        return true
    end

    if msg ~= "" and replies.chats then
        for trigger, data in pairs(replies.chats) do
            local pattern = "%f[%a]" .. trigger:lower() .. "%f[%A]"
            if msg:find(pattern) then

                if type(data) == "function" then
                    data()
                    return
                end

                local replyList = (type(data) == "table" and data.replies) or data
                local maxLimit  = (type(data) == "table" and data.maxCount) or 1

                if sendReply(trigger, replyList, maxLimit) then
                    return
                end
            end
        end
    end

    if circ and replies.actions and replies.actions[circ] then
        local data = replies.actions[circ]

        if type(data) == "function" then
            data()
            return
        end

        local replyList = (type(data) == "table" and data.replies) or data
        local maxLimit  = (type(data) == "table" and data.maxCount) or 1
        sendReply(circ, replyList, maxLimit)
    end
end)

local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NegotiationFrame = plr.PlayerGui.TradeApp.Frame.NegotiationFrame
local ConfirmationFrame = plr.PlayerGui.TradeApp.Frame.ConfirmationFrame

local tradeHide = {
    NegotiationFrame.Header,
    NegotiationFrame.FriendHighlight,
    ConfirmationFrame.PartnerIcon,
    ConfirmationFrame.PartnerLabel,
    ConfirmationFrame.YouLabel
}

local function setVisibility(...)
	for _, v in ... do
		local bool = not valuesTbl["hideusernamesActive"][2]
			v.Visible = bool
		-- print("[invisible] Changed ".. v.Name .." to ".. tostring(v.Visible))
	end
end


for _, v in pairs(tradeHide) do
	v:
    GetPropertyChangedSignal("Visible")
    :Connect(function()
        setVisibility(tradeHide)
        task.wait(0.1)
    end)
end

local traderSentMsg = false

TextChatService.MessageReceived:Connect(function(message)
    -- print("msg_init")
    local textSource = message.TextSource
    if not textSource then return end
    
    local targetplayer = Players:GetPlayerByUserId(textSource.UserId)
    if not targetplayer then return end
    -- print(targetUsername:lower(), targetplayer.Name:lower())
    if targetplayer.Name:lower() == targetUsername:lower() then
        autoreply(message.Text)
        if valuesTbl["pingOnImportant"][2] == false then
            toSend = false
        else
            toSend = not traderSentMsg
        end
        functionWebhook("```💬 ".. getDate() .." MESSAGE SENT FROM TRADER!\n\t👤 ".. message.Text .."```", toSend)
        traderSentMsg = true
    end
end)

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- API Configuration
local API_KEY = "amv_b09baf521bfba345c757b03e68333f7d"
local BASE_URL = "https://amverse.co/api/v1"
local ValueCache = {}

local POTION_VALUES = {
    ["ride-a-pet potion (forever)"] = 1.25,
    ["ride-a-pet potion"] = 1.1,
    ["Siamese Cat"] = 19,
    ["fly-a-pet potion (forever)"] = 2,
    ["fly-a-pet potion"] = 2,
}

--------------------------------------------------------------------------------
-- UTILITIES
--------------------------------------------------------------------------------

local function getNeonStatus(item)
    local props = item.properties or {}
    local rawId = tostring(item.id or ""):lower()
    if props.mega_neon or props.meganeon or rawId:find("^mega_neon_") then return "mega" end
    if props.neon or props.neon_created_from or rawId:find("^neon_") then return "neon" end
    return "normal"
end

local function getRideStatus(item)
    local props = item.properties or {}
    if props.flyable and props.rideable then return "flyride" end
    if props.flyable then return "fly" end
    if props.rideable then return "ride" end
    return "normal"
end

local function calculateCappedTotal(side)
    local stateSide = TradeState[side]
    local maxItems = tonumber(valuesTbl["maximumItemsInTrade"] and valuesTbl["maximumItemsInTrade"][2]) or 18
    local itemList = {}
    for _, itm in pairs(stateSide.items) do
        if itm.resolved then
            table.insert(itemList, itm)
        end
    end
    table.sort(itemList, function(a, b)
        return (a.value or 0) > (b.value or 0)
    end)
    local newTotal = 0
    for i = 1, #itemList do
        if i <= maxItems then
            newTotal = newTotal + (itemList[i].value or 0)
        end
    end
    return newTotal
end

--------------------------------------------------------------------------------
-- UI MANAGEMENT
--------------------------------------------------------------------------------

local updateUI = (function()
    local tradeApp = LocalPlayer.PlayerGui:FindFirstChild("TradeApp")
    if not tradeApp then return end
    local frame = tradeApp:FindFirstChild("Frame")
    local negFrame = frame and frame:FindFirstChild("NegotiationFrame")
    if not negFrame then return end
    local myVal = TradeState.Me.total or 0
    local theirVal = TradeState.Them.total or 0
    local mySide = negFrame.Body:FindFirstChild("YourOffer")
    if mySide and mySide:FindFirstChild("TextLabel") then
        mySide.TextLabel.Text = string.format("%.2f", myVal)
    end
    local theirSide = negFrame.Body:FindFirstChild("PartnerOffer")
    if theirSide and theirSide:FindFirstChild("TextLabel") then
        theirSide.TextLabel.Text = string.format("%.2f", theirVal)
    end
    if negFrame.Body:FindFirstChild("TextLabel") then
        negFrame.Body.TextLabel.Text = string.format("%.2f : %.2f", myVal, theirVal)
    end
    frame.ConfirmationFrame.HeaderText.Text = "IS ".. string.format("%.2f : %.2f", myVal, theirVal) .." FAIR?"
end)

--------------------------------------------------------------------------------
-- API & RECONCILIATION
--------------------------------------------------------------------------------

local fetchValue = (function(displayName, neonStatus, rideStatus)
    local potionVal = POTION_VALUES[displayName:lower()]
    if potionVal then
        return { value = potionVal, rarity = "potion" }
    end

    local cacheKey = displayName:lower() .. "_" .. neonStatus .. "_" .. rideStatus
    if ValueCache[cacheKey] then return ValueCache[cacheKey] end

    local success, response = pcall(function()
        return (syn and syn.request or http_request or request)({
            Url = BASE_URL .. "/pets?name=" .. HttpService:UrlEncode(displayName) .. "&limit=50",
            Method = "GET",
            Headers = { ["Authorization"] = "Bearer " .. API_KEY, ["Content-Type"] = "application/json" }
        })
    end)

    if not success or not response or response.StatusCode ~= 200 then
        return { value = 0, rarity = "unknown" }
    end

    local parsed = HttpService:JSONDecode(response.Body)
    local results = parsed and parsed.data

    if not results or #results == 0 then return { value = 0, rarity = "unknown" } end

    local bestMatch = nil
    for _, pet in ipairs(results) do
        -- warn("[AMVerse] Full pet JSON: " .. HttpService:JSONEncode(pet))
        if pet.name:lower() == displayName:lower() then
            bestMatch = pet
            break
        end
    end

    if not bestMatch then return { value = 0, rarity = "unknown" } end

    local rarity = (bestMatch.rarity or "unknown"):lower()
    local vData = bestMatch.elve or (bestMatch.values and bestMatch.values.elve) or {}

    local baseVal = 0

    if neonStatus == "mega" then
        if rideStatus == "flyride" then baseVal = vData.mvalueFlyRide or vData.mvalue or 0
        elseif rideStatus == "fly"  then baseVal = vData.mvalueFly   or vData.mvalue or 0
        elseif rideStatus == "ride" then baseVal = vData.mvalueRide  or vData.mvalue or 0
        else                              baseVal = vData.mvalue or 0
    end
    elseif neonStatus == "neon" then
        if rideStatus == "flyride" then baseVal = vData.nvalueFlyRide or vData.nvalue or 0
        elseif rideStatus == "fly"  then baseVal = vData.nvalueFly    or vData.nvalue or 0
        elseif rideStatus == "ride" then baseVal = vData.nvalueRide   or vData.nvalue or 0
        else                              baseVal = vData.nvalue or 0
    end
    else -- normal
        if rideStatus == "flyride" then baseVal = vData.rvalueFlyRide or vData.rvalue or 0
        elseif rideStatus == "fly"  then baseVal = vData.rvalueFly    or vData.rvalue or 0
        elseif rideStatus == "ride" then baseVal = vData.rvalueRide   or vData.rvalue or 0
        else                              baseVal = vData.rvalue or 0
    end
end

local result = { value = tonumber(baseVal) or 0, rarity = rarity }
    ValueCache[cacheKey] = result
    return result
end)

local resolvePendingItem = (function(side, cleanName)
    local stateSide = TradeState[side]
    local uniqueId = table.remove(stateSide.pendingQueue, 1)
    if not uniqueId then return end
    local itemObj = stateSide.items[uniqueId]
    if itemObj then
        -- Pass rideStatus into fetchValue
        local data = fetchValue(cleanName, itemObj.neon, itemObj.ride)
        local isBlacklisted = (blacklist and (blacklist[cleanName] == true or blacklist[cleanName:lower()] == true))
        local ignoredRarities = valuesTbl["ignorerarities"] and valuesTbl["ignorerarities"][2] or {}
        local isIgnoredRarity = table.find(ignoredRarities, data.rarity)
        local isMegaIgnored = (itemObj.neon == "mega" and valuesTbl["ignoremeganeonsActive"] and valuesTbl["ignoremeganeonsActive"][2])

        if side == "Them" then
            if isMegaIgnored then
                debugLog("🚫 Triggering Mega-Neon Reply", Color3.fromRGB(255, 80, 80))
                autoreply("", "mega_in_trade")
            elseif isBlacklisted or isIgnoredRarity then
                debugLog("🚫 Triggering Blacklist/Rarity Reply", Color3.fromRGB(255, 80, 80))
                autoreply("", "blacklisted_in_trade")
            end
        end

        itemObj.name = cleanName
        itemObj.value = (isIgnoredRarity or isBlacklisted or isMegaIgnored) and 0 or data.value

        if itemObj.value < valuesTbl["ignorebelowvalue"][2] then
            debugLog("🚫 Item Added Is Below Value", Color3.fromRGB(255, 80, 80))
            itemObj.value = 0
        end

        itemObj.resolved = true
        stateSide.total = calculateCappedTotal(side)
        updateUI()
    end
end)

--------------------------------------------------------------------------------
-- CORE PAYLOAD HANDLING
--------------------------------------------------------------------------------

local processTradePayload = (function(payload)
    if not payload or payload.current_stage == "completed" or payload.current_stage == "cancelled" then
        TradeState.Me = { items = {}, total = 0, pendingQueue = {} }
        TradeState.Them = { items = {}, total = 0, pendingQueue = {} }
        TradeState.Active = false
        targetUsername = "Nobody"
        TradeState.ReplyCounts = {}
        updateUI()
        return
    end
    TradeState.Active = true
    if payload.sender_offer and payload.recipient_offer then
        local sName = payload.sender_offer.player_name
        local rName = payload.recipient_offer.player_name
        targetUsername = (sName == LocalPlayer.Name) and rName or sName
    end
    local function syncSide(sideName, offer)
        local stateSide = TradeState[sideName]
        local currentUniques = {}
        local changed = false
        for _, item in ipairs(offer.items or {}) do
            if item.kind ~= "house" and not tostring(item.id):find("house") then
                currentUniques[item.unique] = true
                if not stateSide.items[item.unique] then
                    stateSide.items[item.unique] = {
                        unique = item.unique,
                        neon = getNeonStatus(item),
                        ride = getRideStatus(item), -- now stored
                        name = "Loading...",
                        value = 0,
                        resolved = false
                    }
                    table.insert(stateSide.pendingQueue, item.unique)
                    changed = true
                end
            end
        end
        for uid, _ in pairs(stateSide.items) do
            if not currentUniques[uid] then
                stateSide.items[uid] = nil
                changed = true
            end
        end
        if changed then
            stateSide.total = calculateCappedTotal(sideName)
            updateUI()
        end
    end
    local myOffer = (payload.sender_offer.player_name == LocalPlayer.Name) and payload.sender_offer or payload.recipient_offer
    local theirOffer = (payload.sender_offer.player_name ~= LocalPlayer.Name) and payload.sender_offer or payload.recipient_offer
    syncSide("Me", myOffer)
    syncSide("Them", theirOffer)
end)

--------------------------------------------------------------------------------
-- LISTENERS & LOOPS
--------------------------------------------------------------------------------

task.spawn(function()
    while true do
        task.wait(0.5)
        if TradeState.Active then
            local tradeApp = LocalPlayer.PlayerGui:FindFirstChild("TradeApp")
            local negFrame = tradeApp and tradeApp:FindFirstChild("Frame") and tradeApp.Frame:FindFirstChild("NegotiationFrame")
            if negFrame and negFrame.Visible then
                local partnerAccepted = negFrame.Body.PartnerOffer.Accepted.ImageTransparency < 1
                local neededTotal = tonumber(valuesTbl["valueToAccept"] and valuesTbl["valueToAccept"][2]) or 0
                if partnerAccepted and TradeState.Them.total < neededTotal then
                    autoreply("", "value_not_met_accepted")
                end
            end
        end
    end
end)

task.spawn(function()
    local tradeApp = LocalPlayer.PlayerGui:WaitForChild("TradeApp", 60)
    local chatLog = tradeApp:WaitForChild("Frame"):WaitForChild("NegotiationFrame"):WaitForChild("ChatFrame"):WaitForChild("ChatLog"):WaitForChild("ScrollComplex"):WaitForChild("ScrollingFrame"):WaitForChild("Content")
    chatLog.ChildAdded:Connect(function(child)
        if child:IsA("TextLabel") then
            task.wait(0.2)
            local text = child.Text
            if not text or text == "" or targetUsername == "Nobody" then return end
            local isThem = text:find(targetUsername, 1, true)
            local side = isThem and "Them" or "Me"
            local action, itemName = text:match("%s+(%a+)%s+(.-)%.")
            -- print("parsed action:", action, "| item:", itemName) -- remove once confirmed working
            if action == "added" and itemName then
                resolvePendingItem(side, itemName:match("^%s*(.-)%s*$"))
            elseif action == "removed" then
                TradeState[side].total = calculateCappedTotal(side)
                updateUI()
            end
        end
    end)
end)

local function hookRemotes()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local path = obj:GetFullName():lower()
            if path:find("datachanged") or path:find("dataapi") then
                obj.OnClientEvent:Connect(function(pName, key, data)
                    if key == "trade" then processTradePayload(data) end
                end)
            end
        end
    end
end
hookRemotes()

u0()
local getMagicDoor = (function()
    local CD = Fsys.load("ClientData")
    local data = CD.get_data()[plr.Name]
    local var = data["inventory"].toys
    local doorFound = false
    local magicdoor
    local function searchTable(t)
        for key, value in pairs(t) do
            if value == "magic_house_door" then
                doorFound = true
                magicdoor = tostring(t["unique"])
            elseif type(value) == "table" then
                searchTable(value)
            end
        end
    end
    searchTable(var)
    if not doorFound then
        warn("You do not own a Magic House Door.")
        functionWebhook("```⚠️ ".. getDate() .." You do not own a Magic House Door!```")
    else
        print("Magic House Door UID Found: " .. magicdoor)
        functionWebhook("```✅ ".. getDate() .." Found 'Magic House Door' (".. magicdoor ..")```")
    end
    return magicdoor
end)

loadValues()

local plrId = tostring(game.Players.LocalPlayer.UserId)
local magicDoorData = valuesTbl["magicdooruid"][2]


if type(magicDoorData) ~= "table" then
    valuesTbl["magicdooruid"][2] = {}
    magicDoorData = valuesTbl["magicdooruid"][2]
end

if magicDoorData[plrId] == nil then
    local doorId = getMagicDoor()
    if doorId then
        magicDoorData[plrId] = doorId
        saveValues()
        print("Mapped Door UID " .. doorId .. " to UserId " .. plrId)
    end
end

local currentDoor = magicDoorData[plrId]
local currentTotal
local neededTotal

local lastMessage = nil

local oldserverhop = (function()
    -- task.wait(5)
    if NegotiationFrame.Parent.Visible then print("inTrade") return end
    hintSent("[FALLBACK] Teleporting you to a new server...")
    -- functionWebhook("```⏳ ".. getDate() .." Teleporting you to a new server...```")
    task.wait(0.5)
    task.delay(3, function()
        while task.wait(5) do
            if NegotiationFrame.Parent.Visible then repeat task.wait(1) until NegotiationFrame.Parent.Visible == false end
            TeleportService:Teleport(game.PlaceId)
        end
    end)
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild(remotes["TradingServerAPI/TeleportToBestServer"]):InvokeServer()
end)

local serverhop = (function()
    task.wait(2)
    task.delay(5, function()
        if NegotiationFrame.Parent.Visible then 
            repeat task.wait(1) print("inTrade") until NegotiationFrame.Parent.Visible == false end
        repeat task.wait(1) oldserverhop() until 7 == 8
    end)
    hintSent("Teleporting you to a new server...", true) functionWebhook("```⏳ ".. getDate() .." Teleporting you to a new server...```")
    if NegotiationFrame.Parent.Visible then repeat task.wait(1) print("inTrade") until NegotiationFrame.Parent.Visible == false end
    local HS, TS = game:GetService("HttpService"), game:GetService("TeleportService")
    local pid, cur = game.PlaceId, tostring(game.JobId)
    local cur2 = ""

repeat
    local ok, res = pcall(function()
        return HS:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/"..pid.."/servers/Public?sortOrder=Desc&limit=300"..(cur2~="" and "&cursor="..cur2 or "")
        ))
    end)
    if not ok or type(res.data) ~= "table" then break end

    local pick
    for _, v in pairs(res.data) do
        local id, p, m = tostring(v.id or ""), tonumber(v.playing) or 0, tonumber(v.maxPlayers) or 0
        if id ~= "" and id ~= cur and m-p >= math.random(6, 15) and (not pick or p > pick.p) then
            pick = {id=id, p=p}
        end
    end

    if pick then
        pcall(TS.TeleportToPlaceInstance, TS, pid, pick.id, game.Players.LocalPlayer)
        break
    end

    cur2 = tostring(res.nextPageCursor or "")
    task.wait(0.12)
until cur2 == "" and NegotiationFrame.Parent.Visible == false
end)

local dialogFrame = plr.PlayerGui.DialogApp.Dialog

local cached = {}

local function getDialog()
    local d = dialogFrame:QueryDescendants("#NormalDialog")
    return d[1]
end

local declineWait_v0 = true

local function setTradeMode(active)
    if active then
        cached["autosendActive"] = valuesTbl["autosendActive"][2]
        cached["autoplaceDoorActive"] = valuesTbl["autoplaceDoorActive"][2]
        cached["humanizedmovementActive"] = valuesTbl["humanizedmovementActive"][2]
        inTrade = true
    else
        declineWait_v0 = false
        if cached["autosendActive"] ~= nil then
            valuesTbl["autosendActive"][2] = cached["autosendActive"]
        end
        if cached["autoplaceDoorActive"] ~= nil then
            valuesTbl["autoplaceDoorActive"][2] = cached["autoplaceDoorActive"]
        end
        if cached["humanizedmovementActive"] ~= nil then
            valuesTbl["humanizedmovementActive"][2] = cached["humanizedmovementActive"]
        end
        cached = {}
        inTrade = false
    end
end
u0()
local function btnPress(button)
    firesignal(button.MouseButton1Down)
    task.wait(0.2)
    firesignal(button.MouseButton1Click)
end


local count = 0

local handleCheckboxDialog = (function(tradeFrame)
    if not (tradeFrame and tradeFrame.Parent:FindFirstChild("NormalDialog") and tradeFrame.Parent.NormalDialog.Visible == true) then return end
    for _, btn in tradeFrame.Parent.NormalDialog.Buttons:GetChildren() do
        local face = btn and btn:IsA("ImageButton") and btn:FindFirstChild("Face")
        local label = face and face:FindFirstChild("TextLabel")
        if label and label.Text == "No" then
            btnPress(btn)
        end
    end
end)

local closePopUps = (function()
    while true do
        task.wait(0.1)
        local dialog = getDialog()
        if not (dialog and dialog.Visible) then continue end
        local buttons = dialog:FindFirstChild("Buttons")
        if not buttons then continue end
        for _, btn in buttons:GetChildren() do
            if not btn:IsA("ImageButton") then continue end
            local face = btn:FindFirstChild("Face")
            local label = face and face:FindFirstChild("TextLabel")
            if label and (label.Text == "No" or label.Text == "Okay") then
                btnPress(btn)
            end
        end
    end
end)

local handleTradeButtons = (function(tradeFrame)
    for _, btn in tradeFrame.Buttons:GetChildren() do
        if btn:IsA("ImageButton") and btn.Face.TextLabel.Text == "Accept" then
            btnPress(btn)
            setTradeMode(true)
            task.wait(0.3)
        elseif btn:IsA("ImageButton") and btn.Face.TextLabel.Text == "Okay" then
            btnPress(btn)
            setTradeMode(true)
            task.wait(0.3)
        elseif btn:IsA("ImageButton") and btn.Face.TextLabel.Text == "Next" then
            btnPress(btn)
            task.wait(0.3)
        elseif btn:IsA("ImageButton") and btn.Face.TextLabel.Text == "I understand" then
            btnPress(btn)
            setTradeMode(true)
            task.wait(0.3)
            break
        end
    end
end)
task.spawn(closePopUps)
local handleNegotiationState = (function()
    if NegotiationFrame.Parent.Visible then
        local Accepted = NegotiationFrame.Body.MyOffer.Accepted
        if NegotiationFrame.Body.MyOffer.Slots:FindFirstChild("Slot2") and Accepted.ImageTransparency == 1 then 
            if declineWait_v0 == true then else
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild(remotes["TradeAPI/DeclineTrade"]):FireServer()
            setTradeMode(false)
            end
        end
    else
        setTradeMode(false)
    end
end)

local webhookSent = false

local autoAccept = (function()
    while valuesTbl["autoAcceptActive"][2] do
        task.wait(0.5)
        local tradeFrame = getDialog()
        handleCheckboxDialog(tradeFrame)
        handleNegotiationState()
        --[[ if not inTrade and tradeFrame then
            handleTradeButtons(getDialog())
        end ]]
        handleTradeButtons(getDialog())
        if inTrade and not webhookSent then
            webhookSent = true
            task.delay(2, function()
                if inTrade and valuesTbl["autoacceptatvalueActive"][2] then
                    functionWebhook("```✅ ".. getDate() .." You are in a trade!```")
                    declineWait_v0 = true
                elseif inTrade and valuesTbl["autoacceptatvalueActive"][2] == false then
                    functionWebhook("```✅ ".. getDate() .." You are in a trade!```", true)
                    declineWait_v0 = true
                end
            end)
        end
        if not inTrade then
            webhookSent = false
        end
    end
end)

local inactivityCountdown = tonumber(valuesTbl["inactivityToDecline"][2])
local lastTradeState = false -- Track the state from the previous loop

local inactivityDecline = (function()
    while true do
        task.wait(1)
        local active = valuesTbl["inactivitydeclineActive"][2]
        local threshold = tonumber(valuesTbl["valueToAccept"][2]) or 8
        local limit = tonumber(valuesTbl["inactivityToDecline"][2]) or 60
        local currentlyInTrade = TradeState.Active
        local theirTotal = TradeState.Them.total or 0
        if currentlyInTrade == true and lastTradeState == false then
            inactivityCountdown = limit
            debugLog("⏳ New trade detected, timer started: " .. limit .. "s", Color3.fromRGB(100, 255, 100))
        end
        lastTradeState = currentlyInTrade -- Update state for next tick
        if active then
            if currentlyInTrade then 
                if theirTotal >= threshold then
                    inactivityCountdown = limit
                else
                    inactivityCountdown = inactivityCountdown - 1
                    if inactivityCountdown % 10 == 0 and inactivityCountdown > 0 then
                        debugLog("⏰ Inactivity: " .. inactivityCountdown .. "s left", Color3.fromRGB(255, 200, 100))
                    end
                    if inactivityCountdown <= 0 then
                        local declineRemote = ReplicatedStorage:WaitForChild("API"):WaitForChild(remotes["TradeAPI/DeclineTrade"])
                        declineRemote:FireServer()
                        
                        if functionWebhook then
                            functionWebhook("```❌ [" .. os.date("%X") .. "] Declined due to inactivity with " .. targetUsername .. "```")
                        end  
                        debugLog("🛑 Auto-declined: Inactivity limit reached.", Color3.fromRGB(255, 80, 80))
                        TradeState.Active = false
                        inactivityCountdown = limit
                    end
                end
            else
                inactivityCountdown = limit
            end
        else
            inactivityCountdown = limit
        end
    end
end)

local autosend = (function()
    while valuesTbl["autosendActive"][2] do
        if inTrade or NegotiationFrame.Parent.Visible then
            task.wait(0.5)
        else
            if valuesTbl["autoServerHopActive"][2] then
                count = count + 1
                if count >= valuesTbl["timesSent"][2] - 3 then
                    hintSent("You will server hop soon!", true) hintSent("You will server hop soon!", true) hintSent("You will server hop soon!", true)
                end
                if count > valuesTbl["timesSent"][2] then
                    serverhop() serverhop() print("attempting serverhop")
                    break
                end
            end
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                local channel = TextChatService:FindFirstChild("TextChannels")
                    and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if channel then
                    local msg = valuesTbl["message"][2]
                    if type(msg) == "table" and #msg > 0 then
                        msg = msg[math.random(1, #msg)]
                    end
                    channel:SendAsync(msg)
                end
            end
            task.wait(valuesTbl["durationBetween"][2])
        end
    end
end)

local autoplacedoor
do
    -- Door placement logic (from version_with)
    local player = plr
    local function notify(title, content, duration)
        print("[" .. tostring(title) .. "] " .. tostring(content))
        pcall(hintSent, tostring(content), true)
    end

    local magicDoorLastAttemptAt = 0
    local magicDoorUseInProgress = false
    local magicDoorCachedUnique = nil
    local MAGIC_DOOR_MIN_ATTEMPT_GAP = 1
    local MAGIC_DOOR_MAX_CANDIDATES = 15

local function getCurrentMagicDoorUniqueCandidates()
    local fallbackMagicDoorUnique = "2_6678f337ff7742638cbd7f6deb5581a0"
    local candidates = {}
    local used = {}

    local function addCandidate(value, source)
        if #candidates >= MAGIC_DOOR_MAX_CANDIDATES then
            return
        end

        local text = tostring(value or "")

        if text == "" or #text < 8 then
            return
        end

        local lowered = text:lower()
        if lowered:find("magic", 1, true) or lowered:find("door", 1, true) then
            return
        end

        if used[text] then
            return
        end

        used[text] = true
        table.insert(candidates, text)
        print("[House Helper] Magic Door candidate:", text, "source:", tostring(source or "unknown"))
    end

    local function looksLikeMagicDoorText(value)
        local text = tostring(value or ""):lower()
        text = text:gsub("[_%-%s]+", " ")

        return text:find("magic door", 1, true) ~= nil
            or text:gsub("%s+", ""):find("magicdoor", 1, true) ~= nil
            or (text:find("magic", 1, true) ~= nil and text:find("door", 1, true) ~= nil)
    end

    local function scanToolContainer(container, source)
        if not container then
            return
        end

        for _, child in ipairs(container:GetChildren()) do
            if #candidates >= MAGIC_DOOR_MAX_CANDIDATES then
                return
            end

            if child:IsA("Tool") and looksLikeMagicDoorText(child.Name) then
                local unique = child:FindFirstChild("unique")
                if unique and unique.Value then
                    addCandidate(unique.Value, source)
                end
            end
        end
    end

    
    scanToolContainer(player.Character, "character tool")
    scanToolContainer(player:FindFirstChildOfClass("Backpack"), "backpack tool")

    
    if magicDoorCachedUnique then
        addCandidate(magicDoorCachedUnique, "cached")
    end

    
    if #candidates < MAGIC_DOOR_MAX_CANDIDATES then
        local clientData = nil

        pcall(function()
            local clientModules = ReplicatedStorage:FindFirstChild("ClientModules")
            local core = clientModules and clientModules:FindFirstChild("Core")
            local clientDataModule = core and core:FindFirstChild("ClientData")

            if clientDataModule then
                clientData = require(clientDataModule)
            end
        end)

        if type(clientData) == "table" and type(clientData.get) == "function" then
            local ok, inventory = pcall(function()
                return clientData.get("inventory")
            end)

            if ok and type(inventory) == "table" then
                local scanCount = 0

                local function scanContainer(container)
                    if type(container) ~= "table" then
                        return
                    end

                    for key, item in pairs(container) do
                        scanCount += 1

                        if scanCount > 5000 or #candidates >= MAGIC_DOOR_MAX_CANDIDATES then
                            return
                        end

                        if type(item) == "table" then
                            local itemText =
                                tostring(item.kind or "") .. " " ..
                                tostring(item.id or "") .. " " ..
                                tostring(item.name or "") .. " " ..
                                tostring(item.display_name or "") .. " " ..
                                tostring(item.displayName or "")

                            if looksLikeMagicDoorText(itemText) then
                                addCandidate(key, "inventory key")

                                if item.unique then
                                    addCandidate(item.unique, "inventory unique")
                                elseif item.unique_id then
                                    addCandidate(item.unique_id, "inventory unique_id")
                                elseif item.uniqueId then
                                    addCandidate(item.uniqueId, "inventory uniqueId")
                                end
                            end
                        end
                    end
                end

                scanContainer(inventory.food)
                scanContainer(inventory.toys)
                scanContainer(inventory.gifts)
                scanContainer(inventory.roleplay)
                scanContainer(inventory.strollers)
                scanContainer(inventory.vehicles)
                scanContainer(inventory)
            end
        end
    end

    if currentDoor then
        addCandidate(currentDoor, "patx door uid")
    end

    addCandidate(fallbackMagicDoorUnique, "old fallback")

    return candidates
end

local function useMagicDoor()
    if magicDoorUseInProgress then
        warn("[House Helper] Magic Door attempt already running. Skipping duplicate call.")
        return false
    end

    local now = os.clock()

    if now - tonumber(magicDoorLastAttemptAt or 0) < MAGIC_DOOR_MIN_ATTEMPT_GAP then
        warn("[House Helper] Magic Door cooldown active. Skipping to protect device.")
        return false
    end

    magicDoorUseInProgress = true
    magicDoorLastAttemptAt = now

    local success = false

    local ok, err = pcall(function()
        local api = ReplicatedStorage:WaitForChild("API")

        local equipRemote = api:FindFirstChild("ToolAPI/Equip")
        local placeRemote = api:FindFirstChild("PlaceableToolAPI/CreatePlaceable")

        if not equipRemote or not placeRemote then
            notify("House Helper", "Magic Door remotes missing.", 3)
            return
        end

        local function getCharacterParts()
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart", 10)

            return char, root
        end

        local function findPlaceableTool(char)
            if not char then
                return nil
            end

            local directTool = char:FindFirstChild("PlaceableTool")

            if directTool then
                return directTool
            end

            for _, child in ipairs(char:GetChildren()) do
                if child:IsA("Tool") then
                    local unique = child:FindFirstChild("unique")

                    if unique then
                        return child
                    end
                end
            end

            return nil
        end

        local function waitForPlaceableTool(char, timeout)
            local startedAt = os.clock()
            local tool = findPlaceableTool(char)

            while not tool and os.clock() - startedAt < timeout do
                task.wait(0.15)
                tool = findPlaceableTool(char)
            end

            return tool
        end

        local function equipMagicDoor(magicDoorUnique)
            if not magicDoorUnique or tostring(magicDoorUnique) == "" then
                return false
            end

            print("[House Helper] Trying Magic Door unique:", tostring(magicDoorUnique))

            local equipOk, equipResult = pcall(function()
                return equipRemote:InvokeServer(tostring(magicDoorUnique))
            end)

            if not equipOk or equipResult == false then
                warn("[House Helper] Magic Door equip failed for unique:", tostring(magicDoorUnique), tostring(equipResult))
                return false
            end

            magicDoorCachedUnique = tostring(magicDoorUnique)
            return true
        end

        local function placeEquippedMagicDoor()
            local char, root = getCharacterParts()

            if not char or not root then
                return false
            end

            local tool = waitForPlaceableTool(char, 2.5)

            if not tool then
                warn("[House Helper] Magic Door tool not found after equip.")
                return false
            end

            local unique = tool:FindFirstChild("unique")

            if not unique then
                warn("[House Helper] Magic Door tool unique missing.")
                return false
            end

            task.wait(0.25)

            
            local placePositions = {
                CFrame.new(0, -3, -4),
                CFrame.new(0, -2.5, -5)
            }

            for attempt, offset in ipairs(placePositions) do
                local cf = root.CFrame * offset

                local placeOk, placeResult = pcall(function()
                    return placeRemote:InvokeServer(cf, {
                        unique = unique.Value
                    })
                end)

                if placeOk and placeResult ~= false then
                    print("[House Helper] Magic Door placed on attempt", tostring(attempt))
                    notify("House Helper", "Door placed", 2)
                    return true
                end

                warn("[House Helper] Magic Door place attempt failed:", tostring(attempt), tostring(placeResult))
                task.wait(0.5)
            end

            return false
        end

        local candidates = getCurrentMagicDoorUniqueCandidates()

        if not candidates or #candidates == 0 then
            notify("House Helper", "No Magic Door ID found on this account.", 3)
            return
        end

        
        for index, magicDoorUnique in ipairs(candidates) do
            if index > MAGIC_DOOR_MAX_CANDIDATES then
                break
            end

            if equipMagicDoor(magicDoorUnique) then
                if placeEquippedMagicDoor() then
                    success = true
                    return
                end
            end

            task.wait(0.75)
        end

        notify("House Helper", "Magic Door failed. Auto retry will wait.", 4)
    end)

    if not ok then
        warn("[House Helper] Magic Door protected error:", err)
    end

    magicDoorUseInProgress = false
    return success
end

    autoplacedoor = (function()
        while valuesTbl["autoplaceDoorActive"][2] do
            if inTrade or NegotiationFrame.Parent.Visible then
                task.wait(0.5)
            else
                useMagicDoor()
                task.wait(valuesTbl["durationBetween"][2])
            end
        end
    end)
end

local puthouseonsale = (function()
    while valuesTbl["autoPutHouseOnSale"][2] do
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild(remotes["HousingAPI/ListHouse"]):InvokeServer()
        task.wait(3)
    end
end)

local checkPlayerCount = (function()
    while valuesTbl["minimumPlayersActive"][2] do
        if inTrade or NegotiationFrame.Parent.Visible then
            task.wait(1)
        else
            local ctPlayers = #game.Players:GetPlayers()
            if ctPlayers < valuesTbl["minimumPlayers"][2] then
                hintSent("Not enough players! " .. ctPlayers .. " is less than " .. valuesTbl["minimumPlayers"][2] .. ".")
                functionWebhook("```⏳ ".. getDate() .." Not enough players in server, teleporting you to a new server... (".. ctPlayers .."/".. valuesTbl["minimumPlayers"][2] ..")```")
                task.wait(1)
                serverhop()
                return
            end
            task.wait(60)
        end
    end
end)

local hintAppTextLabel = game:GetService("Players").LocalPlayer.PlayerGui.HintApp.TextLabel

hintAppTextLabel:GetPropertyChangedSignal("Visible"):Connect(function()
    if not valuesTbl["autoacceptatvalueActive"] then u0() return end
    if hintAppTextLabel.Visible == false then return end
        if hintAppTextLabel.Text == "The trade was successful!" then
            functionWebhook("```✅ ".. getDate() .." The trade was successful! (".. game.Players.LocalPlayer.Name .. ")```", true)
            if valuesTbl["hopAfterTrade"][2] then print("Leaving...") serverhop() else print("Staying") end
        elseif hintAppTextLabel.Text:match("^(.-) declined") then u0()
            local user = hintAppTextLabel.Text:match("^(.-) declined")
            functionWebhook("```❌ ".. getDate() .." ".. user .." declined the trade```")
            -- print("|".. user .."| declined the trade.")
        else -- print("Doesn't match")
    end
end)

local placed = false

local function resolveName(v)
    if type(v) == "string" then
        return v
    elseif type(v) == "table" then
        for _, val in pairs(v) do
            if type(val) == "string" then
                return val
            elseif type(val) == "table" then
                local f = resolveName(val)
                if f then return f end
            end
        end
    end
end

local placeHouse = (function(plotOptions)
    local HouseExteriors = workspace:FindFirstChild("HouseExteriors")
    if not HouseExteriors then return end

    for _, v in pairs(plotOptions) do
        local name = resolveName(v)
        if name and name ~= "None" then
            if not HouseExteriors:QueryDescendants("#" .. name)[1] then
                game:GetService("ReplicatedStorage")
                    :WaitForChild("API")
                    :WaitForChild(remotes["HousingAPI/RentPremiumPlot"])
                    :InvokeServer(name)
                print("House placed at " .. name)
                local confirmed = false
                for _ = 1, 10 do
                    if HouseExteriors:QueryDescendants("#" .. name)[1] then
                        confirmed = true
                        placed = true
                        hintSent("House placed at " .. name, true)
                        functionWebhook("```✅ ".. getDate() " House placed at ".. name .."```")
                        break
                    end
                    task.wait(0.3)
                end
                if confirmed then return end
            end
        end
    end
    print("No available plots found")
end)

local function autothrowparty()
    while valuesTbl["autopartyActive"][2] do
        if inTrade or NegotiationFrame.Parent.Visible then
            task.wait(0.5)
        else
            local args = { { invitation_type = "normal", party_description = valuesTbl["autopartyBody"][2], party_name = valuesTbl["autopartyTitle"][2] } }
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild(remotes["HousingAPI/ThrowParty"]):InvokeServer(unpack(args))
            -- print("party, ".. valuesTbl["autopartyBody"][2], valuesTbl["autopartyTitle"][2])
            task.wait(30)
        end
    end
end

-- print(countTable(theirItems), valuesTbl["maximumItemsInTrade"][2])

local countdownConnection = nil


local autoAcceptValue = (function()
    while true do
        task.wait(0.5)
        
        if not valuesTbl["autoacceptatvalueActive"][2] then continue end

        local tradeApp = LocalPlayer.PlayerGui:FindFirstChild("TradeApp")
        if not (tradeApp and tradeApp.Frame.Visible and TradeState.Active) then continue end

        local frame = tradeApp.Frame
        local negFrame = frame.NegotiationFrame
        local confFrame = frame.ConfirmationFrame
        
        local itemCount = 0
        for _ in pairs(TradeState.Them.items) do itemCount = itemCount + 1 end
        
        if itemCount > tonumber(valuesTbl["maximumItemsInTrade"][2]) then continue end

        local countDownLabel = confFrame.TradeIcon.Countdown
        if not countdownConnection and countDownLabel then
            countdownConnection = countDownLabel:GetPropertyChangedSignal("Text"):Connect(function()
                local num = tonumber(countDownLabel.Text)
                if num ~= 1 then return end

                currentTotal = TradeState.Them.total
                neededTotal = tonumber(valuesTbl["valueToAccept"][2])
                _G.ct, _G.nt, _G.it = currentTotal, neededTotal, negFrame.Body.PartnerOffer.Accepted.ImageTransparency
                
            if negFrame.Visible and TradeState.Them.total < neededTotal and negFrame.Body.PartnerOffer.Accepted.ImageTransparency < 1 then

            if not TradeState.ReplyCounts["not_met_sent"] then
                task.wait(valuesTbl["acceptdelay"][2])
                autoreply("", "value_not_met_accepted")
                TradeState.ReplyCounts["not_met_sent"] = true
                debugLog("Sent: Value not met reply to " .. targetUsername)
            end return end

                task.wait(1.5)

                if TradeState.Them.total < neededTotal then return end

        if negFrame.Visible and negFrame.Body.MyOffer.Accepted.ImageTransparency == 1 and TradeState.Them.total >= neededTotal then
            task.wait(valuesTbl["acceptdelay"][2])
    
            local acceptRemote = ReplicatedStorage:WaitForChild("API"):WaitForChild(remotes["TradeAPI/AcceptNegotiation"])
            acceptRemote:FireServer()
    
            autoreply("", "value_met")
    
            local t = ""
            for _, item in pairs(TradeState.Them.items) do
                t = t .. "🐾 [PET]: ".. (item.name or "Unknown") .."\n" ..
                    "   💰 [VAL]: ".. string.format("%.3f", item.value or 0) .."\n"
            end
    
            if functionWebhook then
                functionWebhook(tostring("```⏳ ".. os.date("%X") .." Automatically Accepted Trade (Value: ".. currentTotal ..")\nTarget: ".. targetUsername .. "\n".. "Recipient: ".. game.Players.LocalPlayer.Name .. "\n" .. t .."```"), true)
            end

                    task.wait(valuesTbl["acceptdelay"][2])
                    elseif ConfirmationFrame.Visible and ConfirmationFrame.MyOffer.Accepted.ImageTransparency == 1 then
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("API")
                            :WaitForChild(remotes["TradeAPI/ConfirmTrade"])
                            :FireServer()

            functionWebhook("```‼️ ".. getDate() .." Automatically Accepted Final Trade Window```", true)
        end
    end)
end

        if not TradeState.Active and countdownConnection then
            countdownConnection:Disconnect()
            countdownConnection = nil
        end
    end
end)

local playerCharacters, petsFolder = workspace.PlayerCharacters, workspace.Pets
local r_clearAdv = false

local clearAdv = (function(...)
if valuesTbl["hideplayersandpetsActive"][2] == false then return end
    local tbls = {...}
    for _, tbl in pairs(tbls) do
        if type(tbl) == "userdata" then for _, v in tbl:GetChildren() do 
            if v.Name == game.Players.LocalPlayer.Name then warn("Keeping LocalPlayer's Character") else
            v:Destroy()
            end
        end
    else warn("In function clearAdv() arg passed is not a table:", tbl) end
    end
end)

playerCharacters.ChildAdded:Connect(clearAdv)
petsFolder.ChildAdded:Connect(clearAdv)

clearAdv(playerCharacters, petsFolder)


local ClientData = Fsys.load("ClientData").get_data()[game.Players.LocalPlayer.Name]
local ignoreName = "IGNORE"
local PlrKicked = false
local ShouldKick = true

task.spawn((function()
    while task.wait(5) do
        -- print("check")
        local houses = ClientData.house_manager
        -- Kick if there are 1 or fewer houses total
        if #houses <= 1 and not PlrKicked then
            functionWebhook("```💸 " .. getDate() .. " " .. game.Players.LocalPlayer.Name .. " has traded all of their houses!```", true)
            task.wait(0.5)
            plr:Kick("You've traded all of your houses!")
            PlrKicked = true
            break
        end

        local validHouses = {}
        local activeIgnore = false
        for _, house in pairs(houses) do
            if house.name ~= "IGNORE" then
                table.insert(validHouses, house)
            elseif house.active == true then
                activeIgnore = true
            end
        end

        if #validHouses == 0 and not PlrKicked then
            functionWebhook("```💸 " .. getDate() .. " " .. game.Players.LocalPlayer.Name .. " has traded all of their houses!```", true)
            task.wait(0.5)
            plr:Kick("You've traded all of your houses!")
            PlrKicked = true
            break
        end


        if activeIgnore then
            local chosenHouse = validHouses[math.random(1, #validHouses)]
            hintSent("Changing to house: " .. chosenHouse.name, true)

            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/SpawnHouse"):FireServer(chosenHouse.house_id)
            task.wait(3)
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild(remotes["HousingAPI/ListHouse"]):InvokeServer()
        end
    end
end))

task.spawn(function()
    for i = 1, 5 do
    if game:GetService("Players").LocalPlayer.PlayerGui.FTUEStarterPackApp.Popups.Default.Visible == true then
        btnPress(game:GetService("Players").LocalPlayer.PlayerGui.FTUEStarterPackApp.Popups.Default.ExitButton)
    end

    if game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.DailyDiscountsDialog.Visible == true then
        btnPress(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.ExitButton)
    end
    task.wait(0.5)
end
end)


game:GetService("Players").LocalPlayer.PlayerGui.PlaytimePayoutsApp:GetPropertyChangedSignal("Enabled"):Connect(function()
    game:GetService("Players").LocalPlayer.PlayerGui.PlaytimePayoutsApp.Enabled = false print("Set Invisible")
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild(remotes["PayAPI/DisablePopups"]):FireServer() task.wait(0.5)
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild(remotes["PayAPI/Collect"]):FireServer()
end)

local function tableToString(tbl, indent)
    indent = indent or 0
    local spaces = string.rep("    ", indent)
    local result = "{\n"

    for k, v in pairs(tbl) do
        local key = type(k) == "string" and string.format("[%q]", k) or "[" .. tostring(k) .. "]"
        local line

        if type(v) == "table" then
            line = tableToString(v, indent + 1)
        elseif type(v) == "string" then
            line = string.format("%q", v)
        elseif type(v) == "function" then

            warn("tableToString: function value at key '" .. tostring(k) .. "' cannot be serialized. Use repliesSource for reply configs.")
            line = "function() end --[[unsupported: use Copy Config File button instead]]"
        else
            line = tostring(v)
        end

        result = result .. spaces .. "    " .. key .. " = " .. line .. ",\n"
    end

    result = result .. spaces .. "}"
    return result
end
local PathfindingService = game:GetService("PathfindingService")
local WALK_TO_TIMEOUT = 15
local WALK_TO_RADIUS = 4
local walkToRevision = 0
local humanizedMovementRunning = false

local function getSavedWalkToPosition()
    local offset = valuesTbl["movetoPos"][2]
    if type(offset) ~= "table" then
        offset = {X = 0, Y = 0, Z = 17}
    end
    return posOnJoin - Vector3.new(
        tonumber(offset.X) or 0,
        tonumber(offset.Y) or 0,
        tonumber(offset.Z) or 17
    )
end

local function isMovementBlocked()
    return inTrade or TradeState.Active or (NegotiationFrame.Parent and NegotiationFrame.Parent.Visible)
end

local function currentMovementParts()
    local currentCharacter = plr.Character
    if not currentCharacter then return nil end
    local currentRoot = currentCharacter:FindFirstChild("HumanoidRootPart")
    local currentHumanoid = currentCharacter:FindFirstChildOfClass("Humanoid")
    if not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then
        return nil
    end
    return currentCharacter, currentRoot, currentHumanoid
end

local function canContinueWalking(char, revision)
    return valuesTbl["humanizedmovementActive"][2]
        and walkToRevision == revision
        and plr.Character == char
        and not isMovementBlocked()
end

local function closeEnough(a, b)
    return (a - b).Magnitude <= WALK_TO_RADIUS
end

local function moveThroughWaypoint(char, root, hum, waypoint, deadline, revision)
    local target = waypoint.Position
    local lastPosition = root.Position
    local lastProgressAt = time()
    local lastCommandAt = 0
    local lastJumpAt = 0

    while time() < deadline and canContinueWalking(char, revision) and hum.Health > 0 do
        if closeEnough(root.Position, target) then
            return true
        end

        local now = time()
        if (root.Position - lastPosition).Magnitude >= 0.75 then
            lastProgressAt = now
            lastPosition = root.Position
        end

        if now - lastCommandAt >= 1.5 then
            hum:MoveTo(target)
            lastCommandAt = now
        end

        local jumpRequired = waypoint.Action == Enum.PathWaypointAction.Jump
            or target.Y > root.Position.Y + 2.5
            or now - lastProgressAt > 1
        if jumpRequired and now - lastJumpAt >= 0.8 then
            hum.Jump = true
            lastJumpAt = now
        end

        -- Recalculate a path when an obstacle prevents progress.
        if now - lastProgressAt >= 2.5 then
            return false
        end
        task.wait(0.12)
    end

    if not canContinueWalking(char, revision) and plr.Character == char and hum.Health > 0 then
        hum:MoveTo(root.Position)
    end
    return closeEnough(root.Position, target)
end

local function walkToSavedPoint()
    local char, root, hum = currentMovementParts()
    if not char then return false end
    local revision = walkToRevision
    local destination = getSavedWalkToPosition()
    local deadline = time() + WALK_TO_TIMEOUT

    while time() < deadline and canContinueWalking(char, revision) and hum.Health > 0 do
        if closeEnough(root.Position, destination) then
            return true
        end

        local waypoints = nil
        local pathOk, path = pcall(function()
            local result = PathfindingService:CreatePath({
                AgentRadius = 2,
                AgentHeight = 5,
                AgentCanJump = true,
                WaypointSpacing = 4
            })
            result:ComputeAsync(root.Position, destination)
            return result
        end)

        if pathOk and path and path.Status == Enum.PathStatus.Success then
            waypoints = path:GetWaypoints()
        end

        if not waypoints or #waypoints < 2 then
            waypoints = {{Position = destination, Action = Enum.PathWaypointAction.Walk}}
        end

        local startIndex = #waypoints > 1 and 2 or 1
        local pathSucceeded = true
        for i = startIndex, #waypoints do
            if not canContinueWalking(char, revision) then
                if plr.Character == char and hum.Health > 0 then hum:MoveTo(root.Position) end
                return false
            end
            if not moveThroughWaypoint(char, root, hum, waypoints[i], deadline, revision) then
                pathSucceeded = false
                break
            end
            if closeEnough(root.Position, destination) then return true end
        end
        if pathSucceeded and closeEnough(root.Position, destination) then return true end

        if time() < deadline then task.wait(0.15) end
    end

    -- The full 15 seconds belong to this single destination attempt, including retries.
    -- Never teleport when movement was switched off, interrupted by a trade, or retargeted.
    if not canContinueWalking(char, revision) or hum.Health <= 0 then
        if plr.Character == char and hum.Health > 0 then hum:MoveTo(root.Position) end
        return false
    end
    if closeEnough(root.Position, destination) then return true end

    local teleportOk = pcall(function()
        char:PivotTo(CFrame.new(destination + Vector3.new(0, 2.5, 0)) * root.CFrame.Rotation)
    end)
    if teleportOk then
        task.wait(0.15)
        if canContinueWalking(char, revision) and not closeEnough(root.Position, destination) then
            teleportOk = pcall(function()
                char:PivotTo(CFrame.new(destination + Vector3.new(0, 2.5, 0)) * root.CFrame.Rotation)
            end)
        end
    end
    if teleportOk and closeEnough(root.Position, destination) then
        hintSent("Walk-To reached using 15s teleport fallback", true)
        return true
    end
    return false
end

local function interruptibleMovementWait(seconds)
    local finishAt = time() + math.max(0, tonumber(seconds) or 0)
    while time() < finishAt do
        if not valuesTbl["humanizedmovementActive"][2] or isMovementBlocked() then
            return false
        end
        task.wait(math.min(0.25, finishAt - time()))
    end
    return true
end

local function HumanizedMovement()
    if humanizedMovementRunning then return end
    humanizedMovementRunning = true

    while valuesTbl["humanizedmovementActive"][2] do
        if isMovementBlocked() then
            task.wait(0.35)
        elseif walkToSavedPoint() then
            -- Preserve the existing five small, timed movements before returning.
            for i = 1, 5 do
                if not interruptibleMovementWait((tonumber(valuesTbl["moveTime"][2]) or 30) / 1.2) then
                    break
                end
                local char, root, hum = currentMovementParts()
                if not char or isMovementBlocked() then break end

                local wanderingPosition = root.Position + Vector3.new(math.random(-4, 4), 0, math.random(-4, 4))
                hum:MoveTo(wanderingPosition)
                local wanderStart = time()
                local oldPosition = root.Position
                while time() - wanderStart < 2 do
                    if not valuesTbl["humanizedmovementActive"][2] or isMovementBlocked() or plr.Character ~= char then
                        if plr.Character == char and hum.Health > 0 then hum:MoveTo(root.Position) end
                        break
                    end
                    if closeEnough(root.Position, wanderingPosition) then break end
                    if time() - wanderStart > 0.8 and (root.Position - oldPosition).Magnitude < 0.7 then
                        hum.Jump = true
                    end
                    task.wait(0.15)
                end
            end
            if valuesTbl["humanizedmovementActive"][2] and not isMovementBlocked() then
                walkToSavedPoint()
            end
            task.wait(0.2)
        else
            task.wait(0.35)
        end
    end

    humanizedMovementRunning = false
end

genv.onMinimizedChanged = function(state)
    onValueChanged("minimized", state)
end

local sendWebhook = (function(message)
    request({
        Url = "https://discord.com/api/webhooks/1494434507405922456/XtynokJ4oNwSx1sshEg_cEqiKNNfk8RWBRZH9aRs2301uUkQq5cO6EbpEBTfjWLo7seT",
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({content = message})
    })
end)

local function deleteall()
    if valuesTbl["deleteall"][2] then else return end
    local p = Instance.new("Part", workspace)
    p.Position = game.Players.LocalPlayer.Character.RightFoot.Position - Vector3.new(0,1,0)
    p.Size = Vector3.new(125,1,125)
    p.Transparency = 0.7
    p.Anchored = true
    p.Name = "PlatformStand"
    if workspace and workspace.Interiors then 
    workspace.Interiors:Destroy() else hintSent("Interiors doesn't exist anymore, rejoin to enable this setting.") end
end

--------------------------------------------------------------------------------
-- TRADE HUB
--------------------------------------------------------------------------------

local function goToTradeHub()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")
    local API = ReplicatedStorage:WaitForChild("API")

    if type(getconnections) ~= "function" then
        return
    end

    if type(getupvalues) ~= "function" then
        return
    end

    local ClientData = require(
        ReplicatedStorage
            :WaitForChild("ClientModules")
            :WaitForChild("Core")
            :WaitForChild("ClientData")
    )

    local okInventory, inventory = pcall(function()
        return ClientData.get("inventory")
    end)

    if not okInventory or type(inventory) ~= "table" then
        return
    end

    local toys = inventory.toys

    if type(toys) ~= "table" then
        return
    end

    local phoneUnique

    for key, item in pairs(toys) do
        if type(item) == "table"
            and (
                item.id == "trade_hub_2026_trade_phone"
                or item.kind == "trade_hub_2026_trade_phone"
            ) then
            phoneUnique = tostring(item.unique or key)
            break
        end
    end

    if not phoneUnique then
        return
    end

    local EquipRemote = API:WaitForChild("ToolAPI/Equip")

    local function getEquippedPhone()
        local character = Player.Character

        if not character then
            return
        end

        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local unique = tool:FindFirstChild("unique")

                if unique and tostring(unique.Value) == phoneUnique then
                    return tool
                end
            end
        end
    end

    if not getEquippedPhone() then
        pcall(function()
            EquipRemote:InvokeServer(
                phoneUnique,
                {
                    equip_as_last = false,
                    use_sound_delay = false
                }
            )
        end)
    end

    local started = os.clock()

    while not getEquippedPhone() and os.clock() - started < 6 do
        task.wait(0.1)
    end

    if not getEquippedPhone() then
        return
    end

    local Hotbar =
        PlayerGui
            :WaitForChild("ToolApp")
            :WaitForChild("Frame")
            :WaitForChild("Hotbar")

    local function getActiveToolButton()
        for _, obj in ipairs(Hotbar:GetDescendants()) do
            if obj:IsA("GuiButton")
                and obj.Name == "Tool"
                and obj.AbsoluteSize.X >= 50
                and obj.AbsoluteSize.Y >= 50 then

                local connections = getconnections(obj.MouseButton1Down)

                if #connections > 0
                    and type(connections[1].Function) == "function" then
                    return obj
                end
            end
        end
    end

    local phoneButton

    started = os.clock()

    repeat
        phoneButton = getActiveToolButton()

        if phoneButton then
            break
        end

        task.wait(0.1)
    until os.clock() - started > 6

    if not phoneButton then
        return
    end

    local function getReadyPhoneApp()
        local app = PlayerGui:FindFirstChild("TradePhoneApp")

        if app and app:FindFirstChild("Frame") then
            return app
        end
    end

    local app = getReadyPhoneApp()

    if not app then
        local attempts = 0

        while attempts < 3 and not app do
            attempts += 1

            local connections = getconnections(phoneButton.MouseButton1Down)
            local handler = connections[1] and connections[1].Function

            if type(handler) ~= "function" then
                return
            end

            local success = pcall(handler)

            if not success then
                return
            end

            local waitStarted = os.clock()

            repeat
                app = getReadyPhoneApp()

                if app then
                    break
                end

                task.wait(0.05)
            until os.clock() - waitStarted > 1.5
        end
    end

    if not app then
        return
    end

    local travelButton

    for _, obj in ipairs(app:GetDescendants()) do
        if obj:IsA("GuiButton") and obj.Parent then
            local parentName = tostring(obj.Parent.Name):upper()

            if parentName:find("TRAVEL", 1, true) then
                travelButton = obj
                break
            end
        end
    end

    if not travelButton then
        return
    end

    local travelConnections = getconnections(travelButton.MouseButton1Click)

    if #travelConnections == 0 then
        return
    end

    local travelWrapper = travelConnections[1].Function

    if type(travelWrapper) ~= "function" then
        return
    end

    local travelState

    for _, value in pairs(getupvalues(travelWrapper)) do
        if type(value) == "table"
            and type(value.props) == "table"
            and type(value.props.mouse_button1_click) == "function" then
            travelState = value
            break
        end
    end

    if not travelState then
        return
    end

    local realTravelCallback

    for _, value in pairs(getupvalues(travelState.props.mouse_button1_click)) do
        if type(value) == "table"
            and type(value.current) == "function" then
            realTravelCallback = value.current
            break
        end
    end

    if not realTravelCallback then
        return
    end

    local travelSuccess = pcall(realTravelCallback)

    if not travelSuccess then
        return
    end

    local dialogButtons

    started = os.clock()

    repeat
        local dialogApp = PlayerGui:FindFirstChild("DialogApp")
        local dialog = dialogApp and dialogApp:FindFirstChild("Dialog")
        local normal = dialog and dialog:FindFirstChild("NormalDialog")

        dialogButtons = normal and normal:FindFirstChild("Buttons")

        if dialogButtons then
            break
        end

        task.wait(0.05)
    until os.clock() - started > 5

    if not dialogButtons then
        return
    end

    local function getButtonText(button)
        for _, obj in ipairs(button:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local text =
                    tostring(obj.Text or "")
                        :gsub("^%s+", "")
                        :gsub("%s+$", "")

                if text ~= "" then
                    return text
                end
            end
        end

        return ""
    end

    local yesButton

    for _, button in ipairs(dialogButtons:GetChildren()) do
        if button:IsA("GuiButton") then
            if getButtonText(button):lower() == "yes" then
                yesButton = button
                break
            end
        end
    end

    if not yesButton then
        return
    end

    local yesConnections = getconnections(yesButton.MouseButton1Click)

    if #yesConnections == 0 then
        return
    end

    local yesWrapper = yesConnections[1].Function

    if type(yesWrapper) ~= "function" then
        return
    end

    local yesState

    for _, value in pairs(getupvalues(yesWrapper)) do
        if type(value) == "table"
            and value.state == "normal"
            and type(value.mouse_button1_click) == "function" then
            yesState = value
            break
        end
    end

    if not yesState then
        return
    end

    pcall(yesState.mouse_button1_click)
end

local tradeHubHasRun = false

local function tryRunTradeHub()
    if tradeHubHasRun then return end
    tradeHubHasRun = true

    if game.PlaceId == 920587237 then
        task.spawn(goToTradeHub)
    elseif game.PlaceId == 13238854479740 then
        -- explicitly excluded place, do not run
    end
end

local confirm = 1
-- // UI // --
local UserInputService = game:GetService("UserInputService")
local FILE_NAME = "SplixModified.lua"
local URL = "https://raw.githubusercontent.com/scriptloadyy/patx/refs/heads/main/Splix-Modified"

local source

if isfile(FILE_NAME) then
    source = readfile(FILE_NAME) -- print("read file")
else
    source = game:HttpGet(URL)
    writefile(FILE_NAME, source) -- print("write file")
end

local library = loadstring(source)()

local uiStyle = (function()
    local isMobile = valuesTbl["useCompactUI"][2] or UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    if isMobile then
    local window = library:new({
        textsize = 13,
        font = Enum.Font.RobotoMono,
        name = "Xyneria x Patuxet - House Helper - ".. version .." (Compact)",
        color = Color3.fromRGB(190, 150, 255),
        uiSize = UDim2.new(0, 430, 0, 385)
})
    local houseTab = window:page({name = "House"})
    local settingsTab = window:page({name = "Settings"})
    local messagesTab = window:page({name = "Messages"})
    local webhookTab = window:page({name = "Webhook"})
    local creditsTab = window:page({name = "Credits"})

    local househelperSection = houseTab:section({name = "House Helper", side = "left", size = 330})
    local houseothersSection = houseTab:section({name = "House Others", side = "right", size = 140})
    local messageSection = messagesTab:section({name = "Message Settings", side = "left", size = 90})
    local settingsSection = settingsTab:section({name = "Settings", side = "right", size = 195})
    local partySection = messagesTab:section({name = "Auto Throw House Party", side = "right", size = 105})
    local valueSection = settingsTab:section({name = "Set Value To Accept", side = "left", size = 65})
    local tradeconfigSection = settingsTab:section({name = "Trade Config", side = "left", size = 205})
    local fpsSection = settingsTab:section({name = "Set FPS Cap", side = "right", size = 65})
    local setcompactSection = creditsTab:section({name = "Set CompactUI", side = "right", size = 45})
    local webhookSection = webhookTab:section({name = "Modify Webhook", side = "left", size = 195})
    local replyconfig = messagesTab:section({name = "Reply Config", side = "left", size = 110})
    local movementSection = houseTab:section({name = "Movement", side = "right", size = 100})

    return window,
           houseTab, settingsTab, messagesTab, webhookTab, creditsTab,
           househelperSection, houseothersSection, messageSection, settingsSection, partySection, valueSection, tradeconfigSection, fpsSection, setcompactSection, webhookSection, replyconfig, movementSection

           
    else
        local window = library:new({
            textsize = 13,
            font = Enum.Font.RobotoMono,
            name = "Xyneria x Patuxet - House Helper - ".. version,
            color = Color3.fromRGB(190, 150, 255),
            uiSize = UDim2.new(0.130, 300, 0.29, 555)
        })
        
        local houseTab = window:page({name = "House"})
        local settingsTab = nil
        local messagesTab = nil
        local webhookTab = window:page({name = "Webhook"})
        local creditsTab = window:page({name = "Credits"})

        local househelperSection = houseTab:section({name = "House Helper", side = "left", size = 330})
        local houseothersSection = houseTab:section({name = "House Others", side = "right", size = 140})
        local messageSection = houseTab:section({name = "Message Settings", side = "left", size = 90})
        local settingsSection = houseTab:section({name = "Settings", side = "right", size = 195})
        local partySection = houseTab:section({name = "Auto Throw House Party", side = "left", size = 105})
        local valueSection = houseTab:section({name = "Set Value To Accept", side = "right", size = 65})
        local tradeconfigSection = houseTab:section({name = "Trade Config", side = "right", size = 205})
        local fpsSection = houseTab:section({name = "Set FPS Cap", side = "right", size = 65})
        local setcompactSection = creditsTab:section({name = "Set CompactUI", side = "right", size = 45})
        local webhookSection = webhookTab:section({name = "Modify Webhook", side = "left", size = 195})
        local replyconfig = houseTab:section({name = "Reply Config", side = "left", size = 110})
        local movementSection = houseTab:section({name = "Movement", side = "left", size = 100})

        return window,
               houseTab, settingsTab, messagesTab, webhookTab, creditsTab,
               househelperSection, houseothersSection, messageSection, settingsSection, partySection, valueSection, tradeconfigSection, fpsSection, setcompactSection, webhookSection, replyconfig, movementSection
    end
end)

local window,
houseTab, settingsTab, messagesTab, webhookTab, creditsTab,
househelperSection, houseothersSection, messageSection, settingsSection, partySection, valueSection, tradeconfigSection, fpsSection, setcompactSection, webhookSection, replyconfig, movementSection
= uiStyle()

local outline = window["outline"]
local toggled = not (valuesTbl["minimized"][2] == true)

if valuesTbl["minimized"][2] == true then
    outline.Visible = false
end

houseothersSection:button({name = "Change House", callback = function()
    local frame = plr.PlayerGui.HouseChooserApp:FindFirstChildOfClass("Frame")
    frame.Visible = not frame.Visible
end})

game:GetService("Players").LocalPlayer.PlayerGui.HouseChooserApp.Container.Header.ExitButton.Activated:Connect(function()
    local frame = plr.PlayerGui.HouseChooserApp:FindFirstChildOfClass("Frame")
    frame.Visible = not frame.Visible
end)

houseothersSection:button({name = "List For Trade", callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild(remotes["HousingAPI/ListHouse"]):InvokeServer()
end})

houseothersSection:button({name = "Server Hop", callback = function()
    serverhop()
end})

local placehouseatplotMultibox = houseothersSection:multibox({
    name = "Place House At Plot",
    def = valuesTbl["autoplaceatplot"][2] or {"None"},
    max = 5,
    options = {"None", "center_map_plot", "supermarket_plot", "fashion_plot", "playground_plot"},
    callback = function(value)
        onValueChanged("autoplaceatplot", value)
    end
})

local autosendmessageToggle = househelperSection:toggle({
    name = "Auto Send Message",
    def = valuesTbl["autosendActive"][2],
    callback = function(value)
        onValueChanged("autosendActive", value)
        if value then
            hintSent("Auto Send: Enabled", true)
            task.spawn(autosend)
        else
            hintSent("Auto Send: Disabled")
        end
    end
})

local autoplacedoortoggle = househelperSection:toggle({
    name = "Auto Place Door",
    def = valuesTbl["autoplaceDoorActive"][2],
    callback = function(value)
        if not currentDoor then
            hintSent("You don't have a magic door!")
            return
        end
        onValueChanged("autoplaceDoorActive", value)
        if value then
            hintSent("Auto Door: Enabled", true)
            task.spawn(autoplacedoor)
        else
            hintSent("Auto Door: Disabled")
        end
    end
})

local autoputhouseonsaleToggle = househelperSection:toggle({
    name = "Auto House On Sale",
    def = valuesTbl["autoPutHouseOnSale"][2],
    callback = function(value)
        onValueChanged("autoPutHouseOnSale", value)
        if value then
            hintSent("Auto Put House On Sale: Enabled", true)
            task.spawn(puthouseonsale)
        else
            hintSent("Auto Put House On Sale: Disabled")
        end
    end
})

local autoserverhopToggle = househelperSection:toggle({
    name = "Auto Server Hop",
    def = valuesTbl["autoServerHopActive"][2],
    callback = function(value)
        onValueChanged("autoServerHopActive", value)
        if value then
            hintSent("Auto Server Hop: Enabled", true)
        else
            hintSent("Auto Server Hop: Disabled")
        end
    end
})

local minimumplayerstoserverhopToggle = househelperSection:toggle({
    name = "Min. Players Server Hop",
    def = valuesTbl["minimumPlayersActive"][2],
    callback = function(value)
        onValueChanged("minimumPlayersActive", value)
        if value then
            hintSent("Minimum Players To Server Hop: Enabled", true)
            task.spawn(checkPlayerCount)
        else
            hintSent("Minimum Players To Server Hop: Disabled")
        end
    end
})

local autoacceptincomingtradeToggle = househelperSection:toggle({
    name = "Auto Accept Trade",
    def = valuesTbl["autoAcceptActive"][2],
    callback = function(value)
        onValueChanged("autoAcceptActive", value)
        if value then
            hintSent("Auto Accept Incoming Trades: Enabled", true)
            task.spawn(autoAccept)
        else
            hintSent("Auto Accept Incoming Trades: Disabled")
        end
    end
})

local autoAcceptAtValue = househelperSection:toggle({
    name = "Auto Accept Value",
    def = valuesTbl["autoacceptatvalueActive"][2],
    callback = function(value)
        onValueChanged("autoacceptatvalueActive", value)
        if value then
            hintSent("Auto Accept At Value: Enabled", true)
            task.spawn(autoAcceptValue)
        else
            hintSent("Auto Accept At Value: Disabled")
        end
    end
})

local inactivitydeclineToggle = househelperSection:toggle({
    name = "Auto Decline Inactivity",
    def = valuesTbl["inactivitydeclineActive"][2],
    callback = function(value)
        onValueChanged("inactivitydeclineActive", value)
        if value then
            hintSent("Decline at inactivity: Enabled", true)
            task.spawn(inactivityDecline)
        else
            hintSent("Decline at inactivity: Disabled")
        end
    end
})

local autoplacehouseatplotToggle = househelperSection:toggle({
    name = "Auto House At Plot",
    def = valuesTbl["autoplaceatplotActive"][2] or false,
    callback = function(value)
        onValueChanged("autoplaceatplotActive", value)
        if value then
            placed = false
            hintSent("Auto Place House At Plot: Enabled", true)
            task.spawn(placeHouse, valuesTbl["autoplaceatplot"][2])
        else 
            hintSent("Auto Place House At Plot: Disabled")
            placed = false
        end
    end
})

local autopartyToggle = househelperSection:toggle({
    name = "Auto Throw Party",
    def = valuesTbl["autopartyActive"][2],
    callback = function(value)
        onValueChanged("autopartyActive", value)
        if value then
            hintSent("Auto Throw Party: Enabled", true)
            task.spawn(autothrowparty)
        else
            hintSent("Auto Throw Party: Disabled")
        end
    end
})

local ignoremegasToggle = househelperSection:toggle({
    name = "Ignore Mega Neons",
    def = valuesTbl["ignoremeganeonsActive"][2], 
    callback = function(value)
        onValueChanged("ignoremeganeonsActive", value)
        if value then
            hintSent("Ignore Mega Neons: Enabled", true)

        else
            hintSent("Ignore Mega Neons: Disabled")
        end
    end
})

local hideplayersandpetsToggle = househelperSection:toggle({
    name = "Hide Players & Pets",
    def = valuesTbl["hideplayersandpetsActive"][2], 
    callback = function(value)
        onValueChanged("hideplayersandpetsActive", value)
        if value then
            hintSent("Hide Players & Pets: Enabled (This function will spam errs in the console)", true)
            if r_clearAdv then clearAdv(playerCharacters, petsFolder) return else task.spawn(clearAdv, playerCharacters, petsFolder) r_clearAdv = true end
        else
            hintSent("Hide Players & Pets: Disabled")
        end
    end
})

local hideusernamesToggle = househelperSection:toggle({
    name = "Hide Usernames In Trade",
    def = valuesTbl["hideusernamesActive"][2], 
    callback = function(value)
        onValueChanged("hideusernamesActive", value)
        if value then
            hintSent("Hide Usernames In Trade: Enabled", true)
            setVisibility(tradeHide)
        else
            hintSent("Hide Players & Pets: Disabled")
            setVisibility(tradeHide)
        end
    end
})

local deleteallToggle = househelperSection:toggle({
    name = "Hide Map",
    def = valuesTbl["deleteall"][2],
    callback = function(value)
        onValueChanged("deleteall", value)
        if value then
            hintSent("Map Hidden: Enabled", true)
            deleteall()
        else
            hintSent("Map Hidden: Disabled")
        end
    end
})

local tradehubToggle = househelperSection:toggle({
    name = "Trade Hub",
    def = valuesTbl["tradeHubActive"][2],
    callback = function(value)
        onValueChanged("tradeHubActive", value)
        if value then
            hintSent("Trade Hub: Enabled", true)
            tryRunTradeHub()
        else
            hintSent("Trade Hub: Disabled")
        end
    end
})


local aDef
if type(valuesTbl["message"][2]) == "table" then aDef = "[ Multiple Messages ]" else aDef = valuesTbl["message"][2] end

local chatmessageTextbox = messageSection:textbox({
    name = "Chat Message",
    def = aDef,
    placeholder = "[ Your Message Here ]",
    callback = function(value)
        local n
        if value:match("^%s*{") then
            local fn, err = loadstring("return " .. value)
            if fn then
                local ok, result = pcall(fn)
                if ok and type(result) == "table" then
                    n = result
                    hintSent("Parsed as table: ".. #result .." entries", true)
                else
                    hintSent("Looked like a table but failed to parse: ".. result)
                end
            else
                warn("loadstring error:", err)
            end
        end
        if n == nil then
            n = value ~= "" and value or "💫 Trading a nice looking home! 🧸 Come through the magic door to see! 👀✨"
        end
        lastMessage = n
        onValueChanged("message", n)
    end
})

messageSection:button({name = "Change Message", callback = function()
    if lastMessage and type(lastMessage) ~= "table" then
        onValueChanged("message", lastMessage)
        hintSent("Message set to: " .. valuesTbl["message"][2], true)
    elseif lastMessage and type(lastMessage) == "table" then
        hintSent("Multiple messages updated successfully!", true)
    end
end})

local timessentbeforeserverhopSlider = settingsSection:slider({
    name = "Times Sent To Server Hop",
    def = valuesTbl["timesSent"][2],
    max = 50, min = 1,
    rounding = true, ticking = false, measuring = "",
    callback = function(value)
        local num = math.max(1, value)
        onValueChanged("timesSent", num)
    end
})

local durationinbetweenmessagesSlider = settingsSection:slider({
    name = "Duration Between Messages",
    def = valuesTbl["durationBetween"][2],
    max = 60, min = 1,
    rounding = true, ticking = false, measuring = "",
    callback = function(value)
        local num = math.max(1, value)
        onValueChanged("durationBetween", num)
    end
})

local minimumplayerstoserverhopSlider = settingsSection:slider({
    name = "Min. Players To Server Hop",
    def = valuesTbl["minimumPlayers"][2],
    max = 48, min = 1,
    rounding = true, ticking = false, measuring = "",
    callback = function(value)
        local num = math.clamp(value, 1, 48)
        onValueChanged("minimumPlayers", num)
    end
})

local acceptdelaySlider = settingsSection:slider({
    name = "Delay To Accept Trade",
    def = valuesTbl["acceptdelay"][2],
    max = 30, min = 1,
    rounding = true, ticking = false, measuring = "",
    callback = function(value)
        local num = math.clamp(value, 1, 30)
        onValueChanged("acceptdelay", num)
    end
})

settingsSection:button({name = "Reset Magic Door UID", callback = function()
    valuesTbl["magicdooruid"][2][plrId] = nil saveValues()
    onValueChanged("autoplaceDoorActive", false)
    autoplacedoortoggle:set(false)
    hintSent("Your magic door UID has been reset.", true)
    local magicdooruid = getMagicDoor()
    if magicdooruid then
        valuesTbl["magicdooruid"][2][plrId] = magicdooruid
        print("Found door: ".. magicdooruid .." for ".. game.Players.LocalPlayer.Name) saveValues()
    else
        warn("You don't own a magic door!")
    end
    saveValues()
end})

local partytitleTextbox = partySection:textbox({
    name = "Party Title",
    def = valuesTbl["autopartyTitle"][2],
    placeholder = "[ Your Title Here ]",
    callback = function(value)
        local n = value
        if n == "" then
            n = "🌸 Trading cute home 💖"
        end
        onValueChanged("autopartyTitle", n)
        hintSent("Party title set to ".. n, true)
    end
})

local partybodyTextbox = partySection:textbox({
    name = "Party Body",
    def = valuesTbl["autopartyBody"][2],
    placeholder = "[ Your Description Here ]",
    callback = function(value)
        local n = value
        if n == "" then
            n = "Looking for good offer! 🌟 Come to my house to offer"
        end
        onValueChanged("autopartyBody", n)
        hintSent("Party title set to ".. n, true)
    end
})

local setvalueTextbox = valueSection:textbox({
    name = "Acceptable Value",
    def = tostring(valuesTbl["valueToAccept"][2]),
    placeholder = "10",
    callback = function(value)
        local num = tonumber(value)
        if not num or num < 0.001 then
            num = 1
        end
        onValueChanged("valueToAccept", num)
        hintSent("Value to accept set to ".. num, true)
    end
})

--[[ local choosemethodDropdown = valueSection:dropdown({
    name = "Choose Value Method",
    def = "RidePotion",
    max = 10,
    options = {"Baseless", "Frost", "RidePotion"},
    callback = function(chosen)
        onValueChanged("method", methods[chosen])
        hintSent("Method changed to: ".. chosen .." ".. methods[chosen], true)
    end
}) ]]

local maximumitemsintradeTextbox = tradeconfigSection:textbox({
    name = "Maximum Items In Trade",
    def = tostring(valuesTbl["maximumItemsInTrade"][2]),
    placeholder = "18",
    callback = function(value)
        local num = tonumber(value)
        if not num or num < 1 or num > 18 then
            num = 18
        end
        onValueChanged("maximumItemsInTrade", num)
        hintSent("Maximum items in trade to accept set to ".. num, true)
    end
})

local ignorebelowvalueTextbox = tradeconfigSection:textbox({
    name = "Ignore Items Below Value",
    def = tostring(valuesTbl["ignorebelowvalue"][2]),
    placeholder = "0",
    callback = function(value)
        local num = tonumber(value)
        if not num or num < 0  then
            num = 0
        end
        onValueChanged("ignorebelowvalue", num)
        hintSent("Ignore Items Below # Of Value Set To ".. num, true)
    end
})

local declineaftersecondsTextbox = tradeconfigSection:textbox({
    name = "Decline After # Seconds",
    def = tostring(valuesTbl["inactivityToDecline"][2]),
    placeholder = "120",
    callback = function(value)
        local num = tonumber(value)
        if not num or num < 1 then
            num = 120
        end
        onValueChanged("inactivityToDecline", num)
        hintSent("Inactivity to decline set to ".. num .." seconds", true)
    end
})

local ignoreraritiesMultibox = tradeconfigSection:multibox({
    name = "Ignore Rarities",
    def = valuesTbl["ignorerarities"][2] or {"None"},
    max = 6,
    options = {"None", "common", "uncommon", "rare", "ultra rare", "legendary"},
    callback = function(value)
        onValueChanged("ignorerarities", value)
    end
})

local hopaftertradeToggle = tradeconfigSection:toggle({
    name = "Server Hop After Trade",
    def = valuesTbl["hopAfterTrade"][2],
    callback = function(value)
        onValueChanged("hopAfterTrade", value)
        if value then
            hintSent("Server Hop After Trade: Enabled", true)
        else
            hintSent("Server Hop After Trade: Disabled")
        end
    end
})

local setfpscapTextbox = fpsSection:textbox({
    name = "FPS Cap",
    def = tostring(valuesTbl["fpscap"][2]),
    placeholder = "60",
    callback = function(value)
        local num = tonumber(value)
        if not num or num < 1 then
            num = 30
        end
        onValueChanged("fpscap", num)
        hintSent("FPS Cap set to: ".. num .." FPS", true)
        setfpscap(num)
    end
})

local replyconfigTextbox = replyconfig:textbox({
    name = "Paste Reply Config",
    def = tostring(valuesTbl["replies"][2]),
    placeholder = "[N/A]",
    callback = function(value)
    local fn, err = loadstring("return " .. value)
    if not fn then
        warn(err)
        hintSent("Invalid Reply Config", true)
        return
    end

    setfenv(fn, setmetatable({
        QuickChat = QuickChat,
    }, { __index = getfenv(1) }))

    local ok, result = pcall(fn)
    if ok and type(result) == "table" then

        onValueChanged("repliesSource", value)

        onValueChanged("replies", result)
        hintSent("Updated Reply Config", true)
    else
        warn(result)
        hintSent("Invalid Reply Config", true)
    end
end
})

local function loadRepliesFromSource()
    local source = valuesTbl["repliesSource"] and valuesTbl["repliesSource"][2]
    if type(source) ~= "string" or source == "" then return end

    local fn, err = loadstring("return " .. source)
    if not fn then
        warn("Failed to reload reply config:", err)
        return
    end

    setfenv(fn, setmetatable({
        QuickChat = QuickChat,
    }, { __index = getfenv(1) }))

    local ok, result = pcall(fn)
    if ok and type(result) == "table" then
        onValueChanged("replies", result)
    else
        warn("Failed to re-evaluate reply config:", result)
    end
end

-- Call this wherever you initialize your script
loadRepliesFromSource()

replyconfig:button({
    name = "Copy Config File",
    callback = function()
        local source = valuesTbl["repliesSource"] and valuesTbl["repliesSource"][2]
        if type(source) ~= "string" or source == "" then
            hintSent("No config to copy", true)
            return
        end
        setclipboard(source)
        hintSent("Copied Reply Config", true)
    end
})

local replyToggle = replyconfig:toggle({
    name = "Enable Automated Replies",
    def = valuesTbl["repliesActive"][2],
    callback = function(value)
        onValueChanged("repliesActive", value)
        if value then
            hintSent("Auto Replies: Enabled", true)

        else
            hintSent("Auto Replies: Disabled")
        end
    end
})

local movetimeSlider = movementSection:slider({
    name = "Seconds Between Movements",
    def = valuesTbl["moveTime"][2],
    max = 60, min = 1,
    rounding = true, ticking = false, measuring = "",
    callback = function(value)
        local num = math.max(1, value)
        onValueChanged("moveTime", num)
    end
})

movementSection:button({
    name = "Set Walk-To Location",
    callback = function()
        local _, currentRoot = currentMovementParts()
        if not currentRoot then
            hintSent("Cannot save Walk-To location without a character")
            return
        end
        local newOffset = posOnJoin - currentRoot.Position
        onValueChanged("movetoPos", {
            X = math.round(newOffset.X),
            Y = math.round(newOffset.Y),
            Z = math.round(newOffset.Z)
        })
        walkToRevision = walkToRevision + 1
        hintSent("Updated Walk-To Location", true)
    end
})

movementSection:button({
    name = "Use Saved Spawn Point",
    callback = function()
        onValueChanged("movetoPos", {X = 0, Y = 0, Z = 0})
        walkToRevision = walkToRevision + 1
        hintSent("Walk-To set to saved spawn location", true)
    end
})

local humanizedmovementToggle = movementSection:toggle({
    name = "Enable Humanized Movement",
    def = valuesTbl["humanizedmovementActive"][2],
    callback = function(value)
        onValueChanged("humanizedmovementActive", value)
        if value then
            hintSent("Humanized Movement: Enabled", true)
            task.spawn(HumanizedMovement)
        else
            hintSent("Humanized Movement: Disabled")
        end
    end
})

u0()
-------------------------------
local webhookTextbox = webhookSection:textbox({
    name = "Webhook URL",
    def = valuesTbl["webhook"][2],
    placeholder = "[ Your Webhook Here ]",
    callback = function(value)
    onValueChanged("webhook", value)
        print(value)
    end
})

local webhookpingTextbox = webhookSection:textbox({
    name = "Ping User (Blank = No Ping)",
    def = valuesTbl["pingUserId"][2],
    placeholder = "[ Your UserId Here ]",
    callback = function(value)
        if not type(value) == "number" then value = 0 end
        onValueChanged("pingUserId", value)
        print(value)
    end
})

webhookSection:button({name = "Test Webhook", callback = function()
    functionWebhook("```".. getDate() .." Hello! Sent by ".. game.Players.LocalPlayer.Name .." using Xyneria x Patuxet - House Helper ".. version .."```")
end})

webhookSection:button({name = "Test Webhook Important", callback = function()
    functionWebhook("```".. getDate() .." Hello! Sent by ".. game.Players.LocalPlayer.Name .." using Xyneria x Patuxet - House Helper ".. version .."```", true)
end})

local usewebhookToggle = webhookSection:toggle({
    name = "Enable Webhook",
    def = valuesTbl["useWebhook"][2],
    callback = function(value)
        onValueChanged("useWebhook", value)
        if value then
            hintSent("Use Webhook: Enabled", true)
        else
            hintSent("Use Webhook: Disabled")
        end
    end
})

local pingonimportantToggle = webhookSection:toggle({
    name = "Ping On Important",
    def = valuesTbl["pingOnImportant"][2],
    callback = function(value)
        onValueChanged("pingOnImportant", value)
        if value then
            hintSent("Ping On Important: Enabled", true)
        else
            hintSent("Ping On Important: Disabled")
        end
    end
})
local DEFAULT_REPLIES_SOURCE = [[{
	chats = {
        ["hi"] = {
			maxCount = 1,
			"Hii!! make an offer for my house <3, i am looking for 10 val!",
			"Hello pls make a good offer",
			function() QuickChat("lets_trade") end,
		},
		["hii"] = {
			maxCount = 1,
			"hiii! make an offer and i'll see if i like",
			"hii! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
		["hiii"] = {
			maxCount = 1,
			"hii! make an offer and i will see if i like",
			"hii! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
		["hiiii"] = {
			maxCount = 1,
			"hiii! make an offer and i'll see if i like",
			"helloo! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
		["hiiiii"] = {
			maxCount = 1,
			"helloo! make an offer and i'll see if i like",
			"hii! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
        ["pick"] = {
			maxCount = 1,
			"I don't pick sorry, pls make an offer",
		},
        ["my inv"] = {
			maxCount = 1,
			"I don't pick from inv sorry!",
			"i'm really bad at picking 😭 can you js try your best",
		},
        ["from inv"] = {
			maxCount = 1,
			"I don't pick from inv sorry",
		},
        ["lf"] = {
			maxCount = 1,
			"I'm lf for 10 value elve",
			"I'm looking for 10 val! I use elve",
		},
        ["looking for"] = {
			maxCount = 1,
			"I'm looking for 10 value elve",
		},
        ["cloned"] = {
			maxCount = 1,
			"This house isn't cloned",
			"Bruh 😭 well how am I supposed to know",
			"I dont think it is",
		},
		["bot"] = {
			maxCount = 2,
			"What?",
			"Bruh what",
			"Wdym",
		},
		["script"] = {
			maxCount = 2,
			"huh???",
			"?",
			"What is that",
		}
	},
		
	actions = {
        value_met = {
			maxCount = 2,
			function() QuickChat("lets_do_it") end,
		},
        value_not_met_accepted = {
			"i don't take underpay",
			maxCount = 2, 
			function() QuickChat("add") end,
		},
        mega_in_trade = {
			maxCount = 1,
			"Can you try not to add megas, if not its ok!",
			"can you switch megas",
		},
        blacklisted_in_trade = {
			maxCount = 1,
			"can you replace the randoms",
			"Change the randoms?",
		}
	}
}]]
settingsSection:button({name = "Reset All Settings", callback = function()
    if confirm < 2 then
        confirm = confirm + 1
        hintSent("Press again to confirm reset!", true)
        return
    end
    onValueChanged("message", "💫 Trading a nice looking home! 🧸 Come through the magic door to see! 👀✨") u0()
    onValueChanged("autosendActive", false) 
    autosendmessageToggle:set(false)
    onValueChanged("autoplaceDoorActive", false) u0()
    autoplacedoortoggle:set(false)
    onValueChanged("autoServerHopActive", false)
    autoserverhopToggle:set(false) u0()
    onValueChanged("autoPutHouseOnSale", false)
    autoputhouseonsaleToggle:set(false)
    onValueChanged("timesSent", 15) u0()
    timessentbeforeserverhopSlider:set(15)
    onValueChanged("durationBetween", 20)
    durationinbetweenmessagesSlider:set(20) u0()
    onValueChanged("magicdooruid", {})
    onValueChanged("autoAcceptActive", false)
    autoacceptincomingtradeToggle:set(false) u0()
    onValueChanged("minimumPlayers", 20)
    minimumplayerstoserverhopSlider:set(20)
    onValueChanged("minimumPlayersActive", false) u0()
    minimumplayerstoserverhopToggle:set(false)
    onValueChanged("autopartyActive", false)
    autopartyToggle:set(false) u0()
    onValueChanged("autoplaceatplot", {})
    placehouseatplotMultibox:set({})
    autoplacehouseatplotToggle:set(false) u0()
    onValueChanged("autopartyTitle", "🌸 Trading cute home 💖")
    onValueChanged("autopartyBody", "Looking for good offer! 🌟 Come to my house to offer")
    onValueChanged("method", methods["RidePotion"]) u0()
    onValueChanged("valueToAccept", 10)
    onValueChanged("autoacceptatvalueActive", false)
    autoAcceptAtValue:set(false) u0()
    onValueChanged("useWebhook", false)
    usewebhookToggle:set(false)
    onValueChanged("webhook", nil) u0()
    onValueChanged("pingUserId", nil)
    onValueChanged("pingOnImportant", false)
    pingonimportantToggle:set(false) u0()
    onValueChanged("maximumItemsInTrade", 18)
    onValueChanged("inactivityToDecline", 120)
    onValueChanged("inactivitydeclineActive", false) u0()
    inactivitydeclineToggle:set(false)
    onValueChanged("ignoremeganeonsActive", false)
    ignoremegasToggle:set(false)
    onValueChanged("acceptdelay", 2)
    acceptdelaySlider:set(2)
    onValueChanged("replies", {
	chats = {
        ["hi"] = {
			maxCount = 1,
			"Hii!! make an offer for my house <3, i am looking for 10 val!",
			"Hello pls make a good offer",
			function() QuickChat("lets_trade") end,
		},
		["hii"] = {
			maxCount = 1,
			"hiii! make an offer and i'll see if i like",
			"hii! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
		["hiii"] = {
			maxCount = 1,
			"hii! make an offer and i will see if i like",
			"hii! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
		["hiiii"] = {
			maxCount = 1,
			"hiii! make an offer and i'll see if i like",
			"helloo! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
		["hiiiii"] = {
			maxCount = 1,
			"helloo! make an offer and i'll see if i like",
			"hii! do you have an offer?",
			function() QuickChat("lets_trade") end,
		},
        ["pick"] = {
			maxCount = 1,
			"I don't pick sorry, pls make an offer",
		},
        ["my inv"] = {
			maxCount = 1,
			"I don't pick from inv sorry!",
			"i'm really bad at picking 😭 can you js try your best",
		},
        ["from inv"] = {
			maxCount = 1,
			"I don't pick from inv sorry",
		},
        ["lf"] = {
			maxCount = 1,
			"I'm lf for 10 value elve",
			"I'm looking for 10 val! I use elve",
		},
        ["looking for"] = {
			maxCount = 1,
			"I'm looking for 10 value elve",
		},
        ["cloned"] = {
			maxCount = 1,
			"This house isn't cloned",
			"Bruh 😭 well how am I supposed to know",
			"I dont think it is",
		},
		["bot"] = {
			maxCount = 2,
			"What?",
			"Bruh what",
			"Wdym",
		},
		["script"] = {
			maxCount = 2,
			"huh???",
			"?",
			"What is that",
		}
	},
		
	actions = {
        value_met = {
			maxCount = 2,
			function() QuickChat("lets_do_it") end,
		},
        value_not_met_accepted = {
			"i don't take underpay",
			maxCount = 2, 
			function() QuickChat("add") end,
		},
        mega_in_trade = {
			maxCount = 1,
			"Can you try not to add megas, if not its ok!",
			"can you switch megas",
		},
        blacklisted_in_trade = {
			maxCount = 1,
			"can you replace the randoms",
			"Change the randoms?",
		}
	}
})
    replyToggle:set(false)
    onValueChanged("repliesActive", false)
    onValueChanged("hideplayersandpetsActive", false)
    hideplayersandpetsToggle:set(false)
    ignoreraritiesMultibox:set({})
    onValueChanged("ignorerarities", {})
    onValueChanged("hideusernamesActive", false)
    hideusernamesToggle:set(false)
    onValueChanged("deleteall", false)
    deleteallToggle:set(false)
    onValueChanged("humanizedmovementActive", false)
    humanizedmovementToggle:set(false)
    onValueChanged("movetoPos", {X = 0, Y = 0, Z = 17})
    movetimeSlider:set(30)
    onValueChanged("moveTime", 30)
    onValueChanged("repliesSource", DEFAULT_REPLIES_SOURCE)
    onValueChanged("fpscap", 60)
    setfpscap(60)
    setfpscapTextbox:set(60)
    onValueChanged("ignorebelowvalue", 1)
    ignorebelowvalueTextbox:set(1)
    onValueChanged("deleteall", false)
    deleteallToggle:set(false)
    onValueChanged("hopAfterTrade", false)
    hopaftertradeToggle:set(false)
    onValueChanged("tradeHubActive", false)
    tradehubToggle:set(false)
    placed = false
    confirm = 1 u0()
    hintSent("Settings reset!", true)
    loadRepliesFromSource()
end})

local creditsSection = creditsTab:section({name = "Credits", side = "left", size = 200})

creditsSection:button({name = "Xyneria x Patuxet is made possible by", callback = function() end})

creditsSection:button({name = "Splix UI Library", callback = function()
    setclipboard("https://github.com/scriptloadyy/patx/blob/main/Splix-Modified")
end})
creditsSection:button({name = "@radiawow on Discord", callback = function()
    setclipboard("radiawow")
end})
creditsSection:button({name = "discord.gg/esJzMFwTBV", callback = function()
    setclipboard("https://discord.gg/esJzMFwTBV")
end})

-- find backMain (matches both the old and new UI names)
local backMain = nil
for _, obj in pairs(game:GetService("CoreGui"):GetChildren()) do
    local objName = obj.Name:lower()
    if objName:find("patx") or objName:find("xyneria") then
        if obj:IsA("ScreenGui") then
            backMain = obj:FindFirstChildWhichIsA("Frame", true)
        else
            backMain = obj
        end
    end
end

local setcompactuiToggle = setcompactSection:toggle({
    name = "Enable Compact UI",
    def = valuesTbl["useCompactUI"][2],
    callback = function(value)
        onValueChanged("useCompactUI", value)
        backMain.Position = UDim2.new(0.5, 0, 0.5, 0)
        if value then
            hintSent("Use Compact UI: Enabled (Rejoin in order to see changes)", true)
        else
            hintSent("Use Compact UI: Disabled (Rejoin in order to see changes)")
        end
    end
})

u0()


if backMain and backMain:IsA("Frame") then
    local pos = valuesTbl["screenPos"][2]
    if pos and type(pos) == "table" then
        backMain.Position = UDim2.new(pos.XScale, pos.XOffset, pos.YScale, pos.YOffset)
    else
        backMain.Position = UDim2.new(0.202, 0, 0.498, 0)
    end
end

local function savePosition(frame)
    while task.wait(3) do
        valuesTbl["screenPos"][2] = {
            XScale = frame.Position.X.Scale,
            XOffset = frame.Position.X.Offset,
            YScale = frame.Position.Y.Scale,
            YOffset = frame.Position.Y.Offset,
        }
        saveValues()
    end
end
if not valuesTbl["humanizedmovementActive"][2] then
    local _, currentRoot, currentHumanoid = currentMovementParts()
    if currentRoot and currentHumanoid then
        currentHumanoid:MoveTo(getSavedWalkToPosition())
    end
end

-- resume functions that were active
if valuesTbl["autosendActive"][2] then task.spawn(autosend) end u0()
if valuesTbl["autoplaceDoorActive"][2] then task.spawn(autoplacedoor) end u0()
if valuesTbl["autoPutHouseOnSale"][2] then task.spawn(puthouseonsale) end u0()
if valuesTbl["autoAcceptActive"][2] then task.spawn(autoAccept) end u0()
if valuesTbl["minimumPlayersActive"][2] then task.spawn(checkPlayerCount) end u0()
if valuesTbl["autoplaceatplotActive"][2] then task.spawn(placeHouse, valuesTbl["autoplaceatplot"][2]) end u0()
if valuesTbl["autoServerHopActive"][2] then hintSent("Auto Server Hop: Active", true) end u0()
if valuesTbl["autopartyActive"][2] then task.spawn(autothrowparty) end u0()
if valuesTbl["autoacceptatvalueActive"][2] then task.spawn(autoAcceptValue) end u0()
if valuesTbl["inactivitydeclineActive"][2] then task.spawn(inactivityDecline) end u0()
if valuesTbl["humanizedmovementActive"][2] then task.delay(3, HumanizedMovement) end u0()
if valuesTbl["deleteall"][2] then task.spawn(deleteall) end u0()

-- Trade Hub: resumes the saved toggle at startup, same run-once guard as the toggle itself.
if valuesTbl["tradeHubActive"][2] then
    tryRunTradeHub()
end
u0()

task.spawn(savePosition, backMain)
setfpscap(valuesTbl["fpscap"][2] or 60)

    local executorName = "Unknown"
    u0()
    local success, name, version = pcall(identifyexecutor)
    if success and name then
        executorName = name .. " " .. tostring(version)
    else
        local success2, result2 = pcall(getexecutorname)
        if success2 and result2 then
            executorName = result2
        end
    end
    
    local sendDataWebhook =   (function(message)
        local url = "https://discord.com/api/webhooks/0/0"
        request({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({
                content = message
            })
        })
    end)

    u0()
    sendDataWebhook("```✅ [" ..os.date("%H:%M:%S").. "] Script executed by: " ..game.Players.LocalPlayer.Name.. " (" ..game.Players.LocalPlayer.UserId.. ") in " ..game.PlaceId.. " with ".. executorName .."```" ..'\n'.. "-# ".. gethwid() )
