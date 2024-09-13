//
//  ColorGenerator.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 8/10/24.
//

import Foundation
import SwiftUI
import RealityKit

class ColorSettings {
    
    var gradient: Gradient
    var material: ShaderGraphMaterial
    
    init(gradient: Gradient, material: ShaderGraphMaterial) {
        self.gradient = gradient
        self.material = material
    }
    
}
