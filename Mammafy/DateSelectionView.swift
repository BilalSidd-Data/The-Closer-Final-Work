import SwiftUI

struct DateSelectionView: View {

    @State private var selectedDate = Date()
    @State private var navigateToHome = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            
            Spacer()
            
            DateSelectionIcon()
            
            Spacer().frame(height: 30)
            
            DateSelectionTitle()
            
            Spacer().frame(height: 40)
            
            CalendarView(selectedDate: $selectedDate)
            
            Spacer()
            
            PrimaryButton(
                title: "Get Started",
                action: {
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    PregnancyManager.shared.setStartDate(selectedDate)
                    navigateToHome = true
                },
                isDisabled: false
            )
            .padding(.bottom, 30)
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        DateSelectionView()
    }
}
