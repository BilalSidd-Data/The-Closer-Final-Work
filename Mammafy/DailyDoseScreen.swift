import SwiftUI

struct DailyDoseScreen: View {
    @State private var showAddSupplement = false
    @State private var supplementToEdit: Supplement?
    @ObservedObject var supplementManager = SupplementManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HomeHeader()
                
                PregnancyInfoCard()
                
                ProgressSection(
                    takenCount: supplementManager.progress.taken,
                    totalCount: supplementManager.progress.total
                )
                
                AddSupplementButton(action: {
                    showAddSupplement = true
                })
                
                if supplementManager.activeSupplements.isEmpty {
                    RoutineStartCard()
                } else {
                    VStack(spacing: 15) {
                        ForEach(supplementManager.activeSupplements) { supplement in
                            SupplementRow(supplement: supplement)
                                .onTapGesture {
                                    supplementToEdit = supplement
                                }
                        }
                    }
                }
                
                Spacer().frame(height: 100) // Space for tab bar
            }
            .padding(.top)
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showAddSupplement) {
            AddSupplementView(supplementToEdit: nil)
        }
        .sheet(item: $supplementToEdit) { supplement in
            AddSupplementView(supplementToEdit: supplement)
        }
    }
}

// MARK: - Components

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

struct PregnancyInfoCard: View {
    @ObservedObject var manager = PregnancyManager.shared
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Week \(manager.currentWeek)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.sageGreen)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Baby is the size of a")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(manager.currentBabySize)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.darkText)
                }
                
                Text(dateString)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                    .padding(.top, 4)
                
                Text("Next dose in: Check your schedule!")
                    .font(.caption)
                    .foregroundColor(.sageGreen)
                    .padding(.top, 4)
            }
            
            Spacer()
            
            Image(systemName: manager.currentBabySymbol)
                .font(.system(size: 50))
                .foregroundColor(.sageGreen)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct ProgressSection: View {
    var takenCount: Int = 0
    var totalCount: Int = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Your Progress")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text("\(takenCount)/\(totalCount) Taken")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.darkText)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.sageGreen.opacity(0.3), lineWidth: 8)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: totalCount > 0 ? CGFloat(takenCount) / CGFloat(totalCount) : 0)
                    .stroke(Color.sageGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct AddSupplementButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Supplement")
            }
            .font(.headline)
            .foregroundColor(.sageGreen)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.sageGreen.opacity(0.2))
            .cornerRadius(16)
        }
        .padding(.horizontal)
    }
}

struct RoutineStartCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "list.clipboard.fill")
                .font(.system(size: 40))
                .foregroundColor(.sageGreen)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.sageGreen, lineWidth: 2)
                )
            
            Text("Start Your Routine")
                .font(.headline)
                .foregroundColor(.darkText)
            
            Text("Add your prenatal vitamins and\nsupplements to get reminder and\ntrack your progress")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

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
    DailyDoseScreen()
}
