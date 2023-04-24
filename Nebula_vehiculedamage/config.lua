Config = {}

-- 150 = +/- 5/6 9mm bullet (28 damage)
-- Disable mean that vehicule motor will be stop
Config.MaxVehiculeHealthBeforeDisable = 150

-- When reach, vehicule speed will be lock
-- default is 150 - 30 = 120
Config.MaxVehiculeHealthBeforeLockSpeed = Config.MaxVehiculeHealthBeforeDisable - 30

-- number of 9mm bullet hit in other part than engine needs to disable vehicule
-- can't be more than 39, because after 39 bullet hit, CEventNetworkEntityDamage is never
-- trigger by the game because the game consider the body car health equal to 0
-- so the game consider the car destroy and entity destroy can't be damage
Config.MaxNumberOfBulletNeedToDisableVehicule = 35

--Max speed when engine is lock
Config.MaxSpeedWhenLock = 30

-- 1000 Body health / 1000 engine health [DO NOT TOUCH]
Config.MaxVehiculeDefaultHealth = 2000

-- To know if is a foot / fist hit [DO NOT TOUCH]
Config.FistWeaponHash = -1569615261 -- '0xA2719263' -- WEAPON_UNARMED

-- This is the Hash get when player in vehicule hit something [DO NOT TOUCH]
-- WEAPON_RAMMED_BY_CAR 133987706
Config.RammedByCarHash = 133987706

-- From test define than one fist / foot made 57.4 damage to the car [DO NOT TOUCH]
Config.FistWeaponDamage = 58.17

-- From test define than one mele weapon /  made 58.17 damage to the car [DO NOT TOUCH]
Config.MeleWeaponDamage = 58.17

-- New damage apply to vehicule when hit with fist / foot
Config.NewMeleWeaponDamage = 0.5

-- Reference gun [DO NOT TOUCH]
Config.ReferencePistolHash = 453432689

Config.GoodLimit = Config.MaxVehiculeHealthBeforeLockSpeed / 2
Config.MiddleLimit = Config.MaxVehiculeHealthBeforeLockSpeed / 2
Config.CriticalLimit = Config.MaxVehiculeHealthBeforeLockSpeed
Config.UndrivableLimit = Config.MaxVehiculeHealthBeforeDisable

Config.VehiculeClassDomageMultiplicator = {
    [0] = 0.5, -- 'Compacts',  
    [1] = 0.5, -- 'Sedans',  
    [2] = 0.5, -- 'SUVs',  
    [3] = 0.5, -- 'Coupes',  
    [4] = 0.5, -- 'Muscle',  
    [5] = 0.5, -- 'Sports Classics',
    [6] = 0.5, -- 'Sports',  
    [7] = 0.5, -- 'Super',  
    [8] = 0.5, -- 'Motorcycles',  
    [9] = 0.5, -- 'Off-road',
    [10] = 0.5, -- 'Industrial',  
    [11] = 0.5, -- 'Utility',  
    [12] = 0.5, -- 'Vans',  
    [13] = 0.5, -- 'Cycles',  
    [14] = 0.5, -- 'Boats',  
    [15] = 0.5, -- 'Helicopters',  
    [16] = 0.5, -- 'Planes',  
    [17] = 0.5, -- 'Service',  
    [18] = 0.5, -- 'Emergency',  
    [19] = 0.5, -- 'Military',  
    [20] = 0.5, -- 'Commercial',  
    [21] = 0.5 -- 'Trains',
}