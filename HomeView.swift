//
//  HomeView.swift
//  learning
//
//  Created by Kazuki Minami on 2023/12/17.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var presets: [Presets]
    
    @State private var path = NavigationPath()
    @State private var disableAnimation: Bool = true

    private var transaction: Transaction {
        var t = Transaction()
        t.disablesAnimations = disableAnimation
        return t
    }
    
    @State var selectedPreset: Presets
    @State var isActive: Bool = true
    @State private var isZero: Bool = false
    @State var isFocused: Bool = true
    @State private var secondsFocus: Int = 0
    @State private var secondsRest: Int = 0
    @State private var previousFocusTime: Int = 0
    @State private var previousRestTime: Int = 0
    @State private var cycles: Int = 0
    
    @State private var newPreset = Presets() // Assuming Presets has an initializer
    @State private var showingEditPresetView = false
    
    @State private var showEditSettings: Bool = false
    
    
    //Colors
    var buttonColor = Color(red: 89/255.0, green: 141/255.0, blue: 162/255.0)

    
    @State var example: Int = 10
    
    
    var body: some View {
        
        
        NavigationStack(path: $path.transaction(transaction)) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.dairyCream, location: 0.49),
                        .init(color: Color.dairyCream, location: 0.5),
                        .init(color: Color.seagull, location: 0.5),
                        .init(color: Color.seagull, location: 0.51)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all) // Ensure the gradient fills the entire screen
                
                VStack {
                    VStack {
                        NavigationLink(destination: SelectView(selectedPreset: $selectedPreset)) {
                            VStack {
                                if isFocused {
                                    CountdownView(timeRemaining: $secondsFocus, isActive: $isActive, isZero: $isZero)
                                } else {
                                    CountdownView(timeRemaining: $secondsRest, isActive: $isActive, isZero: $isZero)
                                }
                            }
                        }

                        Text(isFocused ? "Focus \(cycles)" : "Rest \(cycles)")
                            .font(.headline)
                            .foregroundStyle(Color.seagull)
                    }
                    .onAppear {
                        updateTotalSeconds()
                    }
                    .onChange(of: selectedPreset.rest) {
                        updateTotalSeconds()
                    }
                    .onChange(of: selectedPreset.focus) {
                        updateTotalSeconds()
                    }
                    .onChange(of: isZero){
                        checkZero()
                    }
                    .onChange(of: isFocused) {
                        if isFocused {
                            cycles += 1
                        }
                    }
                    
    
                    Image("cat1")
                        .resizable()
                        .scaledToFit()
                        .opacity(1)
                        .symbolRenderingMode(.multicolor)
                        .offset(y: 0)
                        .edgesIgnoringSafeArea(.all) // Make the image fill the whole screen
                    
                    //Buttons
                    HStack {
                        // Start Timer Button
                        Button(action: {
                            isActive.toggle()
                            previousRestTime = selectedPreset.rest
                            previousFocusTime = selectedPreset.focus
                        }) {
                            Text(isActive ? "Stop" : "Start")
                                .font(.bold(.headline)())
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(buttonColor)
                                .cornerRadius(30)
                        }
                        .padding()
                        
                        // Skip Button
                        Button(action: {
                            isActive = false //pauses the timer
                            isFocused.toggle() //Focus -> Rest, or Rest -> Focus
                            
                            //Reset time when skipped
                            
                            !isFocused ? (secondsRest = previousRestTime*60) : (secondsFocus = previousFocusTime*60)
                        }) {
                            Text("Skip")
                                .font(.bold(.headline)())
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(buttonColor)
                                .cornerRadius(30)
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    
    // Functions
    private func updateTotalSeconds() {
        secondsFocus = selectedPreset.focus * 60
        secondsRest = selectedPreset.rest * 60
    }
    
    func checkZero() {
        if isZero {
            print("isZero Working")
            selectedPreset.focus = previousFocusTime
            selectedPreset.rest = previousRestTime
            isActive = false
            isFocused.toggle()
        }
    }
    
    func addPreset() {
        let preset = Presets()
        modelContext.insert(preset)
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Presets.self, configurations: config)
        
        let example = Presets(id: 9, name: "Example", focus: 15, rest: 15)
        return HomeView(selectedPreset: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

//#Preview {
//    HomeView()
//}
