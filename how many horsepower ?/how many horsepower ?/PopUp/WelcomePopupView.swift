import SwiftUI

struct WelcomePopupView: View {
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
                .animation(.easeInOut, value: 0.5) // Optional animation for smooth display

            VStack(spacing: 20) {
                Text(NSLocalizedString("welcome_popup_title", comment: "Title of the welcome popup"))
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)

                Text(NSLocalizedString("welcome_popup_description", comment: "Description of the welcome popup"))
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()

                Button(action: onDismiss) {
                    Text(NSLocalizedString("welcome_popup_action", comment: "Button text for the welcome popup"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.black)
            .cornerRadius(15)
            .shadow(radius: 10)
            .frame(maxWidth: 300)
            .transition(.scale)
        }
    }
}
