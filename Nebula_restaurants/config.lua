ConfigRestaurants = {}

ConfigRestaurants.CookDict = "mini@drinking"
ConfigRestaurants.CookAnim = "shots_barman_b"

ConfigRestaurants.CookingTime = 5 -- En secondes et par items
ConfigRestaurants.DrinksTime = 2.5 -- En secondes et par items

-- Ajouter un job / items. 
-- La valeur boisson (true/false) doit être mise sur false si c'est un point de nourriture et sur true si c'est un point de boissons
ConfigRestaurants.Restaurants = {

-- PRODUIT UP N ATOM

    ['upnatom'] = {
        ["atombox"] = {
            price = 190,
            boisson = false,
            label = "Box Atomic Frites"
        },
        ["atombox2"] = {
            price = 190,
            boisson = false,
            label = "Box Atomic Onions"
        },
        ["atombox3"] = {
            price = 190,
            boisson = false,
            label = "Box Atomic Salade"
        },
        ["burger"] = {
            price = 150,
            boisson = false,
            label = "Atom Burger"
        },
        ["bourguignon"] = {
            price = 75,
            boisson = false,
            label = "Bacon Burger"
        },
        ["kebab"] = {
            price = 75,
            boisson = false,
            label = "Double Whooper"
        },
        ["kebab2"] = {
            price = 75,
            boisson = false,
            label = "Chicken Burger"
        },
        ["kefta"] = {
            price = 75,
            boisson = false,
            label = "Cheese Burger"
        },
        ["upnatom"] = {
            price = 150,
            boisson = false,
            label = "Burger Veggie"
        },
        ["salade"] = {
            price = 30,
            boisson = false,
            label = "Salade"
        },
        ["hotdog"] = {
            price = 30,
            boisson = false,
            label = "Hotdog"
        },
        ["frites"] = {
            price = 20,
            boisson = false,
            label = "Frites"
        },
        ["croissant"] = {
            price = 20,
            boisson = false,
            label = "Onion Rings"
        },
        ["durum"] = {
            price = 20,
            boisson = false,
            label = "Glace"
        },
        ["water"] = {
            price = 50,
            boisson = true,
            label = "Bouteille d'eau"
        },
        ["icetea"] = {
            price = 90,
            boisson = true,
            label = "Ice Tea"
        },
        ["pepsi"] = {
            price = 90,
            boisson = true,
            label = "Pepsi"
        },
        ["fanta"] = {
            price = 90,
            boisson = true,
            label = "Fanta"
        },
        ["orangina"] = {
            price = 90,
            boisson = true,
            label = "Orangina"
        },
        ["coca"] = {
            price = 90,
            boisson = true,
            label = "Coca"
        },
        ["citronnade"] = {
            price = 90,
            boisson = true,
            label = "Citronnade"
        },
    },

-- PRODUIT PHARE OUEST

    ['mboubar'] = {
        ["mojito"] = {
            price = 150,
            boisson = true,
            label = "Mojito",
            requiredItem = {
                { label = 'Verre de rhum', value ='rhum', quantity = 1}
            }
        },
        ["martini"] = {
            price = 150,
            boisson = true,
            label = "Martini Blanc"
        },
        ["pinacolada"] = {
            price = 150,
            boisson = true,
            label = "Pinacolada",
            requiredItem = {
                { label = 'Verre de rhum', value ='rhum', quantity = 1}
            }
        },
        ["sangria"] = {
            price = 150,
            boisson = true,
            label = "Sangria"
        },
        ["beer_lost7"] = {
            price = 150,
            boisson = true,
            label = "Grand Schroumpf",
            requiredItem = {
                { label = 'Verre de vodka', value ='vodka', quantity = 1}
            }
        },
        ["bolpistache"] = {
            price = 45,
            boisson = true,
            label = "Bol de pistaches"
        },
        ["bolcacahuetes"] = {
            price = 45,
            boisson = true,
            label = "Bol de cacahuètes"
        },
        ["bolnoixcajou"] = {
            price = 45,
            boisson = true,
            label = "Bol de noix de cajou"
        },
        ["bolchips"] = {
            price = 45,
            boisson = true,
            label = "Bol de chips"
        },
        ["saucisson"] = {
            price = 45,
            boisson = true,
            label = "Saucisson"
        },
        ["olives"] = {
            price = 45,
            boisson = true,
            label = "Olives pimentées"
        },
        ["annasbanana"] = {
            price = 150,
            boisson = true,
            label = "Anna\'s Banana",
            requiredItem = {
                { label = 'Verre de rhum', value ='rhum', quantity = 1}
            }
        },
        ["rhumtini"] = {
            price = 150,
            boisson = true,
            label = "Expresso Rhumtini",
            requiredItem = {
                { label = 'Verre de rhum', value ='rhum', quantity = 1}
            }
        },
        ["rhumcoca"] = {
            price = 150,
            boisson = true,
            label = "Rhum - Coca",
            requiredItem = {
                { label = 'Verre de rhum', value ='rhum', quantity = 1}
            }
        },        
        ["rhumfruit"] = {
            price = 150,
            boisson = true,
            label = "Rhum - Jus de fruits",
            requiredItem = {
                { label = 'Verre de rhum', value ='rhum', quantity = 1}
            }
        },
        ["brhum"] = {
            price = 500,
            boisson = true,
            label = "Bouteille de Rhum"
        },
    },
-- PRODUIT YELLOWJACK

    ['yellow'] = {
        ["beer_lost1"] = {
            price = 125,
            boisson = false,
            label = "Bière In Memoriam"
        },
        ["beer_lost3"] = {
            price = 125,
            boisson = false,
            label = "Bière Ace of Spades"
        },
        ["beer_lost8"] = {
            price = 125,
            boisson = false,
            label = "Bière Lucky Day"
        },
        ["beer_lost6"] = {
            price = 125,
            boisson = false,
            label = "Bière Marbee"
        },
        ["beer_lost5"] = {
            price = 125,
            boisson = false,
            label = "Bière Reconquest"
        },
        ["beer_lost4"] = {
            price = 125,
            boisson = false,
            label = "Bière Tombstone"
        },
        ["beer_lost2"] = {
            price = 125,
            boisson = false,
            label = "Bière Valhalla"
        },
        ["water"] = {
            price = 50,
            boisson = false,
            label = "Bouteille d'eau"
        },
        ["energy"] = {
            price = 90,
            boisson = false,
            label = "Energy drink"
        },
        ["icetea"] = {
            price = 90,
            boisson = false,
            label = "Ice Tea"
        },        
        ["coca"] = {
            price = 90,
            boisson = false,
            label = "Coca"
        },
        ["croquem"] = {
            price = 90,
            boisson = false,
            label = "Croque monsieur"
        },
        ["croquemm"] = {
            price = 90,
            boisson = false,
            label = "Croque madame"
        },
        ["packcig"] = {
            price = 100,
            boisson = false,
            label = "Paquet de cigarette"
        },
        ["packcigar"] = {
            price = 250,
            boisson = false,
            label = "Paquet de cigare"
        },
    },

-- PRODUIT TEQUILALA

    ['tequi'] = {
        ["rhumcoca"] = {
            price = 150,
            boisson = true,
            label = "Rhum - Coca"
        },        
        ["rhumfruit"] = {
            price = 150,
            boisson = true,
            label = "Rhum - Jus de fruits"
        },
        ["tequila"] = {
            price = 125,
            boisson = true,
            label = "Verre de Tequila"
        },
        ["tequisun"] = {
            price = 150,
            boisson = true,
            label = "Tequila Sunrise"
        },
        ["btequila"] = {
            price = 500,
            boisson = true,
            label = "Bouteille de tequila"
        },
        ["brhum"] = {
            price = 500,
            boisson = true,
            label = "Bouteille de Rhum"
        },
        ["monaco"] = {
            price = 100,
            boisson = true,
            label = "Monaco"
        },
        ["shot_tequila"] = {
            price = 100,
            boisson = true,
            label = "Shot de Tequila"
        },
        ["tequipaf"] = {
            price = 100,
            boisson = true,
            label = "Tek'Paf"
        },
        ["margarita"] = {
            price = 125,
            boisson = true,
            label = "Margarita"
        },
        ["hurricane"] = {
            price = 125,
            boisson = true,
            label = "Hurricane"
        },
        ["ceviche"] = {
            price = 125,
            boisson = true,
            label = "Salade Ceviche"
        }
    },

-- PRODUIT BAHAMA MAS

    ['bahama'] = {
        ["shot_jager"] = {
            price = 150,
            boisson = true,
            label = "Vodka Poctocki"
        },
        ["shot_b52"] = {
            price = 150,
            boisson = true,
            label = "Whisky Bowmore"
        },
        ["bwhisky"] = {
            price = 500,
            boisson = true,
            label = "Bouteille de Whisky"
        },
        ["shot_vodka"] = {
            price = 125,
            boisson = true,
            label = "Shot de Vodka"
        },
        ["vodkafruit"] = {
            price = 150,
            boisson = true,
            label = "Vodka Jus de Fruits"
        },
        ["vodkaenergy"] = {
            price = 150,
            boisson = true,
            label = "Vodka Energy"
        },
        ["bvodka"] = {
            price = 500,
            boisson = true,
            label = "Bouteille de Vodka"
        },
        ["whiskycoca"] = {
            price = 125,
            boisson = true,
            label = "Whisky Coca"
        },
    },

-- PRODUIT Unicorn

    ['event'] = {
        ["champagne"] = {
            price = 1000,
            boisson = true,
            label = "Bouteille de Champagne"
        },
        ["vchampagne"] = {
            price = 200,
            boisson = true,
            label = "Coupe de Champagne"
        },
        ["ruinart"] = {
            price = 1500,
            boisson = true,
            label = "Bouteille de ruinart"
        },
        ["vruinart"] = {
            price = 300,
            boisson = true,
            label = "Coupe Champagne ruinart"
        },
        ["vrouge"] = {
            price = 500,
            boisson = true,
            label = "Bouteille de vin rouge"
        },
        ["vinrouge"] = {
            price = 150,
            boisson = true,
            label = "Verre de vin rouge"
        },
        ["bving"] = {
            price = 500,
            boisson = true,
            label = "Bouteille de vin gingembre"
        },
        ["ving"] = {
            price = 150,
            boisson = true,
            label = "Verre de vin gingembre"
        },
        ["bvinf"] = {
            price = 500,
            boisson = true,
            label = "Bouteille de vin Framboise"
        },
        ["vinf"] = {
            price = 150,
            boisson = true,
            label = "Verre de vin framboise"
        },
        ["vblanc"] = {
            price = 500,
            boisson = true,
            label = "Bouteille de vin blanc"
        },
        ["vinblanc"] = {
            price = 150,
            boisson = true,
            label = "Verre de vin blanc"
        },    
        ["vrose"] = {
            price = 500,
            boisson = true,
            label = "Bouteille de rosé"
        },    
        ["vinrose"] = {
            price = 150,
            boisson = true,
            label = "Verre de rosé"
        },
    },

-- PRODUIT BlackWood Saloon

    ['diner'] = {
        ["cesarsalad"] = {
            price = 90,
            boisson = false,
            label = "Poulet Kentucky"
        },
        ["oeufmimo"] = {
            price = 90,
            boisson = false,
            label = "Pommes de terres au four"
        },
        ["blanquette"] = {
            price = 150,
            boisson = false,
            label = "Salade Beef"
        },
        ["cotelette_cuite"] = {
            price = 150,
            boisson = false,
            label = "Trio de brochettes"
        },
        ["steak_cuit"] = {
            price = 150,
            boisson = false,
            label = "Entrecote"
        },
        ["parisbrest"] = {
            price = 150,
            boisson = false,
            label = "Ribbs"
        },
        ["moules"] = {
            price = 150,
            boisson = false,
            label = "Dorade grillée"
        },
        ["saucisse_cuite"] = {
            price = 150,
            boisson = false,
            label = "Macaroni au fromage"
        },
        ["mozastick"] = {
            price = 90,
            boisson = false,
            label = "Cheesecake"
        },
        ["corngrilled"] = {
            price = 90,
            boisson = false,
            label = "Mais grillé"
        },
        ["oplat"] = {
            price = 90,
            boisson = false,
            label = "Salade de fruit"
        },
        ["btlait"] = {
            price = 90,
            boisson = true,
            label = "Root beer"
        },
        ["water"] = {
            price = 50,
            boisson = true,
            label = "Carafe d'eau"
        },
        ["grandmatea"] = {
            price = 90,
            boisson = true,
            label = "Tisane"
        },
        ["coca"] = {
            price = 90,
            boisson = true,
            label = "Coca"
        },
        ["sprunk"] = {
            price = 90,
            boisson = true,
            label = "Sprunk"
        },
    },
    -- PRODUIT Bean Coffee

    ['coffee'] = {
        ["mocaccino"] = {
            price = 90,
            boisson = false,
            label = "Chouquettes"
        },
        ["irish_coffee"] = {
            price = 90,
            boisson = false,
            label = "Bistoule",
            requiredItem = {
                { label = 'Verre de rhum', value ='rhum', quantity = 1}
            }
        },
        ["caramel_macchiato"] = {
            price = 90,
            boisson = false,
            label = "Caramel Macchiato"
        },
        ["chocolate_chaud_tiramisu"] = {
            price = 90,
            boisson = false,
            label = "Chocolat chaud façon tiramisu"
        },
        ["coffee"] = {
            price = 90,
            boisson = false,
            label = "Café"
        },
        ["cappuccino"] = {
            price = 90,
            boisson = false,
            label = "Cappuccino"
        },
        ["chocolatc"] = {
            price = 90,
            boisson = false,
            label = "Chocolat Chaud"
        },
        ["coffee_sandwich"] = {
            price = 90,
            boisson = false,
            label = "Assiette de Boeuf"
        },
        ["cheesecake"] = {
            price = 90,
            boisson = false,
            label = "Croissant"
        },
        ["muffins"] = {
            price = 90,
            boisson = false,
            label = "Pain au chocolat"
        },
        ["scones"] = {
            price = 90,
            boisson = false,
            label = "Wraps"
        },
        -- ["chiacchiere"] = {
        --     price = 90,
        --     boisson = false,
        --     label = "Chiacchiere"
        -- },
        ["gaufre"] = {
            price = 90,
            boisson = false,
            label = "Gaufre"
        },
        ["pancake"] = {
            price = 90,
            boisson = false,
            label = "Pain aux amandes"
        },
        ["cookies"] = {
            price = 90,
            boisson = false,
            label = "Cookie"
        },
        -- ["tarte"] = {
        --     price = 90,
        --     boisson = false,
        --     label = "Tarte aux pommes"
        -- },
        ["donut"] = {
            price = 90,
            boisson = false,
            label = "Donut"
        },
        ["cafe_frappe"] = {
            price = 90,
            boisson = false,
            label = "Expresso"
        },
        ["the"] = {
            price = 90,
            boisson = false,
            label = "Thé"
        },
    },

    -- PRODUIT ARCADIAN BAR

    ['arcade'] = {
        ["pokebowl"] = {
            price = 90,
            boisson = false,
            label = "Pokebowl"
        },
        ["onigiri"] = {
            price = 90,
            boisson = false,
            label = "Onigiri"
        },
        ["rizthai"] = {
            price = 90,
            boisson = false,
            label = "Riz thai"
        },
        ["limonade"] = {
            price = 90,
            boisson = true,
            label = "Limonade"
        },
        ["bubbletea"] = {
            price = 90,
            boisson = true,
            label = "BubbleTea"
        },
        ["mochiyoshi"] = {
            price = 90,
            boisson = false,
            label = "Mochi"
        },
        ["dangoventi"] = {
            price = 90,
            boisson = false,
            label = "Dango"
        },
    },

    -- PRODUIT Eight Pool BAR
    
    ['eightpool'] = {
        ["water"] = {
            price = 50,
            boisson = true,
            label = "Bouteille d'eau"
        },
        ["icetea"] = {
            price = 90,
            boisson = true,
            label = "Ice Tea"
        },
        ["pepsi"] = {
            price = 90,
            boisson = true,
            label = "Pepsi"
        },
        ["fanta"] = {
            price = 90,
            boisson = true,
            label = "Fanta"
        },
        ["orangina"] = {
            price = 90,
            boisson = true,
            label = "Orangina"
        },
        ["coca"] = {
            price = 90,
            boisson = true,
            label = "Coca"
        },
        ["beer_lost1"] = {
            price = 125,
            boisson = true,
            label = "Bière In Memoriam"
        },
        ["beer_lost3"] = {
            price = 125,
            boisson = true,
            label = "Bière Ace of Spades"
        },
        ["beer_lost8"] = {
            price = 125,
            boisson = true,
            label = "Bière Lucky Day"
        },
        ["beer_lost6"] = {
            price = 125,
            boisson = true,
            label = "Bière Marbee"
        },
        ["beer_lost5"] = {
            price = 125,
            boisson = true,
            label = "Bière Reconquest"
        },
        ["beer_lost4"] = {
            price = 125,
            boisson = true,
            label = "Bière Tombstone"
        },
        ["beer_lost2"] = {
            price = 125,
            boisson = true,
            label = "Bière Valhalla"
        },
        ["tequila"] = {
            price = 125,
            boisson = true,
            label = "Verre de Tequila"
        },
        ["tequisun"] = {
            price = 150,
            boisson = true,
            label = "Tequila Sunrise"
        },
        ["btequila"] = {
            price = 500,
            boisson = true,
            label = "Bouteille de tequila"
        },
        ["shot_tequila"] = {
            price = 100,
            boisson = true,
            label = "Shot de Tequila"
        },
        ["tequipaf"] = {
            price = 100,
            boisson = true,
            label = "Tek'Paf"
        },
    },

    -- PRODUIT Hookah

    ['hooka'] = {
        ["water"] = {
            price = 50,
            boisson = true,
            label = "Bouteille d'eau"
        },
        ["pepsi"] = {
            price = 90,
            boisson = true,
            label = "Pepsi"
        },
        ["coca"] = {
            price = 90,
            boisson = true,
            label = "Coca"
        },
        ["mirinda"] = {
            price = 90,
            boisson = true,
            label = "Mirinda"
        },        
        ["hawai"] = {
            price = 90,
            boisson = true,
            label = "Hawaï"
        },        
        ["marocain_the"] = {
            price = 90,
            boisson = true,
            label = "Thé à la menthe"
        },
        ["mahjouba"] = {
            price = 90,
            boisson = false,
            label = "Mahjouba "
        },
        ["corne_gazelle"] = {
            price = 90,
            boisson = false,
            label = "Corne de gazelle"
        },
    },

    -- PRODUIT Pizza This

    ['pizzathis'] = {
        ["pizza"] = {
            price = 150,
            boisson = false,
            label = "Pizza"
        },
        ["lasagne"] = {
            price = 90,
            boisson = false,
            label = "Lasagne"
        },
        ["pates"] = {
            price = 90,
            boisson = false,
            label = "Pâtes"
        },
        ["escalopem"] = {
            price = 90,
            boisson = false,
            label = "Escalope Milanaise"
        },
        ["risotto"] = {
            price = 90,
            boisson = false,
            label = "Risotto"
        },
        ["ossobuco"] = {
            price = 90,
            boisson = false,
            label = "Ossobuco"
        },
        ["bruscheta"] = {
            price = 90,
            boisson = false,
            label = "Bruscheta"
        },
        ["tomatemoz"] = {
            price = 90,
            boisson = false,
            label = "Tomate Mozzarella"
        },
        ["croqueparm"] = {
            price = 90,
            boisson = false,
            label = "Croque Parm'accia"
        },
        ["tiramisug"] = {
            price = 90,
            boisson = false,
            label = "Tiramisu"
        },
        ["pannacotta"] = {
            price = 90,
            boisson = false,
            label = "Panna cotta"
        },
        ["water"] = {
            price = 50,
            boisson = true,
            label = "Bouteille d'eau"
        },
        ["grandmatea"] = {
            price = 90,
            boisson = true,
            label = "Tisane"
        },
        ["coca"] = {
            price = 90,
            boisson = true,
            label = "Coca"
        },
        ["chinotto"] = {
            price = 90,
            boisson = true,
            label = "Chinotto"
        },
        ["btlait"] = {
            price = 90,
            boisson = true,
            label = "Root beer"
        }
    },
}