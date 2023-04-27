Config = Config or {}

Config = {
    PercentPlayer = 30, -- Pourcentage perçu par le joueur
    NameCommand = "SellSession",

    Interaction = {
        ["coffee"] = {
            nameSociety = "society_coffee",
            Job = "coffee",
            Position = vector3(110.63, -1036.64, 29.34), -- Position ou le ped se rendra pour commander sa nourriture avec vous
            Position2 = vector3(120.03, -1039.98, 29.27),
            PositionSpwan = vector3(115.14, -1024.31, 29.35), -- Position ou le ped spwan (Le ped marchera jusqu'à la position au dessus)
            HeadingSpwan = 225.71,
            Peds = {
                "ig_mp_agent14",
                "g_m_y_ballasout_01",
            },
            TimeSpwan = 2, -- Temps en seconde entre chaque spwan de ped
            Commande = { -- Commande passé par le ped (les commandes passer par le ped sont aléatoire)
                {Name = "bread", Label = "Pain", Price = 3},
                {Name = "water", Label = "Eau", Price = 4},
            },
            CommandeMax = 3, -- Nombre de "menu" commander d'un coup (aléatoire)
        },
    }
}

