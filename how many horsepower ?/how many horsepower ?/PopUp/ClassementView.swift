import SwiftUI

struct ClassementView: View {
    var displayedCars: [String] // Liste des noms de voitures
    var Chevaux: Double
    @State private var useMPH: Bool = UserDefaults.standard.bool(forKey: "useMPH")
    @State private var useKW: Bool = UserDefaults.standard.bool(forKey: "useKW")
    
    @State private var visibleCars: [String] = [] // État pour garder la trace des voitures visibles
    @State private var currentIndex = 0 // Pour suivre quel élément afficher
    
    @State private var showPopup = false // État pour afficher ou non la popup
    @State private var showAdvantagesView = false // État pour afficher la vue Premium

    var body: some View {
        ZStack {
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
            
            // Popup pour afficher les informations premium
            if showPopup {
                VStack(spacing: 20) {
                    Text("🚀 Débloquez votre couple moteur !")
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Découvrez des fonctionnalités exclusives comme le couple moteur, les courbes de performance, et bien plus encore.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    HStack {
                        Button(action: {
                            showPopup = false // Ferme la popup
                        }) {
                            Text("Non, merci")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding()
                        }

                        Button(action: {
                            showPopup = false // Ferme la popup
                            showAdvantagesView = true // Active la vue Premium
                        }) {
                            Text("En savoir plus")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(15)
                .shadow(radius: 10)
                .transition(.scale.combined(with: .opacity)) // Animation de transition
                .zIndex(1) // Assurez-vous que la popup est au-dessus
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(displayedCars.count) * 0.30 + 3.0) {
                withAnimation {
                    showPopup = true
                }
            }
        }
        .sheet(isPresented: $showAdvantagesView) {
            AdvantagesView() // Assurez-vous que cette vue est bien importée
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
