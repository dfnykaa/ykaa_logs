local manifestUrl = "https://raw.githubusercontent.com/dfnykaa/ykaa_logs/main/fxmanifest.lua"
local repoUrl = "https://github.com/dfnykaa/ykaa_logs"
local notified = false

local L = setmetatable({}, { __index = function(_, k)
    local cur = Locales[ykaa.Locale]
    local v = cur[k]
    if v == nil then v = en[k] end
    if v == nil then return tostring(k) end
    return v
end })

local function parse(v)
    local t = {}
    for n in tostring(v):gmatch("%d+") do
        t[#t + 1] = tonumber(n)
    end
    return t
end

local function isNewer(remote, current)
    local a, b = parse(remote), parse(current)
    for i = 1, math.max(#a, #b) do
        local x, y = a[i] or 0, b[i] or 0
        if x ~= y then return x > y end
    end
    return false
end

local function check()
    local current = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
    if not current then return end

    PerformHttpRequest(manifestUrl, function(code, body)
        if code ~= 200 or not body then
            print("^3[INFO] ^6[YKAA LOGS] ^3[WARNING] " .. L.update_failed .. " (" .. tostring(code) .. ")")
            return
        end

        local remote = body:match("version%s+['\"]([%d%.]+)['\"]")
        if not remote then return end

        if isNewer(remote, current) then
            if notified then return end
            notified = true
            print("^3[INFO] ^6[YKAA LOGS] ^3" .. L.update_available)
            print("^3[INFO] ^6[YKAA LOGS] ^7" .. L.update_yours .. ": ^1" .. current .. "^7 | " .. L.update_new .. ": ^2" .. remote)
            print("^3[INFO] ^6[YKAA LOGS] ^7" .. L.update_download .. ": ^5" .. repoUrl)
        else
            print("^3[INFO] ^6[YKAA LOGS] ^2" .. L.update_latest .. " (" .. current .. ")")
        end
    end, "GET")
end

CreateThread(function()
    if not ykaa.VersionCheck then return end

    Wait(5000)
    check()
    while true do
        Wait(6 * 60 * 60 * 1000)
        check()
    end
end)

AddEventHandler("onResourceStart", function(r)
    if r ~= GetCurrentResourceName() then return end
    if r ~= "ykaa_logs" then
        print("[YKAA LOGS] WARNING: Resource was renamed!")
    end
    print("[YKAA LOGS] Running version " .. tostring(GetResourceMetadata(r, "version", 0)))
end)