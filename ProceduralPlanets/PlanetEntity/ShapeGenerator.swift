//
//  ShapeGenerator.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 8/20/24.
//

import Foundation
import RealityKit

struct ShapeGenerator {
    
    var shapeSettings: ShapeSettings
    var noiseFilters: [NoiseFilter]
    var elevationMinMax: MinMax
    
    init(shapeSettings: ShapeSettings) {
        self.shapeSettings = shapeSettings
        self.noiseFilters = shapeSettings.noiseLayers.map({ NoiseFilter(noiseSettings: $0.noiseSettings) })
        self.elevationMinMax = MinMax()
    }
    
    func calculatePointOnPlanet(pointOnUnitSphere: SIMD3<Float>) -> SIMD3<Float> {
        var firstLayerValue: Float = 0
        var elevation: Float = 0
        
        if noiseFilters.count > 0 {
            firstLayerValue = noiseFilters[0].evaluatePoint(pointOnUnitSphere)
            if shapeSettings.noiseLayers[0].enabled {
                elevation = firstLayerValue
            }
        }
        
        if !noiseFilters.isEmpty {
            for i in 1..<noiseFilters.count {
                if shapeSettings.noiseLayers[i].enabled {
                    let mask = shapeSettings.noiseLayers[i].useFirstLayerAsMask ? firstLayerValue : 1
                    elevation += noiseFilters[i].evaluatePoint(pointOnUnitSphere) * mask
                }
            }
        }
        
        elevation = shapeSettings.radius * (1+elevation)
        elevationMinMax.addValue(elevation)
        
        return pointOnUnitSphere * elevation
    }
    
}
