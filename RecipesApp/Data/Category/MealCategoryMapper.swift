//
//  MealCategoryMapper.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

enum MealCategoryMapper {
    static func map(_ dto: MealCategoryDTO) -> MealCategory? {
        guard let id = dto.idCategory, let name = dto.strCategory else { return nil }

        return MealCategory(
            id: id,
            name: name,
            imageURL: URL(string:dto.strCategoryThumb ?? "") ,
            description: dto.strCategoryDescription
        )
    }
}
