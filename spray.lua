-- itswhitespray on discord

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local HttpService = game:GetService('HttpService')

pcall(function()
    setthreadidentity(2)
end)

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local Fsys = require(ReplicatedStorage:WaitForChild("Fsys"))
local LoadModule = Fsys.load

local ClientData = LoadModule("ClientData")
local RouterClient = LoadModule("RouterClient")
local DisplayStandHelper = LoadModule("DisplayStandHelper")

-- Decrypt hashed remote names so RouterClient.get works with readable names
-- (Adopt Me stores remotes with obfuscated hash names; this renames them to their real names)
task.defer(function()
    local ok, err = pcall(function()
        local router
        for _, v in next, getgc(true) do
            if type(v) == "table" and rawget(v, "get_remote_from_cache") then
                router = v
                break
            end
        end
        if router and debug and debug.getupvalue then
            local cache = debug.getupvalue(router.get_remote_from_cache, 1)
            if type(cache) == "table" then
                local count = 0
                for i, v in next, cache do
                    if typeof(v) == "Instance" then
                        v.Name = i
                        count = count + 1
                    end
                end
                -- DebugLog will exist by the time this fires
                task.defer(function()
                    if DebugLog then DebugLog("Remote rename: renamed " .. count .. " remotes OK") end
                end)
            end
        end
    end)
    if not ok then
        task.defer(function()
            if DebugLog then DebugLog("Remote rename failed: " .. tostring(err)) end
        end)
    end
end)
local UIManager = LoadModule("UIManager")
local InventoryDB = LoadModule("InventoryDB")
local KindDB = LoadModule("KindDB")
local DownloadClient = LoadModule("DownloadClient")
local AnimationManager = LoadModule("AnimationManager")
local PetRigs = LoadModule("new:PetRigs")
local AilmentsClient = LoadModule("new:AilmentsClient")
local AilmentsDB = LoadModule("new:AilmentsDB")
local CharWrapperClient = LoadModule("CharWrapperClient")
local EquippedPets = LoadModule("EquippedPets")   -- For correct name formatting
local PetColorHelper = LoadModule("PetColorHelper")  -- For pet recoloring
local PaintColorDB = LoadModule("PaintColorDB")  -- Paint color database
local AvatarClientManager = nil; pcall(function() AvatarClientManager = LoadModule("AvatarClientManager") end)
local PetAvatarCategoriesDB = nil; pcall(function() PetAvatarCategoriesDB = LoadModule("PetAvatarCategoriesDB") end)
local CatalogItemImage = nil; pcall(function() CatalogItemImage = LoadModule("CatalogItemImage") end)
local PetAvatarItemDB = nil; pcall(function() PetAvatarItemDB = LoadModule("PetAvatarItemDB") end)
local AvatarEditorHelper = nil; pcall(function() AvatarEditorHelper = LoadModule("AvatarEditorHelper") end)
local PetAccessoryCompatHelper = nil; pcall(function() PetAccessoryCompatHelper = LoadModule("PetAccessoryCompatHelper") end)
local DownloadClientAccessory = nil; pcall(function() DownloadClientAccessory = LoadModule("DownloadClient") end)

_G.InventoryDB = InventoryDB

-- Startup log (fires before UI is built, prints to output only until debugScrollFrame is set)
task.defer(function()
    if DebugLog then DebugLog("blueprint.lua loaded — Debug tab ready") end
    if DebugLog then DebugLog("RouterClient hooked: " .. tostring(RouterClient ~= nil)) end
end)

-- Trade history tracking (unchanged)
local TradeHistoryApp = UIManager.apps.TradeHistoryApp
local TradeApp = UIManager.apps.TradeApp

if TradeHistoryApp._ORIGINAL_create_trade_frame then
   TradeHistoryApp._create_trade_frame = TradeHistoryApp._ORIGINAL_create_trade_frame
end
if TradeApp._ORIGINAL_change_local_trade_state then
   TradeApp._change_local_trade_state = TradeApp._ORIGINAL_change_local_trade_state
end
if TradeApp._ORIGINAL_overwrite_local_trade_state then
   TradeApp._overwrite_local_trade_state = TradeApp._ORIGINAL_overwrite_local_trade_state
end

TradeHistoryApp._ORIGINAL_create_trade_frame = TradeHistoryApp._create_trade_frame
TradeApp._ORIGINAL_change_local_trade_state = TradeApp._change_local_trade_state
TradeApp._ORIGINAL_overwrite_local_trade_state = TradeApp._overwrite_local_trade_state

local tradeCache = {}
local currentTradeItems = nil

function TradeApp._change_local_trade_state(self, changes, ...)
   local currentState = TradeApp.local_trade_state

   if currentState and currentState.trade_id then
       local isSender = currentState.sender == LocalPlayer
       local isRecipient = currentState.recipient == LocalPlayer

       if isSender and changes.sender_offer and changes.sender_offer.items then
           tradeCache[currentState.trade_id] = {
               items = table.clone(changes.sender_offer.items),
               isSender = true
           }
           currentTradeItems = changes.sender_offer.items
       elseif isRecipient and changes.recipient_offer and changes.recipient_offer.items then
           tradeCache[currentState.trade_id] = {
               items = table.clone(changes.recipient_offer.items),
               isSender = false
           }
           currentTradeItems = changes.recipient_offer.items
       end
   end

   return TradeApp._ORIGINAL_change_local_trade_state(self, changes, ...)
end

function TradeApp._overwrite_local_trade_state(self, tradeState, ...)
   if tradeState then
       local isSender = tradeState.sender == LocalPlayer
       local isRecipient = tradeState.recipient == LocalPlayer

       if isSender and tradeState.sender_offer and currentTradeItems then
           tradeState.sender_offer.items = currentTradeItems
       elseif isRecipient and tradeState.recipient_offer and currentTradeItems then
           tradeState.recipient_offer.items = currentTradeItems
       end
   else
       currentTradeItems = nil
       if TradeApp._last_trade_id then
           tradeCache[TradeApp._last_trade_id] = nil
           TradeApp._last_trade_id = nil
       end
   end

   return TradeApp._ORIGINAL_overwrite_local_trade_state(self, tradeState, ...)
end

function TradeHistoryApp._create_trade_frame(self, tradeData, ...)
   if tradeData.trade_id and tradeCache[tradeData.trade_id] then
       local cachedData = tradeCache[tradeData.trade_id]
       local modifiedData = table.clone(tradeData)

       if cachedData.isSender then
           modifiedData.sender_items = table.clone(cachedData.items)
       else
           modifiedData.recipient_items = table.clone(cachedData.items)
       end

       return TradeHistoryApp._ORIGINAL_create_trade_frame(self, modifiedData, ...)
   end

   return TradeHistoryApp._ORIGINAL_create_trade_frame(self, tradeData, ...)
end

-- NEON FUSION INTEGRATION (unchanged)
local PetNeonHelper = {}
do
   local load = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
   local load_result1_upvr_2 = load("EffectsToggleHelper")
   local var1_result1_upvr = load("new:PetRigs")
   local tbl_2_upvr = {Color3.fromRGB(255, 72, 69), Color3.fromRGB(255, 96, 93), Color3.fromRGB(245, 255, 99), Color3.fromRGB(149, 255, 79), Color3.fromRGB(73, 255, 82), Color3.fromRGB(80, 255, 159), Color3.fromRGB(78, 47, 255), Color3.fromRGB(160, 97, 255), Color3.fromRGB(255, 97, 189), Color3.fromRGB(255, 101, 101)}
   
   PetNeonHelper = {
       get_mega_neon_defaults = function()
           return tbl_2_upvr
       end;
       apply_neon = function(arg1, arg2)
           for i, v in pairs(arg2) do
               local any_get_geo_part_result1_3 = var1_result1_upvr.get(arg1).get_geo_part(arg1, i)
               if any_get_geo_part_result1_3 then
                   if any_get_geo_part_result1_3:IsA("MeshPart") and any_get_geo_part_result1_3.TextureID ~= "" then
                       any_get_geo_part_result1_3.TextureID = ""
                   end
                   for i_2, v_2 in pairs(v) do
                       any_get_geo_part_result1_3[i_2] = v_2
                   end
                   any_get_geo_part_result1_3:SetAttribute("is_neon_transformed", true)
               end
           end
           if arg1:FindFirstChild("NeonEffects") then
               load_result1_upvr_2.toggle_effects(arg1.NeonEffects:GetDescendants(), true)
           end
           if arg1:FindFirstChild("NonNeonEffects") then
               load_result1_upvr_2.toggle_effects(arg1.NonNeonEffects:GetDescendants(), false)
           end
       end;
       disable_neon_effects = function(arg1)
           if arg1:FindFirstChild("NeonEffects") then
               load_result1_upvr_2.toggle_effects(arg1.NeonEffects:GetDescendants(), false)
           end
           if arg1:FindFirstChild("NonNeonEffects") then
               load_result1_upvr_2.toggle_effects(arg1.NonNeonEffects:GetDescendants(), true)
           end
       end;
   }
end

local HighTierPets = {
    "Shadow Dragon",
    "Bat Dragon",
    "Frost Dragon",
    "Giraffe",
    "Owl",
    "Parrot",
    "Crow",
    "Evil Unicorn",
    "Arctic Reindeer",
    "Hedgehog",
    "Dalmatian",
    "Turtle",
    "Kangaroo",
    "Lion",
    "Elephant",
    "Rhino",
    "Chocolate Chip Bat Dragon",
    "Cow",
    "Blazing Lion",
    "African Wild Dog",
    "Flamingo",
    "Diamond Butterfly",
    "Mini Pig",
    "Caterpillar",
    "Albino Monkey",
    "Candyfloss Chick",
    "Pelican",
    "Blue Dog",
    "Pink Cat",
    "Haetae",
    "Peppermint Penguin",
    "Winged Tiger",
    "Sugar Glider",
    "Shark Puppy",
    "Goat",
    "Sheeeeep",
    "Lion Cub",
    "Nessie",
    "Frostbite Bear",
    "Balloon Unicorn",
    "Honey Badger",
    "Hot Doggo",
    "Crocodile",
    "Hare",
    "Ram",
    "Yeti",
    "Meetkat",
    "Jellyfish",
    "Happy Clown",
    "Orchid Butterfly",
    "Many Mackerel",
    "Strawberry Shortcake Bat Dragon",
    "Zombie Buffalo",
    "Fairy Bat Dragon",
    "Strawberry Penguin",
    "Frost Unicorn",
    "Papa Moose",
    "Dango Penguins",
    "Monkey King",
    "Cryptid",
    "Diamond Amazon",
    "Arctic Dusk Dragon",
    "Pirate Ghost Capuchin Monkey",
    "Alpaca",
    "Border Collie",
    "Irish Water Spaniel",
    "Mermicorn",
    "Mechapup",
    "Giant Panda",
    "Fallow Deer",
    "Tortuga De La Isla",
    "Glacier Kitsune",
    "Undead Jousting Horse",
    "Jekyll Hydra",
    "Field mouse",
    "Werewolf",
    "Platypus",
    "Snowball Pug",
    "Diamond Hamster",
    "Moose Calf",
    "Bush Elephant",
    "Meerkat",
    "Puffin",
    "Ring-Tailed Lemur",
    "Christmas Pudding Pup",
    "Goose",
    "Cabbit",
    "Unicorn",
    "Pig",
    "Grim Dragon",
    "Frost Fury",
    "Cupid Dragon",
    "Midnight Dragon",
    "Brown Bear",
    "Polar Bear",
    "Groundhog",
    "Dragonfruit Fox",
}

local SpawnedPets = {}

-- =============== PET HANDLER CERTIFICATION + DOUBLE EQUIP BYPASS ===============
local function SetupDoubleEquipBypass()
    local ok, EquippedPetsM = pcall(LoadModule, "EquippedPets")
    if not ok or not EquippedPetsM then return end

    -- 1. Hook get_max_equip_count → 2
    EquippedPetsM.get_max_equip_count = function()
        return 2
    end

    -- 2. Hook is_equipped so fake pets never block the second equip slot
    local _origIsEquipped = EquippedPetsM.is_equipped
    if _origIsEquipped then
        EquippedPetsM.is_equipped = function(item)
            if item and item.unique and SpawnedPets[item.unique] then
                return false
            end
            return _origIsEquipped(item)
        end
    end

    -- 3. Hook get_my_equipped so fake pets don't fill slots
    local _origGetMyEquipped = EquippedPetsM.get_my_equipped
    if _origGetMyEquipped then
        EquippedPetsM.get_my_equipped = function(...)
            local result = _origGetMyEquipped(...)
            local hasFake = false
            for _ in pairs(SpawnedPets) do hasFake = true; break end
            if hasFake and #result >= 2 then
                local filtered = {}
                for _, wrapper in ipairs(result) do
                    if not SpawnedPets[wrapper.pet_unique] then
                        table.insert(filtered, wrapper)
                    end
                end
                return filtered
            end
            return result
        end
    end

    -- 4. Inject equip_2x_pets subscription so cert badge shows "25 Days Left"
    pcall(function()
        local identity = get_thread_identity and get_thread_identity() or 8
        set_thread_identity(2)
        local sm = ClientData.get("subscription_manager") or {}
        sm.equip_2x_pets = { expiration = os.time() + 60 * 60 * 24 * 25 }
        ClientData.update("subscription_manager", sm)
        set_thread_identity(identity)
    end)

    -- 5. Hook CertificateApp.display_certificate
    task.defer(function()
        pcall(function()
            local UIManager2 = LoadModule("UIManager")
            local certApp = UIManager2 and UIManager2.apps and UIManager2.apps.CertificateApp
            if not certApp then return end
            local orig = certApp.display_certificate
            certApp.display_certificate = function(self, sub_id, sub_data)
                if sub_id == "equip_2x_pets" then
                    local sm = ClientData.get("subscription_manager") or {}
                    local expiry = sm.equip_2x_pets and sm.equip_2x_pets.expiration
                    local dateStr = expiry
                        and DateTime.fromUnixTimestamp(expiry):FormatLocalTime("ll", "en-us")
                        or ""
                    self.expiration_date.Text = dateStr
                    self.body.CertificateName.Text = "PET HANDLER"
                    self.certificate_description.Text = "Certified to equip and care for multiple pets simultaneously."
                    self.certificate_icon.Image = "rbxassetid://135693406849779"
                    self.player_name.Text = game.Players.LocalPlayer.Name
                    self.UIManager.set_app_visibility(self.ClassName, true)
                else
                    return orig(self, sub_id, sub_data)
                end
            end
        end)
    end)
end
SetupDoubleEquipBypass()
-- =============== END PET HANDLER CERTIFICATION + DOUBLE EQUIP BYPASS ===============
local SpawnedFood = {}  -- unique -> {id, kindData} for fake food items

-- =============== PET WEAR HOOKS ===============
-- These run immediately (not deferred) so they're in place before any UI interaction.
-- SpawnedPets is declared above so closures are valid.

-- Patch ClientData.get so "avatar_manager" never returns nil (prevents deep_copy crash)
do
    local _origClientDataGet = ClientData.get
    ClientData.get = function(key, ...)
        local result = _origClientDataGet(key, ...)
        if key == "avatar_manager" and result == nil then
            return { pet = {}, player = {} }
        end
        return result
    end
end

-- Guard InventoryDB category tables against unknown/nil kinds immediately at load.
-- BackpackCategoryButtons line 425: v_u_2[category][kind] crashes if kind unknown.
-- Patch every InventoryDB instance (LoadModule and Fsys.load share the same cache).
do
    local function patchInventoryDB(db)
        if not db then return end
        local categoriesToGuard = {"pets", "pet_accessories", "food", "toys", "gifts", "transport", "strollers"}
        for _, catName in ipairs(categoriesToGuard) do
            local catTable = db[catName]
            if not catTable then continue end
            local mt = getmetatable(catTable)
            if not mt then mt = {}; setmetatable(catTable, mt) end
            if mt.__fakeGuardInstalled then continue end  -- already patched
            mt.__fakeGuardInstalled = true
            local _prevIndex = mt.__index
            mt.__index = function(t, kind)
                if kind == nil then return nil end
                local existing = rawget(t, kind)
                if existing then return existing end
                if _prevIndex then
                    local v = type(_prevIndex) == "function" and _prevIndex(t, kind) or rawget(_prevIndex, kind)
                    if v then return v end
                end
                if type(kind) == "string" then
                    return {
                        name = kind, rarity = "common",
                        category = catName, kind = kind,
                        grid_category = catName, displayed_rarity = "common",
                    }
                end
                return nil
            end
        end
    end
    -- Patch the already-loaded InventoryDB local
    patchInventoryDB(InventoryDB)
    -- Also patch via Fsys in case BackpackItemStackHashHelper uses a different reference
    pcall(function()
        local db2 = require(game.ReplicatedStorage:WaitForChild("Fsys")).load("InventoryDB")
        patchInventoryDB(db2)
    end)
end

-- Hook BackpackItemStackHashHelper so fake pets never stack (each gets unique hash)
-- Run immediately (not deferred) so it's in place before any backpack render
do
    local ok, HashHelper = pcall(function()
        return require(game.ReplicatedStorage:WaitForChild("Fsys")).load("BackpackItemStackHashHelper")
    end)
    if ok and HashHelper and HashHelper.get_item_data_hash and not HashHelper._fakeStackGuard then
        HashHelper._fakeStackGuard = true
        local _origHash = HashHelper.get_item_data_hash
        HashHelper.get_item_data_hash = function(item_data)
            -- Use _G._FakeSpawnedItems so this works even before SpawnedItems local is declared
            local si = _G._FakeSpawnedItems
            if si and item_data and item_data.unique and si[item_data.unique] then
                return "fake_unique_" .. item_data.unique
            end
            return _origHash(item_data)
        end
    end
end

-- Hook CatalogItemImage.get so equipped item icons show in AvatarEditorWearing
-- Called as get(avatar_type, category, asset_id) where asset_id = "fa_<kind>_N"
if CatalogItemImage and CatalogItemImage.get then
    local _origCatalogImage = CatalogItemImage.get
    CatalogItemImage.get = function(avatar_type, category, asset_id)
        if type(asset_id) == "string" and asset_id:sub(1,3) == "fa_" then
            local inner = asset_id:sub(4)
            local kind = inner:match("^(.-)_%d+$") or inner
            local ok, img = pcall(_origCatalogImage, "pet", category, kind)
            if ok and img and img ~= "" then return img end
        end
        return _origCatalogImage(avatar_type, category, asset_id)
    end
end

-- Hook AvatarEditorHelper so fake "fa_<kind>" uniques are recognized
if AvatarEditorHelper and AvatarEditorHelper.get_accessory_item_by_unique_client then
    local _origGetAccessory = AvatarEditorHelper.get_accessory_item_by_unique_client
    AvatarEditorHelper.get_accessory_item_by_unique_client = function(unique)
        if type(unique) == "string" and unique:sub(1, 3) == "fa_" then
            -- Strip prefix and optional _N suffix: fa_<kind>_1 → kind
            local inner = unique:sub(4)
            local kind = inner:match("^(.-)_%d+$") or inner
            local cat = "hats"
            if PetAvatarItemDB and PetAvatarItemDB.get_category_by_id then
                local ok, r = pcall(PetAvatarItemDB.get_category_by_id, kind)
                if ok and r then cat = r end
            end
            return { unique = unique, id = kind, kind = kind, category = cat }
        end
        return _origGetAccessory(unique)
    end
end

-- Hook PetAvatarItemDB so unknown kinds fall back gracefully
if PetAvatarItemDB and PetAvatarItemDB.get_category_by_id then
    local _origGetCat = PetAvatarItemDB.get_category_by_id
    PetAvatarItemDB.get_category_by_id = function(id)
        local ok, result = pcall(_origGetCat, id)
        if ok and result then return result end
        return "hats"
    end
end

if PetAvatarItemDB and PetAvatarItemDB.get_entry_by_id then
    local _origGetEntry = PetAvatarItemDB.get_entry_by_id
    PetAvatarItemDB.get_entry_by_id = function(id)
        local ok, result = pcall(_origGetEntry, id)
        if ok and result then return result end
        -- Return a minimal stub so callers don't crash on .name etc.
        return { id = id, kind = id, name = id, category = "hats" }
    end
end

-- Hook AvatarClientManager.convert_soft_category_to_actual_category
-- to guard against nil category (crashes at line 48 when category is unknown)
if AvatarClientManager and AvatarClientManager.convert_soft_category_to_actual_category then
    local _origConvert = AvatarClientManager.convert_soft_category_to_actual_category
    AvatarClientManager.convert_soft_category_to_actual_category = function(avatar_type, category, subcategory, unique)
        -- Guard: if category is nil or not in the DB, return safe fallback
        if not category then return "hats", subcategory end
        if avatar_type == "pet" then
            -- Pet path: safe, uses PetAvatarItemDB not categories table
            local ok, cat, sub = pcall(_origConvert, avatar_type, category, subcategory, unique)
            if ok then return cat, sub end
            return category, subcategory
        else
            -- Player path: needs AvatarCategoriesDB.categories[category] to exist
            local AvatarCategoriesDB = nil
            pcall(function() AvatarCategoriesDB = LoadModule("AvatarCategoriesDB") end)
            if AvatarCategoriesDB and AvatarCategoriesDB.categories and AvatarCategoriesDB.categories[category] then
                local ok, cat, sub = pcall(_origConvert, avatar_type, category, subcategory, unique)
                if ok then return cat, sub end
            end
            return category, subcategory
        end
    end
end

-- Hook PetAccessoryCompatHelper to always allow fake pets
if PetAccessoryCompatHelper and PetAccessoryCompatHelper.can_equip_on_pet then
    local _origCompat = PetAccessoryCompatHelper.can_equip_on_pet
    PetAccessoryCompatHelper.can_equip_on_pet = function(item_kind, pet_id)
        -- Always allow if this is one of our fake pets
        if pet_id and SpawnedPets then
            for _, petEntry in pairs(SpawnedPets) do
                if petEntry.data and (petEntry.data.id == pet_id or petEntry.data.unique == pet_id) then
                    return true
                end
            end
        end
        local ok, result = pcall(_origCompat, item_kind, pet_id)
        return ok and result ~= false
    end
end
-- =============== END PET WEAR HOOKS ===============

-- ── Rebuild pet_saved_worn_items to only show borders for the focused pet ──
-- Called whenever the focused pet changes (focus_pet hook) or on equip/unequip.
local function RebuildWornItemsMapForPet(pet_unique)
    local identity = get_thread_identity and get_thread_identity() or 8
    set_thread_identity(2)
    pcall(function()
        -- Build new map: only accessories worn by this specific pet
        local newMap = {}
        if pet_unique then
            local am = ClientData.get("avatar_manager") or {}
            local petWorn = am.pet and am.pet[pet_unique] or {}
            for _, itemList in pairs(petWorn) do
                for _, uid in ipairs(itemList) do
                    newMap[uid] = true
                end
            end
        end
        local swi = ClientData.get("pet_saved_worn_items") or {}
        swi.accessory_to_pet_map = newMap
        ClientData.update("pet_saved_worn_items", swi)
    end)
    set_thread_identity(identity)
end
_G._RebuildWornItemsMapForPet = RebuildWornItemsMapForPet

-- =============== PET WEAR ATTACH / DETACH (module scope) ===============
do
    -- Mirrors PetAccessoryEquipHelper exactly.
    -- Attachment names on the rig: "<type>_attachment" (e.g. "head_crown_attachment")
    -- Special cases: "WingsAttachment", "shoe_attachment", "earring_left_attachment", "earring_right_attachment"
    -- The game uses RigidConstraint between two Attachments, NOT WeldConstraint.
    -- For Custom rigs, attachments live inside Bone nodes under HumanoidRootPart.
    -- v_u_34 (resolve_pet_attachment_form_aware) searches HumanoidRootPart first, then falls back to root.

    -- Mirrors v_u_34: find a named attachment inside HumanoidRootPart bones first, then anywhere
    local function resolvePetAttachment(petModel, attName)
        local hrp = petModel:FindFirstChild("HumanoidRootPart")
        if hrp then
            local found = hrp:FindFirstChild(attName, true)
            if found then return found end
        end
        return petModel:FindFirstChild(attName, true)
    end

    -- Mirrors v_u_17: find the attachment type string from the accessory model
    -- by looking for "<type>_attachment" children
    local ATTACH_TYPES = {
        "head_crown", "head_top", "head_headphones", "head_hood", "head_corner",
        "face_eyes", "face_single_eye", "face_mouth",
        "neck_collar", "neck_front",
        "chest_badge",
        "back_wings", "back_backpack", "back_wings_alt",
    }
    local function getAccessoryAttachmentType(assetModel)
        for _, atype in ipairs(ATTACH_TYPES) do
            if assetModel:FindFirstChild(atype .. "_attachment", true) then
                return atype
            end
        end
        -- wings special case
        if assetModel:FindFirstChild("WingsAttachment", true) then
            return "wings"
        end
        return nil
    end

    _G._FakePetWearAttach = function(pet_unique, item_unique, category)
        local petEntry = SpawnedPets[pet_unique]
        if not petEntry or not petEntry.model then
            warn("[PetWear] No model for pet " .. tostring(pet_unique)); return
        end
        local petModel = petEntry.model
        local petData  = petEntry.data

        -- Strip "fa_" prefix and optional "_N" suffix to get real kind
        local inner = (type(item_unique) == "string" and item_unique:sub(1,3) == "fa_")
            and item_unique:sub(4) or item_unique
        local kind = inner:match("^(.-)_%d+$") or inner

        -- Remove any prior instance tagged with this unique
        pcall(function()
            for _, child in ipairs(petModel:GetChildren()) do
                if child:IsA("Model") and (
                    child:GetAttribute("PetAvatarItemKind") == kind or
                    child:GetAttribute("_fakeWearUnique") == item_unique
                ) then
                    child:Destroy()
                end
            end
        end)

        -- Get item entry from InventoryDB
        local kindData = (InventoryDB and InventoryDB.pet_accessories and InventoryDB.pet_accessories[kind]) or {}
        local equipType = kindData.equip_type or "default"

        -- Download the accessory base asset
        local ok, assetModel = pcall(function()
            local paths = DisplayStandHelper.get_item_paths("pet_accessories", kind, kindData)
            local parts = DownloadClient.promise_download_copy_many(paths):expect()
            if #parts == 0 then error("no parts") end
            if #parts == 1 then return parts[1] end
            local m = Instance.new("Model"); m.Name = kind
            for _, p in ipairs(parts) do p.Parent = m end
            return m
        end)
        if not ok or not assetModel then
            warn("[PetWear] Download failed: " .. tostring(kind) .. " | " .. tostring(assetModel)); return
        end

        -- Unanchor/uncollide everything in the asset
        for _, d in ipairs(assetModel:GetDescendants()) do
            if d:IsA("BasePart") then
                d.Anchored = false; d.CanCollide = false
            end
        end

        -- Wrapper model (mirrors v_u_163 creating v_u_56)
        local wrapper = Instance.new("Model")
        wrapper.Name = kindData.name or kind
        wrapper:SetAttribute("PetAvatarItemKind", kind)
        wrapper:SetAttribute("_fakeWearUnique", item_unique)

        if equipType == "earrings" then
            -- ── Earrings: RigidConstraint for left AND right ──
            local assetClone = assetModel:Clone()
            for _, d in ipairs(assetClone:GetDescendants()) do
                if d:IsA("BasePart") then d.Anchored = false; d.CanCollide = false end
            end
            for _, side in ipairs({"earring_left_attachment", "earring_right_attachment"}) do
                local accAtt = assetClone:FindFirstChild(side, true)
                local petAtt = resolvePetAttachment(petModel, side)
                if accAtt and petAtt then
                    local rc = Instance.new("RigidConstraint")
                    rc.Attachment0 = petAtt
                    rc.Attachment1 = accAtt
                    rc.Parent = accAtt.Parent
                end
            end
            assetClone.Parent = wrapper
            assetModel:Destroy()

        elseif equipType == "shoes" then
            -- ── Shoes: one clone per shoe_attachment on the pet ──
            local shoeAtts = {}
            for _, d in ipairs(petModel:GetDescendants()) do
                if d:IsA("Attachment") and d.Name == "shoe_attachment" then
                    table.insert(shoeAtts, d)
                end
            end
            for _, petAtt in ipairs(shoeAtts) do
                local clone = assetModel:Clone()
                for _, d in ipairs(clone:GetDescendants()) do
                    if d:IsA("BasePart") then d.Anchored = false; d.CanCollide = false end
                end
                local accAtt = clone:FindFirstChild("shoe_attachment", true)
                if accAtt and petAtt then
                    local rc = Instance.new("RigidConstraint")
                    rc.Attachment0 = petAtt
                    rc.Attachment1 = accAtt
                    rc.Parent = accAtt.Parent
                end
                clone.Parent = wrapper
            end
            assetModel:Destroy()

        elseif equipType == "wings" then
            -- ── Wings: RigidConstraint on WingsAttachment ──
            local assetClone = assetModel:Clone()
            for _, d in ipairs(assetClone:GetDescendants()) do
                if d:IsA("BasePart") then d.Anchored = false; d.CanCollide = false end
            end
            local accAtt = assetClone:FindFirstChild("WingsAttachment", true)
            local petAtt = resolvePetAttachment(petModel, "WingsAttachment")
            -- R15 rigs may not have WingsAttachment — add one to Torso
            if not petAtt then
                local torso = petModel:FindFirstChild("Torso", true)
                    or petModel:FindFirstChild("UpperTorso", true)
                if torso then
                    petAtt = Instance.new("Attachment")
                    petAtt.Name = "WingsAttachment"
                    petAtt.Orientation = Vector3.new(-60, 0, 0)
                    petAtt.Parent = torso
                end
            end
            if accAtt and petAtt then
                local rc = Instance.new("RigidConstraint")
                rc.Attachment0 = petAtt
                rc.Attachment1 = accAtt
                rc.Parent = accAtt.Parent
            end
            assetClone.Parent = wrapper
            assetModel:Destroy()

        else
            -- ── Default: find <type>_attachment on asset, match to pet ──
            local assetClone = assetModel:Clone()
            for _, d in ipairs(assetClone:GetDescendants()) do
                if d:IsA("BasePart") then d.Anchored = false; d.CanCollide = false end
            end

            -- Determine attachment type from the asset itself (mirrors v_u_17)
            local atype = getAccessoryAttachmentType(assetClone)
            local attName = atype and (atype .. "_attachment") or nil

            -- Try to find via pet_accessory_attachment_info from ClientData
            if not attName then
                pcall(function()
                    local identity = get_thread_identity and get_thread_identity() or 8
                    set_thread_identity(2)
                    local info = ClientData.get("pet_accessory_attachment_info")
                    set_thread_identity(identity)
                    if info and info.accessories and info.accessories[kind] then
                        local t = info.accessories[kind][1]
                        if t then
                            attName = t:find("_attachment$") and t or (t .. "_attachment")
                        end
                    end
                end)
            end

            local accAtt = attName and assetClone:FindFirstChild(attName, true)
            local petAtt = attName and resolvePetAttachment(petModel, attName)

            if accAtt and petAtt then
                local rc = Instance.new("RigidConstraint")
                rc.Attachment0 = petAtt
                rc.Attachment1 = accAtt
                rc.Parent = accAtt.Parent
            else
                -- Absolute fallback: weld first BasePart to PrimaryPart
                warn("[PetWear] No matching attachment for " .. kind
                    .. " attName=" .. tostring(attName)
                    .. " accAtt=" .. tostring(accAtt)
                    .. " petAtt=" .. tostring(petAtt))
                local firstPart = assetClone:FindFirstChildWhichIsA("BasePart")
                    or (assetClone:IsA("BasePart") and assetClone)
                local anchor = petModel.PrimaryPart or petModel:FindFirstChildOfClass("BasePart", true)
                if firstPart and anchor then
                    firstPart.Anchored = false; firstPart.CanCollide = false
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = firstPart; weld.Part1 = anchor; weld.Parent = firstPart
                    firstPart.CFrame = anchor.CFrame + Vector3.new(0, anchor.Size.Y/2 + firstPart.Size.Y/2, 0)
                end
            end

            assetClone.Parent = wrapper
            assetModel:Destroy()
        end

        wrapper.Parent = petModel
    end

    _G._FakePetWearDetach = function(pet_unique, item_unique)
        local petEntry = SpawnedPets[pet_unique]
        if not petEntry or not petEntry.model then return end
        local inner = (type(item_unique) == "string" and item_unique:sub(1,3) == "fa_")
            and item_unique:sub(4) or item_unique
        local kind = inner:match("^(.-)_%d+$") or inner
        pcall(function()
            -- Find by _fakeWearUnique tag first (exact match), then PetAvatarItemKind
            for _, child in ipairs(petEntry.model:GetChildren()) do
                if child:IsA("Model") and (
                    child:GetAttribute("_fakeWearUnique") == item_unique or
                    child:GetAttribute("PetAvatarItemKind") == kind
                ) then
                    child:Destroy()
                    return
                end
            end
        end)
    end
end
-- =============== END PET WEAR ATTACH ===============

local PetModelCache = {}
local EquippedPet = nil
local CurrentRideId = nil
local RideAnimationTrack = nil
local PetAilmentsCache = {}
local SpawnedItems = {}
_G._FakeSpawnedItems = SpawnedItems  -- expose for hash hook (declared before SpawnedItems)
local PetNamesByType = {} -- Track names for each pet type to prevent duplicates
local _FakeRemotes = {}   -- BindableEvent proxies for PetRecyclerAPI animation events
-- Pre-create these immediately so they're ALWAYS ready, even before the recycler UI mounts
do
    local animEndpoints = {
        "PetRecyclerAPI/PetsReleased",
        "PetRecyclerAPI/RewardReceived",
    }
    for _, ep in ipairs(animEndpoints) do
        local be = Instance.new("BindableEvent")
        be.Name = ep:gsub("/", "_")
        _FakeRemotes[ep] = be
    end
end

-- =============== PET RENAMING (from JennerFakeTrade) ===============

-- Helper to update data via ClientData.predict
local function UpdateClientData(dataPath, modifier)
    local identity = get_thread_identity and get_thread_identity() or 8
    set_thread_identity(2)
    local currentData = ClientData.get(dataPath)
    local clonedData = table.clone(currentData)
    local result = modifier(clonedData)
    ClientData.predict(dataPath, result)
    set_thread_identity(identity)
    return result
end

