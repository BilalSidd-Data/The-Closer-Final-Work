import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        NavigationStack {
            if hasCompletedOnboarding {
                HomeView()
            } else {
                DateSelectionView()
            }
        }
        .onAppear {
            NotificationManager.shared.requestAuthorization()
        }
    }
}

#Preview {
    ContentView()
}
