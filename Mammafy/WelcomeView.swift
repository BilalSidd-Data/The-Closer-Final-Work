import SwiftUI

struct WelcomeView: View {
    @State private var name: String = ""
    @State private var navigateToDateSelection = false
    
    var body: some View {
        VStack {
            Spacer()
            
            WelcomeLogo()
            
            Spacer().frame(height: 40)
            
            WelcomeTitle()
            
            Spacer().frame(height: 60)
            
            NameInputView(name: $name)
            
            Spacer()
            
            PrimaryButton(
                title: "Next",
                action: {
                    navigateToDateSelection = true
                },
                isDisabled: name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            )
            .padding(.bottom, 30)
            .navigationDestination(isPresented: $navigateToDateSelection) {
                DateSelectionView()
            }
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    WelcomeView()
}
