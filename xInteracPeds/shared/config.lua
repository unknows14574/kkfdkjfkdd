Config = Config or {}

Config.PercentPlayer = 30 -- Pourcentage perçu par le joueur
Config.NameCommand = "SellSession"

Config.Interactions = {
    coffee = {
        nameSociety = "society_coffee",
        Job = "coffee",
        TimeSpwan = 2, -- Temps en seconde entre chaque spwan de ped
        Commande = { -- Commande passé par le ped (les commandes passer par le ped sont aléatoire)
            {Name = "bread", Label = "Pain", Price = 3},
            {Name = "water", Label = "Eau", Price = 4},
        },
        CommandeMax = 3, -- Nombre de "menu" commander d'un coup (aléatoire)
    },
}
