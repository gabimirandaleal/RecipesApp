//
//  MealDTO.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

struct MealDTO: Decodable, Sendable {
    let idMeal: String?
    let strMeal: String?
    let strMealThumb: String?
    let strArea: String?
    let strCountry: String?

    private enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strMealThumb
        case strArea
        case strCountry
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idMeal = try container.decodeIfPresent(String.self, forKey: .idMeal)
        self.strMeal = try container.decodeIfPresent(String.self, forKey: .strMeal)
        self.strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        self.strArea = try container.decodeIfPresent(String.self, forKey: .strArea)
        self.strCountry = try container.decodeIfPresent(String.self, forKey: .strCountry)
    }
}
