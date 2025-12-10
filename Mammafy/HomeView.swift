import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // Content
            Group {
                switch selectedTab {
                case 0:
                    DailyDoseScreen()
                case 1:
                    NextVisitView()
                case 2:
                    ChecklistScreen()

                default:
                    EmptyView()
                }
            }
            
            // Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
