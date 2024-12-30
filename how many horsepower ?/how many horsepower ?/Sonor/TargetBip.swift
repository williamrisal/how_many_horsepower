import Foundation
import AVFoundation

class TargetBip {
    private var audioPlayer: AVAudioPlayer?

    func playBeep() {
        // Utiliser un son natif "ping"
        let systemSoundID: SystemSoundID = 1005 // ID de son système "ping"

        // Jouer le son
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
