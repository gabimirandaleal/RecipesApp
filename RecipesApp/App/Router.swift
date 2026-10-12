//
//  Router.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import SwiftUI
import Foundation

enum Route: Hashable {
    case recipeDetail(id: String)
    case recipeList(id: String)
}

@MainActor
@Observable
final class Router {
    var path: [Route] = []
    
    func showDetail(of id: String) {
        path.append(.recipeDetail(id: id))
    }
    
    func showList(of id: String) {
        path.append(.recipeList(id: id))
    }
}
