//
//  MealCategory.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

struct MealCategory: Hashable, Sendable, Identifiable {
    let id: String
    let name: String       // texto exibido (pode estar traduzido)
    let apiName: String    // nome que a API exige (sempre em inglês)
    let imageURL: URL?
    let description: String?
}
