//
//  CategoryMapperTests.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation
import Testing
@testable import RecipesApp

struct CategoryMapperTests {
    private func decode(_ json: String) throws -> MealCategoryDTO {
        try JSONDecoder().decode(MealCategoryDTO.self, from: Data(json.utf8))
    }
    
    @Test
    func returnNilWhenIdIsMissing() throws {
        let dto = try decode("""
        { "strCategory": "Flan" }
        """)
        #expect(MealCategoryMapper.map(dto) == nil)
    }
    
    @Test
    func returnNilWhenNameIsMissing() throws {
        let dto = try decode("""
        { "idCategory": "1" }
        """)
        #expect(MealCategoryMapper.map(dto) == nil)
    }
}
