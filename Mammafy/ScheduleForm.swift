import SwiftUI

struct ScheduleForm: View {
    @Binding var time: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Schedule")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.leading, 5)
            
            HStack {
                Text("Time")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                
                Spacer()
                
                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .padding(5)
                    .background(Color.sageGreen.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

#Preview {
    ScheduleForm(time: .constant(Date()))
        .padding()
        .background(Color.warmCream)
}
