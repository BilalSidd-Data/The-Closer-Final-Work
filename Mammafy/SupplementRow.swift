import SwiftUI

struct SupplementRow: View {
    let supplement: Supplement
    @ObservedObject var manager = SupplementManager.shared
    @State private var showOptions = false
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: supplement.time)
    }
    
    var cardColor: Color {
        switch supplement.status {
        case .taken: return .sageGreen
        case .late: return .yellow.opacity(0.6)
        case .missed: return .red.opacity(0.6)
        case .pending: return .sageGreen.opacity(0.2)
        }
    }
    
    var textColor: Color {
        switch supplement.status {
        case .taken, .late, .missed: return .white
        case .pending: return .darkText
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(supplement.name.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(textColor.opacity(0.8))
                
                Text(supplement.dosage.uppercased())
                    .font(.caption2)
                    .foregroundColor(textColor.opacity(0.8))
                
                Spacer().frame(height: 8)
                
                if !supplement.instructions.isEmpty {
                    Text(supplement.instructions.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(textColor)
                }
                
                HStack {
                    Image(systemName: "clock")
                    Text(timeString)
                }
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(textColor)
            }
            
            Spacer()
            
            Button(action: {
                showOptions = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 40, height: 40)
                    
                    if supplement.status == .taken {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.headline)
                    } else if supplement.status == .missed {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.headline)
                    } else if supplement.status == .late {
                        Image(systemName: "clock.badge.checkmark")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
            }
            .confirmationDialog("Update Status", isPresented: $showOptions, titleVisibility: .visible) {
                Button("Taken") {
                    manager.updateStatus(for: supplement.id, status: .taken)
                }
                Button("Taken Late") {
                    manager.updateStatus(for: supplement.id, status: .late)
                }
                Button("Missed") {
                    manager.updateStatus(for: supplement.id, status: .missed)
                }
                Button("Reset", role: .destructive) {
                    manager.updateStatus(for: supplement.id, status: .pending)
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .padding()
        .background(cardColor)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        SupplementRow(supplement: Supplement(name: "Vitamin", dosage: "1 Tablet", instructions: "", time: Date(), status: .taken))
        SupplementRow(supplement: Supplement(name: "Iron", dosage: "1 Pill", instructions: "", time: Date(), status: .pending))
    }
}
