import SwiftUI

struct AiguilleView: View {
    var progress: Double // Progrès de la rotation de l'aiguille

    var body: some View {
        ZStack {
            
            // Aiguille avec effet de gradient en opacité
            RoundedRectangle(cornerRadius: 13)
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "FF9C07").opacity(0.15), location: 0.0), // Dégradé de l'opacité (15% en bas)
                        .init(color: Color(hex: "FF9C07").opacity(1.0), location: 1.0)  // 100% opacité en haut
                    ]),
                    startPoint: .top,
                    endPoint: .bottom))
                .frame(width: 16, height: 130) // Dimensions de l'aiguille
                .offset(y: -60) // Décale l'aiguille pour que sa base soit à l'origine de la rotation
                // Ajuster l'angle de rotation pour qu'il corresponde à la progression et au cercle
                .rotationEffect(Angle(degrees: (progress * 360.0) * 0.8 - 144.0)) // Utiliser 80% de 360 pour correspondre au cercle
                .animation(.easeInOut(duration: 0.2), value: progress)

            Circle()
                .stroke(Color(hex: "FF9C07"), lineWidth: 4) // Cercle creux avec contour orange
                .frame(width: 26, height: 26) // Taille du cercle
                .background(Circle().fill(Color(hex: "1E1E1E"))) // Cercle plein blanc à l'intérieur
        }
        .frame(width: 10, height: 100)
        .rotationEffect(Angle(degrees: 0)) // Faire commencer l'aiguille à la même position que le cercle (125° à -144°)
        .offset(y: -50) // Corrige l'offset pour que l'aiguille tourne à partir du bas
    }
}




// Extension pour utiliser les couleurs HEX dans SwiftUI
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    AiguilleView(progress: 0.0)
}
