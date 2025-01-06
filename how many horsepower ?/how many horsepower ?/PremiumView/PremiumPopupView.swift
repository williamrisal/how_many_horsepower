import SwiftUI

struct PremiumPopupView: View {
    @State private var showAdvantagesView = false
    @State private var showPopup = true

    var body: some View {
        ZStack {
            // Main content
            Color.white.ignoresSafeArea()

            if showPopup {
                VStack(spacing: 20) {
                    Text("🚀 Découvrez votre couple moteur !")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text("Améliorez votre expérience avec des analyses avancées comme le couple moteur, des courbes de performances, et plus encore.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    HStack {
                        Button("Non, merci") {
                            withAnimation {
                                showPopup = false
                            }
                        }
                        .foregroundColor(.red)

                        Spacer()

                        Button("En savoir plus") {
                            withAnimation {
                                showAdvantagesView = true
                                showPopup = false
                            }
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.top, 10)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()
                .frame(maxWidth: 300)
            }
        }
        .sheet(isPresented: $showAdvantagesView) {
            AdvantagesView()
        }
    }
}

#Preview {
    PremiumPopupView()
}
