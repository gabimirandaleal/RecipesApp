//
//  MealMapper.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

enum MealMapper {
    static func map(_ dto: MealDTO) -> Meal? {
        guard let id = dto.idMeal, let name = dto.strMeal else { return nil }

        return Meal(
            id: id,
            name: name,
            imageURL: URL(string:dto.strMealThumb ?? "") ,
            area: dto.strArea ?? dto.strCountry,
        )
    }
}
