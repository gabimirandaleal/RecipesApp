//
//  RemoteMealRepository.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

struct RemoteMealDetailRepository: MealDetailRepository {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchRecipe(id: String) async throws -> [MealDetail] {
        guard var components = URLComponents(string: "https://www.themealdb.com/api/json/v1/1/lookup.php") else {
            throw URLError(.badURL)
        }
        components.queryItems = [URLQueryItem(name: "i", value: id)]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let dto = try JSONDecoder().decode(MealsDetailsResponseDTO.self, from: data)
        return (dto.meals ?? []).compactMap(MealDetailMapper.map)
    }
}
