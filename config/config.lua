ykaa = {

    VersionCheck = true, -- Check for Updates?

    Locale = "en", -- Configure your Language in config/locale.lua, Basic: "en", "cs"

    WebhookName = "YKAA Logs", -- Webhook Name
    AvatarURL = "https://cdn.discordapp.com/attachments/1494695230518329475/1570459729669390377/ykaa-scripts-logo.png?ex=6af72c19&is=6af5da99&hm=3a26d591db566c3f1d4863f14eabcd8d3326cc6bbb8e5f733a9a50a59dad0c45&",

    Join = true, -- Log Player Join
    Leave = true, -- Log Player Leave
    Chat = true, -- Log Player Chat
    Explosion = true, -- Log Explosions
    Death = true, -- Log Player Death
    Steal = true, -- Log Player Steal

    Screenshot = true, -- Require https://github.com/citizenfx/screenshot-basic
    ScreenshotCooldown = 10, -- Seconds, 0 = No Cooldown for sending Screenshots
    ExplosionCooldown = 10, -- Seconds, cooldown between explosion logs per player

    Colors = {
        join = 5763719,
        leave = 15548997,
        chat = 3447003,
        blacklist = 16776960,
        explosion = 15105570,
        death = 10038562,
        steal = 10181046
    },

    -- Blacklisted Words
    BlacklistWords = {
        'nigger', 'niggers', 'nigga', 'n1gga', 'n1ga',
        'negr', 'nega', 'negro', 'negre', 'kys', 'kill yourself',
        'cheats', 'susano', 'redengine', 'eulen', 'Susano', 'RedEngine', 'Eulen',
        'discord.gg', 'dsc.gg', 'http://', 'https://'
    },

    -- Weapons (used to translate weapon hash to name in death logs)
    Weapons = {
        'WEAPON_UNARMED', 'WEAPON_KNIFE', 'WEAPON_NIGHTSTICK', 'WEAPON_HAMMER', 'WEAPON_BAT',
        'WEAPON_CROWBAR', 'WEAPON_GOLFCLUB', 'WEAPON_BOTTLE', 'WEAPON_DAGGER', 'WEAPON_HATCHET',
        'WEAPON_KNUCKLE', 'WEAPON_MACHETE', 'WEAPON_FLASHLIGHT', 'WEAPON_SWITCHBLADE',
        'WEAPON_POOLCUE', 'WEAPON_WRENCH', 'WEAPON_BATTLEAXE', 'WEAPON_STONE_HATCHET',
        'WEAPON_PISTOL', 'WEAPON_PISTOL_MK2', 'WEAPON_COMBATPISTOL', 'WEAPON_APPISTOL',
        'WEAPON_STUNGUN', 'WEAPON_PISTOL50', 'WEAPON_SNSPISTOL', 'WEAPON_SNSPISTOL_MK2',
        'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_FLAREGUN', 'WEAPON_MARKSMANPISTOL',
        'WEAPON_REVOLVER', 'WEAPON_REVOLVER_MK2', 'WEAPON_DOUBLEACTION', 'WEAPON_CERAMICPISTOL',
        'WEAPON_NAVYREVOLVER', 'WEAPON_GADGETPISTOL',
        'WEAPON_MICROSMG', 'WEAPON_SMG', 'WEAPON_SMG_MK2', 'WEAPON_ASSAULTSMG', 'WEAPON_COMBATPDW',
        'WEAPON_MACHINEPISTOL', 'WEAPON_MINISMG',
        'WEAPON_PUMPSHOTGUN', 'WEAPON_PUMPSHOTGUN_MK2', 'WEAPON_SAWNOFFSHOTGUN', 'WEAPON_ASSAULTSHOTGUN',
        'WEAPON_BULLPUPSHOTGUN', 'WEAPON_MUSKET', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_DBSHOTGUN',
        'WEAPON_AUTOSHOTGUN', 'WEAPON_COMBATSHOTGUN',
        'WEAPON_ASSAULTRIFLE', 'WEAPON_ASSAULTRIFLE_MK2', 'WEAPON_CARBINERIFLE', 'WEAPON_CARBINERIFLE_MK2',
        'WEAPON_ADVANCEDRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_SPECIALCARBINE_MK2',
        'WEAPON_BULLPUPRIFLE', 'WEAPON_BULLPUPRIFLE_MK2', 'WEAPON_COMPACTRIFLE', 'WEAPON_MILITARYRIFLE',
        'WEAPON_MG', 'WEAPON_COMBATMG', 'WEAPON_COMBATMG_MK2', 'WEAPON_GUSENBERG',
        'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_HEAVYSNIPER_MK2',
        'WEAPON_MARKSMANRIFLE', 'WEAPON_MARKSMANRIFLE_MK2',
        'WEAPON_RPG', 'WEAPON_GRENADELAUNCHER', 'WEAPON_GRENADELAUNCHER_SMOKE', 'WEAPON_MINIGUN',
        'WEAPON_FIREWORK', 'WEAPON_RAILGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_COMPACTLAUNCHER',
        'WEAPON_EMPLAUNCHER',
        'WEAPON_GRENADE', 'WEAPON_BZGAS', 'WEAPON_SMOKEGRENADE', 'WEAPON_FLARE', 'WEAPON_MOLOTOV',
        'WEAPON_STICKYBOMB', 'WEAPON_PROXMINE', 'WEAPON_SNOWBALL', 'WEAPON_PIPEBOMB', 'WEAPON_BALL',
        'WEAPON_PETROLCAN', 'WEAPON_FIREEXTINGUISHER', 'WEAPON_HAZARDCAN', 'WEAPON_FERTILIZERCAN',
        'WEAPON_TACTICALRIFLE', 'WEAPON_PRECISIONRIFLE'
    },

    -- Explosions Types
    Explosions = {
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
        [71] = "BURIEDMINE",
        [72] = "SCRIPT_MISSILE",
        [73] = "SCRIPT_MISSILE",
        [82] = "EXP_TAG_SUBMARINE_BIG"
    },

    }
