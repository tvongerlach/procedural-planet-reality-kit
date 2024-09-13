//
//  TextureParameterEditorView.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 8/13/24.
//

import SwiftUI
import CoreImage

struct MaterialSettingsView: View {
    
    @Bindable var viewModel: PlanetEditorViewModel
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Gradient Points")) {
                    ForEach($viewModel.textureConfiguration.gradientPoints) { $point in
                        HStack {
                            ColorPicker("Color", selection: $point.color)
                            Slider(value: $point.position, in: 0...1)
                            Text(String(format: "%.2f", point.position))
                        }
                    }
                    .onDelete(perform: deleteGradientPoint)
                    
                    Button("Add Gradient Point") {
                        addGradientPoint()
                    }
                }
            }
            
            TexturePreview(image: viewModel.textureImage)
                .frame(height: 200)
                .padding()
        }
    }
    
    private func deleteGradientPoint(at offsets: IndexSet) {
        viewModel.textureConfiguration.gradientPoints.remove(atOffsets: offsets)
    }
    
    private func addGradientPoint() {
        let newPoint = GradientPoint(color: .white, position: 0.5)
        viewModel.textureConfiguration.gradientPoints.append(newPoint)
    }
}

struct TexturePreview: View {
    
    let image: CGImage?
    
    var body: some View {
        if let image {
            Image(image, scale: 1.0, label: Text("Procedural Planet Texture"))
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }

}
