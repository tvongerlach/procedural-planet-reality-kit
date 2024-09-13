//
//  PlanetGallery.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 8/6/24.
//

import Foundation
import SwiftUI
import RealityKit
import CoreGraphics

struct EditorControlsView: View {
    
    @Environment(\.physicalMetrics) var physicalMetrics
    
    var viewModel: PlanetEditorViewModel
    
    @State private var selectedTab = 0
    let tabs = ["Mesh", "Materials"]
    
    var body: some View {
        SegmentedTabView(selectedTab: $selectedTab, tabs: tabs) { index in
            switch index {
            case 0:
                @Bindable var viewModel = viewModel
                MeshSettingsView(planetConfiguration: $viewModel.meshConfiguration)
            case 1:
                MaterialSettingsView(viewModel: viewModel)
            default:
                EmptyView()
            }
        }
        .padding()
    }
    
}

@Observable
class PlanetEditorViewModel {
    
    var meshConfiguration: MeshConfiguration
    var textureConfiguration: TextureConfiguration {
        didSet {
            self.textureImage = createProceduralPlanetTexture(size: .init(width: 200, height: 100))
        }
    }
    var planetName: String
    
    var textureImage: CGImage?
    
    private var planetModel: PlanetModel
    
    init(planetModel: PlanetModel) {
        self.planetModel = planetModel
        self.meshConfiguration = planetModel.meshConfiguration
        self.textureConfiguration = planetModel.textureConfiguration
        self.planetName = planetModel.name
        self.textureImage = createProceduralPlanetTexture(size: .init(width: 200, height: 100))
    }
    
    func save() {
        planetModel.name = planetName
        planetModel.meshConfiguration = self.meshConfiguration
        planetModel.textureConfiguration = self.textureConfiguration
    }
    
    func createProceduralPlanetTexture(size: CGSize) -> CGImage? {
        guard let cgImage = createMultiColorGradient(size: size, gradientPoints: textureConfiguration.gradientPoints) else {
            return nil
        }
    
        return cgImage
    }
    
    func createMultiColorGradient(size: CGSize, gradientPoints: [GradientPoint]) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let cgColors = gradientPoints.map { $0.color.cgColor } as CFArray
        let locations = gradientPoints.map({ CGFloat($0.position) })
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: locations) else {
            return nil
        }
        
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.drawLinearGradient(gradient,
                                   start: CGPoint(x: 0, y: 0),
                                   end: CGPoint(x: size.width, y: 0),
                                   options: [])
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        return image.cgImage
    }
    
}

struct PlanetEditorView: View {
    
    @Environment(\.physicalMetrics) var physicalMetrics
    
    @State var viewModel: PlanetEditorViewModel
    
    init(planetModel: PlanetModel) {
        _viewModel = State(initialValue: PlanetEditorViewModel(planetModel: planetModel))
    }
    
    var body: some View {
        HStack {
            NavigationStack {
                HStack {
                    EditorControlsView(viewModel: viewModel)
                }
                .navigationTitle(viewModel.planetName)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            viewModel.save()
                        }
                    }
                }
            }
            PlanetView(viewModel: viewModel)
        }
    }
                                                         
}

#Preview(windowStyle: .volumetric) {
    PlanetEditorView(planetModel: .samplePlanet())
}

extension PlanetModel {
    
    static func samplePlanet() -> PlanetModel {
        let firstLayerSettings = NoiseSettings(numberOfLayers: 5,
                                               persistance: 0.4,
                                               baseRoughness: 1.2,
                                               strength: 0.3,
                                               roughness: 2,
                                               center: .zero,
                                               minValue: 0.95)
        let firstNoiseLayer = NoiseLayer(enabled: true,
                                         useFirstLayerAsMask: false,
                                         noiseSettings: firstLayerSettings)
        
        let secondLayerSettings = NoiseSettings(numberOfLayers: 5,
                                                persistance: 0.5,
                                                baseRoughness: 1,
                                                strength: 4,
                                                roughness: 2,
                                                center: .init(x: 0, y: 0, z: 0),
                                                minValue: 1.2)
        let secondNoiseLayer = NoiseLayer(enabled: true,
                                          useFirstLayerAsMask: true,
                                          noiseSettings: secondLayerSettings)
        
        let shapeSettings = ShapeSettings(radius: 0.15, noiseLayers: [firstNoiseLayer,
                                                                     secondNoiseLayer
                                                                    ])
        let meshConfiguration = MeshConfiguration(resolution: 50,
                                                  shapeSettings: shapeSettings)
        
        let textureConfiguration = TextureConfiguration(gradientPoints: [
            GradientPoint(color: Color(red: 0, green: 0, blue: 0.5), position: 0),
            GradientPoint(color: Color(red: 1, green: 1, blue: 1), position: 1)
        ])
        return PlanetModel(name: "Sample Planet",
                           meshConfiguration: meshConfiguration,
                           textureConfiguration: textureConfiguration)
    }
    
}
