import SwiftUI

struct TopBarView: View {
    var navigateToSettings: () -> Void // Pass a function to trigger navigation from the parent

    var body: some View {
        HStack {
            // Logo to the left
            Image("Image") // Charge l'image depuis les assets
                .resizable()
                .frame(width: 40, height: 40)
                .overlay(
                    Text(NSLocalizedString("top_bar_logo", comment: "Logo text"))
                        .font(.caption)
                        .foregroundColor(.black)
                )
                .cornerRadius(8)

            Spacer()
            
            // App name in the center
            Text(NSLocalizedString("top_bar_title", comment: "App title in the top bar"))
                .font(.system(size: 18, weight: .light, design: .default))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            // Gear icon to the right
            Button(action: navigateToSettings) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "gearshape")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal)
        .background(Color(hex: "1E1E1E"))
    }
}
