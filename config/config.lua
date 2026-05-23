Config = {}

-- [SETTINGS]
Config.BotName = "YKAA Logs" -- webhook name
Config.AvatarURL = "https://cdn.discordapp.com/attachments/1494695230518329475/1507714846828007514/ykaa-scripts-logo.png?ex=6a12e85f&is=6a1196df&hm=7b4da2d7089155ac907660937f78d9fc3542c2bd21aa27aed8a51adaa1f942fc&"
Config.WebhookURL = "https://discord.com/api/webhooks/1507720457074245782/Ddr_ulIk8rGgx3QjC1Fzg9tD-MUsvaDuBP8JI7AdVcY0K3pme8Sqnfu5tYeYoqNjgNig"
Config.Locale = "en" -- Language (en, cs)

-- [LOGS]
Config.Join = true
Config.Leave = true
Config.Chat = true
Config.Explosion = true
Config.Color = 16711680

-- [BLACKLIST WORDS]
Config.BlacklistChats = {
    'nigger', 'nigga', 'n1gga', 'n1ga', 'negr', 'niggers',
    'nega', 'negro', 'negre', 'negr'
}

-- [EXPLOSIONS]
Config.Explosions = {
    [0] = "Grenade",
    [1] = "GrenadeLauncher",
    [2] = "C4",
    [3] = "Molotov",
    [4] = "Rocket",
    [5] = "TankShell",
    [6] = "HiOctane",
    [7] = "Car",
    [8] = "Plane",
    [9] = "PetrolPump",
    [10] = "Bike",
    [11] = "Dir_Steam",
    [12] = "Dir_Flame",
    [13] = "Dir_Water_Hydrant",
    [14] = "Dir_Gas_Canister",
    [15] = "Boat",
    [16] = "Ship_Destroy",
    [17] = "Truck",
    [19] = "SMOKEGRENADELAUNCHER",
    [20] = "SMOKEGRENADE",
    [21] = "BZGAS",
    [25] = "PROGRAMMABLEAR",
    [32] = "PLANE_ROCKET",
    [33] = "VEHICLE_BULLET",
    [36] = "RAILGUN",
    [38] = "FIREWORK",
    [40] = "PROXMINE",
    [41] = "VALKYRIE_CANNON",
    [42] = "AIR_DEFENSE",
    [43] = "PIPEBOMB",
    [44] = "VEHICLEMINE",
    [45] = "EXPLOSIVEAMMO",
    [46] = "APCSHELL",
    [47] = "BOMB_CLUSTER",
    [48] = "BOMB_GAS",
    [49] = "BOMB_INCENDIARY",
    [50] = "BOMB_STANDARD",
    [51] = "TORPEDO",
    [52] = "TORPEDO_UNDERWATER",
    [53] = "BOMBUSHKA_CANNON",
    [54] = "BOMB_CLUSTER_SECONDARY",
    [55] = "HUNTER_BARRAGE",
    [56] = "HUNTER_CANNON",
    [57] = "ROGUE_CANNON",
    [58] = "MINE_UNDERWATER",
    [59] = "ORBITAL_CANNON",
    [60] = "BOMB_STANDARD_WIDE",
    [61] = "EXPLOSIVEAMMO_SHOTGUN",
    [62] = "OPPRESSOR2_CANNON",
    [63] = "MORTAR_KINETIC",
    [64] = "VEHICLEMINE_KINETIC",
    [65] = "VEHICLEMINE_EMP",
    [66] = "VEHICLEMINE_SPIKE",
    [67] = "VEHICLEMINE_SLICK",
    [68] = "VEHICLEMINE_TAR",
    [69] = "SCRIPT_DRONE",
    [70] = "RAYGUN",
    [71] = "BURIEDMINE",
    [72] = "SCRIPT_MISSILE",
    [73] = "SCRIPT_MISSILE",
    [82] = "EXP_TAG_SUBMARINE_BIG"
}