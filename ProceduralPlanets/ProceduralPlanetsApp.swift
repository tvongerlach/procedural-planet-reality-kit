//
//  ProceduralPlanetsApp.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 7/15/24.
//

import SwiftUI
import RealityKitContent
import SwiftData

@main
struct ProceduralPlanetsApp: App {
    
    @Environment(\.physicalMetrics) var physicalMetrics
    
    @State var appState = AppState()
    
    var body: some Scene {
        
        WindowGroup {
            PlanetLibrary()
                .modelContainer(for: [
                    PlanetModel.self
                ])
                .environment(appState)
        }
        
        WindowGroup(for: UUID.self) { id in
            if let value = id.wrappedValue,
                let planetModel = appState.planetModelMap[value] {
                PlanetEditorView(planetModel: planetModel)
                    .environment(appState)
            }
        }.windowStyle(.plain)
    }
    
}
