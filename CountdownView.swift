//
//  MasterView.swift
//  learning
//
//  Created by Kazuki Minami on 2023/11/20.
//

import SwiftUI

struct CountdownView: View {
    @Binding var timeRemaining: Int // time in seconds
    @Binding var isActive: Bool
    @Binding var isZero: Bool

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text(timeString())
                //.font(.system(size: 72))
                .onReceive(timer) { _ in
                    if isActive && timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                    else if timeRemaining == 0 {
                        isZero = true
                    }
                }
                .font(.system(size: 93, weight: .semibold, design: .rounded)) // A rounded, playful font
                .foregroundColor(Color(red: 83/255.0, green: 164/255.0, blue: 255/255.0)) // A color that matches the cat's bandana
                //.shadow(color: .gray, radius: 2, x: 0, y: 2) // Subtle shadow for depth
                .padding(.top, 20) // Adjust padding as needed
        }
    }

    // Function to format time from seconds to "mm:ss"
    func timeString() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}



#Preview {
    CountdownView(timeRemaining: .constant(100), isActive: .constant(true), isZero: .constant(false))
}
