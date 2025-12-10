import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let isDisabled: Bool
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isDisabled ? .gray : .white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isDisabled ? Color.buttonDisabled : Color.sageGreen)
                .cornerRadius(16)
        }
        .disabled(isDisabled)
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        PrimaryButton(title: "Next", action: {}, isDisabled: false)
        PrimaryButton(title: "Next", action: {}, isDisabled: true)
    }
}
