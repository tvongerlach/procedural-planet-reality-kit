//
//  ContentView.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 7/15/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct PlanetView: View {
    
    @Environment(\.physicalMetrics) var physicalMetrics
    
    var viewModel: PlanetEditorViewModel
    
    let root = Entity()
    
    @State private var planetEntity: PlanetEntity?
    
    var body: some View {
        RealityView { content in
            
            content.add(root)
            
            let planet = try! await PlanetEntity(meshConfiguration: viewModel.meshConfiguration,
                                                 imageTexture: viewModel.textureImage)
            self.planetEntity = planet
            
            root.addChild(planet)
        }
        .onChange(of: self.viewModel.meshConfiguration) { _, newValue in
            Task {
                try! await self.planetEntity?.updatePlanetConfig(meshConfiguration: newValue)
                if let image = self.viewModel.textureImage {
                    self.planetEntity?.updateImageTexture(image)
                }
            }
        }
        .onChange(of: self.viewModel.textureImage) { _, newValue in
            if let newValue {
                self.planetEntity?.updateImageTexture(newValue)
            }
        }
    }

}
