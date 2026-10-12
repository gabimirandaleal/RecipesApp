//
//  ExperimentProvider.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

import Foundation

@MainActor
protocol ExperimentProvider {
    func variant(for experiment: Experiment) -> Variant
}

@MainActor
final class LocalExperimentProvider: ExperimentProvider {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func variant(for experiment: Experiment) -> Variant {
        let key = "experiment.\(experiment.rawValue)"
        if let saved = defaults.string(forKey: key), let variant = Variant(rawValue: saved) {
            return variant
        }
        
        let variant: Variant = Bool.random() ? .control : .treatment
        defaults.set(variant.rawValue, forKey: key)
        return variant
    }
    
    func setVariant(_ variant: Variant, for experiment: Experiment) {
        defaults.set(variant.rawValue, forKey: key(for: experiment))
    }
    
    func reset(_ experiment: Experiment) {
        defaults.removeObject(forKey: key(for: experiment))
    }
    
    func key(for experiment: Experiment) -> String {
        "experiment.\(experiment.rawValue)"
    }
}
