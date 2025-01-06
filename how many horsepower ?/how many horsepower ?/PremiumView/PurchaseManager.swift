//
//  PurchaseManager.swift
//  how many horsepower ?
//
//  Created by William Risal on 03/01/2025.
//

import Foundation
import StoreKit

class PurchaseManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    static let shared = PurchaseManager()
    
    @Published var productID = "Power_Curve"  // Remplacez par l'identifiant de votre produit
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self) // Ajouter l'observateur des transactions
    }
    
    // Vérifier si l'utilisateur peut effectuer des paiements
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    // Demander un produit
    func fetchProduct() {
        let productIDs: Set<String> = [productID]
        let productsRequest = SKProductsRequest(productIdentifiers: productIDs)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    // Réponse aux produits demandés
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            startPurchase(for: product)
        } else {
            print("Produit introuvable")
        }
    }
    
    // Démarrer l'achat
    private func startPurchase(for product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)  // Ajoute la requête de paiement à la file d'attente
    }
    
    // Observer les transactions
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Achat réussi")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("L'achat a échoué")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                print("Achat restauré")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
