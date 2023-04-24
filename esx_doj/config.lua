Config_esx_doj                            = {}
Config_esx_doj.DrawDistance = 15.0--               = 100.0
Config_esx_doj.MarkerType                 = 25
Config_esx_doj.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config_esx_doj.MarkerColor                = { r = 255, g = 255, b = 0 }
Config_esx_doj.EnablePlayerManagement     = true
Config_esx_doj.EnableArmoryManagement     = true
Config_esx_doj.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config_esx_doj.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config_esx_doj.EnableSocietyOwnedVehicles = false
Config_esx_doj.EnableLicenses             = true
Config_esx_doj.MaxInService               = -1
Config_esx_doj.Locale                     = 'fr'

Config_esx_doj.dojStations = {

  GOUV = {

	Blip2 = {
      Pos     = { x = 230.78, y = -424.78, z = 47.94 },
      Sprite  = 419,
      Display = 4,
      Scale   = 0.6,
      Name = "Department of Justice",
  },

  AuthorizedWeapons = {
      { name = 'WEAPON_NIGHTSTICK',          price = 2500 },
      { name = 'WEAPON_STUNGUN',             price = 5000 },
      { name = 'WEAPON_PISTOL_MK2',          price = 6000 },
      { name = 'weapon_pumpshotgun',          price = 20000 },
  },

  AuthorizedVehicles = {
  },

    Cloakrooms = {
      { x = -536.35, y = -183.61, z = 38.22-0.98 },
    },

    Armories = {
      { x = -560.38, y = -185.91, z = 38.22-0.98 },
    },

    BossActions = {
      {  x = -521.07, y = -169.36, z = 42.83-0.98 }
    },
  },
}