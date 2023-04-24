Config = { }

-- 15 000$ limitation without prime

Config.MaxBoxQuantity = 2345

Config.MaxEmsRunQuantity = 50

Config.MaxTaxiRunQuantity = 50

Config.MaxDinerRunQuantity = 26

Config.MaxMosleyRunQuantity = 5

Config.MaxBurgerRunQuantity = 50

Config.MaxPizzaRunQuantity = 50

Config.JobNameAndRunLimitation = {
    ['boxJob'] = Config.MaxBoxQuantity,
    ['taxiJob'] = Config.MaxTaxiRunQuantity,
    ['emsJob'] = Config.MaxEmsRunQuantity,
    ['dinerJob'] = Config.MaxDinerRunQuantity,
    ['mosleyJob'] = Config.MaxMosleyRunQuantity,
    ['burgerJob'] = Config.MaxBurgerRunQuantity,
    ['pizzaJob'] = Config.MaxPizzaRunQuantity
}