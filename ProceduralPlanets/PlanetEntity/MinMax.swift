//
//  MinMax.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 8/8/24.
//

import Foundation

class MinMax {
    
    private(set) var min: Float
    private(set) var max: Float
    
    init() {
        self.min = Float.greatestFiniteMagnitude
        self.max = -Float.greatestFiniteMagnitude
    }
    
    func addValue(_ value: Float) {
        if value > max {
            max = value
        }
        if value < min {
            min = value
        }
    }
    
}
