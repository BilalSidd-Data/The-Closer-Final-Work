import SwiftUI

struct DateSelectionIcon: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.sageGreen.opacity(0.2))
                .frame(width: 100, height: 100)
            
            Image(systemName: "calendar.badge.clock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.sageGreen)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    DateSelectionIcon()
}
