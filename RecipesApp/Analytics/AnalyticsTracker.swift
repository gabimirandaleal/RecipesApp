//
//  AnalyticsTracker.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

@MainActor
protocol AnalyticsTracker {
    func track(_ event: AnalyticsEvent)
}
