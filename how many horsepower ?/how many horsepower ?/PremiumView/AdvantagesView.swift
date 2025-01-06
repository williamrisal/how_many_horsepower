//
//  AdvantagesView.swift
//  how many horsepower ?
//
//  Created by William Risal on 03/01/2025.
//
import SwiftUI
import StoreKit

struct AdvantagesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var purchaseManager = PurchaseManager.shared // Utiliser PurchaseManager
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fond dégradé pour un style moderne
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "1E1E1E"), Color(hex: "3A3A3A")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    // Titre
                    Text("Avantages Premium 🚗")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)

                    // Description
                    Text("Débloquez des fonctionnalités exclusives pour enrichir votre expérience automobile.")
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Liste des avantages
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "speedometer")
                                .foregroundColor(.blue)
                                .frame(width: 30, height: 30)
                            Text("Visualisez le couple moteur (Nm)")
                                .font(.body)
                                .foregroundColor(.white)
                        }

                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.green)
                                .frame(width: 30, height: 30)
                            Text("Courbes de puissance et de couple")
                                .font(.body)
                                .foregroundColor(.white)
                        }

                        HStack {
                            Image(systemName: "list.bullet.rectangle")
                                .foregroundColor(.purple)
                                .frame(width: 30, height: 30)
                            Text("Analyse détaillée des performances")
                                .font(.body)
                                .foregroundColor(.white)
                        }

                        HStack {
                            Image(systemName: "car.fill")
                                .foregroundColor(.red)
                                .frame(width: 30, height: 30)
                            Text("Comparaisons avec d'autres véhicules")
                                .font(.body)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Spacer()

                    // Bouton d'achat
                    Button(action: {
                        purchaseManager.fetchProduct() // Demande le produit lors de l'appui
                    }) {
                        Text("Débloquez dès maintenant pour 1,99 €")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.cyan]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .cornerRadius(15)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
#Preview {
    AdvantagesView()
}
