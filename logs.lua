local webhook = "YOUR_WEBHOOK_URL"

local lastShot = {}
local lastDeath = {}
local lastExplosion = {}
local weaponNames = {}
local causeNames = {}
local queue = {}
local running = false

local L = setmetatable({}, { __index = function(_, k)
    local cur = Locales[ykaa.Locale] or {}
    local en = Locales["en"] or {}
    local v = cur[k]
    if v == nil then v = en[k] end
    if v == nil then return tostring(k) end
    return v
end })

CreateThread(function()
    for _, name in ipairs(ykaa.Weapons or {}) do
        weaponNames[GetHashKey(name) & 0xFFFFFFFF] = name
    end

    for name, label in pairs(L.causes or {}) do
        causeNames[GetHashKey(name) & 0xFFFFFFFF] = label
    end
end)

local function weaponName(hash)
    if type(hash) ~= "number" then return "N/A" end
    local h = hash & 0xFFFFFFFF
    return weaponNames[h] or string.format("0x%X", h)
end

local function runQueue()
    if running then return end
    running = true

    CreateThread(function()
        while #queue > 0 do
            local job = table.remove(queue, 1)
            local finished = false
            local delay = 1000
            local waited = 0

            job.run(function(code, retry)
                if code == 429 then
                    delay = math.ceil((tonumber(retry) or 2) * 1000) + 250
                    if job.tries < 3 then
                        job.tries = job.tries + 1
                        table.insert(queue, 1, job)
                    else
                        print("^6[YKAA LOGS] ^3[WARNING] " .. job.label .. " (429)")
                    end
                elseif code ~= 200 and code ~= 204 then
                    print("^6[YKAA LOGS] ^3[WARNING] " .. job.label .. " (" .. tostring(code) .. ")")
                end
                finished = true
            end)

            while not finished and waited < 20000 do
                Wait(50)
                waited = waited + 50
            end

            Wait(delay)
        end

        running = false
    end)
end

