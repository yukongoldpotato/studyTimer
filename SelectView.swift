//
//  SelectView.swift
//  learning
//
//  Created by Kazuki Minami on 2023/12/18.
//

import SwiftUI
import SwiftData


struct SelectView: View {
    @Environment(\.modelContext) var modelContext
    @Query var presets: [Presets]
    @State private var path = [Presets]()
    @Binding var selectedPreset: Presets
    @State private var isActive: Bool = false

    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Color.dairyCream
                    .ignoresSafeArea()
                    
                    HStack {
                        Picker("", selection: $selectedPreset.focus){
                            ForEach(0..<60, id: \.self) { i in
                                Text("\(i)").tag(i)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .padding(.horizontal)
                        .scaleEffect(1.6)
                        .font(.largeTitle)
                        .bold()
                        
                        Text("Focus")
                        
                        Picker("", selection: $selectedPreset.rest){
                            ForEach(0..<60, id: \.self) { i in
                                Text("\(i)").tag(i)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .padding(.horizontal)
                        .scaleEffect(1.6)
                        .font(.largeTitle)
                        .bold()
                        
                        
                        Text("Rest")
                    }
                    .disabled(isActive)
                    .padding(.horizontal)
                    
            }
            .navigationTitle("Edit Time ")
    }
    }
    
}


struct PresetView: View {
    let preset: Presets
    let isSelected: Bool

    var body: some View {
        HStack {
            Text("\(preset.name) \(preset.focus) mins \(preset.rest) mins")
                .foregroundColor(isSelected ? Color.blue : Color.dairyCream) // Color("TextDefault") should be defined in your asset catalog
                .font(.headline) // You can create and use a custom font if you have one
                .bold()
                .padding(.vertical, 10)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.blue.opacity(0.2) : Color.clear) // Light blue background for selected state
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
                .shadow(color: isSelected ? Color.blue.opacity(0.5) : Color.clear, radius: 5, x: 0, y: 0)
        }
        .padding(.horizontal)
    }
}



#Preview {
    SelectView(selectedPreset: .constant(Presets(id: 9, name: "Example", focus: 15, rest: 15)))
}

