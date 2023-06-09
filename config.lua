Config = {

    -- BASIC SETTINGS
    EnableWeaponUI = false, 
    DisableClothing = true, -- Disables clothing feature if you dont have a way to add clothing items with metadata and dont want to use core_clothing

    DefaultItemSizeX = 2, -- If item size is not defined this will be used
    DefaultItemSizeY = 2, -- If item size is not defined this will be used

    DropShowDistance = 1.0,

    DefaultDurability = 100, -- If category has durability asigned this will be the default (%)
    ShootingDurabilityDegradation = 1.5, -- Higher the value faster guns will break

    OpenKey = 'tab', -- The key to open inventory

    CloseAfterUse = {'lockpick', 'chalumeau', 'clip', 'radio', 'scratchcard', 'cagoule', 'tondeuse', 'robbank', 'plate', 'mkey', 'robatm', 'yusuf', 'pinceforte', 'net_cracker', 'thermite', 'boxweed',
                      'hazmat1', 'hazmat2', 'hazmat3', 'hazmat4', 'hazmatused', 'animal_bait'}, -- Closes inventory if these items are used
    ItemCantBeDrop = { 'braceletgps' },    
    ItemCantBeMoveFromInventory = { 'braceletgps' },
    JobCanByPassRestriction = { 'police', 'sheriff', 'gouv', 'doj', 'ambulance' },
    EnableDiscovery = false, -- Items need to be discovered with right click so they can be used (NEW)

    SyncBackpacks = false, -- If you have a eligible backpack in your inventory it will add it on you as clothes

    -- 3D MODEL SETTINGS
    Use3DModelAlways = true, -- 3D model is drawn in the UI intead of using a camera (Does not sync up well, scale is small)
    Use3DModelInteriors = true, -- Use 3D model only in interiors when camera can glich trough walls
    BlurIf3DModel = true, -- Blurs everything around if using 3D model
    HeightRecognizedAsInterior = -10, -- Most shells (interiors generated by scripts) are below ground. Set height which is defined as interior

    -- CAMERA SETTINGS

    StartFOV = 60.0,
    EndFOV = 20.0,

    CameraOffsetStart = vector3(0.0, 0.8, 0.0),
    CameraOffsetEnd = vector3(0.0, 6.0, 0.0), -- Offset from player while camera active
    CameraTransitionTime = 400, -- Time in miliseconds it takes to transition from start to end offsets

    CameraVehicleOffsetStart = vector3(-1.0, 10.0, 1.0),
    CameraVehicleOffsetEnd = vector3(-8.0, 0.0, 1.5), -- Offset from player vehicle while camera active
    VehicleCameraTransitionTime = 600, -- Time in miliseconds it takes to transition from start to end offsets

    CameraTrunkOffsetStart = vector3(-0.1, 0.1, 3.0),
    CameraTrunkOffsetEnd = vector3(-5.0, 1.0, 3.0), -- Offset from player using trunk while camera active
    TrunkCameraTransitionTime = 600, -- Time in miliseconds it takes to transition from start to end offsets

    -- SHOWN METADATA IN INFORMATION (NEW)
    ShownMetadata = { -- Metadata that will be shown in information of the item. For example idcard will show firstname and lastname
        ['firstname'] = 'Prénom',
        ['lastname'] = 'Nom',
        ['dateofbirth'] = 'Date de naissance',
        ['sex'] = 'Sexe',
        ['height'] = 'Taille'
    },

    -- ITEM PROPERTIES (NEW)
    ShowItemName = true, -- Shows item's name in top right corner
    ShowItemCount = true,
    ShowItemAmmunition = true,

    -- STARTING ITEMS
    SyncOldInventory = true, -- Syncs old inventory items (if there is enough space)
    StartItems = {
        -- ['phone'] = {amount = 1, metadata = {}},
        -- ['bread'] = {amount = 3, metadata = {}},
        -- ['water'] = {amount = 3, metadata = {}}
    },

    -- DEFAULT CLOTHING (NEW)

    -- !!WARNING!! Make sure you have inventories created below for new clothing

    -- mID: Men clothing drawable id
    -- wID: Woman clothing drawable id
    -- mModel: Men clothing drawable model
    -- wModel: Woman clothing drawable model
    -- mTexture: Men clothing drawable texture/color
    -- wTexture: Woman clothing drawable texture/color
    -- mTorso: Men arms (the ones that glitch trough clothes)
    -- wTorso: Woman arms (the ones that glitch trough clothes)

    InventoryClothing = {

        ['hat'] = {
            mID = 1,
            mModel = 0,
            mTexture = 0,
            wID = 1,
            wModel = 0,
            wTexture = 0
        },
        ['torso'] = {
            mID = 11,
            mModel = 15,
            mTexture = 0,
            mTorso = 15,
            wID = 11,
            wModel = 15,
            wTexture = 0,
            wTorso = 15
        },
        ['pants'] = {
            mID = 4,
            mModel = 15,
            mTexture = 0,
            wID = 4,
            wModel = 15,
            wTexture = 0
        },
        ['shoes'] = {
            mID = 6,
            mModel = 5,
            mTexture = 0,
            wID = 6,
            wModel = 5,
            wTexture = 0
        },
        ['watch'] = {
            mID = 7,
            mModel = 0,
            mTexture = 0,
            wID = 7,
            wModel = 0,
            wTexture = 0
        },
        ['tshirt'] = {
            mID = 8,
            mModel = 15,
            mTexture = 0,
            wID = 8,
            wModel = 5,
            wTexture = 0
        }
    },

    -- CATEGORIES
    -- color: Sets color of items in that category
    -- takeSound: Sound used when item taken
    -- takePut: Sound used when item put
    -- durability: If added and set to true item will have durability
    -- serial: If added and set to true item will have serial code
    -- stack: If added and asigned a number items in this category will stack (Infinite stacksize is 0) (NEW)

    ItemCategories = {

        -- WARNING! ONLY CHANGE VALUES WITHIN CATEGORY AFTER THIS LINE (DO NOT DELETE) 

        ["backpacks"] = {
            color = "#62a859",
            takeSound = 'take_fabric',
            putSound = 'put_fabric',
            stack = 1
        },
        ["cases"] = {
            color = "#8330ff",
            takeSound = 'take',
            putSound = 'put',
            stack = 1
        },
        ["misc"] = {
            color = "#f2f2f2",
            takeSound = 'take',
            putSound = 'put',
            stack = 10
        },
        ["weapons"] = {
            color = "#4ac3ff",
            takeSound = 'take',
            putSound = 'put',
            durability = true,
            serial = true
        },
        ["component_suppressor"] = {
            color = "#f77dff",
            takeSound = 'take',
            putSound = 'put',
            stack = 1
        },
        ["component_scope"] = {
            color = "#f77dff",
            takeSound = 'take',
            putSound = 'put',
            stack = 1
        },
        ["component_grip"] = {
            color = "#f77dff",
            takeSound = 'take',
            putSound = 'put',
            stack = 1
        },
        ["component_finish"] = {
            color = "#f77dff",
            takeSound = 'take',
            putSound = 'put',
            stack = 1
        },
        ["component_flashlight"] = {
            color = "#f77dff",
            takeSound = 'take',
            putSound = 'put',
            stack = 1
        },
        ["component_clip"] = {
            color = "#f77dff",
            takeSound = 'take',
            putSound = 'put',
            stack = 1
        },
        ["pants"] = {
            color = "#ff0088",
            takeSound = 'take_clothes',
            putSound = 'put_clothes',
            stack = 1
        },
        ["watch"] = {
            color = "#ff0088",
            takeSound = 'take_clothes',
            putSound = 'put_clothes',
            stack = 1
        },
        ["hat"] = {
            color = "#ff0088",
            takeSound = 'take_clothes',
            putSound = 'put_clothes',
            stack = 1
        },
        ["tshirt"] = {
            color = "#ff0088",
            takeSound = 'take_clothes',
            putSound = 'put_clothes',
            stack = 1
        },
        ["torso"] = {
            color = "#ff0088",
            takeSound = 'take_clothes',
            putSound = 'put_clothes',
            stack = 1
        },
        ["shoes"] = {
            color = "#ff0088",
            takeSound = 'take_clothes',
            putSound = 'put_clothes',
            stack = 1
        },

        -- CHANGE type and category (this is type not category)
        ["accessoire"] = {
            color = "#f2f2f2",
            takeSound = 'take',
            putSound = 'put',
            stack = 1
        },
        ["medical"] = {
            color = "#f2f2f2",
            takeSound = 'take',
            putSound = 'put',
            stack = 20
        },
        ["drink"] = {
            color = "#f2f2f2",
            takeSound = 'take',
            putSound = 'put',
            stack = 10
        },
        --261.58, 222.05, 106.28
        ["eatbox"] = {
            color = "#f2f2f2",
            takeSound = 'take',
            putSound = 'put',
            stack = 10
        },
        ["eat"] = {
            color = "#f2f2f2",
            takeSound = 'take',
            putSound = 'put',
            stack = 10
        },
        ["drug"] = {
            color = "#f2f2f2",
            takeSound = 'take',
            putSound = 'put',
            stack = 10
        },
        ["alcool"] = {
            color = "#f2f2f2",
            takeSound = 'take',
            putSound = 'put',
            stack = 10
        },
        ["divers"] = {
            color = "#f2f2f2",
            takeSound = 'take',
            putSound = 'put',
            stack = 50
        },
        ["admin"] = {
            color = "#f2f2f2",
            takeSound = 'take',
            putSound = 'put',
            stack = 10
        },
        ["cash"] = {
            color = "#00754B",
            takeSound = 'take',
            putSound = 'put',
            stack = 75000
        },
        ["dirty"] = {
            color = "#6A9A8B",
            takeSound = 'take',
            putSound = 'put',
            stack = 75000
        },
        ["infinitestack"] = {
            color = "#6A9A8B",
            takeSound = 'take',
            putSound = 'put',
            stack = 5000000
        },

        -- Hunting
        ["hunting_reward"] = {
            color = "#6A9A8B",
            takeSound = 'take',
            putSound = 'put',
            stack = 4
        },
        ["hunting_item"] = {
            color = "#6A9A8B",
            takeSound = 'take',
            putSound = 'put',
            stack = 5
        },
        -- END CHANGE HERE
    },

    -- INVENTORY SETTINGS
    -- slots: Amount of blocks/slots in inventory
    -- rows: How many slots define one row
    -- x: Where on screen initial inventory position is horizontally
    -- y: Where on screen initial inventory position is vertically
    -- alwaysSave: Saves inventory if its empty (used for saving position of inventory)
    -- restrictedTo: Restricts inventory to a category of items

    Inventories = {

        ["small_backpack"] = {
            slots = 20,
            rows = 5,
            x = "20%",
            y = "20%",
            label = "SAC A DOS",
            alwaysSave = true

        },

        ["medium_bag"] = {
            slots = 48,
            rows = 8,
            x = "20%",
            y = "20%",
            label = "SACOCHE",
            alwaysSave = true

        },

        ["large_backpack"] = {
            slots = 48,
            rows = 8,
            x = "20%",
            y = "20%",
            label = "SAC A DOS",
            alwaysSave = true

        },

        ["weapon_case"] = {
            slots = 200,
            rows = 10,
            x = "20%",
            y = "20%",
            label = "Malette D'ARMES",
            alwaysSave = true,
            restrictedTo = {'weapons'}

        },

        ["storage_case"] = {
            slots = 70,
            rows = 10,
            x = "20%",
            y = "20%",
            label = "MALETTE DE STOCKAGE",
            alwaysSave = true

        },

        ["stash"] = {
            slots = 100,
            rows = 10,
            x = "20%",
            y = "20%",
            label = "STASH",
            alwaysSave = true

        },

        ["small_storage"] = {
            slots = 100,
            rows = 10,
            x = "20%",
            y = "20%",
            label = "STOCKAGE",
            alwaysSave = true

        },

        ["big_storage"] = {
            slots = 150,
            rows = 10,
            x = "20%",
            y = "20%",
            label = "STOCKAGE",
            alwaysSave = true

        },

        ["weapon_storage"] = {
            slots = 150,
            rows = 10,
            x = "20%",
            y = "20%",
            label = "ARMURERIE",
            alwaysSave = true,
            restrictedTo = {'weapons', 'cases', 'accessoire'}
        },

        -- WARNING! ONLY CHANGE VALUES WITHIN CATEGORY AFTER THIS LINE (DO NOT DELETE)
        ["content"] = {
            slots = 60,
            rows = 10,
            x = "20%",
            y = "20%",
            label = "POCHE",
            alwaysSave = true
        },
        -- Debut inventory
        -- ["content"] = {
        --     slots = 200,
        --     rows = 10,
        --     x = "20%",
        --     y = "20%",
        --     label = "POCHE",
        --     alwaysSave = true
        -- },
        ["primary"] = {
            slots = 12,
            rows = 6,
            x = "60%",
            y = "20%",
            label = "PRIMAIRE",
            restrictedTo = {'weapons'},
            alwaysSave = true
        },
        ["secondry"] = {
            slots = 12,
            rows = 6,
            x = "61%",
            y = "30%",
            label = "SECONDAIRE",
            restrictedTo = {'weapons'},
            alwaysSave = true
        },  

        ["tertiary"] = {
            slots = 12,
            rows = 6,
            x = "62%",
            y = "40%",
            label = "TERTIAIRE",
            restrictedTo = {'weapons'},
            alwaysSave = true
        },

        ["hat"] = {
            slots = 4,
            rows = 2,
            x = "50%",
            y = "20%",
            label = "CHAPEAU",
            restrictedTo = {'hat'},
            alwaysSave = true
        },
        ["tshirt"] = {
            slots = 4,
            rows = 2,
            x = "50%",
            y = "20%",
            label = "TSHIRT",
            restrictedTo = {'tshirt'},
            alwaysSave = true
        },
        ["torso"] = {
            slots = 4,
            rows = 2,
            x = "50%",
            y = "20%",
            label = "TORSE",
            restrictedTo = {'torso'},
            alwaysSave = true
        },
        ["pants"] = {
            slots = 4,
            rows = 2,
            x = "50%",
            y = "20%",
            label = "PANTALON",
            restrictedTo = {'pants'},
            alwaysSave = true
        },
        ["shoes"] = {
            slots = 4,
            rows = 2,
            x = "50%",
            y = "20%",
            label = "CHAUSSURE",
            restrictedTo = {'shoes'},
            alwaysSave = true
        },
        ["watch"] = {
            slots = 4,
            rows = 2,
            x = "50%",
            y = "20%",
            label = "MONTRE",
            restrictedTo = {'watch'},
            alwaysSave = true
        },

        ["drop"] = {
            x = "60%",
            y = "45%",
            label = "JETER",
            alwaysSave = false
        },

        -- VEHICLE INVENTORIES
        ["small_trunk"] = {
            slots = 30,
            rows = 10,
            x = "60%",
            y = "45%",
            label = "COFFRE",
            alwaysSave = true
        },
        ["medium_trunk"] = {
            slots = 50,
            rows = 10,
            x = "60%",
            y = "45%",
            label = "COFFRE",
            alwaysSave = true
        },
        ["big_trunk"] = {
            slots = 248,
            rows = 16,
            x = "60%",
            y = "45%",
            label = "COFFRE",
            alwaysSave = true
        },
        ["tiny_trunk"] = {
            slots = 10,
            rows = 5,
            x = "60%",
            y = "45%",
            label = "Rangement",
            alwaysSave = true
        },
        ["glovebox"] = {
            slots = 10,
            rows = 5,
            x = "60%",
            y = "45%",
            label = "BOITE A GANT",
            alwaysSave = true
        },

        -- Custom enterprise inventory 
        ["big_entreprise_utility_storage"] = {
            slots = 150,
            rows = 10,
            x = "20%",
            y = "20%",
            label = "STOCKAGE",
            alwaysSave = true,
            restrictedTo = {'alcool', 'drink', 'eat', 'eatbox', 'divers', 'backpacks', 'cases', 'medical', 'drug' }
        },

        ["big_entreprise_weapons_storage"] = {
            slots = 255,
            rows = 15,
            x = "20%",
            y = "20%",
            label = "ARMURERIE",
            alwaysSave = true,
            restrictedTo = {'cases', 'weapons', 'accessoire' }
        },

        ["big_fdo_weapons_storage"] = {
            slots = 360,
            rows = 18,
            x = "20%",
            y = "20%",
            label = "ARMURERIE",
            alwaysSave = true,
            restrictedTo = {'cases', 'weapons', 'accessoire' }
        },

        ["big_fdo_weapon_buy_storage"] = {
            slots = 255,
            rows = 15,
            x = "10%",
            y = "10%",
            label = "ACHAT ARMURERIE",
            alwaysSave = true,
            restrictedTo = {'cases', 'weapons', 'accessoire' }
        },

        ["big_entreprise_clothing_storage"] = {
            slots = 150,
            rows = 10,
            x = "20%",
            y = "20%",
            label = "DRESSING",
            alwaysSave = true,
            restrictedTo = {'hat', 'pants', 'shoes', 'torso', 'tshirt', 'watch', 'cases', 'bagpacks' }
        },

        ["big_property_utility_storage"] = {
            slots = 200,
            rows = 10,
            x = "20%",
            y = "20%",
            label = "STOCKAGE",
            alwaysSave = true,
            restrictedTo = {'alcool', 'drink', 'eat', 'eatbox', 'divers', 'backpacks', 'cases', 'medical', 'weapons', 'cash', 'dirty', 'drug' }
        },

    },

    SpecificTrunks = { -- Specific trunks for specific cars
        ['caddy'] = 'tiny_trunk',
        ['caddy2'] = 'tiny_trunk',
        ['blazer'] = 'tiny_trunk',
        ['blazer4'] = 'tiny_trunk',
    },

    Trunks = { -- Trunk inventories for each vehicle category (Recommended to add more diversity)

        [0] = 'small_trunk',
        [1] = 'medium_trunk',
        [2] = 'big_trunk',
        [3] = 'medium_trunk',
        [4] = 'medium_trunk',
        [5] = 'small_trunk',
        [6] = 'medium_trunk',
        [7] = 'small_trunk',
        [8] = 'tiny_trunk',
        [9] = 'big_trunk',
        [10] = 'big_trunk',
        [11] = 'big_trunk',
        [12] = 'big_trunk',
        [13] = 'tiny_trunk',
        [14] = 'small_trunk',
        [15] = 'small_trunk',
        [16] = 'big_trunk',
        [17] = 'big_trunk',
        [18] = 'big_trunk',
        [19] = 'big_trunk',
        [20] = 'big_trunk',
        [21] = 'big_trunk'

    },

    BlackListedVehicleClassTrunk = {
        13 -- Cycle
    },

    ItemSell = { -- List stores with items that you can sell there

        -- ['pawnshop'] = {

        --     coords = vector3(27.624807357788, -1345.8685302734, 29.496946334839),
        --     label = 'Pawnshop',
        --     items = {

        --         ['goldbar'] = 500, -- Item and its sell price
        --         ['golchain'] = 50, -- Item and its sell price
        --         ['rolex'] = 1000 -- Item and its sell price

        --     }

        -- }

    },

    ItemBuy = { -- List stores with items you can buy there

        -- ['seveneleven'] = {
        --     coords = vector3(27.624807357788, -1345.8685302734, 29.496946334839),
        --     label = 'Seven Eleven',
        --     items = {

        --         ['snickers'] = 5, -- Item and its buy price
        --         ['water_bottle'] = 3, -- Item and its buy price
        --         ['phone'] = 500 -- Item and its buy price

        --     }
        -- }

    },

    -- INVENTORY STASHES/STORAGES
    -- coords: Place of storage
    -- inventory: Inventory type used! Must be existing one from Inventories above
    -- jobs: jobs/gangs that can access
    -- prop: Prop name that will be placed if wanted
    -- personal: Inventory is individual to everyone using it (not same items for everyone)

    Storage = {

        -- ['departament1'] = {

        --     coords = vector3(474.81225585938, -994.61584472656, 26.2734375),
        --     inventory = 'big_storage',
        --     jobs = {'police'},
        --     prop = nil,
        --     personal = false

        -- },
        -- ['departament2'] = {

        --     coords = vector3(472.9289855957, -995.32574462891, 26.2734375),
        --     inventory = 'big_storage',
        --     jobs = {'police'},
        --     prop = nil,
        --     personal = false

        -- },
        -- ['departament3'] = {

        --     coords = vector3(486.92962646484, -998.24627685547, 30.689805984497),
        --     inventory = 'weapon_storage',
        --     jobs = {'police'},
        --     prop = nil,
        --     personal = false

        -- },
        -- ['mechanic1'] = {

        --     coords = vector3(122.34775543213, -3028.3515625, 7.0408916473389),
        --     inventory = 'big_storage',
        --     jobs = {'mechanic'},
        --     prop = 'prop_toolchest_05',
        --     personal = false

        -- },
        -- ['mechanic2'] = {

        --     coords = vector3(126.8946762085, -3008.6379394531, 10.703436851501),
        --     inventory = 'big_storage',
        --     jobs = {'mechanic',},
        --     prop = 'prop_toolchest_05',
        --     personal = false

        -- },
        -- ['ambulance1'] = {

        --     coords = vector3(306.95159912109, -601.38873291016, 43.284103393555),
        --     inventory = 'big_storage',
        --     jobs = {'ambulance'},
        --     prop = nil,
        --     personal = false

        -- },
        -- ['test'] = {
        --     coords = vector3(285.35,  8.2521, 79.3119),
        --     inventory = 'big_storage',
        --     jobs = {'unemployed'},
        --     prop = nil,
        --     personal = false
        -- }
    },

    Text = {

        ['waypoint_set'] = 'Point GPS mis à jour !',
        ['item_does_not_exist'] = 'Cet item n\'existe pas',
        ['wrong_syntax'] = 'Wrong command syntax!',
        ['no_space'] = 'Plus d\'espace dans l\'inventaire',
        ['no_such_item'] = 'Tu n\'as pas cet item',
        ['no_such_key'] = 'Tu ne peux pas utiliser cette clef',
        ['keybind_set'] = 'Raccourcis enregistré !',
        ['keybinds_cleared'] = 'Raccourcis supprimé !',
        ['no_player_close'] = 'Personne à proximité',

        -- UI TEXT

        ['inventory'] = 'INVENTAIRE',
        ['clothing'] = 'VÊTEMENT',
        ['weapons'] = 'ARMES',
        ['use'] = 'UTILISER',
        ['attachments'] = 'ACCESSOIRES',
        ['drop'] = 'JETER',
        ['give'] = 'DONNER',
        ['discover'] = 'ANALYSER',
        ['info'] = 'INFO',
        ['keybind'] = 'RACCOURCIS',
        ['durability'] = 'DURABILITE',
        ['sell_it_at'] = 'VENDRE A',
        ['buy_it_at'] = 'ACHETER A',
        ['serial'] = 'NUMERO DE SERIE',
        ['close'] = 'FERMER',

        -- ATTACHMENTS

        ['suppressor'] = 'SILENCIEUX',
        ['flashlight'] = 'LAMPE',
        ['grip'] = 'POIGNET',
        ['scope'] = 'VISEUR',
        ['finish'] = 'TEINTURE',
        ['clip'] = 'CHARGEUR'
    },

    --CUSTOM ADD ON CONFIG 

    RemoveDropOnStart = true,

    LegalJob = {
        ['storage'] = {
            ['ambulance'] = 'Default - Coffre',
            ['arcade'] = 'Arcadian Bar - Coffre',
            ['avocat'] = 'Default - Coffre',
            ['avocat2'] = 'Default - Coffre',
            ['bahama'] = 'Bahama - Coffre',
            ['casino'] = 'Casino - Coffre',
            ['casino2'] = 'Default - Coffre',
            ['coffee'] = 'Bean Coffee - Coffre',
            ['diner'] = 'Black Wood - Coffre',
            ['doj'] = 'Default - Coffre',
            ['eightpool'] = '8 Pool Bar - Coffre',
            ['event'] = 'Default - Coffre',
            ['fib'] = 'Default - Coffre',
            ['flywheels'] = 'Mosley - Coffre',
            ['fourriere'] = 'Default - Coffre',
            ['fuel'] = 'Default - Coffre',
            ['galaxy'] = 'Galaxy - Coffre',
            ['gouv'] = 'Gouvernement - Coffre',
            ['gruppe6'] = 'Gruppe6 - Coffre',
            ['hooka'] = 'Hookah Lounge - Coffre',
            ['journaliste'] = 'Weazel News - Coffre',
            ['mboubar'] = 'Le Phare Ouest - Coffre',
            ['mecano'] = 'Bennys - Coffre',
            ['mecano2'] = 'Mecano Sandy Shores - Coffre',
            ['musicrecord'] = 'Music Record - Coffre',
            ['nebevent'] = 'Unicorn - Coffre',
            ['pacific'] = 'Default - Coffre',
            ['parkranger'] = 'Default - Coffre',
            ['pilote'] = 'Default - Coffre',
            ['pizzathis'] = 'Pizza This - Coffre',
            ['police'] = 'LSPD - Coffre',
            ['prison'] = 'Prison- Coffre',
            ['realestateagent'] = 'Default - Coffre',
            ['sheriff'] = 'Sheriff - Coffre',
            ['tabac'] = 'Default - Coffre',
            ['taxi'] = 'Default - Coffre',
            ['tequi'] = 'Tequi-La-La',
            ['unicorn'] = 'Unicorn - Coffre',
            ['upnatom'] = 'Up N Atom - Coffre',
            ['vigne'] = 'Default - Coffre',
            ['yellow'] = 'Yellow Jack - Coffre'
        },
        ['weapon'] = {
            ['ambulance'] = 'Default - Armurerie',
            ['arcade'] = 'Default - Armurerie',
            ['avocat'] = 'Default - Armurerie',
            ['avocat2'] = 'Default - Armurerie',
            ['bahama'] = 'Default - Armurerie',
            ['casino'] = 'Default - Armurerie',
            ['casino2'] = 'Default - Armurerie',
            ['coffee'] = 'Default - Armurerie',
            ['diner'] = 'Default - Armurerie',
            ['doj'] = 'Default - Armurerie',
            ['eightpool'] = 'Default - Armurerie',
            ['event'] = 'Default - Armurerie',
            ['fib'] = 'Default - Armurerie',
            ['flywheels'] = 'Default - Armurerie',
            ['fourriere'] = 'Default - Armurerie',
            ['fuel'] = 'Default - Armurerie',
            ['galaxy'] = 'Default - Armurerie',
            ['gouv'] = 'Default - Armurerie',
            ['gruppe6'] = 'Gruppe6 - Armurerie',
            ['hooka'] = 'Default - Armurerie',
            ['journaliste'] = 'Default - Armurerie',
            ['mboubar'] = 'Le Phare Ouest - Armurerie',
            ['mecano'] = 'Default - Armurerie',
            ['mecano2'] = 'Default - Armurerie',
            ['musicrecord'] = 'Default - Armurerie',
            ['nebevent'] = 'Default - Armurerie',
            ['pacific'] = 'Default - Armurerie',
            ['parkranger'] = 'Default - Armurerie',
            ['pilote'] = 'Default - Armurerie',
            ['pizzathis'] = 'Default - Armurerie',
            ['police'] = 'LSPD - Armurerie',
            ['prison'] = 'Default - Armurerie',
            ['realestateagent'] = 'Default - Armurerie',
            ['sheriff'] = 'Sheriff - Armurerie',
            ['tabac'] = 'Default - Armurerie',
            ['taxi'] = 'Default - Armurerie',
            ['tequi'] = 'Default - Armurerie',
            ['unicorn'] = 'Default - Armurerie',
            ['upnatom'] = 'Default - Armurerie',
            ['vigne'] = 'Default - Armurerie',
            ['yellow'] = 'Default - Armurerie'
        }
    },

    IllegalJob = {
        ['storage'] = {
            ['ballas'] = 'Coffre d\'objets',
            ['bikers'] = 'Coffre d\'objets',
            ['bikers2'] = 'Coffre d\'objets',
            ['bikers3'] = 'Coffre d\'objets',
            ['bikers4'] = 'Coffre d\'objets',
            ['bikers5'] = 'Coffre d\'objets',
            ['cdg'] = 'Coffre d\'objets',
            ['elt'] = 'Coffre d\'objets',
            ['gang'] = 'Coffre d\'objets',
            ['ghost'] = 'Coffre d\'objets',
            ['gitan'] = 'Coffre d\'objets',
            ['hustlers'] = 'Coffre d\'objets',
            ['leninskaia'] = 'Coffre d\'objets',
            ['locosyndicate'] = 'Coffre d\'objets',
            ['madrazo'] = 'Coffre d\'objets',
            ['mafia'] = 'Coffre d\'objets',
            ['mafiacala'] = 'Coffre d\'objets',
            ['mara'] = 'Coffre d\'objets',
            ['mcreary'] = 'Coffre d\'objets',
            ['muertos'] = 'Coffre d\'objets',
            ['orga'] = 'Coffre d\'objets',
            ['psycho'] = 'Coffre d\'objets',
            ['SAB'] = 'Coffre d\'objets',
            ['salvatore'] = 'Coffre d\'objets',
            ['shadow'] = 'Coffre d\'objets',
            ['snk'] = 'Coffre d\'objets',
            ['stony'] = 'Coffre d\'objets',
            ['tucker'] = 'Coffre d\'objets',
            ['vagos'] = 'Coffre d\'objets',
            ['VCF'] = 'Coffre d\'objets',
            ['voleur'] = 'Coffre d\'objets',
            ['weed'] = 'Coffre d\'objets',
            ['yakuza'] = 'Coffre d\'objets',
            ['duggan'] = 'Coffre d\'objets',
            ['monetti'] = 'Coffre d\'objets',
            ['bmf'] = 'Coffre d\'objets'
        },
        ['weapon'] = {
            ['ballas'] = 'Coffre d\'armes',
            ['bikers'] = 'Coffre d\'armes',
            ['bikers2'] = 'Coffre d\'armes',
            ['bikers3'] = 'Coffre d\'armes',
            ['bikers4'] = 'Coffre d\'armes',
            ['bikers5'] = 'Coffre d\'armes',
            ['cdg'] = 'Coffre d\'armes',
            ['elt'] = 'Coffre d\'armes',
            ['gang'] = 'Coffre d\'armes',
            ['ghost'] = 'Coffre d\'armes',
            ['gitan'] = 'Coffre d\'armes',
            ['hustlers'] = 'Coffre d\'armes',
            ['leninskaia'] = 'Coffre d\'armes',
            ['locosyndicate'] = 'Coffre d\'armes',
            ['madrazo'] = 'Coffre d\'armes',
            ['mafia'] = 'Coffre d\'armes',
            ['mafiacala'] = 'Coffre d\'armes',
            ['mara'] = 'Coffre d\'armes',
            ['mcreary'] = 'Coffre d\'armes',
            ['muertos'] = 'Coffre d\'armes',
            ['orga'] = 'Coffre d\'armes',
            ['psycho'] = 'Coffre d\'armes',
            ['SAB'] = 'Coffre d\'armes',
            ['salvatore'] = 'Coffre d\'armes',
            ['shadow'] = 'Coffre d\'armes',
            ['snk'] = 'Coffre d\'armes',
            ['stony'] = 'Coffre d\'armes',
            ['tucker'] = 'Coffre d\'armes',
            ['vagos'] = 'Coffre d\'armes',
            ['VCF'] = 'Coffre d\'armes',
            ['voleur'] = 'Coffre d\'armes',
            ['weed'] = 'Coffre d\'armes',
            ['yakuza'] = 'Coffre d\'armes',
            ['duggan'] = 'Coffre d\'armes',
            ['monetti'] = 'Coffre d\'armes',
            ['bmf'] = 'Coffre d\'armes'
        }
    }
}

function SendTextMessage(msg)

    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(0, 1)
end
