//
//  IngredientSearch.swift
//  cocktailMaker
//
//  Created by Claudia Contreras on 3/31/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import Foundation

struct IngredientSearch: Codable {
    let drinkName: String
    let drinkID: String
    
    enum CodingKeys: String, CodingKey {
        case drinkName = "strDrink"
        case drinkID = "idDrink"
    }
}

struct IngredientDrinks: Codable {
    let drinks: [IngredientSearch]
}
