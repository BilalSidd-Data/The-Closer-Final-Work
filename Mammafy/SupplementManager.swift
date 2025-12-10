import Foundation
import SwiftUI
import Combine

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
}

class SupplementManager: ObservableObject {
    static let shared = SupplementManager()
    
    @Published var supplements: [Supplement] = [] {
        didSet {
            saveSupplements()
        }
    }
    
    init() {
        loadSupplements()
        checkDateAndReset()
    }
    
    func addSupplement(name: String, dosage: String, instructions: String, time: Date) {
        let newSupplement = Supplement(name: name, dosage: dosage, instructions: instructions, time: time)
        supplements.append(newSupplement)
    }
    
    func updateFullSupplement(_ updatedSupplement: Supplement) {
        if let index = supplements.firstIndex(where: { $0.id == updatedSupplement.id }) {
            supplements[index] = updatedSupplement
        }
    }
    
    func updateStatus(for id: UUID, status: SupplementStatus) {
        if let index = supplements.firstIndex(where: { $0.id == id }) {
            supplements[index].status = status
        }
    }
    
    func deleteSupplement(at offsets: IndexSet) {
        supplements.remove(atOffsets: offsets)
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
        let taken = supplements.filter { $0.status == .taken || $0.status == .late }.count
        let total = supplements.count
        return (taken, total)
    }
}
