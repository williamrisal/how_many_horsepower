import SwiftUI

struct CircularProgressBarView: View {
    @Binding var progress: Int // Représente la progression de 0 à 100
    let maxSpeed: Double = 100
    
    var body: some View {
        ZStack {
            // Cercle de fond (statique)
            Circle()
                .trim(from: 0.0, to: 0.8) // Limite à un demi-cercle
                .stroke(lineWidth: 30.0)
                .opacity(0.3)
                .foregroundColor(Color.gray)
                .rotationEffect(Angle(degrees: 125))
            
            // Graduation avec numéros
            GraduationView(divisions: 10, maxSpeed: maxSpeed) // 10 divisions avec numéros
            
            // Cercle de progression (animé)
            Circle()
                .trim(from: 0.0, to: min(Double(progress) / 100, 1.0) * 0.8) // Normalisation de la progression (0.0 à 1.0) et ajustement à 0.8
                .stroke(style: StrokeStyle(lineWidth: 35.0, lineCap: .round, lineJoin: .round)) // Correspond à l'épaisseur du cercle statique
                .foregroundColor(progress >= 100 ? .orange : .yellow) // Si la progression atteint 100, changer de couleur
                .rotationEffect(Angle(degrees: 125)) // Alignement sur le cercle de fond
                .animation(.linear(duration: 0.2), value: progress)

            // Aiguille
            AiguilleView(progress: Double(progress) / 100)
                .padding(.top, 100)
        }
        .frame(width: 327, height: 327) // Fixe la taille du cercle à 327x327
        .padding(40)
    }
}

struct GraduationView: View {
    let divisions: Int
    let maxSpeed: Double

    var body: some View {
        ForEach(0...divisions, id: \.self) { i in
            VStack {
                // Graduation line
                Rectangle()
                    .fill(Color(hex: "8D8D8E"))
                    .frame(width: 1.25, height: 6.24) // Dimensions des graduations
                    .offset(y: -130) // Positionne les graduations sur le bord extérieur
                
                // Text for the numbers
                Text("\(Int(Double(i) * maxSpeed / Double(divisions)))") // Numéros des graduations
                    .font(.system(size: 14, weight: .light, design: .default))
                    .foregroundColor(Color(hex: "8D8D8E"))
                    .offset(y: -130) // Positionne les numéros près des graduations
            }
            .rotationEffect(Angle(degrees: Double(i) * 280.0 / Double(divisions)))
        }
        .rotationEffect(Angle(degrees: 220)) // Faire commencer les graduations à 9 heures
    }
}

#Preview {
    CircularProgressBarView(progress: .constant(100))
}
