import SwiftUI
import AVFoundation

struct CountdownView: View {
    @Binding var isActive: Bool
    @State private var countdownValue = 3
    @State private var player: AVAudioPlayer?

    var body: some View {
        ZStack {
            if isActive {
                Text(countdownValue > 0 ? "\(countdownValue)" : "GO!")
                    .font(.system(size: 220, weight: .bold))
                    .foregroundColor(countdownValue > 0 ? .orange : .white)
                    .transition(.scale)
                    .animation(.easeInOut, value: countdownValue)
                    .onAppear {
                        loadSound()
                        startCountdownIfNeeded()
                    }
                    .onChange(of: isActive) {
                        if isActive {
                            startCountdownIfNeeded()
                        } else {
                            resetCountdown()
                        }
                    }
            }
        }
    }
    
    // Fonction pour charger le son
    func loadSound() {
        guard let url = Bundle.main.url(forResource: "countStartSound", withExtension: "mp3") else {
            print("Le fichier son 'countStartSound.mp3' est introuvable.")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch {
            print("Erreur de chargement du son: \(error.localizedDescription)")
        }
    }

    // Fonction pour démarrer le compte à rebours
    private func startCountdownIfNeeded() {
        if countdownValue == 3 {
            DispatchQueue.global(qos: .background).async {
                startCountdown()
            }
        }
    }

    private func startCountdown() {
        countdownValue = 3
        player?.play()

        // Utilisation d'un timer pour le compte à rebours
        for _ in 0..<3 {
            Thread.sleep(forTimeInterval: 1.0)
            DispatchQueue.main.async {
                if self.countdownValue > 1 {
                    self.countdownValue -= 1
                } else {
                    self.countdownValue = 0
                }
            }
        }
        
        // Ajoute un délai pour afficher "GO!" avant de désactiver isActive
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isActive = false
            self.resetCountdown()
        }
    }

    private func resetCountdown() {
        countdownValue = 3
    }
}

// Prévisualisation du composant CountdownView
struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(isActive: .constant(true))
    }
}
