//
//  MealMapper.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

enum MealDetailMapper {
    static func map(_ dto: MealDetailDTO) -> MealDetail? {
        guard let id = dto.idMeal, let name = dto.strMeal else { return nil }

        let ingredients = zip(dto.ingredients, dto.measures).compactMap { (ingredient, measure) -> Ingredient? in
            guard let name = ingredient, !name.isEmpty else { return nil }
            let cleanMeasure = (measure?.isEmpty ?? true) ? nil : measure
            return Ingredient(name: name, measure: cleanMeasure)
        }
        let tags = dto.strTags?
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty } ?? []

        return MealDetail(
            id: id,
            name: name,
            imageURL: URL(string:dto.strMealThumb ?? "") ,
            ingredients: ingredients,
            area: dto.strArea ?? dto.strCountry,
            category: dto.strCategory,
            videoURL: URL(string: dto.strYoutube ?? ""),
            instructions: dto.strInstructions ?? "",
            tags: tags,
            sourceURL: URL(string: dto.strSource ?? "")
        )
    }
}
