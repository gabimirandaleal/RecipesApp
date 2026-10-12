//
//  MealCategoryDTO.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

struct MealCategoryDTO: Decodable, Sendable  {
    let idCategory: String?
    let strCategory: String?
    let strCategoryDescription: String?
    let strCategoryThumb: String?
    
    private enum CodingKeys: CodingKey {
        case idCategory
        case strCategory
        case strCategoryDescription
        case strCategoryThumb
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idCategory = try container.decodeIfPresent(String.self, forKey: .idCategory)
        self.strCategory = try container.decodeIfPresent(String.self, forKey: .strCategory)
        self.strCategoryDescription = try container.decodeIfPresent(String.self, forKey: .strCategoryDescription)
        self.strCategoryThumb = try container.decodeIfPresent(String.self, forKey: .strCategoryThumb)
    }
}
