import SwiftUI

struct HomeHeader: View {
    var body: some View {
        ZStack {
            // Centered Title
            Text("Daily Dose")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.darkText)
                .frame(maxWidth: .infinity)
            
            // Buttons
            HStack {
                Button(action: {
                    UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.sageGreen)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle()) // Ensures the whole frame is tappable
                }
                
                Spacer()
                

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
    HomeHeader()
        .background(Color.warmCream)
}
