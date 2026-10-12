//
//  MealCategoryRepository.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

struct RemoteMealCategoryRepository: MealCategoryRepository {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchCategory(query: String) async throws -> [MealCategory] {
        guard var components = URLComponents(string: "https://www.themealdb.com/api/json/v1/1/categories.php") else {
            throw URLError(.badURL)
        }
        components.queryItems = [URLQueryItem(name: "i", value: query)]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let dto = try JSONDecoder().decode(MealCategoryResponseDTO.self, from: data)
        return (dto.categories ?? []).compactMap(MealCategoryMapper.map)
    }
}

