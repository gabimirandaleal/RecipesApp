//
//  DynamicCodingKey.swift
//  RecipesApp
//
//  Created by gabriela.leal on 11/10/26.
//

struct DynamicCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int? = nil
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) { nil }
}
