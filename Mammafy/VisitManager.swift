import Foundation
import SwiftUI
import Combine

struct Appointment: Codable, Equatable {
    var doctorName: String
    var location: String
    var date: Date
}

struct ChecklistItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
}

class VisitManager: ObservableObject {
    static let shared = VisitManager()
    
    @Published var appointment: Appointment? {
        didSet {
            saveAppointment()
        }
    }
    
    @Published var checklist: [ChecklistItem] = [] {
        didSet {
            saveChecklist()
        }
    }
    
    @Published var questionsForDoctor: String = "" {
        didSet {
            saveQuestions()
        }
    }
    
    init() {
        loadData()
    }
    
    // MARK: - Appointment Logic
    func scheduleAppointment(doctor: String, location: String, date: Date) {
        appointment = Appointment(doctorName: doctor, location: location, date: date)
        
        // 1. One day before
        if let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: date) {
            NotificationManager.shared.scheduleNotification(
                id: "NextVisit_DayBefore",
                title: "Appointment Tomorrow",
                body: "Remember your appointment with \(doctor) tomorrow at \(DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)).",
                date: dayBefore
            )
        }
        
        // 2. Three hours before
        if let threeHoursBefore = Calendar.current.date(byAdding: .hour, value: -3, to: date) {
            NotificationManager.shared.scheduleNotification(
                id: "NextVisit_3HoursBefore",
                title: "Appointment Soon",
                body: "You have an appointment with \(doctor) in 3 hours at \(location).",
                date: threeHoursBefore
            )
        }
        
        // 3. Exact time
        NotificationManager.shared.scheduleNotification(
            id: "NextVisit_ExactTime",
            title: "Appointment Now",
            body: "It's time for your appointment with \(doctor) at \(location).",
            date: date
        )
    }
    
    func resetAppointment() {
        appointment = nil
        checklist.removeAll()
        questionsForDoctor = ""
        NotificationManager.shared.cancelNotification(id: "NextVisit_DayBefore")
        NotificationManager.shared.cancelNotification(id: "NextVisit_3HoursBefore")
        NotificationManager.shared.cancelNotification(id: "NextVisit_ExactTime")
    }
    
    // MARK: - Checklist Logic
    func addChecklistItem(_ title: String) {
        checklist.append(ChecklistItem(title: title, isCompleted: false))
    }
    
    func toggleChecklistItem(id: UUID) {
        if let index = checklist.firstIndex(where: { $0.id == id }) {
            checklist[index].isCompleted.toggle()
        }
    }
    
    func deleteChecklistItem(at offsets: IndexSet) {
        checklist.remove(atOffsets: offsets)
    }
    
    // MARK: - Persistence
    private let appointmentKey = "savedAppointment"
    private let checklistKey = "savedChecklist"
    private let questionsKey = "savedQuestions"
    
    private func saveAppointment() {
        if let encoded = try? JSONEncoder().encode(appointment) {
            UserDefaults.standard.set(encoded, forKey: appointmentKey)
        } else {
            UserDefaults.standard.removeObject(forKey: appointmentKey)
        }
    }
    
    private func saveChecklist() {
        if let encoded = try? JSONEncoder().encode(checklist) {
            UserDefaults.standard.set(encoded, forKey: checklistKey)
        }
    }
    
    private func saveQuestions() {
        UserDefaults.standard.set(questionsForDoctor, forKey: questionsKey)
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: appointmentKey),
           let decoded = try? JSONDecoder().decode(Appointment.self, from: data) {
            appointment = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: checklistKey),
           let decoded = try? JSONDecoder().decode([ChecklistItem].self, from: data) {
            checklist = decoded
        }
        
        if let savedQuestions = UserDefaults.standard.string(forKey: questionsKey) {
            questionsForDoctor = savedQuestions
        }
    }
}
