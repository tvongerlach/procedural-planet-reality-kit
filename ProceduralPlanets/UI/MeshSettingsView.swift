//
//  Untitled.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 8/14/24.
//

import Foundation
import SwiftUI
import RealityKit

struct MeshSettingsView: View {
    
    @Binding var planetConfiguration: MeshConfiguration
    
    @State private var resolution: Float
    
    init(planetConfiguration: Binding<MeshConfiguration>) {
        _planetConfiguration = planetConfiguration
        
        self.resolution = Float(planetConfiguration.wrappedValue.resolution)
    }
    
    var body: some View {
        Form {
            Section("Resolution: \(Int(resolution))") {
                Slider(value: $resolution, in: 2...200, step: 1.0, onEditingChanged: { isEditing in
                    if !isEditing {
                        let newConfig = MeshConfiguration(resolution: Int(self.resolution.rounded()),
                                                          shapeSettings: planetConfiguration.shapeSettings)
                        planetConfiguration = newConfig
                    }
                })
            }
            Section("Noise Layers") {
                ForEach(planetConfiguration.shapeSettings.noiseLayers.indices, id: \.self) { index in
                    DisclosureGroup {
                        VStack(alignment: .leading) {
                            Toggle("Enable Layer", isOn: Binding(
                                get: { planetConfiguration.shapeSettings.noiseLayers[index].enabled },
                                set: { newValue in
                                    planetConfiguration.shapeSettings.noiseLayers[index].enabled = newValue
                                }
                            ))
                            Toggle("Use First Layer As Mask", isOn: Binding(
                                get: { planetConfiguration.shapeSettings.noiseLayers[index].useFirstLayerAsMask },
                                set: { newValue in
                                    planetConfiguration.shapeSettings.noiseLayers[index].useFirstLayerAsMask = newValue
                                }
                            ))
                            Text("Noise Settings")
                                .font(.title)
                            NoiseSettingsView(noiseLayer: Binding(get: {
                                planetConfiguration.shapeSettings.noiseLayers[index]
                            }, set: {
                                planetConfiguration.shapeSettings.noiseLayers[index] = $0
                            }))
                        }
                    } label: {
                        HStack {
                            Text("Noise Layer \(index + 1)")
                            Spacer()
                            if planetConfiguration.shapeSettings.noiseLayers[index].enabled {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteNoiseLayers)
                
                Button(action: addNoiseLayer) {
                    Label("Add Noise Layer", systemImage: "plus")
                }
            }
        }
    }
    
    private func deleteNoiseLayers(at offsets: IndexSet) {
        planetConfiguration.shapeSettings.noiseLayers.remove(atOffsets: offsets)
    }
    
    private func addNoiseLayer() {
        let settings = NoiseSettings(numberOfLayers: 5,
                                     persistance: 0.4,
                                     baseRoughness: 1.2,
                                     strength: 0.3,
                                     roughness: 2,
                                     center: .zero,
                                     minValue: 0.95)
        let newNoiseLayer = NoiseLayer(enabled: true, noiseSettings: settings)
        planetConfiguration.shapeSettings.noiseLayers.append(newNoiseLayer)
    }
    
}