local function enqueue(job)
    if #queue >= 40 then return end
    job.tries = 0
    queue[#queue + 1] = job
    runQueue()
end

local function post(payload, url)
    local target = url or webhook
    if not target or target == "" then return end

    enqueue({
        label = "Webhook error",
        run = function(done)
            PerformHttpRequest(target, function(code, _, headers)
                local retry = headers and (headers["retry-after"] or headers["Retry-After"])
                done(code, retry)
            end, "POST", json.encode(payload), { ["Content-Type"] = "application/json" })
        end
    })
end

local function upload(payload, data)
    enqueue({
        label = "Screenshot upload failed",
        run = function(done)
            local clean = tostring(data):gsub("^data:image/%w+;base64,", "")
            local boundary = "----ykaalogs" .. tostring(os.time())
            local payloadJson = json.encode(payload)

            local CRLF = "\r\n"
            local bodyParts = {}
            bodyParts[#bodyParts + 1] = "--" .. boundary .. CRLF
            bodyParts[#bodyParts + 1] = "Content-Disposition: form-data; name=\"payload_json\"" .. CRLF
            bodyParts[#bodyParts + 1] = "Content-Type: application/json" .. CRLF .. CRLF
            bodyParts[#bodyParts + 1] = payloadJson .. CRLF
            bodyParts[#bodyParts + 1] = "--" .. boundary .. CRLF
            bodyParts[#bodyParts + 1] = "Content-Disposition: form-data; name=\"files[0]\"; filename=\"screenshot.jpg\"" .. CRLF
            bodyParts[#bodyParts + 1] = "Content-Type: image/jpeg" .. CRLF
            bodyParts[#bodyParts + 1] = "Content-Transfer-Encoding: base64" .. CRLF .. CRLF
            bodyParts[#bodyParts + 1] = clean .. CRLF
            bodyParts[#bodyParts + 1] = "--" .. boundary .. "--" .. CRLF

            local body = table.concat(bodyParts)
            local target = webhook

            PerformHttpRequest(target, function(code, _, headers)
                local retry = headers and (headers["retry-after"] or headers["Retry-After"])
                done(code, retry)
            end, "POST", body, {
                ["Content-Type"] = "multipart/form-data; boundary=" .. boundary,
            })
        end
    })
end

exports("ykaa_logs", function(url, data)
    if not url or not data then return end
    post(data, url)
end)

local function getInfo(src, fallback)
    local dc = GetPlayerIdentifierByType(src, "discord")
    return {
        id = src,
        name = GetPlayerName(src) or fallback
        discord = dc and dc:gsub("discord:", "") or nil,
        steam = GetPlayerIdentifierByType(src, "steam")
        license = GetPlayerIdentifierByType(src, "license")
        ip = GetPlayerEndpoint(src)
    }
end

local function playerText(info)
    local dc = info.discord and ("<@" .. info.discord .. "> (`" .. info.discord .. "`)")
    return "**" .. L.fivem_name .. ":** " .. info.name .. "\n" ..
        "**" .. L.server_id .. ":** " .. info.id .. "\n" ..
        "**" .. L.discord .. ":** " .. dc .. "\n" ..
        "**" .. L.steam .. ":** `" .. info.steam .. "`\n" ..
        "**" .. L.license .. ":** `" .. info.license .. "`\n" ..
        "**" .. L.ip .. ":** `" .. info.ip .. "`"
end

local function now()
    return os.date("%d.%m.%Y %H:%M:%S")
end

local function embed(color, title, desc, fields)
    return {
        color = color,
        title = title,
        description = desc,
        fields = fields,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        footer = { text = "YKAA Logs • " .. now() }
    }
end

local function field(name, value, inline)
    return { name = name, value = tostring(value), inline = inline ~= false }
end

local function send(embeds, shotSrc)
    local payload = {
        username = ykaa.WebhookName or "YKAA Logs",
        avatar_url = ykaa.AvatarURL,
        embeds = embeds
    }

    local canShot = ykaa.Screenshot and shotSrc and GetPlayerName(shotSrc)
        and GetResourceState("screenshot-basic") == "started"

    if canShot then
        local t = os.time()
        local cd = ykaa.ScreenshotCooldown or 10
        if cd > 0 and lastShot[shotSrc] and t - lastShot[shotSrc] < cd then
            canShot = false
        else
            lastShot[shotSrc] = t
        end
    end

    if not canShot then
        post(payload)
        return
    end

    local sent = false
    SetTimeout(8000, function()
        if sent then return end
        sent = true
        post(payload)
    end)

    exports["screenshot-basic"]:requestClientScreenshot(shotSrc, { encoding = "jpg", quality = 0.6 }, function(err, data)
        if sent then return end
        sent = true

        if err or not data then
            post(payload)
            return
        end

        embeds[1].image = { url = "attachment://screenshot.jpg" }
        upload(payload, data)
    end)
end

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    if not ykaa.Join then return end
    local src = tonumber(source)
    deferrals.defer()
    Wait(0)

    send({ embed(ykaa.Colors.join, L.join_title, playerText(getInfo(src, name)), {
        field(L.action, L.act_join),
        field(L.time, now()),
    }) })
    deferrals.done()
end)

AddEventHandler("playerDropped", function()
    local src = tonumber(source)
    local info = getInfo(src)
    lastShot[src] = nil
    lastDeath[src] = nil
    lastExplosion[src] = nil

    if not ykaa.Leave then return end

    send({ embed(ykaa.Colors.leave, L.leave_title, playerText(info), {
        field(L.action, L.act_leave),
        field(L.time, now()),
    }) })
end)

AddEventHandler("chatMessage", function(src, author, message)
    src = tonumber(src)
    if not src or not message then return end

    local info = getInfo(src)
    local low = message:lower()

    for _, word in ipairs(ykaa.BlacklistWords) do
        local w = tostring(word):lower()
        if w ~= "" and low:find(w, 1, true) then
            send({ embed(ykaa.Colors.blacklist, L.chat_blacklist_title, playerText(info), {
                field(L.action, L.act_blacklist),
                field(L.time, now()),
                field(L.blacklist_message, message, false),
            }) })
            DropPlayer(src, L.blacklist_kick)
            CancelEvent()
            return
        end
    end

    if not ykaa.Chat then return end

    send({ embed(ykaa.Colors.chat, L.chat_msg_title, playerText(info), {
        field(L.action, L.act_chat),
        field(L.time, now()),
        field(L.message, message, false),
    }) })
end)

AddEventHandler("explosionEvent", function(src, ev)
    if not ykaa.Explosion then return end
    src = tonumber(src)
    if not src or src <= 0 or not GetPlayerName(src) then return end

    local t = os.time()
    local cd = ykaa.ExplosionCooldown
    if lastExplosion[src] and t - lastExplosion[src] < cd then return end
    lastExplosion[src] = t

    local expName = (ykaa.Explosions and ykaa.Explosions[ev.explosionType]) or ("Unknown (" .. tostring(ev.explosionType) .. ")")
    local pos = string.format("X: %d | Y: %d | Z: %d", math.floor(ev.posX or 0), math.floor(ev.posY or 0), math.floor(ev.posZ or 0))

    send({ embed(ykaa.Colors.explosion, L.explosion_title, playerText(getInfo(src)), {
        field(L.action, L.act_explosion),
        field(L.time, now()),
        field(L.type, expName),
        field(L.position, "`" .. pos .. "`", false),
    }) }, src)
end)

local validTypes = { player = true, npc = true, vehicle = true, suicide = true, environment = true }

RegisterNetEvent("ykaa_logs:playerDied", function(killerId, weapon, killerType, coords, distance, vehicleName)
    if not ykaa.Death then return end

    local victimSrc = tonumber(source)
    if not victimSrc or not GetPlayerName(victimSrc) then return end

    killerId = tonumber(killerId)
    weapon = tonumber(weapon)
    distance = tonumber(distance)
    if not validTypes[killerType] then killerType = "environment" end

    local t = os.time()
    if lastDeath[victimSrc] and t - lastDeath[victimSrc] < 3 then return end
    lastDeath[victimSrc] = t

    local hasKiller = killerType == "player" and killerId > 0 and killerId ~= victimSrc and GetPlayerName(killerId)
    if killerType == "player" and not hasKiller then killerType = "environment" end

    local weaponText = "N/A"
    local causeText = nil
    if weapon and weapon ~= 0 then
        local h = weapon & 0xFFFFFFFF
        causeText = causeNames[h]
        weaponText = causeText or weaponName(weapon)
    end

    local reason
    if killerType == "player" then reason = L.death_player
    elseif killerType == "npc" then reason = L.death_npc
    elseif killerType == "vehicle" then reason = L.death_vehicle
    elseif killerType == "suicide" then reason = causeText or L.death_suicide
    else reason = causeText or L.death_unknown end

    local pos = "N/A"
    if type(coords) == "table" then
        pos = string.format("X: %d | Y: %d | Z: %d",
            math.floor(tonumber(coords.x) or 0), math.floor(tonumber(coords.y) or 0), math.floor(tonumber(coords.z) or 0))
    end

    local fields = {
        field(L.action, L.act_death),
        field(L.time, now()),
        field(L.cause, reason, false),
        field(L.weapon, "`" .. weaponText .. "`"),
    }

    if killerType == "player" or killerType == "npc" or killerType == "vehicle" then
        fields[#fields + 1] = field(L.distance, string.format("%.1f m", distance))
    end
    if type(vehicleName) == "string" and vehicleName ~= "" and vehicleName ~= "CARNOTFOUND" then
        fields[#fields + 1] = field(L.vehicle, vehicleName)
    end
    fields[#fields + 1] = field(L.position, "`" .. pos .. "`", false)

    local embeds = {
        embed(ykaa.Colors.death, L.death_title .. " - " .. L.victim, playerText(getInfo(victimSrc)), fields),
    }

    if hasKiller then
        embeds[2] = embed(ykaa.Colors.death, L.killer, playerText(getInfo(killerId)))
    end

    send(embeds, victimSrc)
end)

exports("Log", function(src, title, message, color, shot)
    src = tonumber(src)
    local text = message and tostring(message) or ""
    local hasPlayer = src and GetPlayerName(src)

    if hasPlayer then
        text = playerText(getInfo(src)) .. "\n\n" .. text
    end

    send({ embed(color or ykaa.Colors.chat, title or "Log", text, {
        field(L.time, now()),
    }) }, (shot and hasPlayer) and src or nil)
end)

exports("LogSteal", function(thiefSrc, victimSrc, details)
    if not ykaa.Steal then return end
    thiefSrc = tonumber(thiefSrc)
    victimSrc = tonumber(victimSrc)
    if not thiefSrc or not victimSrc then return end

    send({
        embed(ykaa.Colors.steal, L.steal_title .. " - " .. L.thief, playerText(getInfo(thiefSrc)), {
            field(L.action, L.act_steal),
            field(L.time, now()),
            field(L.details, details or "N/A", false),
        }),
        embed(ykaa.Colors.steal, L.victim, playerText(getInfo(victimSrc))),
    }, thiefSrc)
end)