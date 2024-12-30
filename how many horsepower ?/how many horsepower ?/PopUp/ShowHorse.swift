import SwiftUI
import Combine
import UIKit

struct ShowHorse: View {
    var targetNumber: Int
    @State private var currentNumber: Int = 0
    @State private var cancellable: AnyCancellable?
    @State private var incrementationNumber = 10
    @State private var useMPH: Bool = UserDefaults.standard.bool(forKey: "useMPH")

    
    init(targetNumber: Double) {
        @State  var useKW: Bool = UserDefaults.standard.bool(forKey: "useKW")
        self.targetNumber = useKW ? Int(targetNumber) : Int(targetNumber * 0.98632)
    }

    var body: some View {
        VStack {
                VStack {
                    Text("\(currentNumber)")
                        .font(.system(size: 100))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "FF9C07"))
                        .scaleEffect(1.5)
                        .animation(.easeInOut(duration: 0.1), value: currentNumber)
                        .padding()
                }

                .onAppear(perform: { startCounter() }) // Démarrer le compteur lors de l'apparition
            
        }
    }

    func startCounter() {
        currentNumber = 0
        cancellable = Timer.publish(every: 0.1, on: .main, in: .common) // Utiliser l'intervalle de base
            .autoconnect()
            .sink { _ in
                if self.currentNumber < self.targetNumber {
                    if(targetNumber - currentNumber <= 20){
                        incrementationNumber = 1
                    }
                    self.currentNumber += incrementationNumber // Incrémenter le compteur
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred() // Vibration à chaque incrément
                } else {
                    cancellable?.cancel() // Annuler le timer lorsque la cible est atteinte
                }
            }
    }
}

#Preview {
    ShowHorse(targetNumber: 100)
}
