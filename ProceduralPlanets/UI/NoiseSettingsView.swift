import Foundation
import SwiftUI

struct NoiseSettingsView: View {
    
    @Binding var noiseLayer: NoiseLayer
    
    init(noiseLayer: Binding<NoiseLayer>) {
        _noiseLayer = noiseLayer
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Strength \(noiseLayer.noiseSettings.strength, specifier: "%.2f")")
                    .padding(.trailing, 20)
                Slider(value: $noiseLayer.noiseSettings.strength, in: 0...2)
            }
            HStack {
                Text("Base Roughness \(noiseLayer.noiseSettings.baseRoughness, specifier: "%.2f")")
                    .padding(.trailing, 20)
                Slider(value: $noiseLayer.noiseSettings.baseRoughness, in: 0...5)
            }
            HStack {
                Text("Roughness \(noiseLayer.noiseSettings.roughness, specifier: "%.2f")")
                    .padding(.trailing, 20)
                Slider(value: $noiseLayer.noiseSettings.roughness, in: 0...5)
            }
            HStack {
                Text("Number Of Layers \(noiseLayer.noiseSettings.numberOfLayers)")
                    .padding(.trailing, 20)
                Slider(value: Binding(
                    get: { Double(noiseLayer.noiseSettings.numberOfLayers) },
                    set: { noiseLayer.noiseSettings.numberOfLayers = Int($0.rounded()) }
                ), in: 0...10, step: 1.0)
            }
            HStack {
                Text("Persistance \(noiseLayer.noiseSettings.persistance, specifier: "%.2f")")
                    .padding(.trailing, 20)
                Slider(value: $noiseLayer.noiseSettings.persistance, in: 0...1)
            }
            HStack {
                Text("Min Value \(noiseLayer.noiseSettings.minValue, specifier: "%.2f")")
                    .padding(.trailing, 20)
                Slider(value: $noiseLayer.noiseSettings.minValue, in: 0...2)
            }
            VStack {
                Text("Center")
                HStack {
                    Text("X")
                    Slider(value: $noiseLayer.noiseSettings.center.x, in: -1...1)
                }
                HStack {
                    Text("Y")
                    Slider(value: $noiseLayer.noiseSettings.center.y, in: -1...1)
                }
                HStack {
                    Text("Z")
                    Slider(value: $noiseLayer.noiseSettings.center.z, in: -1...1)
                }
            }
        }
    }
}
