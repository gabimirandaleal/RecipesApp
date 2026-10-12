//
//  StubExperimentProvider.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

@testable import RecipesApp

#if DEBUG
@MainActor
struct StubExperimentProvider: ExperimentProvider {
    var variant: Variant

    func variant(for experiment: Experiment) -> Variant {
        variant
    }
}
#endif
