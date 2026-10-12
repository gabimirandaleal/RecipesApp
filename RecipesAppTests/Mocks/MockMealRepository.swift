//
//  MockMealRepository.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation
@testable import RecipesApp

#if DEBUG
struct MockMealRepository: MealRepository {
    var result: Result<[Meal], Error>
    func searchMeals(query: String) async throws -> [Meal] {
        try result.get()
    }
}
#endif
