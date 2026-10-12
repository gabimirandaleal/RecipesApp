//
//  RemoteMealRepository.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

import Foundation

struct RemoteMealRepository: MealRepository {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchMeals(query: String) async throws -> [Meal] {
        guard var components = URLComponents(string: "https://www.themealdb.com/api/json/v1/1/filter.php") else {
            throw URLError(.badURL)
        }
        components.queryItems = [URLQueryItem(name: "c", value: query)]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let dto = try JSONDecoder().decode(MealsResponseDTO.self, from: data)
        return (dto.meals ?? []).compactMap(MealMapper.map)
    }
}
