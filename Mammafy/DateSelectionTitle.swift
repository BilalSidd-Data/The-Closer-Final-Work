import SwiftUI

struct DateSelectionTitle: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("When did your journey begin?")
                .font(.system(size: 24, weight: .bold, design: .rounded)) 
                .foregroundColor(.darkText)
                .multilineTextAlignment(.center)
            
            Text("Select the first day of your last period.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DateSelectionTitle()
}
