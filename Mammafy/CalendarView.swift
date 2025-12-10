import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                in: ...Date(), // Disable future dates
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .tint(.sageGreen) // Apply theme color
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

#Preview {
    CalendarView(selectedDate: .constant(Date()))
        .background(Color.warmCream)
}
