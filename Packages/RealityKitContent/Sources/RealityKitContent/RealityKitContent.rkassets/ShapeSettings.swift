//
//  ShapeSettings.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 7/21/24.
//

import Foundation
import RealityKit

struct ShapeSettings: Component, Codable {
    
    let radius: Float
    
}

struct ColorSettings: Component {
    
    let color: SimpleMaterial.BaseColor
    
}
