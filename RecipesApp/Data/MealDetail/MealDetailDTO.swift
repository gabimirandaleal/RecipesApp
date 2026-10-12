//
//  MealDTO.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

struct MealDetailDTO: Decodable, Sendable {
    let idMeal: String?
    let strMeal: String?
    let strMealThumb: String?
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strYoutube: String?
    let strTags: String?
    let strCountry: String?
    let strSource: String?
    let ingredients: [String?]
    let measures: [String?]

    private enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strMealThumb
        case strCategory
        case strArea
        case strInstructions
        case strYoutube
        case strTags
        case strCountry
        case strSource
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idMeal = try container.decodeIfPresent(String.self, forKey: .idMeal)
        self.strMeal = try container.decodeIfPresent(String.self, forKey: .strMeal)
        self.strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        self.strCategory = try container.decodeIfPresent(String.self, forKey: .strCategory)
        self.strArea = try container.decodeIfPresent(String.self, forKey: .strArea)
        self.strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        self.strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)
        self.strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
        self.strCountry = try container.decodeIfPresent(String.self, forKey: .strCountry)
        self.strSource = try container.decodeIfPresent(String.self, forKey: .strSource)

        let dynamic = try decoder.container(keyedBy: DynamicCodingKey.self)
        var ingredients: [String?] = []
        var measures: [String?] = []
        
        let maxIndex = dynamic.allKeys
            .compactMap { Int($0.stringValue.replacingOccurrences(of: "strIngredient", with: "")) }
            .max() ?? 0
        
        for index in stride(from: 1, through: maxIndex, by: 1) {
            let ingredientKey = DynamicCodingKey(stringValue: "strIngredient\(index)")
            let measureKey = DynamicCodingKey(stringValue: "strMeasure\(index)")
            
            ingredients.append(try? dynamic.decodeIfPresent(String.self, forKey: ingredientKey))
            measures.append(try? dynamic.decodeIfPresent(String.self, forKey: measureKey))
        }
        
        self.ingredients = ingredients
        self.measures = measures
    }
}
