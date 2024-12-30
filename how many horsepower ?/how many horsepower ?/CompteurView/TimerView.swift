//
//  TimerView.swift
//  how many horsepower ?
//
//  Created by William Risal on 21/10/2024.
//

import SwiftUI

// TimerView pour afficher le temps écoulé
struct TimerView: View {
    @Binding var elapsedTime: Double
    
    var body: some View {
        VStack {
            Text(String(format: "%.2f", elapsedTime))
                .font(.system(size: 30, weight: .bold, design: .default))
                .foregroundColor(Color(hex: "FF9C07")) // Couleur similaire au jaune dans l'image
                .padding(.bottom, 2)
            Text("Second")
                .font(.system(size: 15, weight: .semibold, design: .default))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    TimerView(elapsedTime: .constant(1.5))
}
