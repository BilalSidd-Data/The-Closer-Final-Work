import SwiftUI

struct NameInputView: View {
    @Binding var name: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("What should we call you?")
                .font(.headline)
                .foregroundColor(.gray)
            
            TextField("Your Name", text: $name)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
}

#Preview {
    NameInputView(name: .constant(""))
        .padding()
        .background(Color.warmCream)
}