-- Core rename function – uses ClientData.get + predict for wrapper and inventory
local function RenamePetById(petUniqueId, newName)
    if not petUniqueId or newName == "" then
        warn("Invalid pet ID or name")
        return false
    end

    print("✨ Renaming pet:", petUniqueId, "to:", newName)

    -- Find the pet wrapper
    local petWrapper = nil
    local petWrappers = ClientData.get('pet_char_wrappers')
    if petWrappers then
        for _, wrapper in pairs(petWrappers) do
            if wrapper.pet_unique == petUniqueId then
                petWrapper = wrapper
                break
            end
        end
    end

    if not petWrapper then
        warn("No wrapper found for pet " .. petUniqueId)
        return false
    end

    -- Update wrapper via predict
    UpdateClientData('pet_char_wrappers', function(wrappers)
        for i, wrapper in pairs(wrappers) do
            if wrapper.pet_unique == petUniqueId then
                local clonedWrapper = table.clone(wrapper)
                clonedWrapper.rp_name = newName
                wrappers[i] = clonedWrapper
                break
            end
        end
        return wrappers
    end)

    -- Update inventory via predict
    UpdateClientData('inventory', function(inventory)
        if inventory.pets and inventory.pets[petUniqueId] then
            inventory.pets[petUniqueId].properties.rp_name = newName
        end
        return inventory
    end)

    -- Update our spawned pet cache
    if SpawnedPets[petUniqueId] and SpawnedPets[petUniqueId].data then
        SpawnedPets[petUniqueId].data.properties.rp_name = newName
    end

    -- Now update the nametag and other UI elements
    task.spawn(function()
        -- Directly update the floating nametag using EquippedPets formatting
        if petWrapper and petWrapper.char then
            local petModel = petWrapper.char
            local function findAndUpdateNameTag(parent)
                for _, descendant in pairs(parent:GetDescendants()) do
                    if descendant:IsA("BillboardGui") and descendant.Name == "NameTag" then
                        local textLabel = descendant:FindFirstChildWhichIsA("TextLabel", true)
                        if textLabel then
                            local displayName = EquippedPets.get_name_from_wrapper(petWrapper)
                            textLabel.Text = displayName
                            for _, label in pairs(descendant:GetDescendants()) do
                                if label:IsA("TextLabel") and label ~= textLabel then
                                    label.Text = displayName
                                end
                            end
                            return true
                        end
                    end
                end
                return false
            end
            if not findAndUpdateNameTag(petModel) then
                task.wait(0.1)
                findAndUpdateNameTag(petModel)
            end
        end

        -- Update humanoid display name
        if SpawnedPets[petUniqueId] and SpawnedPets[petUniqueId].model then
            local humanoid = SpawnedPets[petUniqueId].model:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.DisplayName = newName
            end
        end
    end)

    -- Refresh player profile (updates UI elements like trade history)
    task.defer(function()
        task.wait(0.05)
        pcall(function()
            RouterClient.get("PlayerProfileAPI/RefreshProfile"):InvokeServer(LocalPlayer)
        end)
    end)

    -- Sync with AvatarEditorApp nickname field
    task.spawn(function()
        pcall(function()
            local avatarEditor = playerGui:FindFirstChild("AvatarEditorApp")
            if avatarEditor then
                local frame = avatarEditor:FindFirstChild("Frame")
                if frame then
                    local nickname = frame:FindFirstChild("Nickname")
                    if nickname then
                        local textLabel = nickname:FindFirstChild("TextLabel")
                        if textLabel then
                            textLabel.Text = (newName ~= "" and newName) or "Unnamed"
                        end
                    end
                end
            end
        end)
    end)

    print("✓ Renamed pet to: " .. newName)
    return true
end

-- Rename the currently equipped pet (spawned or real)
local function RenameEquippedPet(newName)
    if EquippedPet then
        return RenamePetById(EquippedPet.unique, newName)
    end
    -- Check for any real equipped pet
    local wrappers = ClientData.get("pet_char_wrappers") or {}
    for _, wrapper in pairs(wrappers) do
        if wrapper.controller == LocalPlayer then
            return RenamePetById(wrapper.pet_unique, newName)
        end
    end
    return false
end

-- Get list of available paint colors
local function GetAvailablePaintColors()
    local colors = {}
    for _, paint in pairs(PaintColorDB) do
        if not paint.gradient then  -- Only solid colors, not gradients
            table.insert(colors, paint.name)
        end
    end
    table.sort(colors)
    return colors
end

-- Listen to rp_name changes from CharWrapperClient (optional)
CharWrapperClient.register_property_changed("rp_name", function(char, _, newRpName)
    local head = char:FindFirstChild("Head")
    if head then
        for _, child in pairs(head:GetChildren()) do
            if child:IsA("BillboardGui") then
                local frame = child:FindFirstChild("Frame")
                if frame then
                    for _, textChild in pairs(frame:GetChildren()) do
                        if textChild:IsA("TextLabel") then
                            textChild.Text = newRpName
                        end
                    end
                end
            end
        end
    end
end)

-- =============== END RENAMING ===============

