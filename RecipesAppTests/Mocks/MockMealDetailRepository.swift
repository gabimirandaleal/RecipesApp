//
//  MockMealDetailRepository.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

import Foundation
@testable import RecipesApp

#if DEBUG
struct MockMealDetailsRepository: MealDetailRepository {
    var result: Result<[MealDetail], Error>
    func searchRecipe(id: String) async throws -> [MealDetail] {
        try result.get()
    }
}
#endif
