//
//  Planet.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 7/16/24.
//

import Foundation
import RealityKit
import RealityKitContent
import Combine
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

@MainActor
class PlanetEntity: Entity {
    
    init(meshConfiguration: MeshConfiguration, imageTexture: CGImage?) async throws {
        super.init()
        try await self.updatePlanetConfig(meshConfiguration: meshConfiguration)
        if let imageTexture {
            self.updateImageTexture(imageTexture)
        }
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func updatePlanetConfig(meshConfiguration: MeshConfiguration) async throws {
        let shapeGenerator = ShapeGenerator(shapeSettings: meshConfiguration.shapeSettings)
        let meshResource = try await createMeshResource(resolution: meshConfiguration.resolution,
                                                        shapeGenerator: shapeGenerator)
        let material = await self.createMaterial(elevationMin: shapeGenerator.elevationMinMax.min, elevationMax: shapeGenerator.elevationMinMax.max)
        let modelComponent = ModelComponent(mesh: meshResource,
                                            materials: [material])
        self.components.set(modelComponent)
    }
    
    func updateImageTexture(_ texture: CGImage) {
        guard var modelComponent = self.modelComponent else { return }
        guard var material = modelComponent.materials.first as? ShaderGraphMaterial else { return }
        let textureResource = try! TextureResource(image: texture, options: .init(semantic: .color))
        try! material.setParameter(name: "texture", value: .textureResource(textureResource))
        modelComponent.materials = [material]
        self.components.set(modelComponent)
    }
    
    private func createMeshResource(resolution: Int, shapeGenerator: ShapeGenerator) async throws -> MeshResource {
        let directions: [SIMD3<Float>] = [
            SIMD3<Float>(0, 1, 0),   // up
            SIMD3<Float>(0, -1, 0),  // down
            SIMD3<Float>(-1, 0, 0),  // left
            SIMD3<Float>(1, 0, 0),   // right
            SIMD3<Float>(0, 0, 1),   // forward
            SIMD3<Float>(0, 0, -1)   // back
        ]
        
        let faceGenerator = TerrainFaceGenerator(shapeGenerator: shapeGenerator)
        let meshDescriptors = directions.map({ faceGenerator.constructMesh(resolution: resolution, localUp: $0) })
        return try await MeshResource(from: meshDescriptors)
    }
    
    private func createMaterial(elevationMin: Float, elevationMax: Float) async -> ShaderGraphMaterial {
        
        var customMaterial = try! await ShaderGraphMaterial(named: "/Root/MyMaterial/MyMaterial",
                                                            from: "Immersive",
                                                            in: realityKitContentBundle)
        
        try! customMaterial.setParameter(name: "min", value: .float(elevationMin))
        try! customMaterial.setParameter(name: "max", value: .float(elevationMax))
        
        return customMaterial
    }
    
}

extension Entity {
    
    var modelComponent: ModelComponent? {
        return self.components.first(where: { $0 is ModelComponent }) as? ModelComponent
    }
    
}
