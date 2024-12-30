import SwiftUI

struct ClassementView: View {
    var displayedCars: [String] // Liste des noms de voitures
    var Chevaux: Double
    @State private var useMPH: Bool = UserDefaults.standard.bool(forKey: "useMPH")
    @State private var useKW: Bool = UserDefaults.standard.bool(forKey: "useKW")
    
    @State private var visibleCars: [String] = [] // État pour garder la trace des voitures visibles
    @State private var currentIndex = 0 // Pour suivre quel élément afficher
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            VStack {
                Text("Power Rivals ⚔️")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10) // Espacement entre le titre et la liste
                List {
                    ForEach(0..<visibleCars.count + 1, id: \.self) { index in
                        HStack {
                            
                            if index == visibleCars.count / 2 {
                                // Affiche "You" au milieu de la liste
                                Text("🏆 Your Power: \(Int(useKW ? Chevaux : Chevaux * 0.98632)) HorsePower !")
                                    .font(.body)
                                    .foregroundColor(.yellow) // Couleur spéciale pour "You"
                                    .fontWeight(.bold)
                            } else {
                                // Affiche les éléments de la liste autour de "You"
                                let carIndex = index > visibleCars.count / 2 ? index - 1 : index
                                Text(visibleCars[carIndex])
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .id(visibleCars[carIndex]) // Attribuer un ID aux voitures
                            }
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color(hex: "1E1E1E")) // Couleur d'arrière-plan des lignes
                    }
                }
                .listStyle(.plain) // Style de liste
                .frame(width: 400, height: 300) // Ajustez la taille de la liste
            }
            .onAppear {
                // Commence à ajouter des voitures une par une
                addCarsWithAnimation(scrollProxy: scrollProxy)
            }
        }
    }
    
    private func addCarsWithAnimation(scrollProxy: ScrollViewProxy) {
        // Ajoute les voitures une par une avec un délai
        for (index, car) in displayedCars.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                withAnimation {
                    visibleCars.append(car) // Ajoute la voiture à la liste visible
                }
            }
        }

        // Ajouter un délai final pour faire défiler vers "You" après que toutes les voitures ont été ajoutées
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(displayedCars.count) * 0.30) {
            withAnimation {
                scrollProxy.scrollTo(displayedCars.count / 2, anchor: .center) // Défiler vers "You"
            }
        }
    }
}

#Preview {
    ClassementView(displayedCars: ["Ferrari", "Lamborghini", "Porsche", "Bugatti", "Tesla"], Chevaux: 300)
}
