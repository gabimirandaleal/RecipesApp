//
//  SpyAnalyticsTracker.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

@testable import RecipesApp

#if DEBUG
@MainActor
final class SpyAnalyticsTracker: AnalyticsTracker {
    private(set) var events: [AnalyticsEvent] = []
    
    func track(_ event: AnalyticsEvent) {
        self.events.append(event)
    }
}
#endif
