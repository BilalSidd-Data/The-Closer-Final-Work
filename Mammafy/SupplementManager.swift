import Foundation
import SwiftUI
import Combine
import UserNotifications

enum SupplementStatus: String, Codable {
    case pending
    case taken
    case late
    case missed
}

struct Supplement: Identifiable, Codable {
    var id = UUID()
    var name: String
    var dosage: String
    var instructions: String
    var time: Date
    var status: SupplementStatus = .pending
    var dateAdded: Date = Date()
    
    // New fields for date range
    var startDate: Date?
    var endDate: Date?
}

class SupplementManager: ObservableObject {
    static let shared = SupplementManager()
    
    @Published var supplements: [Supplement] = [] {
        didSet {
            saveSupplements()
        }
    }
    
    // Computed property for Today's display
    var activeSupplements: [Supplement] {
        let calendar = Calendar.current
        let today = Date() // Or start of today
        
        return supplements.filter { supplement in
            // Default to true if no dates set (legacy support)
            guard let start = supplement.startDate, let end = supplement.endDate else {
                return true
            }
            // Check if today is within range [start, end]
            // We strip time components for accurate "Day" comparison
            let startDay = calendar.startOfDay(for: start)
            let endDay = calendar.startOfDay(for: end)
            let todayDay = calendar.startOfDay(for: today)
            
            return todayDay >= startDay && todayDay <= endDay
        }
    }
    
    init() {
        loadSupplements()
        checkDateAndReset()
        setupDayChangeObserver()
    }
    
    private func setupDayChangeObserver() {
        // Check for date change when app comes to foreground
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.checkDateAndReset()
        }
    }
    
    func addSupplement(name: String, dosage: String, instructions: String, time: Date, startDate: Date, endDate: Date) {
        let newSupplement = Supplement(
            name: name,
            dosage: dosage,
            instructions: instructions,
            time: time,
            startDate: startDate,
            endDate: endDate
        )
        supplements.append(newSupplement)
        
        scheduleNotifications(for: newSupplement)
    }
    
    func updateFullSupplement(_ updatedSupplement: Supplement) {
        if let index = supplements.firstIndex(where: { $0.id == updatedSupplement.id }) {
            // Cancel old notifications first
            cancelNotifications(for: supplements[index])
            
            supplements[index] = updatedSupplement
            
            // Schedule new
            scheduleNotifications(for: updatedSupplement)
        }
    }
    
    func updateStatus(for id: UUID, status: SupplementStatus) {
        if let index = supplements.firstIndex(where: { $0.id == id }) {
            supplements[index].status = status
        }
    }
    
    func deleteSupplement(at offsets: IndexSet) {
        offsets.forEach { index in
            let supplement = supplements[index]
            cancelNotifications(for: supplement)
        }
        supplements.remove(atOffsets: offsets)
    }
    
    // MARK: - Notification Logic
    private func scheduleNotifications(for supplement: Supplement) {
        guard let start = supplement.startDate, let end = supplement.endDate else { return }
        
        // Creative titles
        let motivatingTitles = [
            "💚 Nourishing you and baby!",
            "✨ Time for your daily dose of love!",
            "🌟 Your wellness moment is here!",
            "💪 Building a healthy future together!",
            "🤱 Taking care of you both!",
            "❤️ Love for you and little one!",
            "🌸 Mama's health time!",
            "⭐ You're doing amazing, mama!"
        ]
        
        // Encouraging messages
        let encouragingMessages = [
            "Remember: \(supplement.name) - \(supplement.dosage). You're giving your baby the best start! 🌱",
            "\(supplement.name) - \(supplement.dosage). Every dose is an act of love for your little one! 💕",
            "Time for \(supplement.name) - \(supplement.dosage). You're such a caring mama! 🤗",
            "\(supplement.name) - \(supplement.dosage). Building strong and healthy, one day at a time! 💪",
            "Don't forget: \(supplement.name) - \(supplement.dosage). Your baby appreciates you! 👶",
            "\(supplement.name) - \(supplement.dosage). Small steps, big impact for your baby! ✨"
        ]
        
        let calendar = Calendar.current
        let today = Date()
        
        // Loop from start date to end date
        var currentDate = start
        while currentDate <= end {
            // Only schedule if date is today or future
            if currentDate >= calendar.startOfDay(for: today) {
                
                // Construct the full fire date: Day from 'currentDate', Time from 'supplement.time'
                var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
                let timeComponents = calendar.dateComponents([.hour, .minute], from: supplement.time)
                
                components.hour = timeComponents.hour
                components.minute = timeComponents.minute
                
                if let fireDate = calendar.date(from: components) {
                    // Create unique ID for this day's notification
                    // Format: SupplementUUID_yyyy-MM-dd
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dayString = dateFormatter.string(from: currentDate)
                    let notifID = "\(supplement.id.uuidString)_\(dayString)"
                    
                    // Select random text for this instance
                    let title = motivatingTitles.randomElement() ?? "💚 Time for your supplement!"
                    let body = encouragingMessages.randomElement() ?? "Take \(supplement.name) - \(supplement.dosage)"
                    
                    NotificationManager.shared.scheduleNotification(
                        id: notifID,
                        title: title,
                        body: body,
                        date: fireDate
                    )
                }
            }
            
            // Increment day
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }
    }
    
    private func cancelNotifications(for supplement: Supplement) {
        guard let start = supplement.startDate, let end = supplement.endDate else {
            // If no range, fallback to clearing the simple ID (legacy code just used UUID)
             NotificationManager.shared.cancelNotification(id: supplement.id.uuidString)
            return
        }
        
        let calendar = Calendar.current
        var currentDate = start
        while currentDate <= end {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dayString = dateFormatter.string(from: currentDate)
            let notifID = "\(supplement.id.uuidString)_\(dayString)"
            
            NotificationManager.shared.cancelNotification(id: notifID)
            
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }
    }
    
    // MARK: - Persistence
    private let saveKey = "savedSupplements"
    private let lastOpenedDateKey = "lastOpenedDate"
    
    private func saveSupplements() {
        if let encoded = try? JSONEncoder().encode(supplements) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadSupplements() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Supplement].self, from: data) {
            supplements = decoded
        }
    }
    
    private func checkDateAndReset() {
        let calendar = Calendar.current
        let lastDate = UserDefaults.standard.object(forKey: lastOpenedDateKey) as? Date ?? Date.distantPast
        
        if !calendar.isDateInToday(lastDate) {
            // It's a new day (or first run), reset statuses
            for i in 0..<supplements.count {
                supplements[i].status = .pending
            }
            // Save the new state
            saveSupplements()
        }
        
        // Update last opened date to now
        UserDefaults.standard.set(Date(), forKey: lastOpenedDateKey)
    }
    
    // Helper for progress
    var progress: (taken: Int, total: Int) {
        let active = activeSupplements
        let taken = active.filter { $0.status == .taken || $0.status == .late }.count
        let total = active.count
        return (taken, total)
    }
}
