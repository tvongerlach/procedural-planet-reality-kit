//
//  AppModel.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 8/18/24.
//

import Foundation

@Observable
class AppState {
    
    var planetModelMap = [UUID: PlanetModel]()
    
}
