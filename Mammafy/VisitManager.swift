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
    }
    
    func resetAppointment() {
        appointment = nil
        checklist.removeAll()
        questionsForDoctor = ""
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
