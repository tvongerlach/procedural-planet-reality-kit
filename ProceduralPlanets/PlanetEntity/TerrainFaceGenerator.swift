//
//  TerrainFace.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 7/16/24.
//

import Foundation
import RealityKit

struct TerrainFaceGenerator {
    
    let shapeGenerator: ShapeGenerator
    
    func constructMesh(resolution: Int, localUp: SIMD3<Float>) -> MeshDescriptor  {
        let tangentA: SIMD3<Float> = SIMD3<Float>(localUp.y, localUp.z, localUp.x)
        let tangentB: SIMD3<Float> = simd_cross(localUp, tangentA)
        
        var vertices = [SIMD3<Float>](repeating: .zero, count: resolution * resolution)
        var triangles = [UInt32](repeating: 0, count: (resolution - 1) * (resolution - 1) * 6)
        
        var triangleIndex = 0
                
        for y in 0..<resolution {
            for x in 0..<resolution {
                let i = x + y * resolution
                let percent = SIMD2<Float>(Float(x), Float(y)) / Float(resolution - 1)
                
                let normalizedCoordinateX = (percent.x - 0.5) * 2
                let normalizedCoordinateY = (percent.y - 0.5) * 2

                let tangentAOffset = normalizedCoordinateX * tangentA
                let tangentBOffset = normalizedCoordinateY * tangentB

                let pointOnUnitCube = localUp + tangentAOffset + tangentBOffset

                let pointOnUnitSphere = simd_normalize(pointOnUnitCube)
                
                vertices[i] = shapeGenerator.calculatePointOnPlanet(pointOnUnitSphere: pointOnUnitSphere)
                
                guard (x != resolution - 1 && y != resolution - 1) else { continue }
                
                triangles[triangleIndex] = UInt32(i)
                triangles[triangleIndex + 1] = UInt32(i) + UInt32(resolution) + UInt32(1)
                triangles[triangleIndex + 2] = UInt32(i) + UInt32(resolution)
                
                triangles[triangleIndex + 3] = UInt32(i)
                triangles[triangleIndex + 4] = UInt32(i) + UInt32(1)
                triangles[triangleIndex + 5] = UInt32(i) + UInt32(resolution) + UInt32(1)
                triangleIndex += 6
            }
        }
        
        var descriptor = MeshDescriptor(name: "face")
        descriptor.positions = MeshBuffers.Positions(vertices)
        descriptor.primitives = .triangles(triangles)
        
        return descriptor
    }
    
}
