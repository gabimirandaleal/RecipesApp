//
//  DebugMenuView.swift
//  RecipesApp
//
//  Created by gabriela.leal on 12/10/26.
//

#if DEBUG
import SwiftUI

struct DebugMenuView: View {
    let experiments: LocalExperimentProvider
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("YouTube button position") {
                    Button("Force control (bottom)") {
                        experiments.setVariant(.control, for: .youtubeButtonPosition)
                    }
                    Button("Force control (TOP)") {
                        experiments.setVariant(.treatment, for: .youtubeButtonPosition)
                    }
                    Button("Reset (draw again)", role: .destructive) {
                        experiments.reset(.youtubeButtonPosition)
                    }
                }
            }
        }
        .navigationTitle("Debug")
        .toolbar {
            Button("Done") { dismiss() }
        }
    }
}

private struct DebugMenuModifier: ViewModifier {
    let experiments: LocalExperimentProvider
    @State private var isPresented = false
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShake)) { _ in
                isPresented = true
            }
            .sheet(isPresented: $isPresented) {
                DebugMenuView(experiments: experiments)
            }
    }
}

extension View {
    func debugMenu(experiments: LocalExperimentProvider) -> some View {
        modifier(DebugMenuModifier(experiments: experiments))
    }
}

#endif
