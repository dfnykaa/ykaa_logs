local function SendWebhook(webhookUrl, payload)
    PerformHttpRequest(webhookUrl, function(statusCode, responseText)
        if statusCode ~= 204 then
            print("^6[YKAA LOGS] ^3[WARNING] Webhook error | Status: " .. tostring(statusCode) .. " | Response: " .. tostring(responseText))
        end
    end, "POST", json.encode(payload), { ["Content-Type"] = "application/json" })
end

local function SendLog(title, description)
    if not Config or not Config.WebhookURL then
        print("^6[YKAA LOGS] ^3[WARNING] Config or WebhookURL is missing!")
        return
    end
    SendWebhook(Config.WebhookURL, {
        username = Config.BotName,
        avatar_url = Config.AvatarURL,
        embeds = {{
            color = Config.Color,
            title = title,
            description = description,
            footer = { text = "YKAA Logs • " .. os.date("%d.%m.%Y %H:%M:%S") }
        }}
    })
end

exports("SendLog", function(webhook, data)
    if not webhook or not data then return end
    SendWebhook(webhook, data)
end)

local function GetPlayerInfo(source)
    local lang = Config.Locale
    local name = GetPlayerName(source)
    local discord = GetPlayerIdentifierByType(source, "discord")
    return name, discord, lang
end

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    if not Config.Join then return end
    local src = source
    deferrals.defer()
    Citizen.Wait(0)
    local pName, discord, lang = GetPlayerInfo(src)
    SendLog(Locales[lang]["join_title"],
        "**" .. Locales[lang]["player"] .. ":** " .. pName .. "\n" ..
        "**" .. Locales[lang]["discord"] .. ":** " .. discord
    )
    deferrals.done()
end)

AddEventHandler("playerDropped", function(reason)
    if not Config.Leave then return end
    local src = source
    local pName, discord, lang = GetPlayerInfo(src)
    SendLog(Locales[lang]["leave_title"],
        "**" .. Locales[lang]["player"] .. ":** " .. pName .. "\n" ..
        "**" .. Locales[lang]["discord"] .. ":** " .. discord .. "\n" ..
        "**" .. Locales[lang]["reason"] .. ":** " .. tostring(reason or "N/A")
    )
end)

AddEventHandler("chatMessage", function(source, authorData, message)
    if not Config.Chat then return end
    local src = source
    local pName, discord, lang = GetPlayerInfo(src)
    local lowerMsg = string.lower(message)
    for _, word in ipairs(Config.BlacklistChats or {}) do
        if string.find(lowerMsg, word, 1, true) then
            SendLog(Locales[lang]["chat_blacklist_title"],
                "**" .. Locales[lang]["player"] .. ":** " .. pName .. "\n" ..
                "**" .. Locales[lang]["discord"] .. ":** " .. discord .. "\n\n" ..
                "**" .. Locales[lang]["blacklist_message"] .. ":** " .. tostring(message)
            )
            DropPlayer(src, Locales[lang]["blacklist_kick"])
            return
        end
    end
    SendLog(Locales[lang]["chat_msg_title"],
        "**" .. Locales[lang]["player"] .. ":** " .. pName .. "\n" ..
        "**" .. Locales[lang]["discord"] .. ":** " .. discord .. "\n\n" ..
        "**" .. Locales[lang]["message"] .. ":** " .. tostring(message)
    )
end)

AddEventHandler("explosionEvent", function(source, ev)
    if not Config.Explosion then return end
    local src = source
    local pName, discord, lang = GetPlayerInfo(src)
    local expType = ev.explosionType
    local expName = (Config.Explosions and Config.Explosions[expType]) or ("Unknown (" .. tostring(expType) .. ")")
    local pos = string.format("X: %d | Y: %d | Z: %d", math.floor(ev.posX or 0), math.floor(ev.posY or 0), math.floor(ev.posZ or 0))
    SendLog(Locales[lang]["explosion_title"],
        "**" .. Locales[lang]["player"] .. ":** " .. pName .. "\n" ..
        "**" .. Locales[lang]["discord"] .. ":** " .. discord .. "\n\n" ..
        "**Typ:** " .. expName .. "\n" ..
        "**Pozice:** `" .. pos .. "`"
    )
end)

AddEventHandler("onResourceStart", function(r)
    if r ~= GetCurrentResourceName() then return end
    if GetCurrentResourceName() ~= "ykaa_logs" then
        print("^6[YKAA LOGS] ^3[WARNING] Resource was renamed!")
    end
    print("^6[YKAA LOGS] ^7You are using version ^6" .. GetResourceMetadata(GetCurrentResourceName(), "version", 0))
end)