Config = {}
Config.PedModels = {
    "a_m_y_hipster_01",
    "a_m_y_hipster_02",
    "a_m_y_hipster_03"
    -- Ajoutez d'autres modèles de peds si vous le souhaitez
}
Config.PercentPlayer = 30 -- Pourcentage perçu par le joueur
Config.NameCommand = "SellSession"

Config.Interaction = {
    upnatom = {
        nameSociety = "society_upnatom",
        Job = "upnatom",
        SpawnZone = {
            {x = 112.50, y = -1029.22, z = 29.35},
        },
        TimeSpwan = 2, -- Temps en seconde entre chaque spwan de ped
        Commande = { -- Commande passée par le ped (les commandes passées par le ped sont aléatoires)
            {Name = "coca", Label = "Coca", Price = 3},
            {Name = "cookies", Label = "Cookies", Price = 4},
        },
        CommandeMax = 3, -- Nombre de "menus" commandés d'un coup (aléatoire)
    },
}