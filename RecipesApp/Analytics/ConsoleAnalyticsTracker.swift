//
//  ConsoleAnalyticsTracker.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

struct ConsoleAnalyticsTracker: AnalyticsTracker {
    func track(_ event: AnalyticsEvent) {
        #if DEBUG
        print("📊 AnalyticsEvent \(event.name) \(event.properties)")
        #endif
    }
}