local function GenerateUniquePetName(petId)
    local prefixes = {"★", "☆", "♡", "☁️", "✨", "🍓", "🌸", "🍯", "☕", "🌙", "🌈", "❄️", "🫧", "🍬", "🍪", "🥛"}
    local names = {"Shadow", "Blaze", "Frost", "Thunder", "Moon", "Star", "Sky", "Ocean", "River", "Storm", 
                   "Ember", "Ash", "Dusk", "Dawn", "Night", "Day", "Sun", "Wind", "Rain", "Snow", "Ice", "Fire",
                   "Nova", "Cosmo", "Galaxy", "Orbit", "Comet", "Meteor", "Aurora", "Nebula", "Crystal", "Gem",
                   "Ruby", "Sapphire", "Emerald", "Diamond", "Gold", "Silver", "Mystic", "Magic", "Enchant"}
    
    -- Initialize pet type tracking if not exists
    if petId and not PetNamesByType[petId] then
        PetNamesByType[petId] = {}
    end
    
    -- Generate a unique name that doesn't exist for this pet type
    local generatedName
    local attempts = 0
    repeat
        local usePrefix = math.random(1, 3) == 1
        local name = names[math.random(1, #names)]
        
        if usePrefix then
            generatedName = prefixes[math.random(1, #prefixes)] .. name
        else
            generatedName = name .. " " .. prefixes[math.random(1, #prefixes)]
        end
        
        attempts = attempts + 1
    until not (petId and PetNamesByType[petId][generatedName]) or attempts > 100
    
    -- Track the name for this pet type
    if petId and attempts <= 100 then
        PetNamesByType[petId][generatedName] = true
    end
    
    return generatedName
end

local NewnessGroups = {
    mega_neon_flyable_rideable = 990000,
    mega_neon_flyable = 980000,
    mega_neon_rideable = 970000,
    mega_neon = 960000,
    neon_flyable_rideable = 950000,
    neon_flyable = 940000,
    neon_rideable = 930000,
    neon = 920000,
    flyable_rideable = 910000,
    flyable = 900000,
    rideable = 890000,
    regular = 880000
}

local function GetPropertyGroup(properties)
    local isMega = properties.mega_neon or false
    local isNeon = properties.neon or false
    local canFly = properties.flyable or false
    local canRide = properties.rideable or false

    if isMega then
        if canFly and canRide then return "mega_neon_flyable_rideable"
        elseif canFly then return "mega_neon_flyable"
        elseif canRide then return "mega_neon_rideable"
        else return "mega_neon" end
    elseif isNeon then
        if canFly and canRide then return "neon_flyable_rideable"
        elseif canFly then return "neon_flyable"
        elseif canRide then return "neon_rideable"
        else return "neon" end
    else
        if canFly and canRide then return "flyable_rideable"
        elseif canFly then return "flyable"
        elseif canRide then return "rideable"
        else return "regular" end
    end
end

local function GenerateUniqueID()
    return HttpService:GenerateGUID(false)
end

local function FindInTable(array, checker)
    for index, value in pairs(array) do
        if checker(value, index) then
            return index
        end
    end
    return nil
end

local originalGetServer = ClientData.get_server

function ClientData.get_server(player, key, ...)
    local data = originalGetServer(player, key, ...)

    if key == "ailments_manager" and player == LocalPlayer then
        local ailmentsData = {}
        if data then
            for k, v in pairs(data) do
                ailmentsData[k] = type(v) == "table" and table.clone(v) or v
            end
        end
        
        ailmentsData.ailments = ailmentsData.ailments or {}
        
        for petId, _ in pairs(SpawnedPets) do
            if PetAilmentsCache[petId] then
                ailmentsData.ailments[petId] = PetAilmentsCache[petId]
            else
                local ailmentTypes = {}
                for kind, _ in pairs(AilmentsDB) do
                    if kind ~= "at_work" and kind ~= "mystery" and kind ~= "walking" then
                        table.insert(ailmentTypes, kind)
                    end
                end

                local ailmentCount = math.random(2, 4)
                local petAilments = {}
                local usedTypes = {}

                for i = 1, math.min(ailmentCount, #ailmentTypes) do
                    local ailmentKind
                    repeat
                        ailmentKind = ailmentTypes[math.random(1, #ailmentTypes)]
                    until not usedTypes[ailmentKind]
                    usedTypes[ailmentKind] = true

                    local ailmentId = GenerateUniqueID()
                    petAilments[ailmentId] = {
                        components = {},
                        created_timestamp = os.time(),
                        kind = ailmentKind,
                        progress = 0,
                        rate = 0,
                        rate_timestamp = os.time(),
                        sort_order = i * 100
                    }
                end

                PetAilmentsCache[petId] = petAilments
                ailmentsData.ailments[petId] = petAilments
            end
        end

        return ailmentsData
    end

    return data
end

local function FetchPetModel(petKind)
    if PetModelCache[petKind] then
        return PetModelCache[petKind]
    end
    local model = DownloadClient.promise_download_copy("Pets", petKind):expect()
    PetModelCache[petKind] = model
    return model
end

local function ApplyNeonVisuals(petModel, petData)
    local modelInstance = petModel:FindFirstChild("PetModel")
    if modelInstance and (petData.properties.neon or petData.properties.mega_neon) then
        local petKindData = KindDB[petData.id]
        for partName, partProps in pairs(petKindData.neon_parts) do
            local geoPart = PetRigs.get(modelInstance).get_geo_part(modelInstance, partName)
            if geoPart then
                geoPart.Material = partProps.Material
                geoPart.Color = partProps.Color
            end
        end
    end
end

local function RegisterPetWrapper(wrapperData)
    UpdateClientData("pet_char_wrappers", function(wrappers)
        wrapperData.unique = #wrappers + 1
        wrapperData.index = #wrappers + 1
        wrappers[#wrappers + 1] = wrapperData
        return wrappers
    end)
end

local function RegisterPetState(stateManager)
    UpdateClientData("pet_state_managers", function(managers)
        managers[#managers + 1] = stateManager
        return managers
    end)
end

local function RemovePetWrapper(petUniqueId)
    UpdateClientData("pet_char_wrappers", function(wrappers)
        local wrapperIndex = FindInTable(wrappers, function(w)
            return w.pet_unique == petUniqueId
        end)
        if wrapperIndex then
            table.remove(wrappers, wrapperIndex)
            for i = wrapperIndex, #wrappers do
                wrappers[i].unique = i
                wrappers[i].index = i
            end
        end
        return wrappers
    end)
end

local function RemovePetState(petUniqueId)
    local pet = SpawnedPets[petUniqueId]
    if not pet or not pet.model then return end

    UpdateClientData("pet_state_managers", function(managers)
        local managerIndex = FindInTable(managers, function(m)
            return m.char == pet.model
        end)
        if managerIndex then
            table.remove(managers, managerIndex)
        end
        return managers
    end)
end

local function ClearPetStates(petUniqueId)
    local pet = SpawnedPets[petUniqueId]
    if not pet or not pet.model then return end

    UpdateClientData("pet_state_managers", function(managers)
        local managerIndex = FindInTable(managers, function(m)
            return m.char == pet.model
        end)
        if managerIndex then
            local updated = table.clone(managers)
            updated[managerIndex] = table.clone(updated[managerIndex])
            updated[managerIndex].states = {}
            return updated
        end
        return managers
    end)
end

local function SetPetState(petUniqueId, stateId)
    local pet = SpawnedPets[petUniqueId]
    if not pet or not pet.model then return end

    UpdateClientData("pet_state_managers", function(managers)
        local managerIndex = FindInTable(managers, function(m)
            return m.char == pet.model
        end)
        if managerIndex then
            local updated = table.clone(managers)
            updated[managerIndex] = table.clone(updated[managerIndex])
            updated[managerIndex].states = {{ id = stateId }}
            return updated
        end
        return managers
    end)
end

local function ClearPlayerStates()
    UpdateClientData("state_manager", function(stateManager)
        local updated = table.clone(stateManager)
        updated.states = {}
        updated.is_sitting = false
        return updated
    end)
end

local function SetPlayerState(stateId)
    UpdateClientData("state_manager", function(stateManager)
        local updated = table.clone(stateManager)
        updated.states = {{ id = stateId }}
        updated.is_sitting = true
        return updated
    end)
end

local function AttachRideConstraint(petModel)
    local character = LocalPlayer.Character
    if not character or not character.PrimaryPart then return false end

    local ridePos = petModel:FindFirstChild("RidePosition", true)
    if not ridePos then return false end

    local sourceAttach = Instance.new("Attachment")
    sourceAttach.Parent = ridePos
    sourceAttach.Position = Vector3.new(0, 1.237, 0)
    sourceAttach.Name = "SourceAttachment"

    local rigidConstraint = Instance.new("RigidConstraint")
    rigidConstraint.Name = "StateConnection"
    rigidConstraint.Attachment0 = sourceAttach
    rigidConstraint.Attachment1 = character.PrimaryPart.RootAttachment
    rigidConstraint.Parent = character

    return true
end

local function DismountPet()
    if not CurrentRideId then return end

    local pet = SpawnedPets[CurrentRideId]
    if pet and pet.model then
        if RideAnimationTrack then
            RideAnimationTrack:Stop()
            RideAnimationTrack:Destroy()
            RideAnimationTrack = nil
        end

        local sourceAttach = pet.model:FindFirstChild("SourceAttachment", true)
        if sourceAttach then sourceAttach:Destroy() end

        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part:GetAttribute("HaveMass") then
                    part.Massless = false
                end
            end
        end

        ClearPetStates(CurrentRideId)
        ClearPlayerStates()
        pet.model:ScaleTo(1)
    end
    CurrentRideId = nil
end

local function MountPet(petUniqueId, playerState, petState)
    local pet = SpawnedPets[petUniqueId]
    if not pet or not pet.model then return end

    local character = LocalPlayer.Character
    if not character or not character.PrimaryPart or not character:FindFirstChild("Humanoid") then return end

    DismountPet()
    CurrentRideId = petUniqueId

    SetPetState(petUniqueId, petState)
    SetPlayerState(playerState)
    pet.model:ScaleTo(2)
    AttachRideConstraint(pet.model)

    RideAnimationTrack = character.Humanoid.Animator:LoadAnimation(AnimationManager.get_track("PlayerRidingPet"))
    character.Humanoid.Sit = true

    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Massless == false then
            part.Massless = true
            part:SetAttribute("HaveMass", true)
        end
    end

    RideAnimationTrack:Play()
end

local function RidePet(petUniqueId)
    MountPet(petUniqueId, "PlayerRidingPet", "PetBeingRidden")
end

local function FlyPet(petUniqueId)
    MountPet(petUniqueId, "PlayerFlyingPet", "PetBeingFlown")
end

local function UnequipPet(petData)
    local pet = SpawnedPets[petData.unique]
    if not pet or not pet.model then return end

    if CurrentRideId == petData.unique then
        DismountPet()
    end

    RemovePetWrapper(petData.unique)
    RemovePetState(petData.unique)
    pet.model:Destroy()
    pet.model = nil

    if EquippedPet and EquippedPet.unique == petData.unique then
        EquippedPet = nil
    end

    -- Remove from equip_manager so BackpackApp clears the green border
    pcall(function()
        local identity = get_thread_identity and get_thread_identity() or 8
        set_thread_identity(2)
        local em = ClientData.get("equip_manager") or {}
        local pets = em.pets or {}
        -- Remove by iterating and finding our unique
        for i = #pets, 1, -1 do
            if pets[i] and pets[i].unique == petData.unique then
                table.remove(pets, i)
            end
        end
        em.pets = pets
        ClientData.update("equip_manager", em)
        set_thread_identity(identity)
    end)

    PetAilmentsCache[petData.unique] = nil

    -- Rebalance FollowOffset for remaining pets after unequip
    task.defer(function()
        pcall(function()
            local wrappers = ClientData.get("pet_char_wrappers") or {}
            local idx = 0
            for _, w in ipairs(wrappers) do
                if w.controller == LocalPlayer then
                    idx = idx + 1
                    local m = SpawnedPets[w.pet_unique] and SpawnedPets[w.pet_unique].model
                    if m then
                        local offset
                        if idx == 1 then offset = Vector3.new(3.5, 0, 0)
                        elseif idx == 2 then offset = Vector3.new(-3.5, 0, 0)
                        else offset = Vector3.new(0, 0, 3.5 * (idx - 1)) end
                        m:SetAttribute("FollowOffset", offset)
                    end
                end
            end
        end)
    end)

    task.wait(0.15)
    AilmentsClient.on_ailments_changed(LocalPlayer)
end

local function EquipPet(petData)
    if petData.category ~= "pets" then return end

    -- Don't equip the same pet twice
    if SpawnedPets[petData.unique] and SpawnedPets[petData.unique].model then return end

    -- Count active pet slots
    local activePetCount = 0
    for _, sp in pairs(SpawnedPets) do
        if sp.model and sp.data and sp.data.category == "pets" then
            activePetCount = activePetCount + 1
        end
    end

    -- Check if pet handler (2x equip) is active
    local sm = ClientData.get("subscription_manager") or {}
    local hasPetHandler = sm.equip_2x_pets ~= nil

    if hasPetHandler then
        if activePetCount >= 2 then
            -- Already have 2 pets equipped — unequip the oldest one first
            local oldest = nil
            for uid, sp in pairs(SpawnedPets) do
                if sp.model and sp.data and sp.data.category == "pets" then
                    oldest = sp.data
                    break
                end
            end
            if oldest then UnequipPet(oldest) end
        end
        -- Don't unequip remaining pet
    else
        if EquippedPet then
            UnequipPet(EquippedPet)
        end
        for _, wrapper in pairs(ClientData.get("pet_char_wrappers") or {}) do
            if wrapper.controller == LocalPlayer then
                RouterClient.get("ToolAPI/Unequip"):InvokeServer(wrapper.pet_unique)
            end
        end
    end

    if not SpawnedPets[petData.unique] then
        SpawnedPets[petData.unique] = { data = petData, model = nil }
    end

    -- For custom pets, resolve the real base kind for model + animation lookup.
    -- DownloadClient hook handles model redirect, but RegisterPetWrapper also
    -- needs the base kind as pet_id so the game finds the right animations.
    local dbEntry = InventoryDB.pets[petData.kind]
    local resolvedPetId = (dbEntry and dbEntry._base_kind) or petData.id

    -- If this is a custom pet with image-as-model mode, build a flat billboard
    -- model instead of downloading a pet model. It follows the player via
    -- BodyPosition on HumanoidRootPart, and displays the image on a BillboardGui.
    local useImageModel = dbEntry and dbEntry._image_as_model and dbEntry._image_url
    local petModel

    if useImageModel then
        -- Download the real base pet model so the wrapper/animation system
        -- works exactly as normal, then make every visible part invisible
        -- and attach a BillboardGui showing the image instead.
        petModel = FetchPetModel(petData.kind):Clone()

        -- Hide every BasePart, MeshPart, SpecialMesh, Decal, Texture, Beam etc.
        for _, desc in ipairs(petModel:GetDescendants()) do
            if desc:IsA("BasePart") or desc:IsA("MeshPart") then
                desc.Transparency = 1
                desc.CastShadow   = false
            elseif desc:IsA("Decal") or desc:IsA("Texture") then
                desc.Transparency = 1
            elseif desc:IsA("Beam") or desc:IsA("Trail") then
                desc.Enabled = false
            elseif desc:IsA("ParticleEmitter") or desc:IsA("PointLight")
                or desc:IsA("SpotLight") or desc:IsA("SurfaceLight") then
                desc.Enabled = false
            elseif desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") then
                desc.Enabled = false  -- hides pet eyes
            end
        end

        -- Find the best anchor part for the billboard
        local anchor = petModel:FindFirstChild("HumanoidRootPart")
                    or petModel:FindFirstChild("Torso", true)
                    or petModel:FindFirstChild("UpperTorso", true)
                    or petModel.PrimaryPart
                    or petModel:FindFirstChildOfClass("BasePart")

        if anchor then
            local billboard = Instance.new("BillboardGui")
            billboard.Name        = "ImageBillboard"
            billboard.Size        = UDim2.new(0, 110, 0, 110)
            billboard.StudsOffset = Vector3.new(0, 1, 0)
            billboard.AlwaysOnTop = false
            billboard.Adornee     = anchor
            billboard.Parent      = anchor

            local img = Instance.new("ImageLabel")
            img.Size                = UDim2.new(1, 0, 1, 0)
            img.BackgroundTransparency = 1
            img.Image               = dbEntry._image_url
            img.ScaleType           = Enum.ScaleType.Fit
            img.Parent              = billboard
        end

        petModel.Parent = workspace
        ApplyNeonVisuals(petModel, petData)
    else
        petModel = FetchPetModel(petData.kind):Clone()
        petModel.Parent = workspace
        ApplyNeonVisuals(petModel, petData)
    end

    SpawnedPets[petData.unique].model = petModel

    -- Set FollowOffset so pets stand on opposite sides
    -- Count only pet models currently active in SpawnedPets
    pcall(function()
        local slotIndex = 0
        for _, sp in pairs(SpawnedPets) do
            if sp.model and sp.data and sp.data.category == "pets" then
                slotIndex = slotIndex + 1
            end
        end
        -- slotIndex includes this pet (just stored above)
        local offset
        if slotIndex <= 1 then
            offset = Vector3.new(3.5, 0, 0)
        else
            offset = Vector3.new(-3.5, 0, 0)
        end
        local kindEntry = InventoryDB.pets[resolvedPetId]
        if kindEntry and kindEntry.follow_offset_scale then
            offset = offset * kindEntry.follow_offset_scale
        end
        petModel:SetAttribute("FollowOffset", offset)
    end)

    -- Initialize avatar_manager for this fake pet using update so hooks fire
    pcall(function()
        local identity = get_thread_identity and get_thread_identity() or 8
        set_thread_identity(2)
        local am = ClientData.get("avatar_manager") or {}
        if not am.pet then am.pet = {} end
        if not am.pet[petData.unique] then am.pet[petData.unique] = {} end
        ClientData.update("avatar_manager", am)
        set_thread_identity(identity)
    end)

    -- With pet handler active, keep EquippedPet as the most recently equipped
    EquippedPet = petData

    -- Add to equip_manager so BackpackApp shows the green border on this pet
    pcall(function()
        local identity = get_thread_identity and get_thread_identity() or 8
        set_thread_identity(2)
        local em = ClientData.get("equip_manager") or {}
        local pets = em.pets or {}
        -- Remove any existing entry for this unique first
        for i = #pets, 1, -1 do
            if pets[i] and pets[i].unique == petData.unique then
                table.remove(pets, i)
            end
        end
        table.insert(pets, petData)
        em.pets = pets
        ClientData.update("equip_manager", em)
        set_thread_identity(identity)
    end)

    task.defer(function()
        RegisterPetWrapper({
            char = petModel,
            mega_neon = petData.properties.mega_neon or false,
            neon = petData.properties.neon or false,
            player = LocalPlayer,
            entity_controller = LocalPlayer,
            controller = LocalPlayer,
            rp_name = petData.properties.rp_name or "",
            pet_trick_level = (function()
                -- Use actual trick count so all tricks show unlocked in interaction panel
                local entry = InventoryDB.pets[resolvedPetId] or InventoryDB.pets[petData.kind]
                local trickCount = entry and entry.tricks and #entry.tricks or 0
                return math.max(petData.properties.pet_trick_level or 0, trickCount)
            end)(),
            pet_unique = petData.unique,
            pet_id = resolvedPetId,
            location = {
                full_destination_id = "housing",
                destination_id = "housing",
                house_owner = LocalPlayer
            },
            pet_progression = {
                age = petData._hatched and 1 or (petData.properties.age or math.random(1, 6)),
                percentage = petData._hatched and 0 or math.random(0, 99) / 100
            },
            are_colors_sealed = false,
            is_pet = true,
        })

        RegisterPetState({
            char = petModel,
            player = LocalPlayer,
            store_key = "pet_state_managers",
            is_sitting = false,
            chars_connected_to_me = {},
            states = {}
        })
        task.wait(0.15)
        AilmentsClient.on_ailments_changed(LocalPlayer)
    end)
end

local NextToyOrder = 60000

local function CreateInventoryItem(itemId, category, properties)
    local uniqueId = GenerateUniqueID()
    local itemKindData = KindDB[itemId]

    if not itemKindData then
        warn("Item not found: " .. itemId)
        return nil
    end

    properties = properties or {}
    local newnessValue = NextToyOrder

    if category == "pets" then
        if properties._newness_order then
            -- Explicit ordering provided (e.g. from Spawn All Variants) — use it directly
            newnessValue = properties._newness_order
            properties._newness_order = nil  -- strip internal key before storing
        else
            local groupKey = GetPropertyGroup(properties)
            NewnessGroups[groupKey] = NewnessGroups[groupKey] - 1
            newnessValue = NewnessGroups[groupKey]
        end

        if not properties.ailments_completed then
            properties.ailments_completed = 0
        end

        if properties.rp_name == "__no_name__" then
            properties.rp_name = ""  -- explicit blank — skip auto-name
        elseif not properties.rp_name or properties.rp_name == "" then
            properties.rp_name = GenerateUniquePetName()
        end

        local _wasHatched = properties._hatched == true
        properties._hatched = nil  -- strip internal flag before storing
    else
        NextToyOrder = NextToyOrder - 1
        newnessValue = NextToyOrder
    end

    local itemData = {
        unique = uniqueId,
        category = category,
        id = itemId,
        kind = itemKindData.kind or itemId,  -- fallback to itemId if KindDB entry has no .kind
        newness_order = newnessValue,
        properties = properties,
        _source = "blueprint.lua",
        _hatched = _wasHatched or false
    }

    local identity = get_thread_identity and get_thread_identity() or 8
    set_thread_identity(2)
    local inventory = ClientData.get("inventory")
    if inventory and inventory[category] then
        inventory[category][uniqueId] = itemData
    end
    set_thread_identity(identity)

    if category == "pets" then
        SpawnedPets[uniqueId] = { data = itemData, model = nil }
    end

    SpawnedItems[uniqueId] = true

    task.defer(function()
        if UIManager and UIManager.apps and UIManager.apps.BackpackApp then
            UIManager.apps.BackpackApp:refresh_rendered_items()
        end
    end)

    return itemData
end

local function ApplyNeonEffectToModel(petModel, petId)
    local modelInstance = petModel:FindFirstChild("PetModel")
    if modelInstance and KindDB[petId] then
        local petKindData = KindDB[petId]
        if petKindData.neon_parts then
            pcall(function()
                PetNeonHelper.apply_neon(modelInstance, petKindData.neon_parts)
            end)
        end
    end
end

local function DeleteAllSpawnedPets()
    local identity = get_thread_identity and get_thread_identity() or 8
    set_thread_identity(2)
    
    local inventory = ClientData.get("inventory")
    local removed = 0
    
    if inventory and inventory.pets then
        for uniqueId, _ in pairs(SpawnedItems) do
            if inventory.pets[uniqueId] and inventory.pets[uniqueId]._source == "blueprint.lua" then
                inventory.pets[uniqueId] = nil
                removed = removed + 1
            end
        end
    end
    
    set_thread_identity(identity)
    
    for uniqueId, _ in pairs(SpawnedPets) do
        if SpawnedPets[uniqueId] and SpawnedPets[uniqueId].data and SpawnedPets[uniqueId].data._source == "blueprint.lua" then
            if SpawnedPets[uniqueId].model then
                SpawnedPets[uniqueId].model:Destroy()
            end
        end
    end
    
    SpawnedPets = {}
    SpawnedItems = {}
    PetAilmentsCache = {}
    EquippedPet = nil
    CurrentRideId = nil
    
    task.defer(function()
        if UIManager and UIManager.apps and UIManager.apps.BackpackApp then
            UIManager.apps.BackpackApp:refresh_rendered_items()
        end
    end)
    
    return removed
end

local function FindPetId(petName)
    for id, info in pairs(InventoryDB.pets) do
        if info.name:lower() == petName:lower() then
            return id
        end
    end
    return nil
end

local function FindToyId(toyName)
    for id, info in pairs(InventoryDB.toys) do
        if info.name:lower() == toyName:lower() then
            return id
        end
    end
    return nil
end

local function FindItemId(itemName)
    local categories = {
        {name = "pets", finder = FindPetId},
        {name = "toys", finder = FindToyId}
    }
    
    for _, cat in ipairs(categories) do
        local id = cat.finder(itemName)
        if id then return id, cat.name end
    end
    return nil, nil
end

-- =============== DEBUG LOG SYSTEM ===============
local DebugLogs = {}
local DebugMaxLines = 80
local debugScrollFrame = nil  -- set later when UI is built

local function DebugLog(msg)
    local timestamp = string.format("[%.2f] ", tick() % 1000)
    local line = timestamp .. tostring(msg)
    table.insert(DebugLogs, line)
    if #DebugLogs > DebugMaxLines then
        table.remove(DebugLogs, 1)
    end
    -- Refresh the debug UI if it exists
    if debugScrollFrame then
        for _, child in pairs(debugScrollFrame:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
        for i, logLine in ipairs(DebugLogs) do
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -4, 0, 12)
            lbl.BackgroundTransparency = 1
            lbl.Text = logLine
            lbl.Font = Enum.Font.Code
            lbl.TextSize = 7
            lbl.TextColor3 = logLine:find("%[FireServer%]") and Color3.fromRGB(255, 200, 80)
                or logLine:find("%[InvokeServer%]") and Color3.fromRGB(100, 200, 255)
                or logLine:find("CLIENT%-SIDE") and Color3.fromRGB(80, 255, 120)
                or logLine:find("ERROR\|WARN\|blocked") and Color3.fromRGB(255, 80, 80)
                or Color3.fromRGB(200, 200, 220)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.LayoutOrder = i
            lbl.Parent = debugScrollFrame
        end
        debugScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #DebugLogs * 13)
        debugScrollFrame.CanvasPosition = Vector2.new(0, math.max(0, #DebugLogs * 13 - debugScrollFrame.AbsoluteSize.Y))
    end
    print("[blueprint debug] " .. line)
end
_G._DebugLog = DebugLog
-- =============== END DEBUG LOG SYSTEM ===============

-- Real PetsReleased RemoteEvent — populated after OriginalRouterGet is defined below.
-- Declared here so HandleConfirmedRelease (defined inside the next block) can close over it.
local _RealPetsReleasedRemote = nil

-- Ticket state — module scope so both PlayTicketAnimation and RouterClient.get hook can access them
local _ActiveTicketPile    = nil
local _ActiveTicketLbl     = nil
local _ActiveTicketBalance = 0

-- =============== CLIENT-SIDED PET RELEASING ===============
local PetRecyclerApp = UIManager.apps.PetRecyclerApp
if PetRecyclerApp and PetRecyclerApp.use_pet_recycler then
    local _OriginalUsePetRecycler = PetRecyclerApp.use_pet_recycler

    -- Compute ticket value for a spawned pet using PetRecyclerCalculator or fallback
    local function ComputeTickets(petData)
        local PetRecyclerCalc = pcall(LoadModule, "new:PetRecyclerCalculator") and LoadModule("new:PetRecyclerCalculator") or nil
        local ok, val = pcall(function()
            return PetRecyclerCalc and PetRecyclerCalc.get_pet_value(petData)
        end)
        if ok and val and val > 0 then return val end
        local petInfo = InventoryDB and InventoryDB.pets and InventoryDB.pets[petData.kind]
        if not petInfo then return 10 end
        local rarityBase = ({ common=1, uncommon=2, rare=3, ultra_rare=5, legendary=10 })[petInfo.rarity] or 1
        local mult = petData.properties.mega_neon and 100 or petData.properties.neon and 20 or 1
        return math.floor(rarityBase * mult * 10)
    end

    -- Play the ticket dispenser animation directly on the recycler's 3D model.
    -- Structure: model.TicketDispenser.Dispenser.Particles → Beam, ParticleEmitter,
    --            TicketAttachment0/1, TicketAttachment0/1Goal, PileAttachment
    --            model.TicketDispenser.Counter → SurfaceGui → TextLabel
    -- Track the active ticket pile so TicketsCollected intercept can destroy it and reset the counter

    local function PlayTicketAnimation(model, tickets)
        if not model then return end
        local dispenser = model:FindFirstChild("TicketDispenser", true)
        if not dispenser then DebugLog("WARN: TicketDispenser not found in model"); return end
        local dispPart = dispenser:FindFirstChild("Dispenser")
        if not dispPart then return end
        local particles = dispPart:FindFirstChild("Particles")
        if not particles then return end

        local att0     = particles:FindFirstChild("TicketAttachment0")
        local att1     = particles:FindFirstChild("TicketAttachment1")
        local att0goal = particles:FindFirstChild("TicketAttachment0Goal")
        local att1goal = particles:FindFirstChild("TicketAttachment1Goal")
        local beam     = particles:FindFirstChildWhichIsA("Beam")
        local emitter  = particles:FindFirstChildWhichIsA("ParticleEmitter")
        local lightBox = dispPart:FindFirstChild("LightBox")
        local pileAttch = particles:FindFirstChild("PileAttachment")

        if not (att0 and att1 and beam and emitter) then
            DebugLog("WARN: ticket dispenser parts missing (att0/att1/beam/emitter)")
            return
        end

        DebugLog("PlayTicketAnimation: tickets=" .. tostring(tickets))

        local att0orig = att0.CFrame
        local att1orig = att1.CFrame
        local origPivot = dispenser:GetPivot()

        -- Phase 1: extend attachments, enable beam/particles
        beam.Enabled    = true
        emitter.Enabled = true
        if lightBox then lightBox.Transparency = 0.9 end

        TweenService:Create(att0, TweenInfo.new(0.45, Enum.EasingStyle.Linear),
            { CFrame = att0goal and att0goal.CFrame or att0.CFrame }):Play()
        TweenService:Create(att1, TweenInfo.new(0.45, Enum.EasingStyle.Linear),
            { CFrame = att1goal and att1goal.CFrame or att1.CFrame }):Play()
        task.wait(0.5)

        -- Phase 2: speed up beam texture + shake dispenser for 4 seconds
        -- Counter starts immediately in parallel so it counts up as tickets dispense
        beam.TextureSpeed = 5.5
        TweenService:Create(beam, TweenInfo.new(4, Enum.EasingStyle.Linear),
            { TextureSpeed = 12 }):Play()

        -- Start counter animating immediately (parallel to shake)
        local counter = dispenser:FindFirstChild("Counter", true)
        if counter then
            local sg  = counter:FindFirstChildWhichIsA("SurfaceGui")
            local lbl = sg and sg:FindFirstChildWhichIsA("TextLabel")
            if lbl then
                local current = tonumber(lbl.Text) or 0
                local goal    = current + tickets
                local iv      = Instance.new("IntValue")
                iv.Value = current
                iv.Changed:Connect(function() lbl.Text = tostring(iv.Value) end)
                TweenService:Create(iv, TweenInfo.new(4, Enum.EasingStyle.Sine,
                    Enum.EasingDirection.Out), { Value = goal }):Play()
                game:GetService("Debris"):AddItem(iv, 5)
                _ActiveTicketLbl = lbl
                DebugLog("Counter: " .. current .. " → " .. goal)
            end
        end

        local shakeConn = RunService.Heartbeat:Connect(function()
            dispenser:PivotTo(origPivot * CFrame.new(
                math.sin(tick() * 30) * 0.02, 0, math.cos(tick() * 30) * 0.02
            ))
        end)
        task.wait(4)
        shakeConn:Disconnect()
        dispenser:PivotTo(origPivot)

        -- Phase 3: wind down
        beam.TextureSpeed = 0
        if att0goal then
            TweenService:Create(att0, TweenInfo.new(0.25, Enum.EasingStyle.Linear),
                { CFrame = att1goal and att1goal.CFrame or att1.CFrame }):Play()
        end
        task.wait(0.3)

        beam.Enabled    = false
        emitter.Enabled = false
        if lightBox then lightBox.Transparency = 1 end
        att0.CFrame = att0orig
        att1.CFrame = att1orig

        -- Phase 4: spawn ticket pile at PileAttachment (keep reference for claim)
        if _ActiveTicketPile and _ActiveTicketPile.Parent then
            _ActiveTicketPile:Destroy()
        end
        _ActiveTicketPile = nil
        if pileAttch then
            local piles = ReplicatedStorage:FindFirstChild("Resources")
                and ReplicatedStorage.Resources:FindFirstChild("TicketPiles")
            if piles then
                local pileModel = tickets >= 10000 and piles:FindFirstChild("Enourmous")
                    or tickets >= 1000 and piles:FindFirstChild("Large")
                    or piles:FindFirstChild("Medium")
                if pileModel then
                    local pile = pileModel:Clone()
                    pile.Parent = workspace
                    pile:PivotTo(pileAttch.WorldCFrame)
                    _ActiveTicketPile = pile
                end
            end
        end

        _ActiveTicketBalance = (_ActiveTicketBalance or 0) + tickets
        DebugLog("Tickets pending: " .. _ActiveTicketBalance .. " (walk to machine to claim)")
    end

    local function HandleConfirmedRelease(self, uniques)
        DebugLog("HandleConfirmedRelease: uniques=" .. tostring(type(uniques) == "table" and #uniques or tostring(uniques)))

        if type(uniques) ~= "table" or #uniques == 0 then
            DebugLog("WARN: empty/nil uniques — no-op")
            return false
        end

        local spawnedUniques = {}
        local realUniques = {}
        for _, u in ipairs(uniques) do
            if SpawnedItems[u] then
                table.insert(spawnedUniques, u)
            else
                table.insert(realUniques, u)
            end
        end

        DebugLog("spawned=" .. #spawnedUniques .. "  real=" .. #realUniques)

        if #spawnedUniques == 0 then
            DebugLog("No spawned pets — server path unchanged")
            return false
        end

        -- Collect pet data BEFORE removing from inventory (animation needs it)
        local identity = get_thread_identity and get_thread_identity() or 8
        set_thread_identity(2)
        local inventory = ClientData.get("inventory")

        local petsReleasedPayload = {}  -- keyed 1..N, each entry shaped for PortalPetAnimation
        for i, u in ipairs(spawnedUniques) do
            local petData = inventory and inventory.pets and inventory.pets[u]
            if petData then
                -- PortalPetAnimation expects: pet.item_info.kind, pet.item_info.properties, pet.accessories
                petsReleasedPayload[i] = {
                    item_info = {
                        kind       = petData.kind or petData.id,
                        properties = petData.properties or {},
                        unique     = petData.unique,
                    },
                    accessories = {},
                }
                DebugLog("payload[" .. i .. "] kind=" .. tostring(petData.kind or petData.id))
            end
        end

        -- Remove spawned pets from inventory and tracking
        for _, u in ipairs(spawnedUniques) do
            if EquippedPet and EquippedPet.unique == u then
                pcall(UnequipPet, EquippedPet)
            end
            if SpawnedPets[u] then
                if SpawnedPets[u].model then pcall(function() SpawnedPets[u].model:Destroy() end) end
                SpawnedPets[u] = nil
            end
            if inventory and inventory.pets then inventory.pets[u] = nil end
            SpawnedItems[u] = nil
            PetAilmentsCache[u] = nil
            DebugLog("CLIENT-SIDE removed: " .. tostring(u))
        end
        set_thread_identity(identity)

        task.defer(function()
            pcall(function() UIManager.apps.BackpackApp:refresh_rendered_items() end)
        end)

        -- Fire PetsReleased animation — PortalPetAnimation connects to our fake BindableEvent
        -- (because RouterClient.get("PetRecyclerAPI/PetsReleased").OnClientEvent returns fakeEvent.Event)
        task.spawn(function()
            DebugLog("Firing PetsReleased animation for " .. #spawnedUniques .. " pet(s)")
            local fakeEvent = _FakeRemotes["PetRecyclerAPI/PetsReleased"]
            if fakeEvent then
                fakeEvent:Fire(petsReleasedPayload)
                DebugLog("Fired fake BindableEvent OK")
            elseif _RealPetsReleasedRemote then
                local ok, err = pcall(firesignal, _RealPetsReleasedRemote.OnClientEvent, petsReleasedPayload)
                DebugLog(ok and "firesignal OK" or "firesignal failed: " .. tostring(err))
            else
                DebugLog("WARN: no animation target found")
            end
        end)

        -- Ticket dispenser animation: fire after pets finish walking into portal.
        -- Walk time per pet = MAX_PET_WALK_TIME(1.6s) + BETWEEN_PETS_DELAY(1s), then 0.5s buffer.
        local ticketModel = self.model  -- capture before self might change
        task.spawn(function()
            local numPets = #spawnedUniques
            local walkDelay = numPets * 1.6 + math.max(0, numPets - 1) * 1 + 0.5
            task.wait(walkDelay)

            -- Compute total tickets from the payload we built before inventory removal
            local totalTickets = 0
            for _, p in pairs(petsReleasedPayload) do
                if p.item_info then
                    local petData = { kind = p.item_info.kind, properties = p.item_info.properties or {} }
                    totalTickets = totalTickets + ComputeTickets(petData)
                end
            end

            DebugLog("Ticket dispenser: " .. totalTickets .. " tickets")
            PlayTicketAnimation(ticketModel, totalTickets)
        end)

        game.StarterGui:SetCore("SendNotification", {
            Title = "Pet Recycler",
            Text = "Released " .. #spawnedUniques .. " pet(s) client-side!",
            Duration = 3,
        })

        if #realUniques == 0 then
            DebugLog("All spawned — will block server call with empty uniques")
            return true
        else
            DebugLog("Mixed — real pets still going to server: " .. #realUniques)
            return false
        end
    end

    function PetRecyclerApp.use_pet_recycler(self, ...)
        DebugLog("use_pet_recycler called")

        -- Probe what API the Signal object exposes so we can log it once
        local sigMethods = {}
        for k, v in pairs(getmetatable(self.confirm_signal) or {}) do
            table.insert(sigMethods, k .. "=" .. type(v))
        end
        for k, v in pairs(self.confirm_signal) do
            table.insert(sigMethods, k .. "=" .. type(v))
        end
        DebugLog("confirm_signal API: " .. table.concat(sigMethods, ", "))

        -- Strategy 1: wrap confirm_signal.Fire directly (most reliable)
        -- This fires synchronously before the original Promise.fromEvent resolves
        local originalFire = self.confirm_signal.Fire
        local blockNextFire = false
        self.confirm_signal.Fire = function(sig, uniques)
            DebugLog("confirm_signal:Fire intercepted, uniques type=" .. type(uniques))
            local shouldBlock = HandleConfirmedRelease(self, uniques)
            -- Always restore Fire immediately so the second use works cleanly
            self.confirm_signal.Fire = originalFire
            if shouldBlock then
                -- Fire with empty list — the server call becomes a no-op,
                -- but the recycler's Promise race resolves normally so its
                -- internal state machine closes cleanly for the next use
                DebugLog("Blocking server — firing confirm with empty uniques")
                return originalFire(sig, {})
            end
            return originalFire(sig, uniques)
        end

        -- Strategy 2: also try :Connect in case the signal type supports it
        local confirmConn
        local ok2, connErr = pcall(function()
            -- Try direct :Connect first (custom Signal), fallback to .Event:Connect (BindableEvent)
            local connectFn = self.confirm_signal.Connect or (self.confirm_signal.Event and self.confirm_signal.Event.Connect)
            if connectFn then
                confirmConn = connectFn(self.confirm_signal, function(uniques)
                    DebugLog("confirm_signal:Connect fired (strategy 2)")
                    if confirmConn then confirmConn:Disconnect() end
                    -- Strategy 1 already handled removal; this is just a fallback log
                end)
                DebugLog("Strategy 2 (:Connect) registered OK")
            else
                DebugLog("Strategy 2: no Connect method found on signal")
            end
        end)
        if not ok2 then
            DebugLog("Strategy 2 error: " .. tostring(connErr))
        end

        local result = _OriginalUsePetRecycler(self, ...)

        -- Restore Fire in case it wasn't restored inside (e.g. cancel path)
        if self.confirm_signal.Fire ~= originalFire then
            self.confirm_signal.Fire = originalFire
        end
        if confirmConn then pcall(function() confirmConn:Disconnect() end) end

        return result
    end

    DebugLog("use_pet_recycler hook installed OK")
else
    DebugLog("WARN: PetRecyclerApp.use_pet_recycler not found — hook skipped")
end
-- =============== END CLIENT-SIDED PET RELEASING ===============

-- =============== REMOTE EVENT PROXY SETUP ===============
-- RouterClient.get is hooked below. For PetsReleased/RewardReceived we return
-- our BindableEvent.Event as OnClientEvent so we can fire animations client-side.
-- _FakeRemotes are pre-created at startup (line ~278) and used here.
-- =============== END REMOTE EVENT PROXY SETUP ===============

-- ShopAPI dedup: prevents ShopM's repeated InvokeServer calls from spawning multiple pets
local _ShopDedupKey  = nil
local _ShopDedupTime = 0

-- =============== ROUTER HOOKS ===============
local OriginalRouterGet = RouterClient.get

-- Populate _RealPetsReleasedRemote now that OriginalRouterGet exists
task.spawn(function()
    local ok, remote = pcall(OriginalRouterGet, "PetRecyclerAPI/PetsReleased")
    if ok and remote then
        _RealPetsReleasedRemote = remote
        DebugLog("Stored real PetsReleased remote OK, Name=" .. tostring(pcall(function() return remote.Name end) and remote.Name or "?"))
    else
        DebugLog("WARN: could not get real PetsReleased remote: " .. tostring(remote))
    end
end)

function RouterClient.get(endpoint)
    if endpoint == "ToolAPI/Equip" then
        return {
            InvokeServer = function(_, uniqueId)
                local pet = SpawnedPets[uniqueId]
                if pet then
                    EquipPet(pet.data)
                    return true, { action = "equip", is_server = true }
                end
                -- SpawnedFood items are handled fully client-side (model downloaded via DisplayStandHelper)
                -- so skip the server call for them entirely
                if SpawnedFood[uniqueId] then
                    return true
                end
                return OriginalRouterGet("ToolAPI/Equip"):InvokeServer(uniqueId)
            end
        }
    elseif endpoint == "ToolAPI/Unequip" then
        return {
            InvokeServer = function(_, uniqueId)
                local pet = SpawnedPets[uniqueId]
                if not pet then
                    return OriginalRouterGet("ToolAPI/Unequip"):InvokeServer(uniqueId)
                end
                UnequipPet(pet.data)
                return true, { action = "unequip", is_server = true }
            end
        }
    elseif endpoint == "AdoptAPI/RidePet" then
        return {
            InvokeServer = function(_, petData)
                local pet = SpawnedPets[petData.pet_unique]
                if not pet then
                    return OriginalRouterGet("AdoptAPI/RidePet"):InvokeServer(petData)
                end
                RidePet(petData.pet_unique)
                return true
            end
        }
    elseif endpoint == "AdoptAPI/FlyPet" then
        return {
            InvokeServer = function(_, petData)
                local pet = SpawnedPets[petData.pet_unique]
                if not pet then
                    return OriginalRouterGet("AdoptAPI/FlyPet"):InvokeServer(petData)
                end
                FlyPet(petData.pet_unique)
                return true
            end
        }
    elseif endpoint == "AdoptAPI/ExitSeatStates" then
        return {
            FireServer = function()
                if CurrentRideId then
                    DismountPet()
                    return true
                end
                return OriginalRouterGet("AdoptAPI/ExitSeatStates"):FireServer()
            end
        }
    elseif endpoint == "SettingsAPI/SetPetRoleplayName" then
        return {
            InvokeServer = function(_, petUniqueId, newName)
                -- Check if this is one of our spawned pets
                local pet = SpawnedPets[petUniqueId]
                if not pet then
                    -- Real pet – let server handle it
                    return OriginalRouterGet("SettingsAPI/SetPetRoleplayName"):InvokeServer(petUniqueId, newName)
                end
                -- Use our enhanced rename function
                return RenamePetById(petUniqueId, newName)
            end
        }
    elseif endpoint == "PetAPI/DoNeonFusion" then
        return {
            InvokeServer = function(_, petIds, isMega)
                -- Fusion logic (unchanged)
                local allOurPets = true
                local validPets = {}
                local basePetId = nil
                local hasAnyFlyRide = false
                local sourceNeonStatus = nil
                
                for _, petId in ipairs(petIds) do
                    if not SpawnedPets[petId] then
                        allOurPets = false
                        break
                    end
                    
                    local petData = SpawnedPets[petId].data
                    table.insert(validPets, petData)
                    
                    if not basePetId then
                        basePetId = petData.id
                        sourceNeonStatus = petData.properties.neon or false
                    end
                    
                    if petData.properties.flyable or petData.properties.rideable then
                        hasAnyFlyRide = true
                    end
                end
                
                if not allOurPets or #validPets < 4 then
                    return OriginalRouterGet("PetAPI/DoNeonFusion"):InvokeServer(petIds, isMega)
                end
                
                -- Determine actual fusion type
                local actualIsMega = sourceNeonStatus
                
                -- Create the fused pet with DEFAULT name (not random)
                local petDefaultName = ""
                if InventoryDB.pets and InventoryDB.pets[basePetId] then
                    petDefaultName = InventoryDB.pets[basePetId].name
                end
                
                local flags = {
                    neon = not actualIsMega,
                    mega_neon = actualIsMega,
                    age = 6,
                    rp_name = petDefaultName,  -- Use default pet name instead of random
                    pet_trick_level = 1,
                    rideable = hasAnyFlyRide,
                    flyable = hasAnyFlyRide,
                    ailments_completed = 0
                }
                
                local fusedPetData = CreateInventoryItem(basePetId, "pets", flags)
                
                if fusedPetData then
                    -- REPLACE the 4 pet models with neon/mega versions
                    for _, petId in ipairs(petIds) do
                        if SpawnedPets[petId] and SpawnedPets[petId].model then
                            local oldModel = SpawnedPets[petId].model
                            
                            -- Clone a fresh pet model
                            local newModel = FetchPetModel(basePetId):Clone()
                            newModel.Parent = oldModel.Parent or workspace
                            newModel:PivotTo(oldModel:GetPivot())
                            
                            -- Update the pet data to be neon/mega
                            SpawnedPets[petId].data.properties.neon = not actualIsMega
                            SpawnedPets[petId].data.properties.mega_neon = actualIsMega
                            
                            -- Apply neon effects
                            ApplyNeonVisuals(newModel, SpawnedPets[petId].data)
                            
                            if newModel:FindFirstChild("PetModel") and KindDB[basePetId] then
                                local petKindData = KindDB[basePetId]
                                if petKindData.neon_parts then
                                    pcall(function()
                                        PetNeonHelper.apply_neon(newModel:FindFirstChild("PetModel"), petKindData.neon_parts)
                                    end)
                                end
                            end
                            
                            -- Mega neon animation
                            if actualIsMega then
                                task.spawn(function()
                                    if newModel:FindFirstChild("PetModel") and KindDB[basePetId] then
                                        local petKindData = KindDB[basePetId]
                                        if petKindData.mega_neon_parts then
                                            local megaNeonCache = {
                                                cached_colors = nil,
                                                cached_parts = nil
                                            }
                                            
                                            pcall(function()
                                                PetNeonHelper.precache(megaNeonCache, petKindData, newModel:FindFirstChild("PetModel"))
                                            end)
                                            
                                            local animStart = tick()
                                            while (tick() - animStart) < 12 and newModel.Parent do
                                                pcall(function()
                                                    PetNeonHelper.step_mega_neon(megaNeonCache, newModel:FindFirstChild("PetModel"), petKindData)
                                                end)
                                                RunService.RenderStepped:Wait()
                                            end
                                        end
                                    end
                                end)
                            end
                            
                            SpawnedPets[petId].model = newModel
                            oldModel:Destroy()
                        end
                    end
                    
                    -- Update inventory
                    local identity = get_thread_identity and get_thread_identity() or 8
                    set_thread_identity(2)
                    
                    local inventory = ClientData.get("inventory")
                    for _, petId in ipairs(petIds) do
                        if inventory and inventory.pets and inventory.pets[petId] then
                            inventory.pets[petId].properties.neon = not actualIsMega
                            inventory.pets[petId].properties.mega_neon = actualIsMega
                        end
                    end
                    
                    set_thread_identity(identity)
                    
                    -- Schedule cleanup and equip
                    task.delay(12, function()
                        local inv = ClientData.get("inventory")
                        if inv and inv.pets then
                            for _, petId in ipairs(petIds) do
                                inv.pets[petId] = nil
                                if SpawnedPets[petId] and SpawnedPets[petId].model then
                                    SpawnedPets[petId].model:Destroy()
                                end
                                SpawnedPets[petId] = nil
                                SpawnedItems[petId] = nil
                            end
                        end
                        
                        if SpawnedPets[fusedPetData.unique] then
                            EquipPet(fusedPetData)
                            
                            game.StarterGui:SetCore('SendNotification', {
                                Title = 'Fusion Complete!',
                                Text = (actualIsMega and 'Mega ' or '') .. 'Neon created and equipped!',
                                Duration = 3,
                            })
                        end
                    end)
                    
                    return true, {
                        success = true,
                        petId = fusedPetData.unique,
                        isMega = actualIsMega
                    }
                end
                
                return false
            end
        }
    else
        -- Intercept PetRecyclerAPI/* calls
        if endpoint:sub(1, 15) == "PetRecyclerAPI/" then
            DebugLog("[RouterClient.get] " .. endpoint)

            -- TicketsCollected: called both as the recycler NPC claim AND as polling.
            -- Only intercept when we have fake tickets pending (_ActiveTicketBalance > 0).
            -- Otherwise pass straight through to the real server.
            if endpoint == "PetRecyclerAPI/TicketsCollected" then
                local ok, originalRemote = pcall(OriginalRouterGet, endpoint)
                return {
                    InvokeServer = function(_, ...)
                        if _ActiveTicketBalance > 0 then
                            local earned = _ActiveTicketBalance

                            DebugLog("TicketsCollected: claiming " .. earned .. " fake tickets")

                            -- Update the real ticket balance key used by PetRecyclerTicketsIndicatorApp
                            set_thread_identity(2)
                            pcall(function()
                                local current = ClientData.get("pet_recycler_tickets_2026") or 0
                                ClientData.predict("pet_recycler_tickets_2026", current + earned)
                                DebugLog("pet_recycler_tickets_2026: " .. current .. " → " .. (current + earned))
                            end)
                            set_thread_identity(get_thread_identity and get_thread_identity() or 8)

                            -- Trigger the indicator app's toast popup (same as a real claim)
                            pcall(function()
                                local TicketApp = UIManager.apps.PetRecyclerTicketsIndicatorApp
                                if TicketApp and TicketApp.show_toast then
                                    TicketApp:show_toast(earned)
                                end
                            end)

                            -- Destroy pile, reset counter, clear pending balance
                            if _ActiveTicketPile and _ActiveTicketPile.Parent then
                                _ActiveTicketPile:Destroy()
                            end
                            _ActiveTicketPile = nil
                            if _ActiveTicketLbl and _ActiveTicketLbl.Parent then
                                _ActiveTicketLbl.Text = "0"
                            end
                            _ActiveTicketLbl = nil
                            _ActiveTicketBalance = 0
                            DebugLog("TicketsCollected: done — counter reset, pile removed")
                            return true
                        end
                        -- No fake tickets pending — pass through to real server
                        if ok and originalRemote then
                            return originalRemote:InvokeServer(...)
                        end
                    end
                }
            end

            local ok, originalRemote = pcall(OriginalRouterGet, endpoint)
            if not ok or not originalRemote then
                DebugLog("ERROR: OriginalRouterGet failed for " .. endpoint)
                return OriginalRouterGet(endpoint)
            end
            local fakeEvent = _FakeRemotes[endpoint]
            if fakeEvent then
                DebugLog("Returning fake OnClientEvent for " .. endpoint)
            end
            return setmetatable({}, {
                __index = function(_, method)
                    if method == "OnClientEvent" then
                        if fakeEvent then
                            return fakeEvent.Event
                        end
                        return originalRemote.OnClientEvent
                    elseif method == "FireServer" or method == "InvokeServer" then
                        return function(_self, ...)
                            local args = {...}
                            local ok2, argStr = pcall(function() return HttpService:JSONEncode(args) end)
                            DebugLog("[" .. method .. "] " .. endpoint .. " | args: " .. (ok2 and argStr or "<unserializable>"))
                            return originalRemote[method](originalRemote, ...)
                        end
                    else
                        return originalRemote[method]
                    end
                end
            })
        end
        -- LootBoxAPI/ExchangeItemForReward: intercept egg hatching client-side.
        -- Server rejects expired/unavailable eggs ("No existing loot box reward").
        -- We handle known eggs ourselves: pick random pet from pool, remove egg, spawn pet.
        if endpoint == "LootBoxAPI/ExchangeItemForReward" then
            local ok, originalRemote = pcall(OriginalRouterGet, endpoint)
            return {
                InvokeServer = function(_, eggKind, uniqueId, ...)
                    DebugLog("[LootBoxAPI/ExchangeItemForReward] kind=" .. tostring(eggKind) .. " uid=" .. tostring(uniqueId))

                    -- Egg pool tables: {petName, weight} — higher weight = more common
                    -- Weights roughly match Adopt Me rarity tiers
                    local EGG_POOLS = {
                        christmas_egg = {
                            {"Polar Bear",         25},
                            {"Reindeer",           20},
                            {"Snowman",            15},
                            {"Arctic Reindeer",     8},
                            {"Evil Unicorn",        5},
                        },
                        farm_egg = {
                            {"Chicken",   30},
                            {"Pig",       25},
                            {"Horse",     20},
                            {"Cow",       18},
                            {"Buffalo",   15},
                            {"Rabbit",    15},
                            {"Dog",       12},
                            {"Cat",       12},
                            {"Turkey",    10},
                            {"Penguin",   10},
                            {"Dragon",     5},
                            {"Unicorn",    5},
                        },
                        -- Add more eggs here as needed
                        jungle_egg = {
                            {"Monkey",     25},
                            {"Parrot",     20},
                            {"Toucan",     18},
                            {"Flamingo",   18},
                            {"Crocodile",  15},
                            {"Rhino",      12},
                            {"Elephant",    8},
                            {"King Bee",    5},
                        },
                        aussie_egg = {
                            {"Tasmanian Tiger",  25},
                            {"Dingo",            25},
                            {"Frog",             20},
                            {"Emu",              18},
                            {"Glyptodon",        12},
                            {"Koala",            10},
                            {"Kangaroo",          8},
                        },
                        fossil_egg = {
                            {"Ground Sloth",  25},
                            {"Tasmanian Tiger",20},
                            {"Stegosaurus",   18},
                            {"Triceratops",   15},
                            {"Pterodactyl",   12},
                            {"Woolly Mammoth", 10},
                            {"T-Rex",          8},
                            {"Dodo",           5},
                        },
                        ocean_egg = {
                            {"Seahorse",     25},
                            {"Clownfish",    25},
                            {"Dolphin",      20},
                            {"Shark",        15},
                            {"Crab",         15},
                            {"Narwhal",      10},
                            {"Octopus",       8},
                        },
                        safari_egg = {
                            {"Giraffe",   20},
                            {"Lion",      20},
                            {"Elephant",  18},
                            {"Hyena",     15},
                            {"Crocodile", 15},
                            {"Cheetah",   12},
                            {"Rhino",     10},
                        },
                        woodland_egg = {
                            {"Beaver",     25},
                            {"Bunny",      25},
                            {"Woodpecker", 20},
                            {"Squirrel",   20},
                            {"Red Fox",    15},
                            {"Deer",       15},
                            {"Hedgehog",   10},
                        },
                    }

                    local pool = EGG_POOLS[eggKind]
                    if not pool then
                        -- Unknown egg — pass through to server
                        DebugLog("LootBoxAPI: unknown egg kind '" .. tostring(eggKind) .. "' — passing to server")
                        if ok and originalRemote then
                            return originalRemote:InvokeServer(eggKind, uniqueId, ...)
                        end
                        return nil
                    end

                    DebugLog("LootBoxAPI: known egg '" .. eggKind .. "' — hatching client-side")

                    -- Weighted random pick from pool
                    local totalWeight = 0
                    for _, entry in ipairs(pool) do totalWeight = totalWeight + entry[2] end
                    local roll = math.random(1, totalWeight)
                    local cumulative = 0
                    local chosenName = pool[1][1]
                    for _, entry in ipairs(pool) do
                        cumulative = cumulative + entry[2]
                        if roll <= cumulative then
                            chosenName = entry[1]
                            break
                        end
                    end
                    DebugLog("LootBoxAPI: rolled " .. chosenName .. " from " .. eggKind)

                    -- Remove the egg from inventory via ClientData
                    set_thread_identity(2)
                    pcall(function()
                        local inv = ClientData.get("inventory")
                        if inv and inv.pets and inv.pets[uniqueId] then
                            local newPets = {}
                            for k, v in pairs(inv.pets) do
                                if k ~= uniqueId then newPets[k] = v end
                            end
                            local newInv = {}
                            for k, v in pairs(inv) do newInv[k] = v end
                            newInv.pets = newPets
                            ClientData.predict("inventory", newInv)
                            DebugLog("LootBoxAPI: removed egg " .. uniqueId .. " from inventory")
                        end
                    end)
                    set_thread_identity(get_thread_identity and get_thread_identity() or 8)

                    -- Spawn the hatched pet
                    local petId = FindPetId(chosenName)
                    if petId then
                        local item = CreateInventoryItem(petId, "pets", {
                            mega_neon          = false,
                            neon               = false,
                            flyable            = false,
                            rideable           = false,
                            age                = 1,
                            trick_level        = 0,
                            ailments_completed = 0,
                            rp_name            = "__no_name__",
                            _hatched           = true,
                        })
                        if item then
                            DebugLog("LootBoxAPI: spawned " .. chosenName)
                            -- Return fake result table matching what the real server returns
                            -- so BoxM's v_u_39 callback equips the pet
                            return {{ category = "pets", kind = petId, unique = item.unique }}
                        end
                    end
                    DebugLog("LootBoxAPI: WARN spawn failed for " .. chosenName)
                    return nil
                end
            }
        end
        if endpoint == "PetAPI/OwnedEggHatched" or endpoint == "PetAPI/PetHatched" or endpoint == "PetAPI/ConsumeFoodObject" then
            local ok, originalRemote = pcall(OriginalRouterGet, endpoint)
            return setmetatable({}, {
                __index = function(_, method)
                    if method == "FireServer" or method == "InvokeServer" then
                        return function(_self, ...)
                            local args = {...}
                            local ok2, argStr = pcall(function() return HttpService:JSONEncode(args) end)
                            DebugLog("[" .. endpoint .. "] " .. method .. " | " .. (ok2 and argStr or "<unserializable>"))
                            -- Log individual args for non-serializable ones
                            for i, a in ipairs(args) do
                                if type(a) == "table" then
                                    local ok3, s = pcall(HttpService.JSONEncode, HttpService, a)
                                    DebugLog("  arg[" .. i .. "] = " .. (ok3 and s or type(a)))
                                else
                                    DebugLog("  arg[" .. i .. "] = " .. tostring(a))
                                end
                            end
                            if ok and originalRemote then
                                return originalRemote[method](originalRemote, ...)
                            end
                        end
                    elseif method == "OnClientEvent" then
                        return ok and originalRemote and originalRemote.OnClientEvent
                    else
                        return ok and originalRemote and originalRemote[method]
                    end
                end
            })
        end
        -- ShopAPI/BuyItem: intercept recycler shop purchases, spawn pet + deduct tickets
        if endpoint == "ShopAPI/BuyItem" then
            local ok, originalRemote = pcall(OriginalRouterGet, endpoint)
            return {
                InvokeServer = function(_, category, itemKind, options)
                    DebugLog("[ShopAPI/BuyItem] category=" .. tostring(category) .. " kind=" .. tostring(itemKind))

                    -- Check if this is a recycler shop item via currency_id in InventoryDB
                    local isRecycler = false
                    local cost = 0
                    pcall(function()
                        local entry = InventoryDB[category] and InventoryDB[category][itemKind]
                        if entry then
                            isRecycler = entry.currency_id == "pet_recycler_tickets_2026"
                            cost = entry.cost or 0
                            DebugLog("ShopAPI: entry found, currency_id=" .. tostring(entry.currency_id) .. " cost=" .. tostring(cost))
                        end
                    end)

                    if isRecycler then
                        -- Dedup: ShopM calls InvokeServer up to 7 times per purchase.
                        -- Module-scope vars persist across calls so this actually works.
                        local now = tick()
                        if _ShopDedupKey == itemKind and (now - _ShopDedupTime) < 2 then
                            DebugLog("ShopAPI: dedup skip")
                            return "success"
                        end
                        _ShopDedupKey  = itemKind
                        _ShopDedupTime = now

                        DebugLog("ShopAPI: recycler item — handling client-side")
                        local balance = ClientData.get("pet_recycler_tickets_2026") or 0

                        if balance < cost then
                            DebugLog("ShopAPI: not enough tickets (" .. balance .. " < " .. cost .. ")")
                            UIManager.apps.DialogApp:dialog({ text = "You can't afford this.", button = "Okay" })
                            return "not_enough_currency"
                        end

                        -- Deduct tickets
                        set_thread_identity(2)
                        pcall(function()
                            ClientData.predict("pet_recycler_tickets_2026", math.max(0, balance - cost))
                        end)
                        set_thread_identity(get_thread_identity and get_thread_identity() or 8)
                        DebugLog("ShopAPI: deducted " .. cost .. " tickets, balance " .. balance .. " → " .. math.max(0, balance - cost))

                        -- Map shop item kind → pet display name (as used by FindPetId / InventoryDB)
                        -- Covers both direct pets (pet_recycler_2025_*) and egg purchases (egg_teaser_2026_*)
                        local SHOP_TO_PET_NAME = {
                            -- Direct pet purchases
                            ["pet_recycler_2025_giant_panda"]      = "Giant Panda",
                            ["pet_recycler_2025_bat_dragon"]       = "Bat Dragon",
                            ["pet_recycler_2025_shadow_dragon"]    = "Shadow Dragon",
                            ["pet_recycler_2025_frost_dragon"]     = "Frost Dragon",
                            ["pet_recycler_2025_giraffe"]          = "Giraffe",
                            ["pet_recycler_2025_owl"]              = "Owl",
                            ["pet_recycler_2025_parrot"]           = "Parrot",
                            ["pet_recycler_2025_crow"]             = "Crow",
                            ["pet_recycler_2025_evil_unicorn"]     = "Evil Unicorn",
                            ["pet_recycler_2025_arctic_reindeer"]  = "Arctic Reindeer",
                            ["pet_recycler_2025_turtle"]           = "Turtle",
                            ["pet_recycler_2025_kangaroo"]         = "Kangaroo",
                            ["pet_recycler_2025_lion"]             = "Lion",
                            ["pet_recycler_2025_elephant"]         = "Elephant",
                            ["pet_recycler_2025_rhino"]            = "Rhino",
                            ["pet_recycler_2025_cow"]              = "Cow",
                            ["pet_recycler_2025_flamingo"]         = "Flamingo",
                            ["pet_recycler_2025_hedgehog"]         = "Hedgehog",
                            ["pet_recycler_2025_dalmatian"]        = "Dalmatian",
                            ["pet_recycler_2025_blue_dog"]         = "Blue Dog",
                            ["pet_recycler_2025_pink_cat"]         = "Pink Cat",
                            -- Egg teaser purchases (each egg gives a specific pet)
                            ["egg_teaser_2026_dire_wolf"]          = "Dire Wolf",
                            ["egg_teaser_2026_giant_panda"]        = "Giant Panda",
                            ["egg_teaser_2026_shadow_dragon"]      = "Shadow Dragon",
                            ["egg_teaser_2026_bat_dragon"]         = "Bat Dragon",
                            ["egg_teaser_2026_frost_dragon"]       = "Frost Dragon",
                            ["egg_teaser_2026_giraffe"]            = "Giraffe",
                            ["egg_teaser_2026_owl"]                = "Owl",
                        }

                        local petName = SHOP_TO_PET_NAME[itemKind]

                        -- Fallback: try stripping prefix and converting underscores to title case
                        if not petName then
                            local stripped = itemKind:match("^pet_recycler_%d+_(.+)$")
                                          or itemKind:match("^egg_teaser_%d+_(.+)$")
                            if stripped then
                                -- "giant_panda" → "Giant Panda"
                                petName = stripped:gsub("_(%a)", function(c) return " " .. c:upper() end)
                                          :gsub("^%a", string.upper)
                                DebugLog("ShopAPI: auto-generated name=" .. petName)
                            end
                        end

                        DebugLog("ShopAPI: petName=" .. tostring(petName))

                        local spawned = false
                        if petName then
                            -- Exact same path as the Spawn button: FindPetId → CreateInventoryItem
                            local petId = FindPetId(petName)
                            DebugLog("ShopAPI: FindPetId('" .. petName .. "') = " .. tostring(petId))
                            -- If nil, dump InventoryDB names containing "panda" or the first word of petName
                            if not petId then
                                local searchWord = petName:lower():match("^(%a+)")
                                for id, info in pairs(InventoryDB.pets) do
                                    if info.name and info.name:lower():find(searchWord) then
                                        DebugLog("  InventoryDB match: id=" .. id .. " name=" .. info.name)
                                    end
                                end
                            end
                            if petId then
                                local item = CreateInventoryItem(petId, "pets", {
                                    mega_neon          = false,
                                    neon               = false,
                                    flyable            = false,
                                    rideable           = false,
                                    age                = 1,
                                    trick_level        = 0,
                                    ailments_completed = 0,
                                    rp_name            = "__no_name__",
                                    _hatched           = true,
                                })
                                if item then
                                    spawned = true
                                    DebugLog("ShopAPI: spawned " .. petName)
                                else
                                    DebugLog("ShopAPI: CreateInventoryItem returned nil for " .. petName)
                                end
                            else
                                DebugLog("ShopAPI: FindPetId returned nil for '" .. petName .. "' — check dump above")
                            end
                        else
                            DebugLog("ShopAPI: no mapping for " .. itemKind .. " — add it to SHOP_TO_PET_NAME")
                        end
                        return "success"
                    end

                    -- Not a recycler item — pass through to server
                    if ok and originalRemote then
                        return originalRemote:InvokeServer(category, itemKind, options)
                    end
                end
            }
        end
        -- ─── Pet wear helpers defined at module scope above ───
        local AttachAccessoryToPet = _G._FakePetWearAttach
        local DetachAccessoryFromPet = _G._FakePetWearDetach
        -- AvatarAPI/PutOn: intercept wear for fake pets
        if endpoint == "AvatarAPI/PutOn" then
            local ok_r, real_r = pcall(OriginalRouterGet, endpoint)
            return {
                InvokeServer = function(_, avatar_type, category, asset_id, pet_unique)
                    local isFakePet = pet_unique and SpawnedPets[pet_unique] ~= nil
                    if not isFakePet then
                        -- Not a fake pet — pass to server normally
                        if ok_r and real_r then return real_r:InvokeServer(avatar_type, category, asset_id, pet_unique) end
                        return
                    end
                    -- Fake pet: update avatar_manager AND pet_saved_worn_items using
                    -- ClientData.update so register_callback fires and green outline appears.
                    local identity = get_thread_identity and get_thread_identity() or 8
                    set_thread_identity(2)
                    pcall(function()
                        local function deepCopy(t)
                            if type(t) ~= "table" then return t end
                            local c = {}
                            for k, v in pairs(t) do c[deepCopy(k)] = deepCopy(v) end
                            return c
                        end
                        -- 1. avatar_manager — drives get_equipped_ids_set → "equipped" green border
                        local am = ClientData.get("avatar_manager") or {}
                        local amCopy = deepCopy(am)
                        amCopy.pet = amCopy.pet or {}
                        amCopy.pet[pet_unique] = amCopy.pet[pet_unique] or {}
                        amCopy.pet[pet_unique][category] = amCopy.pet[pet_unique][category] or {}
                        local list = amCopy.pet[pet_unique][category]
                        local found = false
                        for _, v in ipairs(list) do if v == asset_id then found = true; break end end
                        if not found then table.insert(list, asset_id) end
                        ClientData.update("avatar_manager", amCopy)
                        -- 2. pet_saved_worn_items.accessory_to_pet_map — rebuild for this pet only
                        --    so borders from other pets don't leak in.
                        if _G._RebuildWornItemsMapForPet then
                            task.defer(function() _G._RebuildWornItemsMapForPet(pet_unique) end)
                        end
                    end)
                    set_thread_identity(identity)
                    -- Attach the accessory model to the pet rig
                    task.spawn(function()
                        AttachAccessoryToPet(pet_unique, asset_id, category)
                    end)
                    return true
                end
            }
        end
        -- AvatarAPI/TakeOff: intercept unwear for fake pets
        if endpoint == "AvatarAPI/TakeOff" then
            local ok_r, real_r = pcall(OriginalRouterGet, endpoint)
            return {
                InvokeServer = function(_, avatar_type, category, asset_id, pet_unique)
                    local isFakePet = pet_unique and SpawnedPets[pet_unique] ~= nil
                    if not isFakePet then
                        if ok_r and real_r then return real_r:InvokeServer(avatar_type, category, asset_id, pet_unique) end
                        return
                    end
                    -- Fake pet: remove from avatar_manager AND pet_saved_worn_items
                    local identity = get_thread_identity and get_thread_identity() or 8
                    set_thread_identity(2)
                    pcall(function()
                        local function deepCopy(t)
                            if type(t) ~= "table" then return t end
                            local c = {}
                            for k, v in pairs(t) do c[deepCopy(k)] = deepCopy(v) end
                            return c
                        end
                        -- 1. avatar_manager
                        local am = ClientData.get("avatar_manager") or {}
                        local amCopy = deepCopy(am)
                        if amCopy.pet and amCopy.pet[pet_unique] and amCopy.pet[pet_unique][category] then
                            local list = amCopy.pet[pet_unique][category]
                            for i = #list, 1, -1 do
                                if list[i] == asset_id then table.remove(list, i) end
                            end
                            ClientData.update("avatar_manager", amCopy)
                        end
                        -- 2. pet_saved_worn_items — rebuild for this pet only
                        if _G._RebuildWornItemsMapForPet then
                            task.defer(function() _G._RebuildWornItemsMapForPet(pet_unique) end)
                        end
                    end)
                    set_thread_identity(identity)
                    -- Remove accessory model from pet rig
                    task.spawn(function()
                        DetachAccessoryFromPet(pet_unique, asset_id)
                    end)
                    return true
                end
            }
        end
        return OriginalRouterGet(endpoint)
    end
end

-- Unequip all existing pets on startup
for _, wrapper in pairs(ClientData.get("pet_char_wrappers")) do
    OriginalRouterGet("ToolAPI/Unequip"):InvokeServer(wrapper.pet_unique)
end

_G._ui_SpawnedPets = SpawnedPets
_G._ui_SpawnedItems = SpawnedItems
_G._ui_LocalPlayer = LocalPlayer
_G._ui_playerGui = playerGui
_G._ui_InventoryDB = InventoryDB
_G._ui_KindDB = KindDB
_G._ui_ClientData = ClientData
_G._ui_RouterClient = RouterClient
_G._ui_OriginalRouterGet = OriginalRouterGet
_G._ui_UIManager = UIManager
_G._ui_TweenService = TweenService
_G._ui_ReplicatedStorage = ReplicatedStorage
_G._ui_DebugLogs = DebugLogs
_G._ui_debugScrollFrame = debugScrollFrame
_G._ui_CreateInventoryItem = CreateInventoryItem
_G._ui_FindPetId = FindPetId
_G._ui_FindToyId = FindToyId
_G._ui_FindItemId = FindItemId
_G._ui_EquipPet = EquipPet
_G._ui_UnequipPet = UnequipPet
_G._ui_DeleteAllSpawnedPets = DeleteAllSpawnedPets
_G._ui_GenerateUniquePetName = GenerateUniquePetName
_G._ui_HighTierPets = HighTierPets
_G._ui_PetColorHelper = PetColorHelper
_G._ui_PaintColorDB = PaintColorDB
_G._ui_AnimationManager = AnimationManager
_G._ui_DisplayStandHelper = DisplayStandHelper
_G._ui_DownloadClient = DownloadClient
_G._ui_PetRecyclerApp = PetRecyclerApp
_G._ui__ActiveTicketBalance = _ActiveTicketBalance
_G._ui_IsFakePet = IsFakePet
_G._ui_GetPetModel = GetPetModel
_G._ui_EquippedPet = function() return EquippedPet end
_G._blueprint_EquippedPet = _G._ui_EquippedPet  -- persistent ref


do local _lf0,_le0=loadstring([[
local DebugLog = _G._DebugLog or function() end
local SpawnedPets = _G._ui_SpawnedPets
local SpawnedItems = _G._ui_SpawnedItems
local LocalPlayer = _G._ui_LocalPlayer
local playerGui = _G._ui_playerGui
local InventoryDB = _G._ui_InventoryDB
local KindDB = _G._ui_KindDB
local ClientData = _G._ui_ClientData
local RouterClient = _G._ui_RouterClient
local OriginalRouterGet = _G._ui_OriginalRouterGet
local UIManager = _G._ui_UIManager
local TweenService = _G._ui_TweenService
local ReplicatedStorage = _G._ui_ReplicatedStorage
local DebugLogs = _G._ui_DebugLogs
local debugScrollFrame = _G._ui_debugScrollFrame
local CreateInventoryItem = _G._ui_CreateInventoryItem
local FindPetId = _G._ui_FindPetId
local FindToyId = _G._ui_FindToyId
local FindItemId = _G._ui_FindItemId
local EquipPet = _G._ui_EquipPet
local UnequipPet = _G._ui_UnequipPet
local DeleteAllSpawnedPets = _G._ui_DeleteAllSpawnedPets
local GenerateUniquePetName = _G._ui_GenerateUniquePetName
local HighTierPets = _G._ui_HighTierPets
local PetColorHelper = _G._ui_PetColorHelper
local PaintColorDB = _G._ui_PaintColorDB
local AnimationManager = _G._ui_AnimationManager
local DisplayStandHelper = _G._ui_DisplayStandHelper
local DownloadClient = _G._ui_DownloadClient
local PetRecyclerApp = _G._ui_PetRecyclerApp
local _ActiveTicketBalance = _G._ui__ActiveTicketBalance
local IsFakePet = _G._ui_IsFakePet
local GetPetModel = _G._ui_GetPetModel
_G._ui_SpawnedPets=nil; _G._ui_SpawnedItems=nil; _G._ui_LocalPlayer=nil; _G._ui_playerGui=nil; _G._ui_InventoryDB=nil; _G._ui_KindDB=nil; _G._ui_ClientData=nil; _G._ui_RouterClient=nil; _G._ui_OriginalRouterGet=nil; _G._ui_UIManager=nil; _G._ui_TweenService=nil; _G._ui_ReplicatedStorage=nil; _G._ui_DebugLogs=nil; _G._ui_debugScrollFrame=nil; _G._ui_CreateInventoryItem=nil; _G._ui_FindPetId=nil; _G._ui_FindItemId=nil; _G._ui_EquipPet=nil; _G._ui_UnequipPet=nil; _G._ui_DeleteAllSpawnedPets=nil; _G._ui_GenerateUniquePetName=nil; _G._ui_HighTierPets=nil; _G._ui_PetColorHelper=nil; _G._ui_PaintColorDB=nil; _G._ui_AnimationManager=nil; _G._ui_DisplayStandHelper=nil; _G._ui_DownloadClient=nil; _G._ui_PetRecyclerApp=nil; _G._ui__ActiveTicketBalance=nil; _G._ui_IsFakePet=nil; _G._ui_GetPetModel=nil


-- =============== ORIGINAL UI (unchanged) ===============

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "blueprint_lua"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local uiScale = Instance.new("UIScale", mainFrame)
uiScale.Scale = 0.7

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 3
uiStroke.Color = Color3.fromRGB(0, 220, 255)
uiStroke.Parent = mainFrame

local palette = {
    Color3.fromRGB(0, 220, 255),
    Color3.fromRGB(120, 90, 255),
    Color3.fromRGB(255, 80, 160),
    Color3.fromRGB(0, 200, 180)
}
local colorIdx = 1
task.spawn(function()
    while true do
        colorIdx = colorIdx % #palette + 1
        TweenService:Create(uiStroke, TweenInfo.new(4), { Color = palette[colorIdx] }):Play()
        task.wait(4)
    end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 4)
title.BackgroundTransparency = 1
title.Text = "blueprint.lua on discord"
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextColor3 = Color3.fromRGB(235, 240, 255)
title.Parent = mainFrame

local tabContainer = Instance.new('Frame')
tabContainer.Size = UDim2.new(0.94, 0, 0, 22)
tabContainer.Position = UDim2.new(0.03, 0, 0, 24)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 3)
tabLayout.Parent = tabContainer

local tabs = {
    { key = 'Spawn', label = 'Spawn' },
    { key = 'Tools', label = 'Tools' },
    { key = 'Misc',  label = 'Misc'  },
    { key = 'Debug', label = '🐛 Debug' }
}

local activeTab = 'Spawn'
local tabElements = {}

local function SwitchTab(tabName)
    activeTab = tabName
    for name, data in pairs(tabElements) do
        local isActive = name == tabName
        data.button.BackgroundColor3 = isActive and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(40, 40, 50)
        data.stroke.Color = isActive and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 80)
        data.stroke.Thickness = isActive and 1.2 or 0.8
    end
end

for i, tab in ipairs(tabs) do
    local tabButton = Instance.new('TextButton')
    tabButton.Size = UDim2.new(0, 62, 1, 0)
    tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(40, 40, 50)
    tabButton.BackgroundTransparency = 0.2
    tabButton.Text = tab.label
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 9
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Parent = tabContainer

    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)

    local tabStroke = Instance.new('UIStroke')
    tabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    tabStroke.Color = i == 1 and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 80)
    tabStroke.Thickness = i == 1 and 1.2 or 0.8
    tabStroke.Transparency = 0.3
    tabStroke.Parent = tabButton

    tabElements[tab.key] = { button = tabButton, stroke = tabStroke }

    tabButton.MouseButton1Click:Connect(function()
        SwitchTab(tab.key)
    end)
end

local spawnPanel = Instance.new("Frame")
spawnPanel.Size = UDim2.new(0.94, 0, 1, -50)
spawnPanel.Position = UDim2.new(0.03, 0, 0, 48)
spawnPanel.BackgroundTransparency = 1
spawnPanel.Visible = true
spawnPanel.Parent = mainFrame

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0, 10)
nameLabel.Position = UDim2.new(0, 0, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "🐾 Pet Name"
nameLabel.Font = Enum.Font.Gotham
nameLabel.TextSize = 8
nameLabel.TextColor3 = Color3.fromRGB(160, 170, 200)
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = spawnPanel

local nameInput = Instance.new("TextBox")
nameInput.Size = UDim2.new(1, 0, 0, 22)
nameInput.Position = UDim2.new(0, 0, 0, 11)
nameInput.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
nameInput.TextColor3 = Color3.fromRGB(240, 240, 255)
nameInput.TextSize = 11
nameInput.Font = Enum.Font.Gotham
nameInput.PlaceholderText = "Enter pet name..."
nameInput.PlaceholderColor3 = Color3.fromRGB(140, 150, 180)
nameInput.ClearTextOnFocus = false
nameInput.Text = "Bat Dragon"
nameInput.Parent = spawnPanel

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = nameInput

local glowColors = {
    neutral = Color3.fromRGB(220, 220, 255),
    valid = Color3.fromRGB(120, 255, 150),
    invalid = Color3.fromRGB(255, 120, 120)
}

local inputGlow = Instance.new("UIStroke")
inputGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
inputGlow.Color = glowColors.neutral
inputGlow.Thickness = 2
inputGlow.Transparency = 0.3
inputGlow.Parent = nameInput

local ageLabel = Instance.new("TextLabel")
ageLabel.Size = UDim2.new(1, 0, 0, 10)
ageLabel.Position = UDim2.new(0, 0, 0, 38)
ageLabel.BackgroundTransparency = 1
ageLabel.Text = "📅 Age"
ageLabel.Font = Enum.Font.Gotham
ageLabel.TextSize = 8
ageLabel.TextColor3 = Color3.fromRGB(160, 170, 200)
ageLabel.TextXAlignment = Enum.TextXAlignment.Left
ageLabel.Parent = spawnPanel

local ageGrid = Instance.new("Frame")
ageGrid.Size = UDim2.new(1, 0, 0, 20)
ageGrid.Position = UDim2.new(0, 0, 0, 49)
ageGrid.BackgroundTransparency = 1
ageGrid.Parent = spawnPanel

local ageCodes = {"N", "J", "P", "T", "P", "F"}
local ageDescriptions = {"Newborn", "Junior", "Pre-Teen", "Teen", "Post-Teen", "Full Grown"}
local currentAge = {v = 1}  -- table so cross-chunk reference stays live

for i, code in ipairs(ageCodes) do
    local ageButton = Instance.new("TextButton")
    ageButton.Size = UDim2.new(1/6 - 0.01, 0, 1, 0)
    ageButton.Position = UDim2.new((i-1) * (1/6), (i > 1) and 2 or 0, 0, 0)
    ageButton.Text = code
    ageButton.BackgroundColor3 = i == 1 and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(40, 44, 66)
    ageButton.Font = Enum.Font.GothamBold
    ageButton.TextColor3 = Color3.fromRGB(240, 240, 255)
    ageButton.TextSize = 11
    ageButton.Parent = ageGrid
    
    local ageCorner = Instance.new("UICorner")
    ageCorner.CornerRadius = UDim.new(0, 6)
    ageCorner.Parent = ageButton
    
    local hintBox = Instance.new("TextLabel")
    hintBox.Text = ageDescriptions[i]
    hintBox.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
    hintBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    hintBox.TextSize = 7
    hintBox.Font = Enum.Font.Gotham
    hintBox.Size = UDim2.new(0, 0, 0, 0)
    hintBox.Visible = false
    hintBox.Parent = ageButton
    Instance.new("UICorner", hintBox).CornerRadius = UDim.new(0, 4)
    
    ageButton.MouseEnter:Connect(function()
        hintBox.Size = UDim2.new(0, 65, 0, 15)
        hintBox.Position = UDim2.new(0, 0, -1.2, 0)
        hintBox.Visible = true
    end)
    
    ageButton.MouseLeave:Connect(function()
        hintBox.Visible = false
    end)
    
    ageButton.MouseButton1Click:Connect(function()
        currentAge.v = i
        for _, btn in pairs(ageGrid:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(40, 44, 66)
            end
        end
        ageButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end)
end

local flagLabel = Instance.new("TextLabel")
flagLabel.Size = UDim2.new(1, 0, 0, 10)
flagLabel.Position = UDim2.new(0, 0, 0, 74)
flagLabel.BackgroundTransparency = 1
flagLabel.Text = "✨ Pet Flags"
flagLabel.Font = Enum.Font.Gotham
flagLabel.TextSize = 8
flagLabel.TextColor3 = Color3.fromRGB(160, 170, 200)
flagLabel.TextXAlignment = Enum.TextXAlignment.Left
flagLabel.Parent = spawnPanel

local flagGrid = Instance.new("Frame")
flagGrid.Size = UDim2.new(1, 0, 0, 24)
flagGrid.Position = UDim2.new(0, 0, 0, 85)
flagGrid.BackgroundTransparency = 1
flagGrid.Parent = spawnPanel

local flagColors = {
    M = Color3.fromRGB(170, 0, 255),
    N = Color3.fromRGB(0, 255, 100),
    F = Color3.fromRGB(0, 200, 255),
    R = Color3.fromRGB(255, 50, 150)
}

local flagOrder = {"M", "N", "F", "R"}
local flagState = {M = false, N = false, F = true, R = true}

for i, flag in ipairs(flagOrder) do
    local flagButton = Instance.new("TextButton")
    flagButton.Size = UDim2.new(0.23, -2, 1, 0)
    flagButton.Position = UDim2.new((i-1) * 0.25, (i > 1) and 3 or 0, 0, 0)
    flagButton.Text = flag
    flagButton.BackgroundColor3 = flagState[flag] and flagColors[flag] or Color3.fromRGB(40, 44, 66)
    flagButton.Font = Enum.Font.GothamBold
    flagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flagButton.TextSize = 12
    flagButton.Parent = flagGrid
    
    local flagCorner = Instance.new("UICorner")
    flagCorner.CornerRadius = UDim.new(0, 8)
    flagCorner.Parent = flagButton
    
    local flagStroke = Instance.new("UIStroke")
    flagStroke.Color = flagColors[flag]
    flagStroke.Thickness = flagState[flag] and 2.5 or 1.5
    flagStroke.Transparency = flagState[flag] and 0.2 or 0.5
    flagStroke.Parent = flagButton
    
    flagButton.MouseButton1Click:Connect(function()
        if flag == "M" and flagState["N"] then return end
        if flag == "N" and flagState["M"] then return end
        
        flagState[flag] = not flagState[flag]
        
        if flagState[flag] then
            flagButton.BackgroundColor3 = flagColors[flag]
            TweenService:Create(flagStroke, TweenInfo.new(0.2), {
                Thickness = 2.5,
                Transparency = 0.2
            }):Play()
        else
            flagButton.BackgroundColor3 = Color3.fromRGB(40, 44, 66)
            TweenService:Create(flagStroke, TweenInfo.new(0.2), {
                Thickness = 1.5,
                Transparency = 0.5
            }):Play()
        end
    end)
end

local quickLabel = Instance.new("TextLabel")
quickLabel.Size = UDim2.new(1, 0, 0, 10)
quickLabel.Position = UDim2.new(0, 0, 0, 114)
quickLabel.BackgroundTransparency = 1
quickLabel.Text = "⚡ Quick Select"
quickLabel.Font = Enum.Font.Gotham
quickLabel.TextSize = 8
quickLabel.TextColor3 = Color3.fromRGB(160, 170, 200)
quickLabel.TextXAlignment = Enum.TextXAlignment.Left
quickLabel.Parent = spawnPanel

local quickGrid = Instance.new("Frame")
quickGrid.Size = UDim2.new(1, 0, 0, 42)
quickGrid.Position = UDim2.new(0, 0, 0, 125)
quickGrid.BackgroundTransparency = 1
quickGrid.Parent = spawnPanel

local quickPets = {
    {"Shadow Dragon", Color3.fromRGB(100, 0, 100)},
    {"Frost Dragon", Color3.fromRGB(0, 150, 255)},
    {"Bat Dragon", Color3.fromRGB(150, 0, 0)},
    {"Giraffe", Color3.fromRGB(200, 150, 0)},
    {"Owl", Color3.fromRGB(150, 100, 50)},
    {"Parrot", Color3.fromRGB(255, 100, 0)}
}

for i, petData in ipairs(quickPets) do
    local row = math.floor((i-1) / 3)
    local col = (i-1) % 3
    
    local quickButton = Instance.new("TextButton")
    quickButton.Size = UDim2.new(0.32, -2, 0.45, 0)
    quickButton.Position = UDim2.new(col * 0.33, (col > 0) and 3 or 0, row * 0.5, (row > 0) and 3 or 0)
    
    if i <= 3 then
        quickButton.Text = petData[1]
    else
        quickButton.Text = petData[1]:match("^(%w+)") or petData[1]
    end
    
    quickButton.BackgroundColor3 = petData[2]
    quickButton.Font = Enum.Font.GothamBold
    quickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    quickButton.TextSize = 7
    quickButton.Parent = quickGrid
    
    local quickCorner = Instance.new("UICorner")
    quickCorner.CornerRadius = UDim.new(0, 6)
    quickCorner.Parent = quickButton
    
    quickButton.MouseButton1Click:Connect(function()
        nameInput.Text = petData[1]
    end)
end

local spawnAllButton = Instance.new("TextButton")
spawnAllButton.Size = UDim2.new(1, 0, 0, 24)
spawnAllButton.Position = UDim2.new(0, 0, 0, 180)
spawnAllButton.Text = "👑 SPAWN ALL HIGH TIERS"
spawnAllButton.Font = Enum.Font.GothamBold
spawnAllButton.TextSize = 9
spawnAllButton.BackgroundColor3 = Color3.fromRGB(180, 120, 50)
spawnAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnAllButton.Parent = spawnPanel

local allCorner = Instance.new("UICorner")
allCorner.CornerRadius = UDim.new(0, 8)
allCorner.Parent = spawnAllButton

local allStroke = Instance.new("UIStroke")
allStroke.Color = Color3.fromRGB(255, 200, 100)
allStroke.Thickness = 1.5
allStroke.Transparency = 0.3
allStroke.Parent = spawnAllButton

local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(1, 0, 0, 28)
spawnButton.Position = UDim2.new(0, 0, 1, -36)
spawnButton.Text = "✨ SPAWN PET"
spawnButton.Font = Enum.Font.GothamBold
spawnButton.TextSize = 12
spawnButton.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.Parent = spawnPanel

local spawnCorner = Instance.new("UICorner")
spawnCorner.CornerRadius = UDim.new(0, 10)
spawnCorner.Parent = spawnButton

local toolsPanel = Instance.new("Frame")
toolsPanel.Size = UDim2.new(0.94, 0, 1, -50)
toolsPanel.Position = UDim2.new(0.03, 0, 0, 48)
toolsPanel.BackgroundTransparency = 1
toolsPanel.Visible = false
toolsPanel.Parent = mainFrame

local toolsTitle = Instance.new("TextLabel")
toolsTitle.Size = UDim2.new(1, 0, 0, 16)
toolsTitle.Position = UDim2.new(0, 0, 0, 0)
toolsTitle.BackgroundTransparency = 1
toolsTitle.Text = "🔧 Tools"
toolsTitle.Font = Enum.Font.GothamBold
toolsTitle.TextSize = 11
toolsTitle.TextColor3 = Color3.fromRGB(235, 240, 255)
toolsTitle.TextXAlignment = Enum.TextXAlignment.Left
toolsTitle.Parent = toolsPanel

-- =============== MISC PANEL ===============

local miscPanel = Instance.new("ScrollingFrame")
miscPanel.Size = UDim2.new(0.94, 0, 1, -50)
miscPanel.Position = UDim2.new(0.03, 0, 0, 48)
miscPanel.BackgroundTransparency = 1
miscPanel.ScrollBarThickness = 4
miscPanel.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 180)
miscPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
miscPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
miscPanel.BorderSizePixel = 0
miscPanel.Visible = false
miscPanel.Parent = mainFrame
local miscLayout = Instance.new("UIListLayout")
miscLayout.SortOrder = Enum.SortOrder.LayoutOrder
miscLayout.Padding = UDim.new(0, 5)
miscLayout.Parent = miscPanel
local miscPadding = Instance.new("UIPadding")
miscPadding.PaddingLeft   = UDim.new(0, 2)
miscPadding.PaddingRight  = UDim.new(0, 2)
miscPadding.PaddingTop    = UDim.new(0, 4)
miscPadding.Parent = miscPanel

-- ── Section title ─────────────────────────────────────────────────────────
local miscTitle = Instance.new("TextLabel")
miscTitle.Size = UDim2.new(1, 0, 0, 14)
miscTitle.BackgroundTransparency = 1
miscTitle.Text = "✨ Misc"
miscTitle.Font = Enum.Font.GothamBold
miscTitle.TextSize = 11
miscTitle.TextColor3 = Color3.fromRGB(235, 240, 255)
miscTitle.TextXAlignment = Enum.TextXAlignment.Left
miscTitle.Parent = miscPanel

-- ── Spawn All Variants ─────────────────────────────────────────────────────
local miscVariantDesc = Instance.new("TextLabel")
miscVariantDesc.Size = UDim2.new(1, 0, 0, 20)
miscVariantDesc.BackgroundTransparency = 1
miscVariantDesc.Text = "Spawns 1 MFR, 1 NFR & 1 FR for every pet in the list"
miscVariantDesc.Font = Enum.Font.Gotham
miscVariantDesc.TextSize = 8
miscVariantDesc.TextColor3 = Color3.fromRGB(160, 170, 200)
miscVariantDesc.TextXAlignment = Enum.TextXAlignment.Left
miscVariantDesc.TextWrapped = true
miscVariantDesc.Parent = miscPanel

local spawnAllVariantsButton = Instance.new("TextButton")
spawnAllVariantsButton.Size = UDim2.new(1, 0, 0, 26)
spawnAllVariantsButton.Text = "🌈 SPAWN ALL VARIANTS"
spawnAllVariantsButton.Font = Enum.Font.GothamBold
spawnAllVariantsButton.TextSize = 10
spawnAllVariantsButton.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
spawnAllVariantsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnAllVariantsButton.Parent = miscPanel
Instance.new("UICorner", spawnAllVariantsButton).CornerRadius = UDim.new(0, 8)
local varStroke = Instance.new("UIStroke")
varStroke.Color = Color3.fromRGB(200, 100, 255)
varStroke.Thickness = 1.5
varStroke.Transparency = 0.3
varStroke.Parent = spawnAllVariantsButton

spawnAllVariantsButton.MouseButton1Click:Connect(function()
    spawnAllVariantsButton.Text = "⏳ SPAWNING..."
    spawnAllVariantsButton.BackgroundColor3 = Color3.fromRGB(80, 0, 140)
    local variants = {
        { mega_neon = true,  neon = false, flyable = true, rideable = true, age = 6, variantPriority = 3 },
        { mega_neon = false, neon = true,  flyable = true, rideable = true, age = 6, variantPriority = 2 },
        { mega_neon = false, neon = false, flyable = true, rideable = true, age = 6, variantPriority = 1 },
    }
    local totalPets = #HighTierPets
    local totalSpawned = 0
    for petIndex, petName in ipairs(HighTierPets) do
        local petId = FindPetId(petName)
        if petId then
            for _, variant in ipairs(variants) do
                local deterministicNewness = (totalPets - petIndex) * 4 + variant.variantPriority
                local opts = {
                    mega_neon = variant.mega_neon, neon = variant.neon,
                    flyable = variant.flyable, rideable = variant.rideable,
                    age = variant.age, trick_level = 5, ailments_completed = 0,
                    rp_name = GenerateUniquePetName(petId), _newness_order = deterministicNewness,
                }
                local item = CreateInventoryItem(petId, "pets", opts)
                if item then totalSpawned = totalSpawned + 1 end
            end
        end
    end
    spawnAllVariantsButton.Text = "✓ SPAWNED " .. totalSpawned .. " PETS!"
    spawnAllVariantsButton.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
    task.wait(2.5)
    spawnAllVariantsButton.Text = "🌈 SPAWN ALL VARIANTS"
    spawnAllVariantsButton.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
end)

-- ── Divider ────────────────────────────────────────────────────────────────
local ticketDivider = Instance.new("Frame")
ticketDivider.Size = UDim2.new(1, 0, 0, 1)
ticketDivider.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
ticketDivider.BorderSizePixel = 0
ticketDivider.Parent = miscPanel

-- ── Ticket Giver ───────────────────────────────────────────────────────────
local ticketTitle = Instance.new("TextLabel")
ticketTitle.Size = UDim2.new(1, 0, 0, 14)
ticketTitle.BackgroundTransparency = 1
ticketTitle.Text = "🎟️ Recycler Ticket Giver"
ticketTitle.Font = Enum.Font.GothamBold
ticketTitle.TextSize = 10
ticketTitle.TextColor3 = Color3.fromRGB(255, 210, 80)
ticketTitle.TextXAlignment = Enum.TextXAlignment.Left
ticketTitle.Parent = miscPanel

-- ticket input row (box + give button side by side)
local ticketRow = Instance.new("Frame")
ticketRow.Size = UDim2.new(1, 0, 0, 26)
ticketRow.BackgroundTransparency = 1
ticketRow.Parent = miscPanel
local ticketRowLayout = Instance.new("UIListLayout")
ticketRowLayout.FillDirection = Enum.FillDirection.Horizontal
ticketRowLayout.Padding = UDim.new(0, 4)
ticketRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ticketRowLayout.Parent = ticketRow

local ticketBox = Instance.new("TextBox")
ticketBox.Size = UDim2.new(0.63, -2, 1, 0)
ticketBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
ticketBox.BorderSizePixel = 0
ticketBox.Text = ""
ticketBox.PlaceholderText = "Amount (e.g. 50000)"
ticketBox.Font = Enum.Font.Gotham
ticketBox.TextSize = 10
ticketBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ticketBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 130)
ticketBox.ClearTextOnFocus = false
ticketBox.Parent = ticketRow
Instance.new("UICorner", ticketBox).CornerRadius = UDim.new(0, 7)
local ticketBoxStroke = Instance.new("UIStroke", ticketBox)
ticketBoxStroke.Color = Color3.fromRGB(255, 190, 40)
ticketBoxStroke.Thickness = 1.5
ticketBoxStroke.Transparency = 0.5

ticketBox:GetPropertyChangedSignal("Text"):Connect(function()
    local clean = ticketBox.Text:gsub("[^%d]", "")
    if clean ~= ticketBox.Text then ticketBox.Text = clean end
end)

local giveTicketBtn = Instance.new("TextButton")
giveTicketBtn.Size = UDim2.new(0.37, -2, 1, 0)
giveTicketBtn.Text = "Give 🎟️"
giveTicketBtn.Font = Enum.Font.GothamBold
giveTicketBtn.TextSize = 10
giveTicketBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
giveTicketBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
giveTicketBtn.Parent = ticketRow
Instance.new("UICorner", giveTicketBtn).CornerRadius = UDim.new(0, 7)
local giveTicketStroke = Instance.new("UIStroke", giveTicketBtn)
giveTicketStroke.Color = Color3.fromRGB(255, 220, 80)
giveTicketStroke.Thickness = 1.5
giveTicketStroke.Transparency = 0.3

-- Quick preset buttons row
local presetsRow = Instance.new("Frame")
presetsRow.Size = UDim2.new(1, 0, 0, 18)
presetsRow.BackgroundTransparency = 1
presetsRow.Parent = miscPanel
local presetsLayout = Instance.new("UIListLayout")
presetsLayout.FillDirection = Enum.FillDirection.Horizontal
presetsLayout.Padding = UDim.new(0, 4)
presetsLayout.Parent = presetsRow

local presets = { {label="1K", val=1000}, {label="10K", val=10000}, {label="100K", val=100000} }
for _, preset in ipairs(presets) do
    local pb = Instance.new("TextButton")
    pb.Size = UDim2.new(0, 54, 1, 0)
    pb.Text = preset.label
    pb.Font = Enum.Font.GothamBold
    pb.TextSize = 9
    pb.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    pb.TextColor3 = Color3.fromRGB(255, 210, 80)
    pb.Parent = presetsRow
    Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", pb).Color = Color3.fromRGB(255, 190, 40)
    pb.MouseButton1Click:Connect(function()
        ticketBox.Text = tostring(preset.val)
    end)
end

giveTicketBtn.MouseButton1Click:Connect(function()
    local amount = tonumber(ticketBox.Text)
    if not amount or amount <= 0 then
        giveTicketBtn.Text = "Enter amt!"
        task.wait(1.2)
        giveTicketBtn.Text = "Give 🎟️"
        return
    end
    amount = math.floor(amount)
    set_thread_identity(2)
    local ok, err = pcall(function()
        local current = ClientData.get("pet_recycler_tickets_2026") or 0
        ClientData.predict("pet_recycler_tickets_2026", current + amount)
    end)
    set_thread_identity(get_thread_identity and get_thread_identity() or 8)
    if ok then
        _ActiveTicketBalance = (_ActiveTicketBalance or 0) + amount
        giveTicketBtn.Text = "✓ Given!"
        giveTicketBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
        DebugLog("Gave " .. amount .. " tickets (pet_recycler_tickets_2026)")
    else
        giveTicketBtn.Text = "Error!"
        giveTicketBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        DebugLog("ERROR giving tickets: " .. tostring(err))
    end
    task.wait(1.5)
    giveTicketBtn.Text = "Give 🎟️"
    giveTicketBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
end)

-- ── Divider ────────────────────────────────────────────────────────────────
local eggDivider = Instance.new("Frame")
eggDivider.Size = UDim2.new(1, 0, 0, 1)
eggDivider.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
eggDivider.BorderSizePixel = 0
eggDivider.Parent = miscPanel

-- ── Egg Hatcher ────────────────────────────────────────────────────────────
local eggTitle = Instance.new("TextLabel")
eggTitle.Size = UDim2.new(1, 0, 0, 14)
eggTitle.BackgroundTransparency = 1
eggTitle.Text = "🥚 Egg Hatcher"
eggTitle.Font = Enum.Font.GothamBold
eggTitle.TextSize = 10
eggTitle.TextColor3 = Color3.fromRGB(255, 230, 120)
eggTitle.TextXAlignment = Enum.TextXAlignment.Left
eggTitle.Parent = miscPanel

local eggStatusLbl = Instance.new("TextLabel")
eggStatusLbl.Size = UDim2.new(1, 0, 0, 12)
eggStatusLbl.BackgroundTransparency = 1
eggStatusLbl.Text = "No egg equipped"
eggStatusLbl.Font = Enum.Font.Gotham
eggStatusLbl.TextSize = 8
eggStatusLbl.TextColor3 = Color3.fromRGB(140, 150, 180)
eggStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
eggStatusLbl.TextTruncate = Enum.TextTruncate.AtEnd
eggStatusLbl.Parent = miscPanel

-- hatch row (hatch now + refresh side by side)
local eggRow = Instance.new("Frame")
eggRow.Size = UDim2.new(1, 0, 0, 24)
eggRow.BackgroundTransparency = 1
eggRow.Parent = miscPanel
local eggRowLayout = Instance.new("UIListLayout")
eggRowLayout.FillDirection = Enum.FillDirection.Horizontal
eggRowLayout.Padding = UDim.new(0, 4)
eggRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
eggRowLayout.Parent = eggRow

local hatchNowBtn = Instance.new("TextButton")
hatchNowBtn.Size = UDim2.new(0.63, -2, 1, 0)
hatchNowBtn.Text = "🥚 Hatch Now"
hatchNowBtn.Font = Enum.Font.GothamBold
hatchNowBtn.TextSize = 9
hatchNowBtn.BackgroundColor3 = Color3.fromRGB(200, 140, 0)
hatchNowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hatchNowBtn.Parent = eggRow
Instance.new("UICorner", hatchNowBtn).CornerRadius = UDim.new(0, 7)
local hatchStroke = Instance.new("UIStroke", hatchNowBtn)
hatchStroke.Color = Color3.fromRGB(255, 200, 60)
hatchStroke.Thickness = 1.5
hatchStroke.Transparency = 0.3

local refreshEggBtn = Instance.new("TextButton")
refreshEggBtn.Size = UDim2.new(0.37, -2, 1, 0)
refreshEggBtn.Text = "🔄 Refresh"
refreshEggBtn.Font = Enum.Font.GothamBold
refreshEggBtn.TextSize = 8
refreshEggBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
refreshEggBtn.TextColor3 = Color3.fromRGB(160, 200, 255)
refreshEggBtn.Parent = eggRow
Instance.new("UICorner", refreshEggBtn).CornerRadius = UDim.new(0, 7)

local function FindEquippedEgg()
    local inv = ClientData.get("inventory")
    if not inv or not inv.pets then return nil, nil end
    local wrappers = ClientData.get("pet_char_wrappers") or {}
    for _, w in pairs(wrappers) do
        local uniqueId = w.pet_unique
        if uniqueId and inv.pets[uniqueId] then
            local entry = inv.pets[uniqueId]
            local kind = entry.id or entry.kind
            local kindData = kind and KindDB and KindDB[kind]
            if kindData and kindData.is_egg then
                local name = (InventoryDB.pets[kind] and InventoryDB.pets[kind].name) or kind
                return uniqueId, name
            end
        end
    end
    return nil, nil
end

local function RefreshEggStatus()
    local uid, name = FindEquippedEgg()
    if uid then
        eggStatusLbl.Text = "Equipped: " .. tostring(name)
        eggStatusLbl.TextColor3 = Color3.fromRGB(100, 220, 120)
        hatchNowBtn.BackgroundColor3 = Color3.fromRGB(200, 140, 0)
    else
        eggStatusLbl.Text = "No egg equipped — equip one first"
        eggStatusLbl.TextColor3 = Color3.fromRGB(180, 100, 80)
        hatchNowBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    end
end

refreshEggBtn.MouseButton1Click:Connect(RefreshEggStatus)
pcall(RefreshEggStatus)

local _hatchBusy = false
hatchNowBtn.MouseButton1Click:Connect(function()
    if _hatchBusy then return end
    local uid, name = FindEquippedEgg()
    if not uid then
        hatchNowBtn.Text = "Equip an egg first!"
        task.wait(1.5)
        hatchNowBtn.Text = "🥚 Hatch Now"
        return
    end
    _hatchBusy = true
    hatchNowBtn.Text = "⏳ Hatching..."
    hatchNowBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 40)
    DebugLog("Hatch: egg=" .. tostring(name) .. " uid=" .. tostring(uid))
    local inv = ClientData.get("inventory")
    local eggEntry = inv and inv.pets and inv.pets[uid]
    local eggKind = eggEntry and (eggEntry.id or eggEntry.kind)
    DebugLog("Hatch: eggKind=" .. tostring(eggKind))
    local EGG_POOLS = {
        christmas_egg = {
            {"Polar Bear", 25}, {"Reindeer", 20},
            {"Snowman", 15}, {"Arctic Reindeer", 8}, {"Evil Unicorn", 5},
        },
        farm_egg = {
            {"Chicken", 30}, {"Pig", 25}, {"Horse", 20}, {"Cow", 18},
            {"Buffalo", 15}, {"Rabbit", 15}, {"Dog", 12}, {"Cat", 12},
            {"Turkey", 10}, {"Penguin", 10}, {"Dragon", 5}, {"Unicorn", 5},
        },
        jungle_egg = {
            {"Monkey", 25}, {"Parrot", 20}, {"Toucan", 18}, {"Flamingo", 18},
            {"Crocodile", 15}, {"Rhino", 12}, {"Elephant", 8}, {"King Bee", 5},
        },
        aussie_egg = {
            {"Tasmanian Tiger", 25}, {"Dingo", 25}, {"Frog", 20},
            {"Emu", 18}, {"Glyptodon", 12}, {"Koala", 10}, {"Kangaroo", 8},
        },
        fossil_egg = {
            {"Ground Sloth", 25}, {"Tasmanian Tiger", 20}, {"Stegosaurus", 18},
            {"Triceratops", 15}, {"Pterodactyl", 12}, {"Woolly Mammoth", 10},
            {"T-Rex", 8}, {"Dodo", 5},
        },
        ocean_egg = {
            {"Seahorse", 25}, {"Clownfish", 25}, {"Dolphin", 20},
            {"Shark", 15}, {"Crab", 15}, {"Narwhal", 10}, {"Octopus", 8},
        },
        safari_egg = {
            {"Giraffe", 20}, {"Lion", 20}, {"Elephant", 18}, {"Hyena", 15},
            {"Crocodile", 15}, {"Cheetah", 12}, {"Rhino", 10},
        },
        woodland_egg = {
            {"Beaver", 25}, {"Bunny", 25}, {"Woodpecker", 20}, {"Squirrel", 20},
            {"Red Fox", 15}, {"Deer", 15}, {"Hedgehog", 10},
        },
    }
    local pool = eggKind and EGG_POOLS[eggKind]
    if not pool then
        DebugLog("Hatch: no pool for '" .. tostring(eggKind) .. "' — add it to EGG_POOLS")
        hatchNowBtn.Text = "❌ Unknown egg"
        hatchNowBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
        task.wait(2)
        _hatchBusy = false
        hatchNowBtn.Text = "🥚 Hatch Now"
        RefreshEggStatus()
        return
    end
    local totalWeight = 0
    for _, e in ipairs(pool) do totalWeight = totalWeight + e[2] end
    local roll = math.random(1, totalWeight)
    local cumulative = 0
    local chosenName = pool[1][1]
    for _, e in ipairs(pool) do
        cumulative = cumulative + e[2]
        if roll <= cumulative then chosenName = e[1]; break end
    end
    DebugLog("Hatch: rolled " .. chosenName)
    pcall(function() OriginalRouterGet("ToolAPI/Unequip"):InvokeServer(uid) end)
    task.wait(0.2)
    local char = LocalPlayer.Character
    local hatchModel = nil
    local hatchDone = false
    task.spawn(function()
        if not char then hatchDone = true return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then hatchDone = true return end

        -- Find the egg character model (p_u_105 in real game)
        local wrappers = ClientData.get("pet_char_wrappers") or {}
        for _, wrapper in pairs(wrappers) do
            if wrapper.pet_unique == uid then hatchModel = wrapper.char; break end
        end
        if not hatchModel and SpawnedPets[uid] then hatchModel = SpawnedPets[uid].model end
        local _DL = _G._DebugLog or DebugLog
        _DL("Hatch: egg model = " .. tostring(hatchModel ~= nil))

        -- Real game checks: IsDescendantOf(workspace), has HumanoidRootPart, has Humanoid
        local eggHRP = hatchModel and hatchModel:FindFirstChild("HumanoidRootPart")
        local eggHumanoid = hatchModel and hatchModel:FindFirstChild("Humanoid")
        _DL("Hatch: eggHRP=" .. tostring(eggHRP ~= nil) .. " eggHumanoid=" .. tostring(eggHumanoid ~= nil))
        if not hatchModel or not hatchModel:IsDescendantOf(workspace) or not eggHRP or not eggHumanoid then
            _DL("Hatch: falling back to local player HRP")
            eggHRP = hrp
        end
        _DL("Hatch: eggHRP pos=" .. tostring(eggHRP.Position))

        -- Create anchor part at egg position for particles
        local anchorPart = Instance.new("Part")
        anchorPart.Size = Vector3.new(2, 2, 1)
        anchorPart.Transparency = 1
        anchorPart.CanCollide = false
        anchorPart.Anchored = false
        anchorPart.CFrame = eggHRP.CFrame
        anchorPart.Parent = workspace
        _DL("Hatch: anchorPart created at " .. tostring(anchorPart.Position))

        -- Weld anchor to the egg HRP so it follows it
        local weld = Instance.new("Weld")
        weld.Part0 = eggHRP
        weld.Part1 = anchorPart
        weld.Parent = anchorPart

        -- If egg model removed, anchor the part so particles don't fall
        if hatchModel then
            hatchModel.AncestryChanged:connect(function(_, p110)
                if p110 == nil then
                    anchorPart.Anchored = true
                end
            end)
        end

        -- Listen for PetHatched to swap weld to the new pet's HRP
        local petHatchedConn
        local ok, StreamingHelper = pcall(function()
            return require(game.ReplicatedStorage:WaitForChild("Fsys")).load("new:StreamingHelper")
        end)
        if not ok then StreamingHelper = nil end
        _DL("Hatch: StreamingHelper=" .. tostring(StreamingHelper ~= nil))
        petHatchedConn = RouterClient.get_event("PetAPI/PetHatched").OnClientEvent:connect(function(p111, p112)
            task.spawn(function()
                local resolvedEgg, resolvedPet
                if StreamingHelper then
                    resolvedEgg, resolvedPet = StreamingHelper.await_many(5, p111, p112)
                else
                    resolvedEgg = typeof(p111) == "Instance" and p111 or nil
                    resolvedPet = typeof(p112) == "Instance" and p112 or nil
                end
                _DL("Hatch: PetHatched fired resolvedEgg=" .. tostring(resolvedEgg ~= nil) .. " resolvedPet=" .. tostring(resolvedPet ~= nil))
                if resolvedEgg and resolvedPet and resolvedEgg == hatchModel then
                    local newHRP = resolvedPet:FindFirstChild("HumanoidRootPart")
                    if newHRP then
                        weld.Part0 = newHRP
                        anchorPart.Anchored = false
                        _DL("Hatch: weld swapped to new pet HRP")
                    end
                end
            end)
        end)

        game:GetService("Debris"):AddItem(anchorPart, 15)

        -- Clone all 4 Hatch particles onto attachment
        local hatchFolder = game.ReplicatedStorage:WaitForChild("Resources", 10)
            :WaitForChild("Particles", 10)
            :WaitForChild("Hatch", 10)
        _DL("Hatch: hatchFolder found=" .. tostring(hatchFolder ~= nil))

        local att = Instance.new("Attachment")
        att.Parent = anchorPart
        local cloneCount = 0
        for _, v117 in pairs(hatchFolder:GetChildren()) do
            v117:clone().Parent = att
            cloneCount = cloneCount + 1
            _DL("Hatch: cloned " .. v117.Name)
        end
        _DL("Hatch: " .. cloneCount .. " emitters cloned, att has " .. #att:GetChildren())

        -- Preload first
        game:GetService("ContentProvider"):PreloadAsync({ att })
        _DL("Hatch: preload done — FIRING NOW")

        -- Real game: Enabled=true, wait(0.2), Enabled=false.
        -- Sparkles (Rate 500) works fine with just Enabled.
        -- Circles/Rays/Rings have low rates so we Emit 1s worth to ensure visibility.
        for _, v118 in pairs(att:GetChildren()) do
            if v118:IsA("ParticleEmitter") and v118.Rate < 100 then
                local emitCount = math.ceil(v118.Rate * 1)
                v118:Emit(emitCount)
                _DL("Hatch: Emit " .. v118.Name .. " x" .. emitCount)
            end
            v118.Enabled = true
        end
        wait(0.2)
        for _, v119 in pairs(att:GetChildren()) do
            v119.Enabled = false
        end
        game:GetService("Debris"):AddItem(att, 10)
        _DL("Hatch: particles fired and disabled")

        task.delay(10, function()
            petHatchedConn:Disconnect()
        end)

        wait(4)
        _DL("Hatch: 4s done, cleaning up egg model")

        if hatchModel and hatchModel.Parent then
            for _, p in ipairs(hatchModel:GetDescendants()) do
                if p:IsA("BasePart") then p.Transparency = 1 end
            end
            game:GetService("Debris"):AddItem(hatchModel, 1)
            hatchModel = nil
        end

        _DL("Hatch: effect complete")
        hatchDone = true
    end)
    -- Wait for effect to fully complete (real game waits the full 4s window)
    local waited = 0
    while not hatchDone and waited < 6 do task.wait(0.1); waited = waited + 0.1 end
    set_thread_identity(2)
    pcall(function()
        local currentInv = ClientData.get("inventory")
        if currentInv and currentInv.pets and currentInv.pets[uid] then
            local newPets = {}
            for k, v in pairs(currentInv.pets) do if k ~= uid then newPets[k] = v end end
            local newInv = {}
            for k, v in pairs(currentInv) do newInv[k] = v end
            newInv.pets = newPets
            ClientData.predict("inventory", newInv)
            DebugLog("Hatch: removed egg from inventory")
        end
    end)
    set_thread_identity(get_thread_identity and get_thread_identity() or 8)
    local petId = FindPetId(chosenName)
    if petId then
        local item = CreateInventoryItem(petId, "pets", {
            mega_neon = false, neon = false, flyable = false, rideable = false,
            age = 1, trick_level = 0, ailments_completed = 0,
            rp_name = "__no_name__", _hatched = true,
        })
        if item then
            item._hatched = true
            DebugLog("Hatch: spawned " .. chosenName)
            task.defer(function() pcall(function() EquipPet(item) end) end)
            hatchNowBtn.Text = "✓ Got " .. chosenName .. "!"
            hatchNowBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
        else
            DebugLog("Hatch: CreateInventoryItem failed for " .. chosenName)
            hatchNowBtn.Text = "❌ Spawn failed"
            hatchNowBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
        end
    else
        DebugLog("Hatch: FindPetId nil for '" .. chosenName .. "'")
        hatchNowBtn.Text = "❌ Pet not found"
        hatchNowBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
    end
    task.wait(2.5)
    _hatchBusy = false
    hatchNowBtn.Text = "🥚 Hatch Now"
    RefreshEggStatus()
end)

-- ── Divider ────────────────────────────────────────────────────────────────
local spawnAllEggsDivider = Instance.new("Frame")
spawnAllEggsDivider.Size = UDim2.new(1, 0, 0, 1)
spawnAllEggsDivider.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
spawnAllEggsDivider.BorderSizePixel = 0
spawnAllEggsDivider.Parent = miscPanel

-- ── Spawn All Eggs ─────────────────────────────────────────────────────────
local spawnAllEggsBtn = Instance.new("TextButton")
spawnAllEggsBtn.Size = UDim2.new(1, 0, 0, 26)
spawnAllEggsBtn.Text = "🥚 SPAWN ALL EGGS"
spawnAllEggsBtn.Font = Enum.Font.GothamBold
spawnAllEggsBtn.TextSize = 11
spawnAllEggsBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 20)
spawnAllEggsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnAllEggsBtn.BorderSizePixel = 0
spawnAllEggsBtn.Parent = miscPanel
Instance.new("UICorner", spawnAllEggsBtn).CornerRadius = UDim.new(0, 6)

local ALL_EGGS = {
    "christmas_egg", "farm_egg", "jungle_egg", "aussie_egg",
    "fossil_egg", "ocean_egg", "safari_egg", "woodland_egg",
}

spawnAllEggsBtn.MouseButton1Click:Connect(function()
    spawnAllEggsBtn.Text = "⏳ Spawning..."
    spawnAllEggsBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 10)
    local count = 0
    for _, eggKind in ipairs(ALL_EGGS) do
        local item = CreateInventoryItem(eggKind, "pets", { rp_name = "__no_name__" })
        if item then
            count = count + 1
            DebugLog("Spawned egg: " .. eggKind)
        else
            DebugLog("WARN: egg not found in KindDB: " .. eggKind)
        end
    end
    spawnAllEggsBtn.Text = "✓ Spawned " .. count .. " eggs!"
    spawnAllEggsBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
    task.wait(2)
    spawnAllEggsBtn.Text = "🥚 SPAWN ALL EGGS"
    spawnAllEggsBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 20)
end)

-- ── Fake Inventory ─────────────────────────────────────────────────────────
local fakeInvDivider = Instance.new("Frame")
fakeInvDivider.Size = UDim2.new(1, 0, 0, 1)
fakeInvDivider.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
fakeInvDivider.BorderSizePixel = 0
fakeInvDivider.Parent = miscPanel

local fakeInvTitle = Instance.new("TextLabel")
fakeInvTitle.Size = UDim2.new(1, 0, 0, 14)
fakeInvTitle.BackgroundTransparency = 1
fakeInvTitle.Text = "🎒 Fake Inventory"
fakeInvTitle.Font = Enum.Font.GothamBold
fakeInvTitle.TextSize = 11
fakeInvTitle.TextColor3 = Color3.fromRGB(235, 240, 255)
fakeInvTitle.TextXAlignment = Enum.TextXAlignment.Left
fakeInvTitle.Parent = miscPanel

local fakeInvDesc = Instance.new("TextLabel")
fakeInvDesc.Size = UDim2.new(1, 0, 0, 20)
fakeInvDesc.BackgroundTransparency = 1
fakeInvDesc.Text = "Spawns 5–10 random items in each non-pet category"
fakeInvDesc.Font = Enum.Font.Gotham
fakeInvDesc.TextSize = 8
fakeInvDesc.TextColor3 = Color3.fromRGB(160, 170, 200)
fakeInvDesc.TextXAlignment = Enum.TextXAlignment.Left
fakeInvDesc.TextWrapped = true
fakeInvDesc.Parent = miscPanel

local fakeInvBtn = Instance.new("TextButton")
fakeInvBtn.Size = UDim2.new(1, 0, 0, 26)
fakeInvBtn.Text = "🎲 SPAWN FAKE INVENTORY"
fakeInvBtn.Font = Enum.Font.GothamBold
fakeInvBtn.TextSize = 11
fakeInvBtn.BackgroundColor3 = Color3.fromRGB(90, 50, 160)
fakeInvBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fakeInvBtn.BorderSizePixel = 0
fakeInvBtn.Parent = miscPanel
Instance.new("UICorner", fakeInvBtn).CornerRadius = UDim.new(0, 6)

-- Category name in InventoryDB  →  category string passed to CreateInventoryItem
local FAKE_INV_CATEGORIES = {
    { db = "toys",            category = "toys"            },
    { db = "food",            category = "food"            },
    { db = "gifts",           category = "gifts"           },
    { db = "roleplay",        category = "roleplay"        },
    { db = "stickers",        category = "stickers"        },
    { db = "strollers",       category = "strollers"       },
    { db = "transport",       category = "transport"       },
    { db = "pet_accessories", category = "pet_accessories" },
}

fakeInvBtn.MouseButton1Click:Connect(function()
    fakeInvBtn.Text = "⏳ Spawning..."
    fakeInvBtn.BackgroundColor3 = Color3.fromRGB(55, 30, 100)

    local totalSpawned = 0
    local totalFailed  = 0

    for _, catInfo in ipairs(FAKE_INV_CATEGORIES) do
        local dbTable = InventoryDB[catInfo.db]
        if not dbTable then
            DebugLog("FakeInv: InventoryDB." .. catInfo.db .. " not found, skipping")
            continue
        end

        -- Collect all valid kind keys for this category
        local kindKeys = {}
        for kind, _ in pairs(dbTable) do
            table.insert(kindKeys, kind)
        end

        if #kindKeys == 0 then
            DebugLog("FakeInv: no entries in " .. catInfo.db .. ", skipping")
            continue
        end

        -- Pick a random count between 5 and 10
        local count = math.random(5, 10)
        local spawned = 0

        for _ = 1, count do
            local kind = kindKeys[math.random(1, #kindKeys)]
            local ok, item = pcall(CreateInventoryItem, kind, catInfo.category, {})
            if ok and item then
                spawned   = spawned   + 1
                totalSpawned = totalSpawned + 1
                DebugLog("FakeInv: spawned " .. kind .. " [" .. catInfo.category .. "]")
            else
                totalFailed = totalFailed + 1
                DebugLog("FakeInv: FAILED " .. tostring(kind) .. " — " .. tostring(item))
            end
        end

        DebugLog("FakeInv: " .. catInfo.db .. " → " .. spawned .. "/" .. count .. " spawned")
    end

    fakeInvBtn.Text = "✓ " .. totalSpawned .. " items spawned!" .. (totalFailed > 0 and (" (" .. totalFailed .. " failed)") or "")
    fakeInvBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
    task.wait(3)
    fakeInvBtn.Text = "🎲 SPAWN FAKE INVENTORY"
    fakeInvBtn.BackgroundColor3 = Color3.fromRGB(90, 50, 160)
end)

-- =============== CUSTOM PET ADDER ===============

-- Registry of fake kind IDs we injected into InventoryDB so we can clean up
-- fakeKind → true
local _injectedFakeKinds = {}

-- Inject a fake InventoryDB + KindDB entry for a custom pet.
-- Returns the fake kind string used, or nil on failure.
local function InjectFakeKind(opts)
    -- opts = {
    --   base_kind      : string  -- real pet kind to copy data from  (e.g. "shadow_dragon")
    --   custom_name    : string  -- name shown in backpack type label (e.g. "Rainbow Dragon")
    --   image_kind     : string? -- real pet kind whose image to steal (optional)
    --   image_asset    : string? -- rbxassetid number string            (optional)
    --   image_as_model : bool?   -- if true, equip shows image billboard instead of 3D model
    -- }
    local baseEntry = InventoryDB.pets[opts.base_kind]
    if not baseEntry then
        DebugLog("InjectFakeKind: base kind not found: " .. tostring(opts.base_kind))
        return nil
    end

    -- Build a unique fake kind key that won't collide
    local fakeKind = "_cp_" .. opts.custom_name:lower():gsub("[^%w]", "_") .. "_" .. tostring(math.random(100000, 999999))

    -- Deep-copy the base InventoryDB entry, override name + image
    local fakeEntry = {}
    for k, v in pairs(baseEntry) do fakeEntry[k] = v end
    fakeEntry.name           = opts.custom_name
    fakeEntry.kind           = fakeKind
    fakeEntry._base_kind     = opts.base_kind  -- used by EquipPet for pet_id + animations
    fakeEntry._image_as_model = opts.image_as_model or false

    -- Resolve image.
    -- ItemImage reads entry.image_large FIRST on desktop, falling back to entry.image.
    -- We must set BOTH fields, otherwise the base pet's image_large silently wins.
    if opts.image_asset and opts.image_asset ~= "" then
        -- rbxassetid:// only works for Image assets, not Decals/Meshes etc.
        -- rbxthumb works universally for any asset type including Decals.
        local url = "rbxthumb://type=Asset&id=" .. opts.image_asset .. "&w=420&h=420"
        fakeEntry.image       = url
        fakeEntry.image_large = url
    elseif opts.image_kind and opts.image_kind ~= "" then
        local imgEntry = InventoryDB.pets[opts.image_kind]
        if imgEntry then
            fakeEntry.image       = imgEntry.image       or fakeEntry.image
            fakeEntry.image_large = imgEntry.image_large or imgEntry.image or fakeEntry.image
            if imgEntry.model then fakeEntry.model = imgEntry.model end
        end
    else
        -- No override — keep base images but ensure image_large is in sync
        fakeEntry.image_large = fakeEntry.image_large or fakeEntry.image
    end

    -- Store the resolved image URL for the image-as-model billboard
    fakeEntry._image_url = fakeEntry.image or ""

    -- Inject into InventoryDB.pets (live table, BackpackApp reads it directly)
    local identity = get_thread_identity and get_thread_identity() or 8
    set_thread_identity(2)
    InventoryDB.pets[fakeKind] = fakeEntry
    -- Also inject into KindDB so CreateInventoryItem can find it
    local kindEntry = {}
    if KindDB[opts.base_kind] then
        for k, v in pairs(KindDB[opts.base_kind]) do kindEntry[k] = v end
    end
    kindEntry.kind  = fakeKind
    kindEntry.name  = opts.custom_name
    if fakeEntry.model then kindEntry.model = fakeEntry.model end
    KindDB[fakeKind] = kindEntry
    set_thread_identity(identity)

    _injectedFakeKinds[fakeKind] = opts.base_kind  -- store base kind for model redirect
    DebugLog("InjectFakeKind: injected '" .. fakeKind .. "' name='" .. opts.custom_name .. "' image=" .. tostring(fakeEntry.image))
    return fakeKind
end

-- Hook DownloadClient so that when a fake kind's model is requested
-- (e.g. on equip), it transparently downloads the base pet's model instead.
do
    local _origDownload = DownloadClient.promise_download_copy
    DownloadClient.promise_download_copy = function(folder, kindArg, ...)
        if folder == "Pets" and type(kindArg) == "string" then
            local baseKind = _injectedFakeKinds[kindArg]
            if baseKind and type(baseKind) == "string" then
                DebugLog("DownloadClient redirect: " .. kindArg .. " → " .. baseKind)
                return _origDownload(folder, baseKind, ...)
            end
        end
        return _origDownload(folder, kindArg, ...)
    end
end

-- ── Custom Pet Creator UI ───────────────────────────────────────────────────
local customPetDivider = Instance.new("Frame")
customPetDivider.Size = UDim2.new(1, 0, 0, 1)
customPetDivider.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
customPetDivider.BorderSizePixel = 0
customPetDivider.Parent = miscPanel

local customPetTitle = Instance.new("TextLabel")
customPetTitle.Size = UDim2.new(1, 0, 0, 14)
customPetTitle.BackgroundTransparency = 1
customPetTitle.Text = "🐾 Custom Pet Creator"
customPetTitle.Font = Enum.Font.GothamBold
customPetTitle.TextSize = 11
customPetTitle.TextColor3 = Color3.fromRGB(235, 240, 255)
customPetTitle.TextXAlignment = Enum.TextXAlignment.Left
customPetTitle.Parent = miscPanel

local customPetDesc = Instance.new("TextLabel")
customPetDesc.Size = UDim2.new(1, 0, 0, 20)
customPetDesc.BackgroundTransparency = 1
customPetDesc.Text = "Creates a pet with a fully custom name + backpack icon, injected directly into InventoryDB"
customPetDesc.Font = Enum.Font.Gotham
customPetDesc.TextSize = 8
customPetDesc.TextColor3 = Color3.fromRGB(160, 170, 200)
customPetDesc.TextXAlignment = Enum.TextXAlignment.Left
customPetDesc.TextWrapped = true
customPetDesc.Parent = miscPanel

-- ── Base Pet ──────────────────────────────────────────────────────────────
local cpBaseLabel = Instance.new("TextLabel")
cpBaseLabel.Size = UDim2.new(1, 0, 0, 11)
cpBaseLabel.BackgroundTransparency = 1
cpBaseLabel.Text = "Base Pet  (stats, model, rarity copied from this)"
cpBaseLabel.Font = Enum.Font.Gotham
cpBaseLabel.TextSize = 9
cpBaseLabel.TextColor3 = Color3.fromRGB(180, 185, 210)
cpBaseLabel.TextXAlignment = Enum.TextXAlignment.Left
cpBaseLabel.Parent = miscPanel

local cpBaseInput = Instance.new("TextBox")
cpBaseInput.Size = UDim2.new(1, 0, 0, 22)
cpBaseInput.BackgroundColor3 = Color3.fromRGB(30, 33, 52)
cpBaseInput.BorderSizePixel = 0
cpBaseInput.Text = ""
cpBaseInput.PlaceholderText = "e.g.  Shadow Dragon"
cpBaseInput.Font = Enum.Font.Gotham
cpBaseInput.TextSize = 10
cpBaseInput.TextColor3 = Color3.fromRGB(220, 225, 255)
cpBaseInput.PlaceholderColor3 = Color3.fromRGB(100, 105, 140)
cpBaseInput.ClearTextOnFocus = false
cpBaseInput.Parent = miscPanel
Instance.new("UICorner", cpBaseInput).CornerRadius = UDim.new(0, 5)
local cpBaseStroke = Instance.new("UIStroke", cpBaseInput)
cpBaseStroke.Color = Color3.fromRGB(80, 80, 130)
cpBaseStroke.Thickness = 1

-- ── Custom Name (shown as TYPE name in backpack, not just nickname) ────────
local cpCNameLabel = Instance.new("TextLabel")
cpCNameLabel.Size = UDim2.new(1, 0, 0, 11)
cpCNameLabel.BackgroundTransparency = 1
cpCNameLabel.Text = "Custom Name  (replaces type label in backpack)"
cpCNameLabel.Font = Enum.Font.Gotham
cpCNameLabel.TextSize = 9
cpCNameLabel.TextColor3 = Color3.fromRGB(180, 185, 210)
cpCNameLabel.TextXAlignment = Enum.TextXAlignment.Left
cpCNameLabel.Parent = miscPanel

local cpCNameInput = Instance.new("TextBox")
cpCNameInput.Size = UDim2.new(1, 0, 0, 22)
cpCNameInput.BackgroundColor3 = Color3.fromRGB(30, 33, 52)
cpCNameInput.BorderSizePixel = 0
cpCNameInput.Text = ""
cpCNameInput.PlaceholderText = "e.g.  Rainbow Galaxy Dragon"
cpCNameInput.Font = Enum.Font.Gotham
cpCNameInput.TextSize = 10
cpCNameInput.TextColor3 = Color3.fromRGB(220, 225, 255)
cpCNameInput.PlaceholderColor3 = Color3.fromRGB(100, 105, 140)
cpCNameInput.ClearTextOnFocus = false
cpCNameInput.Parent = miscPanel
Instance.new("UICorner", cpCNameInput).CornerRadius = UDim.new(0, 5)
local cpCNameStroke = Instance.new("UIStroke", cpCNameInput)
cpCNameStroke.Color = Color3.fromRGB(80, 80, 130)
cpCNameStroke.Thickness = 1

-- ── Nickname (rp_name — the small subtitle, optional) ────────────────────
local cpNickLabel = Instance.new("TextLabel")
cpNickLabel.Size = UDim2.new(1, 0, 0, 11)
cpNickLabel.BackgroundTransparency = 1
cpNickLabel.Text = "Nickname  (optional — blank = auto-generated)"
cpNickLabel.Font = Enum.Font.Gotham
cpNickLabel.TextSize = 9
cpNickLabel.TextColor3 = Color3.fromRGB(180, 185, 210)
cpNickLabel.TextXAlignment = Enum.TextXAlignment.Left
cpNickLabel.Parent = miscPanel

local cpNickInput = Instance.new("TextBox")
cpNickInput.Size = UDim2.new(1, 0, 0, 22)
cpNickInput.BackgroundColor3 = Color3.fromRGB(30, 33, 52)
cpNickInput.BorderSizePixel = 0
cpNickInput.Text = ""
cpNickInput.PlaceholderText = "e.g.  Sparky"
cpNickInput.Font = Enum.Font.Gotham
cpNickInput.TextSize = 10
cpNickInput.TextColor3 = Color3.fromRGB(220, 225, 255)
cpNickInput.PlaceholderColor3 = Color3.fromRGB(100, 105, 140)
cpNickInput.ClearTextOnFocus = false
cpNickInput.Parent = miscPanel
Instance.new("UICorner", cpNickInput).CornerRadius = UDim.new(0, 5)
local cpNickStroke = Instance.new("UIStroke", cpNickInput)
cpNickStroke.Color = Color3.fromRGB(80, 80, 130)
cpNickStroke.Thickness = 1

-- ── Flags ─────────────────────────────────────────────────────────────────
local cpFlagLabel = Instance.new("TextLabel")
cpFlagLabel.Size = UDim2.new(1, 0, 0, 11)
cpFlagLabel.BackgroundTransparency = 1
cpFlagLabel.Text = "✨ Pet Flags"
cpFlagLabel.Font = Enum.Font.Gotham
cpFlagLabel.TextSize = 9
cpFlagLabel.TextColor3 = Color3.fromRGB(180, 185, 210)
cpFlagLabel.TextXAlignment = Enum.TextXAlignment.Left
cpFlagLabel.Parent = miscPanel

local cpFlagGrid = Instance.new("Frame")
cpFlagGrid.Size = UDim2.new(1, 0, 0, 24)
cpFlagGrid.BackgroundTransparency = 1
cpFlagGrid.Parent = miscPanel

local cpFlagColors = {M=Color3.fromRGB(170,0,255), N=Color3.fromRGB(0,255,100), F=Color3.fromRGB(0,200,255), R=Color3.fromRGB(255,50,150)}
local cpFlagOrder = {"M","N","F","R"}
local cpFlagState = {M=false, N=false, F=true, R=true}

for i, flag in ipairs(cpFlagOrder) do
    local fb = Instance.new("TextButton")
    fb.Size = UDim2.new(0.23, -2, 1, 0)
    fb.Position = UDim2.new((i-1)*0.25, i>1 and 3 or 0, 0, 0)
    fb.Text = flag
    fb.BackgroundColor3 = cpFlagState[flag] and cpFlagColors[flag] or Color3.fromRGB(40,44,66)
    fb.Font = Enum.Font.GothamBold
    fb.TextColor3 = Color3.fromRGB(255,255,255)
    fb.TextSize = 12
    fb.Parent = cpFlagGrid
    local fc = Instance.new("UICorner", fb); fc.CornerRadius = UDim.new(0,8)
    local fs = Instance.new("UIStroke", fb)
    fs.Color = cpFlagColors[flag]
    fs.Thickness = cpFlagState[flag] and 2.5 or 1.5
    fs.Transparency = cpFlagState[flag] and 0.2 or 0.5
    fb.MouseButton1Click:Connect(function()
        if flag == "M" and cpFlagState["N"] then return end
        if flag == "N" and cpFlagState["M"] then return end
        cpFlagState[flag] = not cpFlagState[flag]
        fb.BackgroundColor3 = cpFlagState[flag] and cpFlagColors[flag] or Color3.fromRGB(40,44,66)
        TweenService:Create(fs, TweenInfo.new(0.2), {
            Thickness = cpFlagState[flag] and 2.5 or 1.5,
            Transparency = cpFlagState[flag] and 0.2 or 0.5
        }):Play()
    end)
end

-- ── Image override ────────────────────────────────────────────────────────
-- The image field in InventoryDB is what the backpack renders as the icon.
-- We support two override modes:
--   "pet"   → steal the rbxassetid image from another pet's InventoryDB entry
--   "asset" → paste a raw Roblox asset ID directly as rbxassetid://XXXX

local cpImgLabel = Instance.new("TextLabel")
cpImgLabel.Size = UDim2.new(1, 0, 0, 11)
cpImgLabel.BackgroundTransparency = 1
cpImgLabel.Text = "🖼  Backpack Icon Override"
cpImgLabel.Font = Enum.Font.Gotham
cpImgLabel.TextSize = 9
cpImgLabel.TextColor3 = Color3.fromRGB(180, 185, 210)
cpImgLabel.TextXAlignment = Enum.TextXAlignment.Left
cpImgLabel.Parent = miscPanel

local cpImgModeRow = Instance.new("Frame")
cpImgModeRow.Size = UDim2.new(1, 0, 0, 22)
cpImgModeRow.BackgroundTransparency = 1
cpImgModeRow.Parent = miscPanel

local cpImgModeState = "none"

local function makeModeBtn(label, xScale, xOff)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.32, -2, 1, 0)
    b.Position = UDim2.new(xScale, xOff, 0, 0)
    b.Text = label
    b.Font = Enum.Font.GothamBold
    b.TextSize = 9
    b.BackgroundColor3 = Color3.fromRGB(40,44,66)
    b.TextColor3 = Color3.fromRGB(200,200,255)
    b.BorderSizePixel = 0
    b.Parent = cpImgModeRow
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
    return b
end
local cpImgModeNone  = makeModeBtn("None",     0,    0)
local cpImgModePet   = makeModeBtn("Pet Icon", 0.34, 2)
local cpImgModeAsset = makeModeBtn("Asset ID", 0.67, 2)
cpImgModeNone.BackgroundColor3 = Color3.fromRGB(60,80,60)

local function makeCpInput(placeholder)
    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, 0, 0, 22)
    tb.BackgroundColor3 = Color3.fromRGB(30, 33, 52)
    tb.BorderSizePixel = 0
    tb.Text = ""
    tb.PlaceholderText = placeholder
    tb.Font = Enum.Font.Gotham
    tb.TextSize = 10
    tb.TextColor3 = Color3.fromRGB(220, 225, 255)
    tb.PlaceholderColor3 = Color3.fromRGB(100, 105, 140)
    tb.ClearTextOnFocus = false
    tb.Visible = false
    tb.Parent = miscPanel
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 5)
    local s = Instance.new("UIStroke", tb)
    s.Color = Color3.fromRGB(80, 80, 130); s.Thickness = 1
    return tb
end

local cpImgPetInput   = makeCpInput("Pet whose icon to copy  (e.g.  Frost Dragon)")
local cpImgAssetInput = makeCpInput("Asset or Decal ID  (numbers only, e.g.  44096722)")

local function setCpImgMode(mode)
    cpImgModeState = mode
    cpImgModeNone.BackgroundColor3  = mode=="none"  and Color3.fromRGB(60,80,60)  or Color3.fromRGB(40,44,66)
    cpImgModePet.BackgroundColor3   = mode=="pet"   and Color3.fromRGB(60,60,110) or Color3.fromRGB(40,44,66)
    cpImgModeAsset.BackgroundColor3 = mode=="asset" and Color3.fromRGB(90,60,20)  or Color3.fromRGB(40,44,66)
    cpImgPetInput.Visible   = mode == "pet"
    cpImgAssetInput.Visible = mode == "asset"
end
cpImgModeNone.MouseButton1Click:Connect(function()  setCpImgMode("none")  end)
cpImgModePet.MouseButton1Click:Connect(function()   setCpImgMode("pet")   end)
cpImgModeAsset.MouseButton1Click:Connect(function() setCpImgMode("asset") end)

-- ── Image-as-Model toggle ─────────────────────────────────────────────────
-- When ON: equipping the pet shows the image as a 2D billboard that follows
-- you, instead of downloading the base pet's 3D model.
local cpImageAsModelEnabled = false

local cpImgModelRow = Instance.new("Frame")
cpImgModelRow.Size = UDim2.new(1, 0, 0, 22)
cpImgModelRow.BackgroundTransparency = 1
cpImgModelRow.Parent = miscPanel

local cpImgModelToggle = Instance.new("TextButton")
cpImgModelToggle.Size = UDim2.new(0.62, -2, 1, 0)
cpImgModelToggle.Position = UDim2.new(0, 0, 0, 0)
cpImgModelToggle.Text = "🖼 Use Image as Pet Model: OFF"
cpImgModelToggle.Font = Enum.Font.GothamBold
cpImgModelToggle.TextSize = 9
cpImgModelToggle.BackgroundColor3 = Color3.fromRGB(40, 44, 66)
cpImgModelToggle.TextColor3 = Color3.fromRGB(180, 180, 220)
cpImgModelToggle.BorderSizePixel = 0
cpImgModelToggle.Parent = cpImgModelRow
Instance.new("UICorner", cpImgModelToggle).CornerRadius = UDim.new(0, 5)

local cpImgModelHint = Instance.new("TextLabel")
cpImgModelHint.Size = UDim2.new(0.37, 0, 1, 0)
cpImgModelHint.Position = UDim2.new(0.63, 2, 0, 0)
cpImgModelHint.BackgroundTransparency = 1
cpImgModelHint.Text = "requires icon set"
cpImgModelHint.Font = Enum.Font.Gotham
cpImgModelHint.TextSize = 8
cpImgModelHint.TextColor3 = Color3.fromRGB(120, 120, 160)
cpImgModelHint.TextWrapped = true
cpImgModelHint.Parent = cpImgModelRow

cpImgModelToggle.MouseButton1Click:Connect(function()
    cpImageAsModelEnabled = not cpImageAsModelEnabled
    if cpImageAsModelEnabled then
        cpImgModelToggle.Text = "🖼 Use Image as Pet Model: ON"
        cpImgModelToggle.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
        cpImgModelToggle.TextColor3 = Color3.fromRGB(120, 255, 150)
    else
        cpImgModelToggle.Text = "🖼 Use Image as Pet Model: OFF"
        cpImgModelToggle.BackgroundColor3 = Color3.fromRGB(40, 44, 66)
        cpImgModelToggle.TextColor3 = Color3.fromRGB(180, 180, 220)
    end
end)

-- ── Status label ─────────────────────────────────────────────────────────
local cpStatusLabel = Instance.new("TextLabel")
cpStatusLabel.Size = UDim2.new(1, 0, 0, 14)
cpStatusLabel.BackgroundTransparency = 1
cpStatusLabel.Text = ""
cpStatusLabel.Font = Enum.Font.Gotham
cpStatusLabel.TextSize = 9
cpStatusLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
cpStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
cpStatusLabel.TextWrapped = true
cpStatusLabel.Parent = miscPanel

-- ── Spawn button ──────────────────────────────────────────────────────────
local cpSpawnBtn = Instance.new("TextButton")
cpSpawnBtn.Size = UDim2.new(1, 0, 0, 27)
cpSpawnBtn.Text = "🐾 CREATE & SPAWN PET"
cpSpawnBtn.Font = Enum.Font.GothamBold
cpSpawnBtn.TextSize = 11
cpSpawnBtn.BackgroundColor3 = Color3.fromRGB(40, 130, 80)
cpSpawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
cpSpawnBtn.BorderSizePixel = 0
cpSpawnBtn.Parent = miscPanel
Instance.new("UICorner", cpSpawnBtn).CornerRadius = UDim.new(0, 6)
local cpSpawnStroke = Instance.new("UIStroke", cpSpawnBtn)
cpSpawnStroke.Color = Color3.fromRGB(80, 220, 140)
cpSpawnStroke.Thickness = 1.5
cpSpawnStroke.Transparency = 0.4

-- Live validation colouring on base pet input
cpBaseInput:GetPropertyChangedSignal("Text"):Connect(function()
    local t = cpBaseInput.Text
    if t == "" then cpBaseStroke.Color = Color3.fromRGB(80,80,130); return end
    cpBaseStroke.Color = FindPetId(t) and Color3.fromRGB(60,200,100) or Color3.fromRGB(220,60,60)
end)

cpSpawnBtn.MouseButton1Click:Connect(function()
    cpStatusLabel.Text = ""

    -- ── 1. Validate base pet ──────────────────────────────────────────────
    local baseName = cpBaseInput.Text:match("^%s*(.-)%s*$")
    if baseName == "" then
        cpStatusLabel.Text = "⚠ Enter a base pet name"
        cpStatusLabel.TextColor3 = Color3.fromRGB(255,180,80)
        return
    end
    local baseKind = FindPetId(baseName)
    if not baseKind then
        cpStatusLabel.Text = "⚠ Base pet not found: " .. baseName
        cpStatusLabel.TextColor3 = Color3.fromRGB(255,120,120)
        return
    end

    -- ── 2. Validate custom name ───────────────────────────────────────────
    local customName = cpCNameInput.Text:match("^%s*(.-)%s*$")
    if customName == "" then
        cpStatusLabel.Text = "⚠ Enter a custom name"
        cpStatusLabel.TextColor3 = Color3.fromRGB(255,180,80)
        return
    end

    -- ── 3. Validate image override ────────────────────────────────────────
    local imgKind, imgAsset = nil, nil
    if cpImgModeState == "pet" then
        local pname = cpImgPetInput.Text:match("^%s*(.-)%s*$")
        if pname ~= "" then
            imgKind = FindPetId(pname)
            if not imgKind then
                cpStatusLabel.Text = "⚠ Icon pet not found: " .. pname
                cpStatusLabel.TextColor3 = Color3.fromRGB(255,120,120)
                return
            end
        end
    elseif cpImgModeState == "asset" then
        local raw = cpImgAssetInput.Text:match("^%s*(.-)%s*$")
        if raw ~= "" then
            -- Strip common URL prefixes people might paste
            raw = raw:match("rbxassetid://(%d+)") or raw:match("id=(%d+)") or raw
            if not tonumber(raw) then
                cpStatusLabel.Text = "⚠ Asset ID must be a number"
                cpStatusLabel.TextColor3 = Color3.fromRGB(255,120,120)
                return
            end
            imgAsset = raw
        end
    end

    -- ── 4. Inject fake InventoryDB + KindDB entry ─────────────────────────
    -- Validate image-as-model requires an image to be set
    if cpImageAsModelEnabled and cpImgModeState == "none" then
        cpStatusLabel.Text = "⚠ Image-as-Model requires an icon override to be set"
        cpStatusLabel.TextColor3 = Color3.fromRGB(255, 180, 80)
        return
    end

    cpSpawnBtn.Text = "⏳ Injecting..."
    cpSpawnBtn.BackgroundColor3 = Color3.fromRGB(30,80,50)

    local fakeKind = InjectFakeKind({
        base_kind      = baseKind,
        custom_name    = customName,
        image_kind     = imgKind,
        image_asset    = imgAsset,
        image_as_model = cpImageAsModelEnabled,
    })

    if not fakeKind then
        cpStatusLabel.Text = "✗ Injection failed — check DebugLog"
        cpStatusLabel.TextColor3 = Color3.fromRGB(255,80,80)
        cpSpawnBtn.Text = "✗ FAILED"
        cpSpawnBtn.BackgroundColor3 = Color3.fromRGB(140,30,30)
        task.wait(2)
        cpSpawnBtn.Text = "🐾 CREATE & SPAWN PET"
        cpSpawnBtn.BackgroundColor3 = Color3.fromRGB(40,130,80)
        return
    end

    -- ── 5. Build pet properties ───────────────────────────────────────────
    local nickname = cpNickInput.Text:match("^%s*(.-)%s*$")
    local options = {
        mega_neon          = cpFlagState["M"],
        neon               = cpFlagState["N"],
        flyable            = cpFlagState["F"],
        rideable           = cpFlagState["R"],
        age                = 6,
        trick_level        = 5,
        ailments_completed = 0,
        rp_name            = nickname ~= "" and nickname or GenerateUniquePetName(fakeKind),
    }

    -- ── 6. Spawn using the fake kind (InventoryDB + KindDB now has it) ────
    cpSpawnBtn.Text = "⏳ Spawning..."
    local ok, item = pcall(CreateInventoryItem, fakeKind, "pets", options)

    if ok and item then
        DebugLog("CustomPet: spawned fakeKind='" .. fakeKind .. "' name='" .. customName .. "' unique=" .. item.unique)
        cpStatusLabel.Text = "✓ Spawned: " .. customName .. (nickname ~= "" and (" (" .. nickname .. ")") or "")
        cpStatusLabel.TextColor3 = Color3.fromRGB(80, 220, 120)
        cpSpawnBtn.Text = "✓ SPAWNED!"
        cpSpawnBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
    else
        -- Rollback: remove the fake kind we just injected since spawn failed
        local identity2 = get_thread_identity and get_thread_identity() or 8
        set_thread_identity(2)
        InventoryDB.pets[fakeKind] = nil
        KindDB[fakeKind] = nil
        set_thread_identity(identity2)
        _injectedFakeKinds[fakeKind] = nil
        DebugLog("CustomPet: spawn FAILED — " .. tostring(item))
        cpStatusLabel.Text = "✗ Spawn failed — check DebugLog"
        cpStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        cpSpawnBtn.Text = "✗ FAILED"
        cpSpawnBtn.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
    end

    task.wait(2)
    cpSpawnBtn.Text = "🐾 CREATE & SPAWN PET"
    cpSpawnBtn.BackgroundColor3 = Color3.fromRGB(40, 130, 80)
end)

-- =============== END MISC PANEL ===============


-- =============== PAINT (merged into Misc) ===============
local paintDivider = Instance.new("Frame")
paintDivider.Size = UDim2.new(1, 0, 0, 1)
paintDivider.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
paintDivider.BorderSizePixel = 0
paintDivider.Parent = miscPanel

local paintSectionTitle = Instance.new("TextLabel")
paintSectionTitle.Size = UDim2.new(1, 0, 0, 16)
paintSectionTitle.BackgroundTransparency = 1
paintSectionTitle.Text = "\xF0\x9F\x8E\xA8 Recolor Pets"
paintSectionTitle.Font = Enum.Font.GothamBold
paintSectionTitle.TextSize = 11
paintSectionTitle.TextColor3 = Color3.fromRGB(235, 240, 255)
paintSectionTitle.TextXAlignment = Enum.TextXAlignment.Left
paintSectionTitle.Parent = miscPanel

local paintTitle = Instance.new("TextLabel")
paintTitle.Size = UDim2.new(1, 0, 0, 16)
paintTitle.BackgroundTransparency = 1
paintTitle.Text = "🎨 Recolor Pets"
paintTitle.Font = Enum.Font.GothamBold
paintTitle.TextSize = 11
paintTitle.TextColor3 = Color3.fromRGB(235, 240, 255)
paintTitle.TextXAlignment = Enum.TextXAlignment.Left
paintTitle.Parent = miscPanel

-- Pet list scroll
local paintPetScroll = Instance.new("ScrollingFrame")
paintPetScroll.Size = UDim2.new(1, 0, 0, 100)
paintPetScroll.BackgroundColor3 = Color3.fromRGB(25, 28, 45)
paintPetScroll.BorderSizePixel = 0
paintPetScroll.ScrollBarThickness = 3
paintPetScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
paintPetScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
paintPetScroll.Parent = miscPanel
Instance.new("UICorner", paintPetScroll).CornerRadius = UDim.new(0, 6)
local paintPetList = Instance.new("UIListLayout")
paintPetList.SortOrder = Enum.SortOrder.LayoutOrder
paintPetList.Padding = UDim.new(0, 2)
paintPetList.Parent = paintPetScroll

-- Color group label
local paintGroupLabel = Instance.new("TextLabel")
paintGroupLabel.Size = UDim2.new(1, 0, 0, 13)
paintGroupLabel.BackgroundTransparency = 1
paintGroupLabel.Text = "Select a pet above, then pick a color group:"
paintGroupLabel.Font = Enum.Font.Gotham
paintGroupLabel.TextSize = 9
paintGroupLabel.TextColor3 = Color3.fromRGB(160, 170, 200)
paintGroupLabel.TextXAlignment = Enum.TextXAlignment.Left
paintGroupLabel.Parent = miscPanel

-- Color group buttons row
local paintGroupRow = Instance.new("Frame")
paintGroupRow.Size = UDim2.new(1, 0, 0, 24)
paintGroupRow.BackgroundTransparency = 1
paintGroupRow.Parent = miscPanel
local paintGroupList = Instance.new("UIListLayout")
paintGroupList.FillDirection = Enum.FillDirection.Horizontal
paintGroupList.Padding = UDim.new(0, 3)
paintGroupList.Parent = paintGroupRow

-- Color picker scroll
local paintColorScroll = Instance.new("ScrollingFrame")
paintColorScroll.Size = UDim2.new(1, 0, 0, 200)
paintColorScroll.BackgroundColor3 = Color3.fromRGB(25, 28, 45)
paintColorScroll.BorderSizePixel = 0
paintColorScroll.ScrollBarThickness = 3
paintColorScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
paintColorScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
paintColorScroll.Parent = miscPanel
Instance.new("UICorner", paintColorScroll).CornerRadius = UDim.new(0, 6)
local paintColorGrid = Instance.new("UIGridLayout")
paintColorGrid.CellSize = UDim2.new(0, 28, 0, 28)
paintColorGrid.CellPadding = UDim2.new(0, 3, 0, 3)
paintColorGrid.Parent = paintColorScroll

-- State
local paintSelectedPet = nil   -- unique id
local paintSelectedGroup = nil  -- index into sorted colors

local function PaintRefreshColorGrid()
    for _, c in ipairs(paintColorScroll:GetChildren()) do
        if c:IsA("Frame") or c:IsA("ImageButton") or c:IsA("TextButton") then c:Destroy() end
    end
    if not paintSelectedPet or not paintSelectedGroup then return end
    local petData = SpawnedPets[paintSelectedPet]
    if not petData or not petData.model then return end

    -- Build sorted colors for this model
    local sortedColors = pcall and (function()
        local ok, sc = pcall(PetColorHelper.get_sorted_color_data, petData.model)
        return ok and sc or {}
    end)() or {}

    -- All paints from PaintColorDB
    local paints = {}
    for _, p in pairs(PaintColorDB) do
        if not p.gradient then table.insert(paints, p) end
    end
    table.sort(paints, function(a, b) return a.name < b.name end)

    for _, paint in ipairs(paints) do
        local swatch = Instance.new("TextButton")
        swatch.Size = UDim2.new(0, 28, 0, 28)
        swatch.BackgroundColor3 = paint.color
        swatch.Text = ""
        swatch.BorderSizePixel = 0
        swatch.Parent = paintColorScroll
        Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 5)
        local tip = Instance.new("TextLabel")
        tip.Size = UDim2.new(1, 0, 0, 9)
        tip.Position = UDim2.new(0, 0, 1, 1)
        tip.BackgroundTransparency = 1
        tip.Text = paint.name:sub(1, 8)
        tip.Font = Enum.Font.Gotham
        tip.TextSize = 6
        tip.TextColor3 = Color3.fromRGB(200, 210, 240)
        tip.TextTruncate = Enum.TextTruncate.AtEnd
        tip.Parent = swatch

        swatch.MouseButton1Click:Connect(function()
            local pd = SpawnedPets[paintSelectedPet]
            if not pd or not pd.model then return end
            local ok, sc = pcall(PetColorHelper.get_sorted_color_data, pd.model)
            if not ok or not sc then return end
            local colorArray = {}
            if paintSelectedGroup == 0 then
                -- All groups
                for i = 1, #sc do
                    colorArray[i] = {paint.color.R, paint.color.G, paint.color.B}
                end
            else
                -- Just selected group — keep others unchanged
                for i = 1, #sc do
                    if i == paintSelectedGroup then
                        colorArray[i] = {paint.color.R, paint.color.G, paint.color.B}
                    end
                end
            end
            pcall(PetColorHelper.color_pet, pd.model, colorArray, {
                is_neon = pd.data.properties.neon or false,
                is_mega = pd.data.properties.mega_neon or false,
            })
            -- Flash swatch
            swatch.BackgroundColor3 = Color3.fromRGB(255,255,255)
            task.wait(0.15)
            swatch.BackgroundColor3 = paint.color
        end)
    end
end

local function PaintRefreshGroupButtons()
    for _, c in ipairs(paintGroupRow:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    if not paintSelectedPet then return end
    local petData = SpawnedPets[paintSelectedPet]
    if not petData or not petData.model then return end

    local ok, sc = pcall(PetColorHelper.get_sorted_color_data, petData.model)
    if not ok or not sc or #sc == 0 then return end

    -- "All" button
    local allBtn = Instance.new("TextButton")
    allBtn.Size = UDim2.new(0, 28, 1, 0)
    allBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
    allBtn.Text = "All"
    allBtn.Font = Enum.Font.GothamBold
    allBtn.TextSize = 8
    allBtn.TextColor3 = Color3.fromRGB(255,255,255)
    allBtn.BorderSizePixel = 0
    allBtn.Parent = paintGroupRow
    Instance.new("UICorner", allBtn).CornerRadius = UDim.new(0, 5)
    allBtn.MouseButton1Click:Connect(function()
        paintSelectedGroup = 0
        PaintRefreshColorGrid()
    end)

    for i, group in ipairs(sc) do
        local hex = group.hex_color or "aaaaaa"
        local r = tonumber(hex:sub(1,2), 16) or 170
        local g = tonumber(hex:sub(3,4), 16) or 170
        local b = tonumber(hex:sub(5,6), 16) or 170
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 28, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(r, g, b)
        btn.Text = tostring(i)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.BorderSizePixel = 0
        btn.Parent = paintGroupRow
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local idx = i
        btn.MouseButton1Click:Connect(function()
            paintSelectedGroup = idx
            PaintRefreshColorGrid()
        end)
    end

    -- Default to All
    paintSelectedGroup = 0
    PaintRefreshColorGrid()
end

-- Salon open button (shown when a pet is selected)
local paintSalonBtn = Instance.new("TextButton")
paintSalonBtn.Size = UDim2.new(0.62, 0, 0, 20)
paintSalonBtn.BackgroundColor3 = Color3.fromRGB(50, 140, 80)
paintSalonBtn.Text = "\xF0\x9F\x90\xBE Place Pet on Stand"
paintSalonBtn.Font = Enum.Font.GothamBold
paintSalonBtn.TextSize = 9
paintSalonBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
paintSalonBtn.BorderSizePixel = 0
paintSalonBtn.Visible = false
paintSalonBtn.Parent = miscPanel
Instance.new("UICorner", paintSalonBtn).CornerRadius = UDim.new(0, 5)

local paintRemoveSalonBtn = Instance.new("TextButton")
paintRemoveSalonBtn.Size = UDim2.new(0.36, 0, 0, 20)
paintRemoveSalonBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
paintRemoveSalonBtn.Text = "\xE2\x9C\x96 Remove"
paintRemoveSalonBtn.Font = Enum.Font.GothamBold
paintRemoveSalonBtn.TextSize = 9
paintRemoveSalonBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
paintRemoveSalonBtn.BorderSizePixel = 0
paintRemoveSalonBtn.Visible = false
paintRemoveSalonBtn.Parent = miscPanel
Instance.new("UICorner", paintRemoveSalonBtn).CornerRadius = UDim.new(0, 5)

-- Shift existing controls down
paintColorScroll.Size = UDim2.new(1, 0, 0, 200)



-- ============================================================
-- SHARED: Place pet on salon stand and open recolor UI
-- Can be called from the UI button OR from the ProximityPrompt
-- ============================================================
local function ReleasePetFromSalon(uid)
    local _fd2 = uid and SpawnedPets[uid]
    if _fd2 and _fd2.model then
        local _m2 = _fd2.model
        local hrp2 = _m2:FindFirstChild("HumanoidRootPart", true)
        if hrp2 then
            for _, c in ipairs(hrp2:GetChildren()) do
                if c.Name == "_SalonBP" or c.Name == "_SalonBG" then c:Destroy() end
            end
        end
        for _, p in ipairs(_m2:GetDescendants()) do
            if p:IsA("BasePart") then p.Anchored = false end
        end
    end
    local focusApp2 = UIManager.apps.FocusPetApp
    if focusApp2 then
        pcall(function()
            focusApp2.paints:release_focus()
            focusApp2.char_wrapper = nil
            focusApp2.pet_entity   = nil
            UIManager.set_app_visibility("FocusPetApp", false)
        end)
    end
end

local _salonCurrentUID = nil  -- track which pet is currently on the stand

local function PlacePetOnSalon(uid)
    local _fd = SpawnedPets[uid]
    local _m  = _fd and _fd.model
    if not _m then return end

    -- Always release first so we get a clean state on every open
    if _salonCurrentUID then
        ReleasePetFromSalon(_salonCurrentUID)
        _salonCurrentUID = nil
        task.wait(0.05)
    end
    _salonCurrentUID = uid

    local SALON_Y_OFFSET = -0.33
    local SALON_CF = CFrame.new(79.1913986, 6960.68359 + SALON_Y_OFFSET, 5975.72803,
        0.970097661, 0, -0.24271521, 0, 1, 0, 0.242715225, 0, 0.970097601)

    for _, p in ipairs(_m:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            p.Anchored = true
        end
    end
    local hrp = _m:FindFirstChild("HumanoidRootPart", true)
    if hrp then
        hrp.Anchored = false
        for _, c in ipairs(hrp:GetChildren()) do
            if c.Name == "_SalonBP" or c.Name == "_SalonBG" then c:Destroy() end
        end
        local bp = Instance.new("BodyPosition")
        bp.Name = "_SalonBP"
        bp.Position = SALON_CF.Position
        bp.MaxForce  = Vector3.new(1e6, 1e6, 1e6)
        bp.D = 500; bp.P = 10000
        bp.Parent = hrp
        local bg = Instance.new("BodyGyro")
        bg.Name = "_SalonBG"
        bg.CFrame = SALON_CF
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        bg.D = 500; bg.P = 10000
        bg.Parent = hrp
    end
    _m:PivotTo(SALON_CF)

    local focusApp = UIManager.apps.FocusPetApp
    if not focusApp then return end

    do
        local _ok, _err = pcall(function()
        local Fsys = require(game:GetService("ReplicatedStorage"):WaitForChild("Fsys")).load
        local CharWrapperClient = Fsys("CharWrapperClient")
        local PetEntityManager  = Fsys("PetEntityManager")
        local RouterClient      = Fsys("RouterClient")
        local Promise           = Fsys("package:Promise")
        local RunService        = game:GetService("RunService")
        local petData = _fd.data
        local isNeon = (petData.properties and petData.properties.neon == true) or false
        local isMega = (petData.properties and petData.properties.mega_neon == true) or false

        -- Ensure PetModel exists under _m so PetColorHelper can walk it
        local petModel = _m:FindFirstChild("PetModel")
        if not petModel then
            petModel = Instance.new("Model")
            petModel.Name = "PetModel"
            for _, v in ipairs(_m:GetChildren()) do
                if v:IsA("BasePart") or v:IsA("MeshPart") then
                    v.Parent = petModel
                end
            end
            petModel.Parent = _m
        end
        local pmHRP = petModel:FindFirstChild("HumanoidRootPart") or _m:FindFirstChild("HumanoidRootPart")
        local anchorPart = pmHRP or petModel.PrimaryPart or petModel:FindFirstChildWhichIsA("BasePart")

        local charWrapper = {
            char              = _m,
            pet_id            = petData.id,
            player            = LocalPlayer,
            pet_unique        = tostring(petData.unique or paintSelectedPet),
            neon              = isNeon,
            mega_neon         = isMega,
            are_colors_sealed = false,
        }
        -- fakePetEntity: in_game=false so PetEntityManager step systems skip it entirely.
        -- client_has_control=true so capture_focus doesn't hang waiting for server.
        -- Use a deep proxy metatable so ANY field access returns a safe value
        -- instead of nil -- this stops CustomEyesAnimator, PetEntityHelper, etc.
        local _safeProxy
        _safeProxy = setmetatable({}, {
            __index    = function(_, k) return _safeProxy end,
            __call     = function() return _safeProxy end,
            __len      = function() return 0 end,
            __tostring = function() return "" end,
            __concat   = function(a, b)
                if type(a) == "string" then return a
                elseif type(b) == "string" then return b
                else return "" end
            end,
        })
        local fakePetEntity = {
            is_pet_entity            = true,
            client_has_control       = true,
            visible                  = false,
            in_game                  = false,  -- keeps ALL step systems from touching it
            failed_earlier_this_step = false,
            base = setmetatable({
                char         = _m,
                char_wrapper = charWrapper,
                pet_model    = petModel,
                root         = anchorPart,
                entry        = setmetatable({ transforming_pet = nil }, {
                    __index = function(_, k) return _safeProxy end
                }),
            }, {
                __index = function(_, k) return _safeProxy end
            }),
            active_performances               = {},
            active_reactions                  = {},
            staged_performances               = {},
            modifier_values_from_performances = setmetatable({ current_form = nil }, {
                __index = function(_, k) return _safeProxy end
            }),
            move_state       = setmetatable({ is_moving = false }, {
                __index = function(_, k) return _safeProxy end
            }),
            transforming_pet = setmetatable({ needs_setup = false, last_form = nil, maid = nil }, {
                __index = function(_, k) return _safeProxy end
            }),
        }
        -- Make the entity itself a deep proxy for any unknown fields
        setmetatable(fakePetEntity, {
            __index = function(_, k) return _safeProxy end
        })

        -- Hook RouterClient.get to intercept these specific remotes
        local PetColorHelper2 = Fsys("PetColorHelper")

        -- PaintPet proxy: actually recolors the pet parts client-side
        local _paintPetProxy = setmetatable({}, {
            __index = function(_, k)
                if k == "FireServer" or k == "InvokeServer" or k == "Fire" or k == "Invoke" then
                    return function(_, char, paintList)
                        -- paintList is array of {index=N, paint=kindString}
                        if not paintList then return end
                        -- get current color data so we know which parts map to which index
                        local colorData = PetColorHelper2.get_sorted_color_data(char)
                        for _, entry in ipairs(paintList) do
                            local idx = entry.index
                            local paintKind = entry.paint
                            local group = colorData[idx]
                            if group then
                                local newColor
                                if paintKind then
                                    local paintEntry = PetColorHelper2.get_paint_entry(paintKind)
                                    if paintEntry then
                                        newColor = paintEntry.color
                                    end
                                end
                                if not newColor then
                                    -- nil paint = reset to default
                                    newColor = Color3.fromHex(group.hex_color)
                                end
                                for _, part in ipairs(group.parts) do
                                    if PetColorHelper2.is_part_colorable(part) then
                                        part.Color = newColor
                                        -- also update BrickColor to match
                                        part.BrickColor = BrickColor.new(newColor)
                                    end
                                end
                            end
                        end
                    end
                end
                return function() end
            end,
            __newindex = function() end,
        })

        local _blockedRemotes = {
            ["AdoptAPI/FocusPet"]       = true,
            ["AdoptAPI/UnfocusPet"]     = true,
            ["PetPaintAPI/PaintingPet"] = true,
        }
        local _noopProxy = setmetatable({}, {
            __index = function(_, k) return function() end end,
            __newindex = function() end,
        })
        local _origRouterGet = RouterClient.get
        RouterClient.get = function(name)
            if _blockedRemotes[name] then return _noopProxy end
            if name == "PetPaintAPI/PaintPet" then return _paintPetProxy end
            return _origRouterGet(name)
        end
        -- also handle colon-call style
        if RouterClient.Get then
            local _origRouterGetUpper = RouterClient.Get
            RouterClient.Get = function(self, name)
                if _blockedRemotes[name] then return _noopProxy end
                if name == "PetPaintAPI/PaintPet" then return _paintPetProxy end
                return _origRouterGetUpper(self, name)
            end
        end

        -- Stub CharWrapperClient so PetColorHelper sees our neon/mega flags
        local _origGet = CharWrapperClient.get
        CharWrapperClient.get = function(self_or_char, charArg)
            local c = (charArg ~= nil) and charArg or self_or_char
            if c == _m then return charWrapper end
            if charArg ~= nil then return _origGet(self_or_char, charArg) end
            return _origGet(self_or_char)
        end

        -- Stub PetEntityManager:
        -- 1. get_pet_entity returns our fake for _m
        -- 2. Hook add/register so our fake is never added to the real entity list
        --    (prevents CustomEyesAnimator/PetEntityHelper from stepping on it)
        local _origGetPetEntity = PetEntityManager.get_pet_entity
        PetEntityManager.get_pet_entity = function(char)
            if char == _m then return fakePetEntity end
            return _origGetPetEntity(char)
        end
        -- Block AboveCharStack from being created for our fake char
        -- get_head() calls PetRigs.get_safe(pet_model) expecting a string - safeProxy is a table
        local Fsys3 = require(game:GetService("ReplicatedStorage"):WaitForChild("Fsys")).load
        local _AboveCharStack = Fsys3("AboveCharStack")
        local _origACSStart = _AboveCharStack.start
        _AboveCharStack.start = function(self, props, ...)
            if props and props.char == _m then return self end
            return _origACSStart(self, props, ...)
        end

        -- Block any registration method that might add our char to the live list
        local _pemBlockMethods = {"add_pet_entity","register_pet_entity","add","register","create_pet_entity"}
        local _pemOrigBlocked = {}
        for _, mname in ipairs(_pemBlockMethods) do
            local fn = rawget(PetEntityManager, mname)
            if type(fn) == "function" then
                _pemOrigBlocked[mname] = fn
                PetEntityManager[mname] = function(char, ...)
                    if char == _m then return fakePetEntity end
                    return fn(char, ...)
                end
            end
        end

        -- Stub ToolApp
        local toolApp = focusApp.UIManager.apps.ToolApp
        local _origToolTap = toolApp and rawget(toolApp, "set_minigame_world_tap_enabled")
        if toolApp then toolApp.set_minigame_world_tap_enabled = function() end end

        -- Inject PetFocusPosition + PetFocusDistance so real camera locks onto pet
        if pmHRP and not pmHRP:FindFirstChild("PetFocusPosition") then
            local fp = Instance.new("CFrameValue")
            fp.Name = "PetFocusPosition"
            fp.Value = pmHRP.CFrame
            fp.Parent = pmHRP
            local fd = Instance.new("NumberValue")
            fd.Name = "PetFocusDistance"
            fd.Value = 5
            fd.Parent = fp
            local _fpConn
            _fpConn = game:GetService("RunService").RenderStepped:Connect(function()
                if fp and fp.Parent and pmHRP and pmHRP.Parent then
                    fp.Value = pmHRP.CFrame
                else
                    _fpConn:Disconnect()
                end
            end)
        end

        -- Stub rotation handler
        -- Set rotation_controller NOW (not just in capture_focus) so paints:capture_focus
        -- can read focusApp.rotation_handler.rotation_controller immediately
        local fakeRotCtrl = setmetatable({}, {
            __index = function(_, k) return function() return {cancel=function()end} end end
        })
        focusApp.rotation_handler.rotation_controller = fakeRotCtrl
        local _origRotCapture = focusApp.rotation_handler.capture_focus
        local _origRotRelease = focusApp.rotation_handler.release_focus
        focusApp.rotation_handler.capture_focus = function(self, entity)
            self.rotation_controller = fakeRotCtrl
            self.pet_entity = entity
            self.enabled = false
        end
        focusApp.rotation_handler.release_focus = function(self)
            self.rotation_controller = nil
            self.pet_entity = nil
            focusApp.rotation_handler.capture_focus = _origRotCapture
            focusApp.rotation_handler.release_focus = _origRotRelease
        end

        -- Stub feeder
        local _oldFeeder = focusApp.feeder
        local _stubFeeder = {
            done_eating_promise  = function() return Promise.resolve() end,
            _delete_mock_ailment = function() end,
            feed_pet             = function() return Promise.resolve() end,
            start                = function() end,
        }
        focusApp.feeder = _stubFeeder

        local function restoreAll()
            CharWrapperClient.get = _origGet
            PetEntityManager.get_pet_entity = _origGetPetEntity
            RouterClient.get = _origRouterGet
            if RouterClient.Get then RouterClient.Get = _origRouterGetUpper end
            PetEntityManager.get_pet_entity = _origGetPetEntity
            for mname, fn in pairs(_pemOrigBlocked) do
                PetEntityManager[mname] = fn
            end
            if toolApp and _origToolTap then
                toolApp.set_minigame_world_tap_enabled = _origToolTap
            end
            _AboveCharStack.start = _origACSStart
            focusApp.feeder = _oldFeeder
        end

        -- Release any existing focus cleanly
        if focusApp.char_wrapper then
            pcall(function() focusApp:release_focus() end)
        end

        -- Override can_display and refresh to prevent UIManager hiding us
        local _origCanDisplay = focusApp.can_display
        local _origRefresh    = focusApp.refresh
        focusApp.can_display = function() return true end
        focusApp.refresh = function(self, vis)
            if focusApp.paints._fake_hooked then
                -- UIManager tried to hide us - force everything visible instead
                focusApp.instance.Enabled = true
                focusApp.instance.Frame.Visible = true
                if focusApp.exit_button then
                    focusApp.exit_button.instance.Visible = true
                end
            else
                focusApp.can_display = _origCanDisplay
                focusApp.refresh     = _origRefresh
                _origRefresh(self, vis)
            end
        end

        -- Hook paints release_focus to clean everything up when back button pressed
        if not focusApp.paints._fake_hooked then
            focusApp.paints._fake_hooked = true
            local _origPaintsRelease = focusApp.paints.release_focus
            focusApp.paints.release_focus = function(self)
                -- stop force-visible loop
                focusApp.paints._fake_hooked = nil
                focusApp.can_display = _origCanDisplay
                focusApp.refresh     = _origRefresh
                restoreAll()
                focusApp.paints.release_focus = _origPaintsRelease
                focusApp.feeder = _stubFeeder
                pcall(function() _origPaintsRelease(self) end)
                focusApp.feeder = _oldFeeder
            end
        end

        -- Set UIManager state so it thinks FocusPetApp is meant to be shown
        focusApp.UIManager.app_visibilities["FocusPetApp"] = true

        -- Run the real capture_focus - this calls show(), sets up ailments hiding,
        -- zoom_to_pet (stubbed), rotation controller (stubbed), etc.
        focusApp:capture_focus(charWrapper)

        if focusApp.char_wrapper then
            -- Hide all panels except paints
            pcall(function() focusApp.ailments:hide() end)
            pcall(function() focusApp.pet_selector:hide() end)
            pcall(function() focusApp.mock_ailment:hide() end)
            pcall(function() focusApp.backpack:hide() end)
            pcall(function() focusApp.navigator:hide() end)
            pcall(function() focusApp.petting_handler:release_focus() end)

            -- Run paints capture_focus - this builds color slots from PetModel parts
            focusApp.paints:capture_focus(focusApp.char_wrapper)
            focusApp.paints:tween_show()
            pcall(function() focusApp.lighting_toggle:capture_focus() end)
            pcall(function() focusApp.gamepad_support:release_focus() end)
            pcall(function() focusApp.gamepad_support:capture_focus(focusApp.paints.instance) end)

            -- FORCE the ScreenGui visible - this is the key line
            -- focusApp.instance IS the ScreenGui; Enabled=false hides everything
            focusApp.instance.Enabled = true
            focusApp.instance.Frame.Visible = true
            focusApp.paints.instance.Visible = true
            focusApp.paints.canvas.Visible = true
        else
            -- capture_focus failed, restore
            restoreAll()
            focusApp.can_display = _origCanDisplay
            focusApp.refresh     = _origRefresh
            focusApp.paints._fake_hooked = nil
        end
        -- Hook paints release_focus to also release pet from salon stand
        if focusApp.exit_button and focusApp.exit_button.instance then
            local _exitBtn = focusApp.exit_button.instance
            local _exitConn
            _exitConn = _exitBtn.MouseButton1Click:Connect(function()
                _exitConn:Disconnect()
                ReleasePetFromSalon(_salonCurrentUID)
                _salonCurrentUID = nil
            end)
            if not focusApp.paints._salon_exit_hooked then
                focusApp.paints._salon_exit_hooked = true
                local _wrappedRelease = focusApp.paints.release_focus
                focusApp.paints.release_focus = function(self)
                    focusApp.paints._salon_exit_hooked = nil
                    focusApp.paints.release_focus = _wrappedRelease
                    if _exitConn then _exitConn:Disconnect() end
                    task.defer(function()
                        ReleasePetFromSalon(_salonCurrentUID)
                        _salonCurrentUID = nil
                    end)
                    return _wrappedRelease(self)
                end
            end
        end
        end)
        if _err then
            warn("PaintUI error: " .. tostring(_err))
        end
    end
end

-- Wire existing UI button to shared function
paintSalonBtn.MouseButton1Click:Connect(function()
    if paintSelectedPet then
        PlacePetOnSalon(paintSelectedPet)
    end
end)

-- Wire existing remove button to shared release function  
paintRemoveSalonBtn.MouseButton1Click:Connect(function()
    ReleasePetFromSalon(_salonCurrentUID or paintSelectedPet)
    _salonCurrentUID = nil
    paintRemoveSalonBtn.Text = "\xE2\x9C\x85 Removed"
    task.wait(1)
    paintRemoveSalonBtn.Text = "\xE2\x9C\x96 Remove"
end)

-- ============================================================
-- HOOK the salon interaction - bulletproof, all levels
-- ============================================================
task.defer(function()
    local Fsys2       = require(game:GetService("ReplicatedStorage"):WaitForChild("Fsys")).load
    local InteractEng = Fsys2("InteractionsEngine")
    local SALON_POS   = Vector3.new(79.1913986, 6960.68359 - 0.33, 5975.72803)
    local SEARCH_DIST = 25

    local function openSalon(interaction)
        local uid = paintSelectedPet
        if not uid then for k in pairs(SpawnedPets) do uid = k; break end end
        if uid then
            PlacePetOnSalon(uid)
        end
        -- Reset in_use so subsequent clicks/E presses work
        -- interaction:run() sets in_use=true and only resets after on_selected returns
        -- but PlacePetOnSalon yields inside (tweens), so in_use stays true forever
        if interaction then
            task.defer(function() interaction.in_use = false end)
        end
    end

    local function isSalon(inter)
        local ok, part = pcall(function() return inter.part end)
        if not ok or not part or typeof(part) ~= "Instance" then return false end
        local ok2, pos = pcall(function() return part.Position end)
        if not ok2 then return false end
        return (pos - SALON_POS).Magnitude < SEARCH_DIST
    end

    -- Hook InteractionsApp.call_on_selected ONCE - catches both E and click
    -- because both paths go through p_u_133:call_on_selected(interaction)
    local interactApp = UIManager and UIManager.apps and UIManager.apps.InteractionsApp
    if interactApp and not interactApp._salonHooked then
        interactApp._salonHooked = true
        local orig = interactApp.call_on_selected
        interactApp.call_on_selected = function(self, inter, ...)
            if isSalon(inter) then
                openSalon()
                return
            end
            return orig(self, inter, ...)
        end
    end

    -- Also permanently poll and wrap on_selected + TapButton on every interaction
    -- near the salon, so it works even if call_on_selected hook misses edge cases
    local hookedSet = {}
    while true do
        task.wait(0.3)

        -- Re-hook InteractionsApp in case it got replaced
        local app = UIManager and UIManager.apps and UIManager.apps.InteractionsApp
        if app and not app._salonHooked then
            app._salonHooked = true
            local orig = app.call_on_selected
            app.call_on_selected = function(self, inter, ...)
                if isSalon(inter) then openSalon() return end
                return orig(self, inter, ...)
            end
        end

        if InteractEng and InteractEng.interactions then
            for interaction, _ in pairs(InteractEng.interactions) do
                if isSalon(interaction) and not hookedSet[interaction] then
                    hookedSet[interaction] = true

                    -- Wrap on_selected
                    local origOS = interaction.on_selected
                    interaction.on_selected = function(...)
                        openSalon(interaction)
                    end

                    -- Hook TapButton directly (handles clicks that bypass call_on_selected)
                    task.spawn(function()
                        local w = 0
                        while w < 15 do
                            if interaction.gui and interaction.gui.instance then
                                local btn = interaction.gui.instance:FindFirstChild("TapButton", true)
                                if btn and not btn:GetAttribute("_sh") then
                                    btn:SetAttribute("_sh", true)
                                    btn.MouseButton1Down:Connect(function() openSalon(interaction) end)
                                    btn.MouseButton1Click:Connect(function() openSalon(interaction) end)
                                end
                                break
                            end
                            task.wait(0.1); w = w + 0.1
                        end
                    end)
                end
            end
        end
    end
end)



local function PaintRefreshPetList()
    for _, c in ipairs(paintPetScroll:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    local any = false
    for uid, petData in pairs(SpawnedPets) do
        if petData.model and petData.data then
            any = true
            local row = Instance.new("TextButton")
            row.Size = UDim2.new(1, -4, 0, 22)
            row.BackgroundColor3 = (paintSelectedPet == uid)
                and Color3.fromRGB(60, 80, 160) or Color3.fromRGB(35, 38, 58)
            row.Text = "  \xF0\x9F\x90\xBE " .. (petData.data.properties.rp_name or petData.data.id or uid)
            row.Font = Enum.Font.Gotham
            row.TextSize = 9
            row.TextColor3 = Color3.fromRGB(220, 230, 255)
            row.TextXAlignment = Enum.TextXAlignment.Left
            row.BorderSizePixel = 0
            row.Parent = paintPetScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
            local capturedUid = uid
            row.MouseButton1Click:Connect(function()
                paintSelectedPet = capturedUid
                paintSalonBtn.Visible = true
                paintRemoveSalonBtn.Visible = true
                PaintRefreshPetList()
                PaintRefreshGroupButtons()
            end)
        end
    end
    if not any then
        paintSalonBtn.Visible = false
        paintRemoveSalonBtn.Visible = false
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, -4, 0, 22)
        empty.BackgroundTransparency = 1
        empty.Text = "No pets spawned yet"
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 9
        empty.TextColor3 = Color3.fromRGB(160, 170, 200)
        empty.Parent = paintPetScroll
    end
end

-- Refresh pet list when panel becomes visible (handled in tab click)




-- =============== PET TRICKS ===============

do
    local Fsys = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
    local EquippedPets   = Fsys("EquippedPets")
    local PetWorldState  = Fsys("PetWorldState")
    local PetCommandType = Fsys("AdoptMeEnums/PetEntities/PetCommandType")
    local InventoryDB2   = Fsys("InventoryDB")

    -- Divider
    local trickDiv = Instance.new("Frame")
    trickDiv.Size = UDim2.new(1, 0, 0, 1)
    trickDiv.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
    trickDiv.BorderSizePixel = 0
    trickDiv.Parent = miscPanel

    -- Section title
    local trickTitle = Instance.new("TextLabel")
    trickTitle.Size = UDim2.new(1, 0, 0, 14)
    trickTitle.BackgroundTransparency = 1
    trickTitle.Text = "🎪  PET TRICKS"
    trickTitle.Font = Enum.Font.GothamBold
    trickTitle.TextSize = 10
    trickTitle.TextColor3 = Color3.fromRGB(255, 220, 100)
    trickTitle.TextXAlignment = Enum.TextXAlignment.Left
    trickTitle.Parent = miscPanel

    -- Status / feedback label
    local trickStatus = Instance.new("TextLabel")
    trickStatus.Size = UDim2.new(1, 0, 0, 12)
    trickStatus.BackgroundTransparency = 1
    trickStatus.Text = "Equip a pet to see its tricks"
    trickStatus.Font = Enum.Font.Gotham
    trickStatus.TextSize = 9
    trickStatus.TextColor3 = Color3.fromRGB(140, 150, 180)
    trickStatus.TextXAlignment = Enum.TextXAlignment.Left
    trickStatus.Parent = miscPanel

    -- Grid for trick buttons (2 columns)
    local trickGrid = Instance.new("Frame")
    trickGrid.Size = UDim2.new(1, 0, 0, 0)
    trickGrid.AutomaticSize = Enum.AutomaticSize.Y
    trickGrid.BackgroundTransparency = 1
    trickGrid.Parent = miscPanel

    local trickGridLayout = Instance.new("UIGridLayout")
    trickGridLayout.CellSize = UDim2.new(0.5, -3, 0, 24)
    trickGridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
    trickGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    trickGridLayout.Parent = trickGrid

    -- "All Tricks" button
    local allTricksBtn = Instance.new("TextButton")
    allTricksBtn.Size = UDim2.new(1, 0, 0, 24)
    allTricksBtn.Text = "🎭 ALL TRICKS"
    allTricksBtn.Font = Enum.Font.GothamBold
    allTricksBtn.TextSize = 9
    allTricksBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 140)
    allTricksBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    allTricksBtn.BorderSizePixel = 0
    allTricksBtn.Parent = miscPanel
    Instance.new("UICorner", allTricksBtn).CornerRadius = UDim.new(0, 5)

    local _trickButtons = {}

    local function rebuildTrickButtons()
        -- Clear old buttons
        for _, b in ipairs(_trickButtons) do b:Destroy() end
        _trickButtons = {}

        local tricks = {}
        local seen = {}
        for _, wrapper in EquippedPets.get_my_equipped_char_wrappers() do
            local entry = InventoryDB2.pets[wrapper.pet_id]
            if entry and entry.tricks then
                for _, trick in ipairs(entry.tricks) do
                    local name = trick[1]
                    if not seen[name] then
                        seen[name] = true
                        table.insert(tricks, name)
                    end
                end
            end
        end

        if #tricks == 0 then
            trickStatus.Text = "Equip a pet to see its tricks"
            trickStatus.TextColor3 = Color3.fromRGB(140, 150, 180)
            allTricksBtn.Visible = false
            return
        end

        trickStatus.Text = "Tap a trick to perform it  (" .. #tricks .. " available)"
        trickStatus.TextColor3 = Color3.fromRGB(120, 200, 120)
        allTricksBtn.Visible = true

        for i, trickName in ipairs(tricks) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 0, 0, 0)  -- governed by UIGridLayout
            btn.Text = trickName
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 9
            btn.BackgroundColor3 = Color3.fromRGB(45, 55, 80)
            btn.TextColor3 = Color3.fromRGB(200, 210, 255)
            btn.BorderSizePixel = 0
            btn.LayoutOrder = i
            btn.Parent = trickGrid
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

            btn.MouseButton1Click:Connect(function()
                local performed = false
                local AnimMgr = Fsys("AnimationManager")
                local GetEquippedPet = _G._blueprint_EquippedPet
                local SpawnedPets2 = _G._blueprint_SpawnedPets

                local equippedPetData = GetEquippedPet and GetEquippedPet()
                local spawnedEntry = equippedPetData and SpawnedPets2 and SpawnedPets2[equippedPetData.unique]
                local fakeModel = spawnedEntry and spawnedEntry.model

                if fakeModel then
                    -- Fake pet: play animation directly on the model
                    local ok, err = pcall(function()
                        local entry = InventoryDB2.pets[equippedPetData.id]
                            or InventoryDB2.pets[equippedPetData.kind]
                        local animName
                        if entry and entry.tricks then
                            for _, t in ipairs(entry.tricks) do
                                if t[1] == trickName then animName = t[2]; break end
                            end
                        end
                        if not animName then return end
                        local animTrack = AnimMgr.get_track(animName)
                        if not animTrack then return end
                        local petModel = fakeModel:FindFirstChild("PetModel")
                        local animator = petModel
                            and petModel:FindFirstChildOfClass("AnimationController")
                            and petModel:FindFirstChildOfClass("AnimationController"):FindFirstChildOfClass("Animator")
                        if not animator then
                            animator = fakeModel:FindFirstChildOfClass("Animator", true)
                        end
                        if not animator then return end
                        local track = animator:LoadAnimation(animTrack)
                        track:Play()
                        -- Stop track when pet starts moving
                        -- fakeModel == petModel == the char key in PetEntityManager
                        local PetEntityManager = Fsys("PetEntityManager")
                        task.spawn(function()
                            local deadline = tick() + 15
                            while tick() < deadline do
                                if not track.IsPlaying then break end
                                local entity = PetEntityManager.get_pet_entity(fakeModel)
                                if entity and entity.move_state and entity.move_state.is_moving then
                                    track:Stop(0.2)
                                    break
                                end
                                task.wait(0.1)
                            end
                        end)
                    end)
                    if ok then performed = true
                    else DebugLog("Fake trick error: " .. tostring(err)) end
                else
                    -- Real pet: Stay → DoTrick via entity system
                    local PetEntityManager = Fsys("PetEntityManager")
                    for _, wrapper in EquippedPets.get_my_equipped_char_wrappers() do
                        pcall(function()
                            PetWorldState.buffer_command(wrapper.char, PetCommandType.Stay, {})
                        end)
                    end
                    task.wait(0.2)
                    for _, wrapper in EquippedPets.get_my_equipped_char_wrappers() do
                        local ok, err = pcall(function()
                            PetWorldState.buffer_command(wrapper.char, PetCommandType.DoTrick, {
                                trick_name = trickName
                            })
                            local char = wrapper.char
                            task.defer(function()
                                for _ = 1, 10 do
                                    local entity = PetEntityManager.get_pet_entity(char)
                                    if entity and entity.tricks_used then
                                        entity.tricks_used[trickName] = true
                                        break
                                    end
                                    task.wait()
                                end
                            end)
                        end)
                        if ok then performed = true
                        else DebugLog("Trick error: " .. tostring(err)) end
                    end
                end

                if performed then
                    btn.BackgroundColor3 = Color3.fromRGB(60, 110, 60)
                    btn.TextColor3 = Color3.fromRGB(150, 255, 150)
                    trickStatus.Text = "✓ " .. trickName
                    trickStatus.TextColor3 = Color3.fromRGB(120, 255, 120)
                    task.delay(1.2, function()
                        btn.BackgroundColor3 = Color3.fromRGB(45, 55, 80)
                        btn.TextColor3 = Color3.fromRGB(200, 210, 255)
                        trickStatus.Text = "Tap a trick to perform it  (" .. #tricks .. " available)"
                        trickStatus.TextColor3 = Color3.fromRGB(120, 200, 120)
                    end)
                end
            end)

            table.insert(_trickButtons, btn)
        end
    end

    -- All tricks at once
    allTricksBtn.Visible = false
    allTricksBtn.MouseButton1Click:Connect(function()
        local PetEntityManager = Fsys("PetEntityManager")
        local count = 0
        for _, wrapper in EquippedPets.get_my_equipped_char_wrappers() do
            pcall(function()
                PetWorldState.buffer_command(wrapper.char, PetCommandType.Stay, {})
            end)
        end
        task.wait(0.2)
        for _, wrapper in EquippedPets.get_my_equipped_char_wrappers() do
            local entry = InventoryDB2.pets[wrapper.pet_id]
            if entry and entry.tricks then
                for _, trick in ipairs(entry.tricks) do
                    local tname = trick[1]
                    local wchar = wrapper.char
                    task.delay(count * 1.5, function()
                        pcall(function()
                            PetWorldState.buffer_command(wchar, PetCommandType.DoTrick, {
                                trick_name = tname
                            })
                        end)
                    end)
                    count = count + 1
                end
            end
        end
        trickStatus.Text = "🎭 Performing all " .. count .. " tricks..."
        trickStatus.TextColor3 = Color3.fromRGB(255, 220, 100)
        task.delay(count * 1.5 + 1, function()
            trickStatus.Text = "Tap a trick to perform it  (" .. #tricks .. " available)"
            trickStatus.TextColor3 = Color3.fromRGB(120, 200, 120)
        end)
    end)

    -- Rebuild whenever equipped pets change
    pcall(function()
        local CWC = Fsys("CharWrapperClient")
        CWC.register_pet_wrapper_char_changed(function()
            task.defer(rebuildTrickButtons)
        end)
    end)

    -- Initial build
    task.defer(rebuildTrickButtons)
end

-- =============== END PAINT PANEL (merged) ===============

_G._p2_mainFrame = mainFrame
_G._p2_spawnPanel = spawnPanel
_G._p2_toolsPanel = toolsPanel
_G._p2_miscPanel = miscPanel
_G._p2_flagState = flagState
_G._p2_currentAge = currentAge
_G._p2_nameInput = nameInput
_G._p2_tabElements = tabElements
_G._p2_spawnButton = spawnButton
_G._p2_spawnAllButton = spawnAllButton
_G._p2_glowColors = glowColors
_G._p2_inputGlow = inputGlow
_G._p2_uiScale = uiScale
_G._p2_SwitchTab = SwitchTab
_G._p2_activeTab = activeTab
_G._p2_SpawnedPets = SpawnedPets
_G._blueprint_SpawnedPets = SpawnedPets  -- persistent ref for tricks/misc panel
_G._p2_SpawnedItems = SpawnedItems
_G._p2_LocalPlayer = LocalPlayer
_G._p2_playerGui = playerGui
_G._p2_InventoryDB = InventoryDB
_G._p2_KindDB = KindDB
_G._p2_ClientData = ClientData
_G._p2_RouterClient = RouterClient
_G._p2_OriginalRouterGet = OriginalRouterGet
_G._p2_UIManager = UIManager
_G._p2_CharWrapperClient = CharWrapperClient
_G._p2_UpdateClientData = UpdateClientData
_G._p2_TweenService = TweenService
_G._p2_ReplicatedStorage = ReplicatedStorage
_G._p2_DebugLogs = DebugLogs
_G._p2_debugScrollFrame = debugScrollFrame
_G._p2_CreateInventoryItem = CreateInventoryItem
_G._p2_FindPetId = FindPetId
_G._p2_FindToyId = FindToyId
_G._p2_FindItemId = FindItemId
_G._p2_EquipPet = EquipPet
_G._p2_UnequipPet = UnequipPet
_G._p2_DeleteAllSpawnedPets = DeleteAllSpawnedPets
_G._p2_GenerateUniquePetName = GenerateUniquePetName
_G._p2_HighTierPets = HighTierPets
_G._p2_PetColorHelper = PetColorHelper
_G._p2_PaintColorDB = PaintColorDB
_G._p2_AnimationManager = AnimationManager
_G._p2_DisplayStandHelper = DisplayStandHelper
_G._p2_DownloadClient = DownloadClient
_G._p2_PetRecyclerApp = PetRecyclerApp
_G._p2__ActiveTicketBalance = _ActiveTicketBalance
_G._p2_IsFakePet = IsFakePet
_G._p2_GetPetModel = GetPetModel
_G._p2_AvatarClientManager = AvatarClientManager
_G._p2_PetAvatarCategoriesDB = PetAvatarCategoriesDB
_G._p2_CatalogItemImage = CatalogItemImage
_G._p2_SpawnedPets2 = SpawnedPets
_G._p2_PaintRefreshPetList = PaintRefreshPetList

-- Hook PetActions.do_trick: for fake pets, bypass server entirely.
-- The real do_trick fails because StateManagerClient.get(char) returns nil
-- for fake pets, so buffer_command never fires after the dialog.
-- We replace the whole function for fake pets with our working client-side system.
local _hookOk, _hookErr = pcall(function()
    local _load = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
    local PetActions = _load("PetActions")
    if not PetActions then DebugLog("PetActions hook: PetActions is nil") return end
    local origDoTrick = PetActions.do_trick
    if not origDoTrick then DebugLog("PetActions hook: do_trick is nil") return end
    local PEM = _load("PetEntityManager")
    local PetWorldState = _load("PetWorldState")
    local PetCommandType = _load("AdoptMeEnums/PetEntities/PetCommandType")
    local UIManager2 = _load("UIManager")
    DebugLog("PetActions.do_trick hook installing...")

    local _AnimationManager = _load("AnimationManager")

    PetActions.do_trick = function(wrapper)
        DebugLog("do_trick called: unique=" .. tostring(wrapper and wrapper.pet_unique) .. " isFake=" .. tostring(wrapper and _G._blueprint_SpawnedPets and _G._blueprint_SpawnedPets[wrapper.pet_unique] ~= nil))
        -- Only intercept fake pets
        if not (wrapper and _G._blueprint_SpawnedPets and _G._blueprint_SpawnedPets[wrapper.pet_unique]) then
            return origDoTrick(wrapper)
        end

        local entry = InventoryDB.pets[wrapper.pet_id]
        if not entry or not entry.tricks or #entry.tricks == 0 then return end

        -- Build trick buttons exactly like the real do_trick does
        local buttons = {}
        for i, trick in ipairs(entry.tricks) do
            local trickLevel = wrapper.pet_trick_level or 0
            if trickLevel < i then
                buttons[i] = { layout_order = i, text = "???", button_state = "inactive" }
            else
                buttons[i] = { layout_order = i, text = trick[1] }
            end
        end

        -- Show dialog on its own thread so it doesn't block
        task.spawn(function()
            DebugLog("do_trick: showing dialog, entry.tricks count=" .. tostring(entry.tricks and #entry.tricks))
            local chosen = UIManager2.apps.DialogApp:dialog({
                dialog_type = "ScrollingButtonsDialog",
                header = "SELECT TRICK",
                buttons = buttons,
                exit_button = true,
                cells_per_row = 2,
                padding = 10
            })
            DebugLog("do_trick: dialog returned chosen=" .. tostring(chosen))

            if not chosen or chosen == "cancel" then return end

            local trickEntry = entry.tricks[chosen]
            DebugLog("do_trick: trickEntry=" .. tostring(trickEntry and trickEntry[1]))
            if not trickEntry then return end
            local trickName = trickEntry[1]
            local animKey = trickEntry[2] or trickName
            DebugLog("do_trick: trickName=" .. trickName .. " animKey=" .. animKey)

            local char = wrapper.char
            local fakeModel = char

            -- Find animator
            local petModel = fakeModel:FindFirstChild("PetModel")
            local animController = petModel and petModel:FindFirstChildOfClass("AnimationController")
            local animator = (animController and animController:FindFirstChildOfClass("Animator"))
                or fakeModel:FindFirstChildWhichIsA("Animator", true)
            DebugLog("do_trick: animator=" .. tostring(animator))

            if not animator then DebugLog("do_trick: no animator") return end

            -- Try animKey first, then display name
            local animTrack = _AnimationManager.get_track(animKey)
            if not animTrack then animTrack = _AnimationManager.get_track(trickName) end
            DebugLog("do_trick: animTrack=" .. tostring(animTrack))

            if not animTrack then DebugLog("do_trick: no track found for " .. animKey) return end

            -- Fire the original do_trick so the server plays the windup (jump + !)
            -- We don't care if it fails after that — we'll play our anim on top
            pcall(function() origDoTrick(wrapper) end)
            -- Wait for windup to finish
            task.wait(3)
            pcall(function() UIManager2.apps.FocusPetApp:release_focus() end)

            local ok2, err2 = pcall(function()
                -- Stop any currently playing trick track on this pet
                local spEntry = _G._blueprint_SpawnedPets and _G._blueprint_SpawnedPets[wrapper.pet_unique]
                if spEntry and spEntry._activeTrickTrack then
                    pcall(function() spEntry._activeTrickTrack:Stop(0.1) end)
                    spEntry._activeTrickTrack = nil
                end

                -- Play windup/learning anim first, then the trick
                local function playTrick()
                    local track = animator:LoadAnimation(animTrack)
                    track:Play()
                    DebugLog("do_trick: PLAYING " .. animKey)
                    if spEntry then spEntry._activeTrickTrack = track end
                    task.spawn(function()
                        local entity = PEM.get_pet_entity(char)
                        local lp = game.Players.LocalPlayer
                        local lpChar = lp and lp.Character
                        local lastPos = lpChar and lpChar:FindFirstChild("HumanoidRootPart") and lpChar.HumanoidRootPart.Position
                        local t = 0
                        while t < 15 do
                            task.wait(0.1)
                            t = t + 0.1
                            if not track.IsPlaying then break end
                            if entity and entity.move_state and entity.move_state.is_moving then
                                track:Stop(0.2)
                                break
                            end
                            lpChar = lp and lp.Character
                            local hrp = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                            if hrp and lastPos then
                                if (hrp.Position - lastPos).Magnitude > 1.5 then
                                    track:Stop(0.2)
                                    break
                                end
                            end
                            if hrp then lastPos = hrp.Position end
                        end
                        if spEntry then spEntry._activeTrickTrack = nil end
                    end)
                end

                playTrick()
            end)
            if not ok2 then DebugLog("do_trick: LoadAnimation error: " .. tostring(err2)) end
        end)
    end
end)
if not _hookOk then DebugLog('PetActions hook pcall error: ' .. tostring(_hookErr)) end
]]);if not _lf0 then error("Block1 compile error: "..tostring(_le0)) end _lf0() end

do local _lf1,_le1=loadstring([[
local DebugLog = _G._DebugLog or function() end
local mainFrame = _G._p2_mainFrame
local spawnPanel = _G._p2_spawnPanel
local toolsPanel = _G._p2_toolsPanel
local miscPanel = _G._p2_miscPanel
local flagState = _G._p2_flagState
local currentAge = _G._p2_currentAge
local nameInput = _G._p2_nameInput
local tabElements = _G._p2_tabElements
local spawnButton = _G._p2_spawnButton
local spawnAllButton = _G._p2_spawnAllButton
local glowColors = _G._p2_glowColors
local inputGlow = _G._p2_inputGlow
local uiScale = _G._p2_uiScale
local SwitchTab = _G._p2_SwitchTab
local activeTab = _G._p2_activeTab
local SpawnedPets = _G._p2_SpawnedPets
local SpawnedItems = _G._p2_SpawnedItems
local LocalPlayer = _G._p2_LocalPlayer
local playerGui = _G._p2_playerGui
local InventoryDB = _G._p2_InventoryDB
local KindDB = _G._p2_KindDB
local ClientData = _G._p2_ClientData
local RouterClient = _G._p2_RouterClient
local OriginalRouterGet = _G._p2_OriginalRouterGet
local UIManager = _G._p2_UIManager
local CharWrapperClient = _G._p2_CharWrapperClient
local UpdateClientData = _G._p2_UpdateClientData
local TweenService = _G._p2_TweenService
local ReplicatedStorage = _G._p2_ReplicatedStorage
local DebugLogs = _G._p2_DebugLogs
local debugScrollFrame = _G._p2_debugScrollFrame
local CreateInventoryItem = _G._p2_CreateInventoryItem
local FindPetId = _G._p2_FindPetId
local FindToyId = _G._p2_FindToyId
local FindItemId = _G._p2_FindItemId
local EquipPet = _G._p2_EquipPet
local UnequipPet = _G._p2_UnequipPet
local DeleteAllSpawnedPets = _G._p2_DeleteAllSpawnedPets
local GenerateUniquePetName = _G._p2_GenerateUniquePetName
local HighTierPets = _G._p2_HighTierPets
local PetColorHelper = _G._p2_PetColorHelper
local PaintColorDB = _G._p2_PaintColorDB
local AnimationManager = _G._p2_AnimationManager
local DisplayStandHelper = _G._p2_DisplayStandHelper
local DownloadClient = _G._p2_DownloadClient
local PetRecyclerApp = _G._p2_PetRecyclerApp
local _ActiveTicketBalance = _G._p2__ActiveTicketBalance
local IsFakePet = _G._p2_IsFakePet
local GetPetModel = _G._p2_GetPetModel
local AvatarClientManager = _G._p2_AvatarClientManager
local PetAvatarCategoriesDB = _G._p2_PetAvatarCategoriesDB
local CatalogItemImage = _G._p2_CatalogItemImage
local SpawnedPets = _G._p2_SpawnedPets2
local PaintRefreshPetList = _G._p2_PaintRefreshPetList
_G._p2_mainFrame=nil; _G._p2_spawnPanel=nil; _G._p2_toolsPanel=nil; _G._p2_miscPanel=nil; _G._p2_flagState=nil; _G._p2_currentAge=nil; _G._p2_nameInput=nil; _G._p2_tabElements=nil; _G._p2_spawnButton=nil; _G._p2_spawnAllButton=nil; _G._p2_glowColors=nil; _G._p2_inputGlow=nil; _G._p2_uiScale=nil; _G._p2_SwitchTab=nil; _G._p2_activeTab=nil; _G._p2_SpawnedPets=nil; _G._p2_SpawnedItems=nil; _G._p2_LocalPlayer=nil; _G._p2_playerGui=nil; _G._p2_InventoryDB=nil; _G._p2_KindDB=nil; _G._p2_ClientData=nil; _G._p2_RouterClient=nil; _G._p2_OriginalRouterGet=nil; _G._p2_UIManager=nil; _G._p2_CharWrapperClient=nil; _G._p2_UpdateClientData=nil; _G._p2_TweenService=nil; _G._p2_ReplicatedStorage=nil; _G._p2_DebugLogs=nil; _G._p2_debugScrollFrame=nil; _G._p2_CreateInventoryItem=nil; _G._p2_FindPetId=nil; _G._p2_FindToyId=nil; _G._p2_FindItemId=nil; _G._p2_EquipPet=nil; _G._p2_UnequipPet=nil; _G._p2_DeleteAllSpawnedPets=nil; _G._p2_GenerateUniquePetName=nil; _G._p2_HighTierPets=nil; _G._p2_PetColorHelper=nil; _G._p2_PaintColorDB=nil; _G._p2_AnimationManager=nil; _G._p2_DisplayStandHelper=nil; _G._p2_DownloadClient=nil; _G._p2_PetRecyclerApp=nil; _G._p2__ActiveTicketBalance=nil; _G._p2_IsFakePet=nil; _G._p2_GetPetModel=nil; _G._p2_AvatarClientManager=nil; _G._p2_PetAvatarCategoriesDB=nil; _G._p2_CatalogItemImage=nil; _G._p2_SpawnedPets2=nil; _G._p2_PaintRefreshPetList=nil

local debugPanel = Instance.new("Frame")
debugPanel.Size = UDim2.new(0.94, 0, 1, -50)
debugPanel.Position = UDim2.new(0.03, 0, 0, 48)
debugPanel.BackgroundTransparency = 1
debugPanel.Visible = false
debugPanel.Parent = mainFrame

local debugTitle = Instance.new("TextLabel")
debugTitle.Size = UDim2.new(1, 0, 0, 14)
debugTitle.Position = UDim2.new(0, 0, 0, 0)
debugTitle.BackgroundTransparency = 1
debugTitle.Text = "🐛 Debug Log  (RouterClient + Recycler hooks)"
debugTitle.Font = Enum.Font.GothamBold
debugTitle.TextSize = 8
debugTitle.TextColor3 = Color3.fromRGB(180, 220, 255)
debugTitle.TextXAlignment = Enum.TextXAlignment.Left
debugTitle.Parent = debugPanel

-- Legend
local legendLabel = Instance.new("TextLabel")
legendLabel.Size = UDim2.new(1, 0, 0, 10)
legendLabel.Position = UDim2.new(0, 0, 0, 15)
legendLabel.BackgroundTransparency = 1
legendLabel.Text = "🟡 FireServer  🔵 InvokeServer  🟢 CLIENT-SIDE  🔴 ERROR"
legendLabel.Font = Enum.Font.Code
legendLabel.TextSize = 6
legendLabel.TextColor3 = Color3.fromRGB(160, 170, 200)
legendLabel.TextXAlignment = Enum.TextXAlignment.Left
legendLabel.Parent = debugPanel

-- Scrolling log area
local debugBg = Instance.new("Frame")
debugBg.Size = UDim2.new(1, 0, 1, -56)
debugBg.Position = UDim2.new(0, 0, 0, 27)
debugBg.BackgroundColor3 = Color3.fromRGB(12, 14, 22)
debugBg.BorderSizePixel = 0
debugBg.Parent = debugPanel
Instance.new("UICorner", debugBg).CornerRadius = UDim.new(0, 6)
local debugStroke = Instance.new("UIStroke")
debugStroke.Color = Color3.fromRGB(60, 80, 120)
debugStroke.Thickness = 1
debugStroke.Parent = debugBg

debugScrollFrame = Instance.new("ScrollingFrame")
debugScrollFrame.Size = UDim2.new(1, -4, 1, -4)
debugScrollFrame.Position = UDim2.new(0, 2, 0, 2)
debugScrollFrame.BackgroundTransparency = 1
debugScrollFrame.BorderSizePixel = 0
debugScrollFrame.ScrollBarThickness = 3
debugScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 200)
debugScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
debugScrollFrame.Parent = debugBg

local debugLayout = Instance.new("UIListLayout")
debugLayout.SortOrder = Enum.SortOrder.LayoutOrder
debugLayout.Padding = UDim.new(0, 1)
debugLayout.Parent = debugScrollFrame

-- Clear button
local clearDebugBtn = Instance.new("TextButton")
clearDebugBtn.Size = UDim2.new(0.32, -2, 0, 18)
clearDebugBtn.Position = UDim2.new(0, 0, 1, -20)
clearDebugBtn.Text = "🗑 Clear"
clearDebugBtn.Font = Enum.Font.GothamBold
clearDebugBtn.TextSize = 8
clearDebugBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
clearDebugBtn.TextColor3 = Color3.fromRGB(255, 160, 160)
clearDebugBtn.Parent = debugPanel
Instance.new("UICorner", clearDebugBtn).CornerRadius = UDim.new(0, 6)

clearDebugBtn.MouseButton1Click:Connect(function()
    DebugLogs = {}
    for _, child in pairs(debugScrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    debugScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    DebugLog("Log cleared.")
end)

-- Copy to clipboard button
local copyDebugBtn = Instance.new("TextButton")
copyDebugBtn.Size = UDim2.new(0.32, -2, 0, 18)
copyDebugBtn.Position = UDim2.new(0.34, 0, 1, -20)
copyDebugBtn.Text = "📋 Copy Log"
copyDebugBtn.Font = Enum.Font.GothamBold
copyDebugBtn.TextSize = 8
copyDebugBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
copyDebugBtn.TextColor3 = Color3.fromRGB(160, 255, 160)
copyDebugBtn.Parent = debugPanel
Instance.new("UICorner", copyDebugBtn).CornerRadius = UDim.new(0, 6)

copyDebugBtn.MouseButton1Click:Connect(function()
    local allLogs = table.concat(DebugLogs, "\n")
    pcall(function() setclipboard(allLogs) end)
    local orig = copyDebugBtn.Text
    copyDebugBtn.Text = "✓ Copied!"
    copyDebugBtn.BackgroundColor3 = Color3.fromRGB(20, 100, 20)
    task.wait(1.5)
    copyDebugBtn.Text = orig
    copyDebugBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
end)

-- Test hooks button — fires confirm_signal with dummy uniques to test the path
local testReleaseBtn = Instance.new("TextButton")
testReleaseBtn.Size = UDim2.new(0.32, -2, 0, 18)
testReleaseBtn.Position = UDim2.new(0.68, 0, 1, -20)
testReleaseBtn.Text = "🔍 Test Hook Status"
testReleaseBtn.Font = Enum.Font.GothamBold
testReleaseBtn.TextSize = 7
testReleaseBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 80)
testReleaseBtn.TextColor3 = Color3.fromRGB(160, 200, 255)
testReleaseBtn.Parent = debugPanel
Instance.new("UICorner", testReleaseBtn).CornerRadius = UDim.new(0, 6)

testReleaseBtn.MouseButton1Click:Connect(function()
    local PRA = UIManager.apps.PetRecyclerApp
    DebugLog("=== Hook Status Check ===")
    DebugLog("PetRecyclerApp exists: " .. tostring(PRA ~= nil))
    DebugLog("use_pet_recycler hooked: " .. tostring(PRA and PRA.use_pet_recycler ~= nil))
    local spawnedCount = 0
    for _ in pairs(SpawnedItems) do spawnedCount = spawnedCount + 1 end
    DebugLog("SpawnedItems total: " .. spawnedCount)
    local invCount = 0
    local inv = ClientData.get("inventory")
    if inv and inv.pets then
        for _ in pairs(inv.pets) do invCount = invCount + 1 end
    end
    DebugLog("Inventory pets: " .. invCount)
    DebugLog("OriginalRouterGet exists: " .. tostring(OriginalRouterGet ~= nil))

    -- Scan RouterClient cache for food/hatch/egg/open remotes
    DebugLog("=== Scanning for Hatch/Feed remotes ===")
    pcall(function()
        -- Method 1: scan getgc for RouterClient cache table
        for _, v in next, getgc(true) do
            if type(v) == "table" and rawget(v, "get_remote_from_cache") then
                local ok, cache = pcall(debug.getupvalue, v.get_remote_from_cache, 1)
                if ok and type(cache) == "table" then
                    DebugLog("RouterClient cache found, scanning " .. tostring(#cache) .. " entries...")
                    for k in next, cache do
                        if type(k) == "string" then
                            local kl = k:lower()
                            if kl:find("food") or kl:find("feed") or kl:find("hatch")
                            or kl:find("egg") or kl:find("open") or kl:find("potion") then
                                DebugLog("  MATCH: " .. k)
                            end
                        end
                    end
                end
                break
            end
        end
    end)

    -- Method 2: try common names directly via OriginalRouterGet
    local candidates = {
        "FoodAPI/FeedItem", "FoodAPI/Feed", "FoodAPI/UseFood",
        "EggAPI/HatchEgg", "EggAPI/Hatch", "EggAPI/Open",
        "PetAPI/HatchEgg", "PetAPI/FeedPotion",
        "OpenAPI/OpenItem", "OpenAPI/Open",
        "InventoryAPI/OpenItem", "InventoryAPI/UseItem",
        "FeedAPI/Feed", "FeedAPI/FeedItem",
        "ItemAPI/UseItem", "ItemAPI/FeedItem",
    }
    for _, name in ipairs(candidates) do
        local ok2 = pcall(OriginalRouterGet, name)
        if ok2 then
            DebugLog("  LIVE: " .. name)
        end
    end
    DebugLog("========================")
end)

-- =============== END DEBUG PANEL ===============

local deleteButton = Instance.new("TextButton")
deleteButton.Size = UDim2.new(1, 0, 0, 24)
deleteButton.Position = UDim2.new(0, 0, 0, 20)
deleteButton.Text = "🗑️ Delete All Pets"
deleteButton.Font = Enum.Font.GothamBold
deleteButton.TextSize = 9
deleteButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
deleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
deleteButton.Parent = toolsPanel
Instance.new("UICorner", deleteButton).CornerRadius = UDim.new(0, 8)

deleteButton.MouseButton1Click:Connect(function()
    local count = DeleteAllSpawnedPets()
    deleteButton.Text = "✓ DELETED " .. count .. "!"
    task.wait(1)
    deleteButton.Text = "🗑️ Delete All Pets"
end)

-- =============== PET WEAR ===============

-- Items live in inventory.pet_accessories, keyed by unique.
-- avatar_manager.pet[pet_unique][category] = { unique, unique, ... }
-- AvatarClientManager.put_on(avatar_type, category, unique, wrapper)
--   wrapper = { pet_unique, pet_id }

local function SpawnAllPetWear()
    local identity = get_thread_identity and get_thread_identity() or 8
    set_thread_identity(2)

    local inv = ClientData.get("inventory")
    if not inv then set_thread_identity(identity); return 0 end
    inv.pet_accessories = inv.pet_accessories or {}

    local count = 0
    if InventoryDB and InventoryDB.pet_accessories then
        for kind, entry in pairs(InventoryDB.pet_accessories) do
            -- Spawn 5 of each pet wear item with unique suffixes fa_<kind>_1 .. fa_<kind>_5
            for i = 1, 5 do
                local uid = "fa_" .. kind .. "_" .. i
                if not inv.pet_accessories[uid] then
                    inv.pet_accessories[uid] = {
                        unique     = uid,
                        id         = kind,
                        kind       = kind,
                        category   = "pet_accessories",
                        properties = {},
                    }
                    count = count + 1
                end
            end
        end
    end

    ClientData.predict("inventory", inv)
    set_thread_identity(identity)
    print("[PetWear] Spawned " .. count .. " pet accessory items (5x each)")
    return count
end
_G._SpawnAllPetWear = SpawnAllPetWear

local function OpenDressUp()
    local AvatarEditorApp = UIManager and UIManager.apps and UIManager.apps.AvatarEditorApp
    if not AvatarEditorApp then
        print("[PetWear] AvatarEditorApp not found in UIManager.apps")
        return
    end

    -- Find the first fake pet's char_wrapper so the editor focuses it
    local focusedWrapper = nil
    local petWrappers = ClientData.get("pet_char_wrappers") or {}
    for _, wrapper in pairs(petWrappers) do
        if SpawnedPets and SpawnedPets[wrapper.pet_unique] then
            focusedWrapper = wrapper
            break
        end
    end

    pcall(function()
        -- Switch focus to pet mode before opening
        if focusedWrapper and AvatarEditorApp.focus_switcher then
            AvatarEditorApp.focus_switcher:set_focused_avatar_type("pet")
            if AvatarEditorApp.focus_switcher.focus_pet then
                -- Hook focus_pet once so switching pets rebuilds the worn items map
                if not AvatarEditorApp.focus_switcher._fakeWearFocusHooked then
                    AvatarEditorApp.focus_switcher._fakeWearFocusHooked = true
                    local _origFocusPet = AvatarEditorApp.focus_switcher.focus_pet
                    AvatarEditorApp.focus_switcher.focus_pet = function(self, wrapper)
                        local uid = wrapper and wrapper.pet_unique or nil
                        if _G._RebuildWornItemsMapForPet then
                            _G._RebuildWornItemsMapForPet(uid)
                        end
                        return _origFocusPet(self, wrapper)
                    end
                end
                AvatarEditorApp.focus_switcher:focus_pet(focusedWrapper)
            end
        end
        UIManager.set_app_visibility("AvatarEditorApp", true)
        -- Jump straight into the catalog screen (where the categories & items show)
        task.defer(function()
            if AvatarEditorApp.set_screen then
                AvatarEditorApp:set_screen("full_catalog")
            end
        end)
    end)
end

-- Shift existing tools buttons down by 60px to make room
-- deleteButton is at Y=20, scaleLabel at Y=52, scaleControls at Y=63,
-- resetScale at Y=88, lockButton at Y=113  →  add 60 to each
task.defer(function()
    for _, child in ipairs(toolsPanel:GetChildren()) do
        if (child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("Frame"))
            and child.Name ~= "toolsTitle"
            and child ~= toolsPanel
        then
            local pos = child.Position
            -- Only shift items that are NOT the new pet wear buttons (added after this defer)
            if pos.Y.Offset >= 20 and pos.Y.Offset < 200 and
               child.Name ~= "spawnWearButton" and child.Name ~= "dressUpButton" and child.Name ~= "testWearButton" then
                child.Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset + 90)
            end
        end
    end
end)

local spawnWearButton = Instance.new("TextButton")
spawnWearButton.Name = "spawnWearButton"
spawnWearButton.Size = UDim2.new(1, 0, 0, 24)
spawnWearButton.Position = UDim2.new(0, 0, 0, 20)
spawnWearButton.Text = "👗 Spawn All Pet Wear"
spawnWearButton.Font = Enum.Font.GothamBold
spawnWearButton.TextSize = 9
spawnWearButton.BackgroundColor3 = Color3.fromRGB(140, 60, 190)
spawnWearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnWearButton.Parent = toolsPanel
Instance.new("UICorner", spawnWearButton).CornerRadius = UDim.new(0, 8)

spawnWearButton.MouseButton1Click:Connect(function()
    local count = SpawnAllPetWear()
    spawnWearButton.Text = count > 0 and ("✓ " .. count .. " items added!") or "✓ Already spawned!"
    task.wait(1.5)
    spawnWearButton.Text = "👗 Spawn All Pet Wear"
end)

local dressUpButton = Instance.new("TextButton")
dressUpButton.Name = "dressUpButton"
dressUpButton.Size = UDim2.new(1, 0, 0, 24)
dressUpButton.Position = UDim2.new(0, 0, 0, 50)
dressUpButton.Text = "✨ Open Dress Up Tab"
dressUpButton.Font = Enum.Font.GothamBold
dressUpButton.TextSize = 9
dressUpButton.BackgroundColor3 = Color3.fromRGB(60, 110, 210)
dressUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dressUpButton.Parent = toolsPanel
Instance.new("UICorner", dressUpButton).CornerRadius = UDim.new(0, 8)

dressUpButton.MouseButton1Click:Connect(function()
    OpenDressUp()
end)

local testWearButton = Instance.new("TextButton")
testWearButton.Name = "testWearButton"
testWearButton.Size = UDim2.new(1, 0, 0, 24)
testWearButton.Position = UDim2.new(0, 0, 0, 80)
testWearButton.Text = "🐾 Test: Spawn Pet + Wear"
testWearButton.Font = Enum.Font.GothamBold
testWearButton.TextSize = 9
testWearButton.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
testWearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testWearButton.Parent = toolsPanel
Instance.new("UICorner", testWearButton).CornerRadius = UDim.new(0, 8)

testWearButton.MouseButton1Click:Connect(function()
    testWearButton.Text = "⏳ Working..."
    task.spawn(function()
        -- Use the authoritative shared SpawnedPets table
        local sharedPets = _G._ui_SpawnedPets or SpawnedPets

        -- 1. Spawn a random common pet
        local testPetNames = {"Dog", "Cat", "Rabbit", "Chicken", "Horse"}
        local petName = testPetNames[math.random(#testPetNames)]
        local petId = FindPetId(petName)
        if not petId then testWearButton.Text = "❌ Pet not found"; return end

        local petData = CreateInventoryItem(petId, "pets", {
            neon = false, mega_neon = false, flyable = false,
            rideable = false, age = 1, trick_level = 0,
            ailments_completed = 0, rp_name = "__no_name__",
        })
        if not petData then testWearButton.Text = "❌ Failed to create pet"; return end
        EquipPet(petData)

        -- Poll until model is set (FetchPetModel downloads async)
        local petEntry = nil
        for _ = 1, 30 do
            task.wait(0.2)
            petEntry = sharedPets[petData.unique]
            if petEntry and petEntry.model then break end
        end
        if not petEntry or not petEntry.model then
            testWearButton.Text = "❌ No pet model (timeout)"
            return
        end

        -- 3. Pick random accessory from InventoryDB
        local accKinds = {}
        if InventoryDB and InventoryDB.pet_accessories then
            for k, _ in pairs(InventoryDB.pet_accessories) do
                table.insert(accKinds, k)
            end
        end
        if #accKinds == 0 then testWearButton.Text = "❌ No accessories in DB"; return end
        local accKind = accKinds[math.random(#accKinds)]
        local accEntry = InventoryDB.pet_accessories[accKind]
        local accCat = accEntry and accEntry.category or "hats"
        print("[TestWear] Attaching: " .. accKind .. " (cat=" .. accCat .. ")")

        -- 4. Attach directly
        local attachFn = _G._FakePetWearAttach
        if not attachFn then testWearButton.Text = "❌ No attach fn"; return end

        local fakeUnique = "fa_" .. accKind
        attachFn(petData.unique, fakeUnique, accCat)

        -- Verify it appeared in the model
        task.wait(0.5)
        local found = false
        for _, desc in ipairs(petEntry.model:GetDescendants()) do
            if desc:GetAttribute("_fakeWearUnique") == fakeUnique then
                found = true
                print("[TestWear] ✓ Tagged part found: " .. desc.Name .. " class=" .. desc.ClassName)
                break
            end
        end
        if found then
            testWearButton.Text = "✓ " .. petName .. " wearing " .. accKind
        else
            testWearButton.Text = "❌ Part not in model after attach"
            print("[TestWear] ❌ _fakeWearUnique tag not found anywhere in model")
        end

        task.wait(4)
        testWearButton.Text = "🐾 Test: Spawn Pet + Wear"
    end)
end)

-- =============== END PET WEAR ===============

-- =============== SALON: client-side only ===============

local SALON_CFRAME = CFrame.new(79.1913986, 6960.68359, 5975.72803, 0.970097661, 0, -0.24271521, 0, 1, 0, 0.242715225, 0, 0.970097601)
local _SalonPetUID = nil

local function RemoveFakePetFromSalon()
    _SalonPetUID = nil
end

local function PlaceFakePetInSalon(fakePetUniqueId)
    _SalonPetUID = fakePetUniqueId
    local fakeData = SpawnedPets[fakePetUniqueId]
    local model = fakeData and fakeData.model
    if not model then print("no model"); return false end
    model:PivotTo(SALON_CFRAME)
    print("pet moved to salon")
    return true
end

_G.PlaceFakePetInSalon   = PlaceFakePetInSalon
_G.RemoveFakePetFromSalon = RemoveFakePetFromSalon

-- =============== END SALON PLACEMENT ===============

-- Hook into PetColorHelper for recoloring pets placed in the game
local OriginalColorPet = PetColorHelper.color_pet

-- Function to detect if a model is a spawned fake pet
local function IsFakePet(petModel)
    if not petModel then return false end
    
    -- Check if it's in our SpawnedPets table
    for uniqueId, petData in pairs(SpawnedPets) do
        if petData.model == petModel then
            return true, uniqueId, petData
        end
    end
    
    return false
end

-- Function to get pet model from various sources
local function GetPetModel(input)
    -- If it's already a model, return it
    if input and input:IsA("Model") then
        return input
    end
    
    -- If it's a string (pet unique ID), find it in SpawnedPets
    if typeof(input) == "string" then
        local petData = SpawnedPets[input]
        if petData and petData.model then
            return petData.model
        end
    end
    
    return nil
end


-- Function to recolor any pet (real, spawned, or fake)
local function RecolorPetInGame(petModel, colorName)
    if not petModel then
        print("❌ Invalid pet model")
        return false
    end
    
    -- Get actual model if it's a unique ID
    petModel = GetPetModel(petModel)
    if not petModel then
        print("❌ Could not find pet model")
        return false
    end
    
    -- Find paint entry by name
    local paintEntry = nil
    for _, paint in pairs(PaintColorDB) do
        if paint.name:lower() == colorName:lower() then
            paintEntry = paint
            break
        end
    end
    
    if not paintEntry then
        print("❌ Color not found: " .. colorName)
        return false
    end
    
    -- Check if this is a fake pet
    local isFake, uniqueId, petData = IsFakePet(petModel)
    
    if isFake then
        -- For fake pets, we apply colors directly
        print("🎨 Recoloring fake pet: " .. (petData.data.properties.rp_name or "Unknown"))
        
        local sortedColors = PetColorHelper.get_sorted_color_data(petModel)
        local colorArray = {}
        for i, _ in ipairs(sortedColors) do
            colorArray[i] = {paintEntry.color.R, paintEntry.color.G, paintEntry.color.B}
        end
        
        -- Apply color using the game's native function
        PetColorHelper.color_pet(petModel, colorArray, {
            entry = paintEntry,
            is_neon = petData.data.properties.neon or false,
            is_mega = petData.data.properties.mega_neon or false
        })
        
        return true
    else
        -- For real game pets, use the native system
        print("🎨 Recoloring real game pet in salon")
        
        local sortedColors = PetColorHelper.get_sorted_color_data(petModel)
        local colorArray = {}
        for i, _ in ipairs(sortedColors) do
            colorArray[i] = {paintEntry.color.R, paintEntry.color.G, paintEntry.color.B}
        end
        
        PetColorHelper.color_pet(petModel, colorArray, {
            entry = paintEntry,
            is_neon = false,
            is_mega = false
        })
        
        return true
    end
end

-- Make recolor function globally accessible
_G.RecolorPet = function(petModelOrId, colorName)
    if RecolorPetInGame(petModelOrId, colorName) then
        print("✅ Successfully recolored pet to: " .. colorName)
        return true
    else
        return false
    end
end

_G.GetAvailableColors = function()
    return GetAvailablePaintColors()
end

-- Helper function to list all spawned fake pets
_G.GetSpawnedPets = function()
    local pets = {}
    for uniqueId, petData in pairs(SpawnedPets) do
        if petData.model then
            table.insert(pets, {
                id = uniqueId,
                name = petData.data.properties.rp_name or "Unknown",
                petType = petData.data.id,
                model = petData.model
            })
        end
    end
    return pets
end

-- Helper function to recolor all spawned fake pets
_G.RecolorAllFakePets = function(colorName)
    local spawnedPets = _G.GetSpawnedPets()
    local success = 0
    local failed = 0
    
    for _, pet in ipairs(spawnedPets) do
        if RecolorPetInGame(pet.model, colorName) then
            success = success + 1
        else
            failed = failed + 1
        end
    end
    
    print("✅ Recolored " .. success .. " pets | ❌ Failed " .. failed)
    return success, failed
end

-- =============== END RECOLOR SECTION ===============

local scaleLabel = Instance.new("TextLabel")
scaleLabel.Size = UDim2.new(1, 0, 0, 10)
scaleLabel.Position = UDim2.new(0, 0, 0, 52)
scaleLabel.BackgroundTransparency = 1
scaleLabel.Text = "📏 UI Scale (70% default)"
scaleLabel.Font = Enum.Font.Gotham
scaleLabel.TextSize = 7
scaleLabel.TextColor3 = Color3.fromRGB(160, 170, 200)
scaleLabel.TextXAlignment = Enum.TextXAlignment.Left
scaleLabel.Parent = toolsPanel

local scaleControls = Instance.new("Frame")
scaleControls.Size = UDim2.new(1, 0, 0, 20)
scaleControls.Position = UDim2.new(0, 0, 0, 63)
scaleControls.BackgroundTransparency = 1
scaleControls.Parent = toolsPanel

local scaleDown = Instance.new("TextButton")
scaleDown.Size = UDim2.new(0.2, 0, 1, 0)
scaleDown.Position = UDim2.new(0, 0, 0, 0)
scaleDown.Text = "−"
scaleDown.Font = Enum.Font.GothamBold
scaleDown.TextSize = 12
scaleDown.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
scaleDown.TextColor3 = Color3.fromRGB(255, 255, 255)
scaleDown.Parent = scaleControls
Instance.new("UICorner", scaleDown).CornerRadius = UDim.new(0, 6)

local scaleValue = Instance.new("TextLabel")
scaleValue.Size = UDim2.new(0.5, 0, 1, 0)
scaleValue.Position = UDim2.new(0.25, 0, 0, 0)
scaleValue.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
scaleValue.TextColor3 = Color3.fromRGB(240, 240, 255)
scaleValue.Text = "70%"
scaleValue.Font = Enum.Font.GothamBold
scaleValue.TextSize = 9
scaleValue.Parent = scaleControls
Instance.new("UICorner", scaleValue).CornerRadius = UDim.new(0, 6)

local scaleUp = Instance.new("TextButton")
scaleUp.Size = UDim2.new(0.2, 0, 1, 0)
scaleUp.Position = UDim2.new(0.8, 0, 0, 0)
scaleUp.Text = "+"
scaleUp.Font = Enum.Font.GothamBold
scaleUp.TextSize = 12
scaleUp.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
scaleUp.TextColor3 = Color3.fromRGB(255, 255, 255)
scaleUp.Parent = scaleControls
Instance.new("UICorner", scaleUp).CornerRadius = UDim.new(0, 6)

local resetScale = Instance.new("TextButton")
resetScale.Size = UDim2.new(1, 0, 0, 20)
resetScale.Position = UDim2.new(0, 0, 0, 88)
resetScale.Text = "↪️ Reset to 70%"
resetScale.Font = Enum.Font.GothamBold
resetScale.TextSize = 8
resetScale.BackgroundColor3 = Color3.fromRGB(100, 100, 180)
resetScale.TextColor3 = Color3.fromRGB(255, 255, 255)
resetScale.Parent = toolsPanel
Instance.new("UICorner", resetScale).CornerRadius = UDim.new(0, 6)

local lockButton = Instance.new("TextButton")
lockButton.Size = UDim2.new(1, 0, 0, 20)
lockButton.Position = UDim2.new(0, 0, 0, 113)
lockButton.Text = "🔓 Unlocked"
lockButton.Font = Enum.Font.GothamBold
lockButton.TextSize = 8
lockButton.BackgroundColor3 = Color3.fromRGB(150, 150, 50)
lockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockButton.Parent = toolsPanel
Instance.new("UICorner", lockButton).CornerRadius = UDim.new(0, 6)

local currentScale = 0.7

scaleDown.MouseButton1Click:Connect(function()
    currentScale = math.max(0.5, currentScale - 0.1)
    uiScale.Scale = currentScale
    scaleValue.Text = math.floor(currentScale * 100) .. "%"
end)

scaleUp.MouseButton1Click:Connect(function()
    currentScale = math.min(2.0, currentScale + 0.1)
    uiScale.Scale = currentScale
    scaleValue.Text = math.floor(currentScale * 100) .. "%"
end)

resetScale.MouseButton1Click:Connect(function()
    currentScale = 0.7
    uiScale.Scale = currentScale
    scaleValue.Text = "70%"
end)

local uiLocked = false
lockButton.MouseButton1Click:Connect(function()
    uiLocked = not uiLocked
    if uiLocked then
        lockButton.Text = "🔒 Locked"
        lockButton.BackgroundColor3 = Color3.fromRGB(50, 150, 150)
    else
        lockButton.Text = "🔓 Unlocked"
        lockButton.BackgroundColor3 = Color3.fromRGB(150, 150, 50)
    end
end)

local dragging = false
local dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if not uiLocked and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if not uiLocked and dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

tabElements.Spawn.button.MouseButton1Click:Connect(function()
    spawnPanel.Visible = true
    toolsPanel.Visible = false
    miscPanel.Visible = false
    debugPanel.Visible = false
end)

tabElements.Tools.button.MouseButton1Click:Connect(function()
    spawnPanel.Visible = false
    toolsPanel.Visible = true
    miscPanel.Visible = false
    debugPanel.Visible = false
end)

tabElements.Misc.button.MouseButton1Click:Connect(function()
    spawnPanel.Visible = false
    toolsPanel.Visible = false
    miscPanel.Visible = true
    debugPanel.Visible = false
    PaintRefreshPetList()
end)



tabElements.Debug.button.MouseButton1Click:Connect(function()
    spawnPanel.Visible = false
    toolsPanel.Visible = false
    miscPanel.Visible = false
    debugPanel.Visible = true
end)


spawnButton.MouseButton1Click:Connect(function()
    local petName = nameInput.Text
    if petName == "" then return end
    
    local petId = FindPetId(petName)
    if not petId then return end
    
    local ageMap = {1, 2, 3, 4, 5, 6}
    
    local options = {
        mega_neon = flagState["M"],
        neon = flagState["N"],
        flyable = flagState["F"],
        rideable = flagState["R"],
        age = ageMap[currentAge.v],
        trick_level = 5,
        ailments_completed = 0,
        rp_name = GenerateUniquePetName(petId)
    }
    
    if options.neon or options.mega_neon then
        options.age = 6
    end
    
    local item = CreateInventoryItem(petId, "pets", options)
    if item then
        spawnButton.Text = "✓ SPAWNED!"
        task.wait(0.5)
        spawnButton.Text = "✨ SPAWN PET"
    end
end)

spawnAllButton.MouseButton1Click:Connect(function()
    local ageMap = {1, 2, 3, 4, 5, 6}
    
    local options = {
        mega_neon = flagState["M"],
        neon = flagState["N"],
        flyable = flagState["F"],
        rideable = flagState["R"],
        age = ageMap[currentAge.v],
        trick_level = 5,
        ailments_completed = 0
    }
    
    if options.neon or options.mega_neon then
        options.age = 6
    end
    
    local successCount = 0
    spawnAllButton.Text = "⚡ SPAWNING..."
    
    for _, petName in ipairs(HighTierPets) do
        local petId = FindPetId(petName)
        if petId then
            local petOptions = table.clone(options)
            petOptions.rp_name = GenerateUniquePetName(petId)
            
            local item = CreateInventoryItem(petId, "pets", petOptions)
            if item then
                successCount = successCount + 1
            end
        end
    end
    
    spawnAllButton.Text = "✓ SPAWNED " .. successCount .. "!"
    task.wait(1.5)
    spawnAllButton.Text = "👑 SPAWN ALL HIGH TIERS"
end)

nameInput:GetPropertyChangedSignal("Text"):Connect(function()
    local text = nameInput.Text
    if text == "" then
        inputGlow.Color = glowColors.neutral
        return
    end
    
    local isValid = FindPetId(text) ~= nil
    inputGlow.Color = isValid and glowColors.valid or glowColors.invalid
end)

]]);if not _lf1 then error("Block2 compile error: "..tostring(_le1)) end _lf1() end


-- =============== SEARCH FILTER FIX ===============
-- The game's search checks rp_name (our random names like "Shadow") which causes
-- wrong pets to appear (e.g. searching "Shadow Dragon" matches a pet named "Shadow").
-- We hook is_filtered_out so spawned pets are always matched by their real pet name.

task.defer(function()
    local BackpackApp = UIManager.apps.BackpackApp
    local originalIsFilteredOut = BackpackApp.is_filtered_out

    function BackpackApp.is_filtered_out(self, item_data)
        -- Only intercept our spawned pets
        if item_data and item_data.properties and SpawnedItems[item_data.unique] then
            local savedRpName = item_data.properties.rp_name

            -- Substitute the real pet name so search matches "Bat Dragon" not "Shadow ✨"
            local realName = InventoryDB.pets
                and InventoryDB.pets[item_data.id]
                and InventoryDB.pets[item_data.id].name
                or savedRpName

            item_data.properties.rp_name = realName
            local result = originalIsFilteredOut(self, item_data)
            item_data.properties.rp_name = savedRpName  -- restore immediately after
            return result
        end
        return originalIsFilteredOut(self, item_data)
    end
end)

-- =============== END SEARCH FILTER FIX ===============

-- =============== FIREBASE SLOT PERSISTENCE ===============

_G._sp_LP5  = game.Players.LocalPlayer.UserId
_G._sp_CII5 = CreateInventoryItem
_G._sp_SI5  = SpawnedItems
_G._sp_UM5  = UIManager
_G._sp_FSI5 = {}

do local _lf2,_le2=loadstring([[
local DebugLog = _G._DebugLog or function() end
local PLAYER_ID = tostring(_G._sp_LP5)
local CII       = _G._sp_CII5
local SI        = _G._sp_SI5
local UM        = _G._sp_UM5
local FSI       = _G._sp_FSI5
_G._sp_LP5=nil _G._sp_CII5=nil _G._sp_SI5=nil _G._sp_UM5=nil

local HttpService  = game:GetService("HttpService")
local FIREBASE_URL = "https://adoptme-spawner-default-rtdb.asia-southeast1.firebasedatabase.app"
local FIREBASE_KEY = "AIzaSyBUOUMwoqBv1z0ye06b28djNZUntAaXJJ0"
local httpRequest  = (syn and syn.request) or request or http_request or function() return {Body="null"} end

-- Debug output — prints to console with [FB] prefix
local function dbg(msg)
    print("[FB] " .. tostring(msg))
end

local function fbUrl(path)
    return FIREBASE_URL.."/slots/"..PLAYER_ID.."/"..path..".json?auth="..FIREBASE_KEY
end

local function fbGet(path)
    dbg("GET " .. path)
    local ok, res = pcall(function() return httpRequest({Url=fbUrl(path), Method="GET"}) end)
    if not ok then dbg("GET error: " .. tostring(res)); return nil end
    dbg("GET status: " .. tostring(res and res.StatusCode))
    dbg("GET body: " .. tostring(res and res.Body and res.Body:sub(1,200)))
    if res and res.Body and res.Body ~= "null" then
        local ok2, d = pcall(function() return HttpService:JSONDecode(res.Body) end)
        if ok2 and d then return d end
        dbg("JSON decode failed: " .. tostring(d))
    end
    return nil
end

local function fbSet(path, data)
    dbg("SET " .. path)
    local ok, err = pcall(function()
        local body = HttpService:JSONEncode(data)
        dbg("SET body: " .. body:sub(1,200))
        local res = httpRequest({
            Url=fbUrl(path), Method="PUT",
            Headers={["Content-Type"]="application/json"},
            Body=body
        })
        dbg("SET status: " .. tostring(res and res.StatusCode))
        dbg("SET response: " .. tostring(res and res.Body and res.Body:sub(1,200)))
    end)
    if not ok then dbg("SET error: " .. tostring(err)) end
end

local function saveAll()
    task.spawn(function()
        dbg("saveAll called — FSI has " .. (function() local n=0; for _ in pairs(FSI) do n=n+1 end; return n end)() .. " pages")
        local all = {}
        for page, slots in pairs(FSI) do
            all[tostring(page)] = {}
            for slot, items in pairs(slots) do
                local t = {}
                for _, item in ipairs(items) do
                    table.insert(t, {id=item.id, properties=item.properties})
                end
                all[tostring(page)][tostring(slot)] = t
                dbg("Saving page="..page.." slot="..slot.." items="..#items)
            end
        end
        fbSet("pages", all)
    end)
end
_G._sp_saveSlot = function(p, s)
    task.spawn(function()
        local t = {}
        if FSI[p] and FSI[p][s] then
            for _, item in ipairs(FSI[p][s]) do
                table.insert(t, {id=item.id, properties=item.properties})
            end
        end
        dbg("saveSlot page="..p.." slot="..s.." items="..#t)
        fbSet("pages/"..p.."/"..s, t)
    end)
end

game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    dbg("CharacterRemoving — saving all")
    saveAll()
end)
task.spawn(function()
    while true do
        task.wait(30)
        if next(FSI) then
            dbg("30s autosave")
            saveAll()
        end
    end
end)

-- LOAD
task.spawn(function()
    dbg("=== LOAD START ===")
    dbg("httpRequest type: " .. type(httpRequest))
    dbg("Player ID: " .. PLAYER_ID)
    dbg("CII type: " .. type(CII))
    dbg("UM type: " .. type(UM))

    local data = fbGet("pages")
    if not data then
        dbg("No data returned from Firebase — nothing to load")
        return
    end

    dbg("Data loaded. Pages: " .. (function() local n=0; for _ in pairs(data) do n=n+1 end; return n end)())

    -- Spawn pets
    for page, slots in pairs(data) do
        local p = tonumber(page)
        if not p then dbg("Bad page key: "..tostring(page)); continue end
        FSI[p] = {}
        for slot, items in pairs(slots) do
            local s = tonumber(slot)
            if not s then dbg("Bad slot key: "..tostring(slot)); continue end
            if type(items) ~= "table" then dbg("Items not table for page="..page.." slot="..slot); continue end
            FSI[p][s] = {}
            dbg("Page="..p.." Slot="..s.." has "..#items.." items")
            for i, saved in ipairs(items) do
                dbg("  Item "..i..": id="..tostring(saved.id))
                if not saved.id then dbg("  SKIP — no id"); continue end
                local props = {}
                if type(saved.properties) == "table" then
                    for k,v in pairs(saved.properties) do props[k]=v end
                end
                props.flyable = props.flyable ~= false
                props.rideable = props.rideable ~= false
                props.age = props.age or 6
                props.ailments_completed = props.ailments_completed or 0
                local ok, newItem = pcall(CII, saved.id, "pets", props)
                if ok and newItem then
                    table.insert(FSI[p][s], {
                        id=newItem.id, kind=newItem.kind,
                        category=newItem.category, unique=newItem.unique,
                        properties=newItem.properties
                    })
                    dbg("  Spawned OK — unique="..newItem.unique)
                else
                    dbg("  CII FAILED: "..tostring(newItem))
                end
            end
        end
    end

    pcall(function() UM.apps.BackpackApp:refresh_rendered_items() end)
    dbg("Backpack refreshed")

    -- Wait for profile
    local ProfileApp = UM.apps.PlayerProfileApp
    dbg("ProfileApp: "..tostring(ProfileApp))
    local waited = 0
    while waited < 15 do
        task.wait(0.5); waited = waited + 0.5
        local pp = ProfileApp and ProfileApp.player_profile
        if pp and pp.profile_data then
            dbg("Profile ready after "..waited.."s")
            break
        end
    end

    local pp = ProfileApp and ProfileApp.player_profile
    dbg("player_profile: "..tostring(pp))
    if pp then dbg("profile_data: "..tostring(pp.profile_data)) end

    if not pp or not pp.profile_data then
        dbg("Profile not open — will inject via CW.start when profile opens")
        return
    end

    -- Inject into widgets
    for page, slots in pairs(FSI) do
        for slot, items in pairs(slots) do
            if #items == 0 then continue end
            dbg("Injecting page="..page.." slot="..slot.." items="..#items)
            pcall(function()
                local widget
                for _, w in pairs(ProfileApp) do
                    if type(w) == "table" and w.page == page and w.slot == slot then
                        widget = w; break
                    end
                end
                dbg("Widget search result: "..tostring(widget))
                if widget and widget.save_data then
                    widget.save_data.items = widget.save_data.items or {}
                    for _, item in ipairs(items) do
                        table.insert(widget.save_data.items, {
                            kind=item.kind, category=item.category,
                            unique=item.unique, properties=item.properties
                        })
                    end
                    widget:render()
                    dbg("Rendered widget page="..page.." slot="..slot)
                else
                    dbg("Widget not found — CW.start hook will handle it")
                end
            end)
        end
    end
    dbg("=== LOAD COMPLETE ===")
end)

local Fsys = require(game.ReplicatedStorage:WaitForChild("Fsys"))
local CW   = Fsys.load("CollectionPlayerProfileWidget")

local _origStart = CW.start
function CW.start(self, slotData, arg3)
    local p, s = self.page, self.slot
    dbg("CW.start called page="..tostring(p).." slot="..tostring(s))
    if p and s and FSI[p] and FSI[p][s] and #FSI[p][s] > 0 then
        dbg("Injecting "..#FSI[p][s].." items into CW.start")
        slotData = slotData or {}
        slotData.items = slotData.items or {}
        local existing = {}
        for _, item in ipairs(slotData.items) do existing[item.unique] = true end
        for _, item in ipairs(FSI[p][s]) do
            if not existing[item.unique] then
                table.insert(slotData.items, item)
            end
        end
    end
    return _origStart(self, slotData, arg3)
end

local _origPick = CW.pick_new_item
function CW.pick_new_item(self, replaceIndex)
    local result = _origPick(self, replaceIndex)
    if result and SI[result.unique] then
        local p, s = self.page, self.slot
        dbg("pick_new_item: fake pet picked page="..tostring(p).." slot="..tostring(s).." unique="..result.unique)
        if p and s then
            FSI[p] = FSI[p] or {}
            FSI[p][s] = FSI[p][s] or {}
            for i = #FSI[p][s], 1, -1 do
                if FSI[p][s][i].unique == result.unique then table.remove(FSI[p][s], i) end
            end
            if replaceIndex then table.insert(FSI[p][s], replaceIndex, result)
            else table.insert(FSI[p][s], result) end
            dbg("FSI updated — now "..#FSI[p][s].." items in page="..p.." slot="..s)
            _G._sp_saveSlot(p, s)
        end
    end
    return result
end

local _origRemove = CW.remove_item
function CW.remove_item(self, index)
    local items = self.save_data and self.save_data.items
    local p, s = self.page, self.slot
    if items and items[index] and SI[items[index].unique] and p and s then
        local uid = items[index].unique
        if FSI[p] and FSI[p][s] then
            for i = #FSI[p][s], 1, -1 do
                if FSI[p][s][i].unique == uid then table.remove(FSI[p][s], i); break end
            end
            _G._sp_saveSlot(p, s)
        end
    end
    return _origRemove(self, index)
end
]]);if not _lf2 then error("Block3 compile error: "..tostring(_le2)) end _lf2() end

-- =============== END FIREBASE SLOT PERSISTENCE ===============

print("blueprint.lua on discord for scripts. Credits to m0_3a as this script uses some functions from his script!")

-- ═══════════════════════════════════════════════════
-- AUTO SPAWN ALL PET WEAR ON EXECUTE
-- ═══════════════════════════════════════════════════
task.spawn(function()
    task.wait(2) -- wait for ClientData to be ready
    if _G._SpawnAllPetWear then
        local count = _G._SpawnAllPetWear()
        print("[PetWear] Auto-spawned " .. count .. " items (5x each kind) on execute")
    else
        warn("[PetWear] SpawnAllPetWear not available")
    end
end)
