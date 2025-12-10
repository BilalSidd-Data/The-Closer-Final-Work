import SwiftUI

struct ChecklistHeader: View {
    @Binding var isEditing: Bool
    
    var body: some View {
        HStack {
            Text("Checklist")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.darkText)
            
            Spacer()
            
            Button(action: {
                isEditing.toggle()
            }) {
                Text(isEditing ? "Done" : "Edit")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                    .foregroundColor(.sageGreen)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

#Preview {
    ChecklistHeader(isEditing: .constant(false))
        .background(Color.warmCream)
}
