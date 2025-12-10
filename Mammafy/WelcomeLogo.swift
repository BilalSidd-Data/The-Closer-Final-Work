import SwiftUI

struct WelcomeLogo: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.sageGreen)
                .frame(width: 100, height: 100)
                .shadow(color: Color.sageGreen.opacity(0.3), radius: 10, x: 0, y: 5)
            
            Image(systemName: "heart.text.square.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    WelcomeLogo()
}
