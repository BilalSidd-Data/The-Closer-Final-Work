import SwiftUI

struct WelcomeTitle: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to Mammafy")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.darkText)
                .multilineTextAlignment(.center)
            
            Text("Your personal companion for a healthy,\nhappy pregnancy.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.horizontal)
    }
}

#Preview {
    WelcomeTitle()
}
