import StoreKit
import Foundation
import SwiftUI

class ReviewManager {
    static let shared = ReviewManager()
    
    private let lastRequestDateKey = "lastReviewRequestDate"
    private let reviewRequestInterval: TimeInterval = 30 * 24 * 60 * 60 // 30 jours
    
    private init() {}

    /// Vérifie si la demande d'avis peut être affichée
    private func shouldRequestReview() -> Bool {
        let lastRequestDate = UserDefaults.standard.object(forKey: lastRequestDateKey) as? Date ?? Date.distantPast
        return Date().timeIntervalSince(lastRequestDate) > reviewRequestInterval
    }

    /// Affiche la demande d'avis via la boîte de dialogue native (avec intervalle)
    func requestReview() {
        guard shouldRequestReview() else { return } // Ne pas afficher trop souvent
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            UserDefaults.standard.set(Date(), forKey: lastRequestDateKey) // Enregistre la date de la demande
        }
    }

    /// Force l'affichage de la demande d'avis (pour les tests uniquement)
    func forceRequestReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    /// Redirige l'utilisateur vers l'App Store pour laisser un avis
    func openAppStoreForReview(appID: String) {
        guard let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") else { return }
        UIApplication.shared.open(url)
    }
}
