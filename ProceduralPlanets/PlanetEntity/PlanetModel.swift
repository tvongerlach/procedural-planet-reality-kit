//
//  PlanetConfiguration.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 8/15/24.
//

import Foundation
import SwiftData
import SwiftUI
import CoreGraphics
import CoreImage

@Model
class PlanetModel {

    var name: String
    var meshConfiguration: MeshConfiguration
    var textureConfiguration: TextureConfiguration
    
    init(name: String, meshConfiguration: MeshConfiguration, textureConfiguration: TextureConfiguration) {
        self.meshConfiguration = meshConfiguration
        self.textureConfiguration = textureConfiguration
        self.name = name
    }
    
}

struct MeshConfiguration: Equatable, Codable {
    
    let resolution: Int
    var shapeSettings: ShapeSettings
    
    init(resolution: Int, shapeSettings: ShapeSettings) {
        self.resolution = resolution
        self.shapeSettings = shapeSettings
    }
    
}

struct ShapeSettings: Equatable, Codable {
    
    var radius: Float
    var noiseLayers: [NoiseLayer]
    
}

struct NoiseLayer: Equatable, Hashable, Codable {
    var enabled = true
    var useFirstLayerAsMask = true
    var noiseSettings: NoiseSettings
}

struct NoiseSettings: Equatable, Hashable, Codable {
    var numberOfLayers: Int
    var persistance: Float
    var baseRoughness: Float
    var strength: Float
    var roughness: Float
    var center: SIMD3<Float>
    var minValue: Float
}

struct TextureConfiguration: Codable {
    var gradientPoints: [GradientPoint]
}

struct GradientPoint: Identifiable, Codable {
    
    let id: UUID
    
    var color: Color
    var position: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case color
        case position
    }
    
    init(color: Color, position: Float) {
        self.id = UUID()
        self.color = color
        self.position = position
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        position = try container.decode(Float.self, forKey: .position)
        
        let codableColor = try container.decode(CodableColor.self, forKey: .color)
        color = Color(cgColor: codableColor.cgColor)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(position, forKey: .position)
        
        guard let cgColor = color.cgColor else {
            throw CodingError.wrongColor
        }
        let codableColor = CodableColor(cgColor: cgColor)
        try container.encode(codableColor, forKey: .color)
    }
    
}

struct CodableColor: Codable {
    
    let cgColor: CGColor
    
    enum CodingKeys: String, CodingKey {
        case colorSpace
        case components
    }
    
    init(cgColor: CGColor) {
        self.cgColor = cgColor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorSpace = try container.decode(String.self, forKey: .colorSpace)
        let components = try container.decode([CGFloat].self, forKey: .components)
        
        guard
            let cgColorSpace = CGColorSpace(name: colorSpace as CFString),
            let cgColor = CGColor(
                colorSpace: cgColorSpace, components: components
            )
        else {
            throw CodingError.wrongData
        }
        
        self.cgColor = cgColor
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard
            let colorSpace = cgColor.colorSpace?.name,
            let components = cgColor.components
        else {
            throw CodingError.wrongData
        }
              
        try container.encode(colorSpace as String, forKey: .colorSpace)
        try container.encode(components, forKey: .components)
    }
    
}

enum CodingError: Error {
    case wrongColor
    case wrongData
}
