//
//  PlanetLibrary.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 8/16/24.
//

import Foundation
import SwiftUI
import SwiftData

struct PlanetLibrary: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openWindow) private var openWindow
    @Environment(AppState.self) private var appState
    
    @Query(sort: \PlanetModel.name) private var planetModels: [PlanetModel]
    @State var selectedPlanet: PlanetModel?
    
    var body: some View {
        NavigationStack {
            VStack {
                if planetModels.isEmpty {
                    Text("Add your first planet!")
                } else {
                    List(selection: $selectedPlanet) {
                        ForEach(planetModels) { planet in
                            Button("\(planet.name)") {
                                let uuid = UUID()
                                appState.planetModelMap[uuid] = planet
                                openWindow(value: uuid)
                            }
                        }
                        .onDelete(perform: deletePlanets)
                    }
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .bottomOrnament) {
                    Button(action: {
                        addPlanet()
                    }) {
                        Label("Add Planet", systemImage: "plus")
                    }
                    .labelStyle(.titleAndIcon)
                }
            }
        }
    }
    
    private func addPlanet() {
        let newPlanet = PlanetModel.samplePlanet()
        newPlanet.name = "Planet \(planetModels.count + 1)"
        modelContext.insert(newPlanet)
    }
    
    private func deletePlanets(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(planetModels[index])
        }
    }
    
}

#Preview {
    VStack {
        PlanetLibrary()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .glassBackgroundEffect()
    .modelContainer(try! ModelContainer.sample())
}

extension ModelContainer {
    static var sample: () throws -> ModelContainer = {
        let schema = Schema([PlanetModel.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        Task { @MainActor in
            PlanetModel.insertSampleData(modelContext: container.mainContext)
        }
        return container
    }
}

extension PlanetModel {
    
    static func insertSampleData(modelContext: ModelContext) {
        let planetOne = PlanetModel.samplePlanet()
        planetOne.name = "Earth"
        
        let planetTwo = PlanetModel.samplePlanet()
        planetOne.name = "Mars"
        
        modelContext.insert(planetOne)
        modelContext.insert(planetTwo)
    }
    
}
