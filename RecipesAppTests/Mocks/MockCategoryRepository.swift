//
//  MockCategoryRepository.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

import Foundation
@testable import RecipesApp

#if DEBUG
struct MockCategoryRepository: MealCategoryRepository {
    var result: Result<[MealCategory], Error>
    func searchCategory(query: String) async throws -> [MealCategory] {
        try result.get()
    }
}
#endif
