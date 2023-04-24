Config_prisonfederal                            = {}
Config_prisonfederal.DrawDistance = 15.0--               = 100.0
Config_prisonfederal.MarkerType                 = 25
Config_prisonfederal.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config_prisonfederal.MarkerColor                = { r = 255, g = 255, b = 0 }
Config_prisonfederal.EnablePlayerManagement     = true
Config_prisonfederal.EnableArmoryManagement     = true
Config_prisonfederal.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config_prisonfederal.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config_prisonfederal.EnableSocietyOwnedVehicles = false
Config_prisonfederal.EnableLicenses             = true
Config_prisonfederal.MaxInService               = -1
Config_prisonfederal.Locale                     = 'fr'

Config_prisonfederal.prisonStations = {

  PRISON = {

    Blip2 = {
        Pos     = { x = 1854.30, y = 2606.35, z = 45.67 },
        Sprite  = 58,
        Display = 4,
        Scale   = 0.8,
        Colour  = 9,
      Name = "Bolingbroke Federal Prison",
    },

    Cloakrooms = {
      { x = 1778.52, y = 2548.97, z = 45.79-0.98 },
    },

    Armories = {
      { x = 1777.96, y = 2543.30, z = 45.79-0.98 },
    },

    Coffre = {
      { x = 1776.79, y = 2599.30, z = 45.79-0.98 },
    },

    BossActions = {
      {  x = 1778.94, y = 2554.41, z = 49.57-0.98 }
    },
  },
}
