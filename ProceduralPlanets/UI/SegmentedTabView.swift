//
//  SegmentedTabView.swift
//  ProceduralPlanets
//
//  Created by Tassilo von Gerlach on 8/14/24.
//

import SwiftUI

struct SegmentedTabView<Content: View>: View {
    @Binding var selectedTab: Int
    let tabs: [String]
    let content: (Int) -> Content
    
    init(selectedTab: Binding<Int>, tabs: [String], @ViewBuilder content: @escaping (Int) -> Content) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Segmented Tab Bar
            Picker("", selection: $selectedTab) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Text(tabs[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Content View
            content(selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
