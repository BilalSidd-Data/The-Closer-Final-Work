import SwiftUI

struct ChecklistView: View {
    @ObservedObject var manager = VisitManager.shared
    @State private var newItemTitle: String = ""
    @State private var isEditing = false
    @State private var isAddingItem = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Preparation Checklist")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.darkText)
                
                Spacer()
                
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 2)
                        .foregroundColor(.sageGreen)
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(manager.checklist) { item in
                    HStack {
                        Button(action: {
                            manager.toggleChecklistItem(id: item.id)
                        }) {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundColor(item.isCompleted ? .sageGreen : .gray)
                        }
                        
                        Text(item.title.uppercased())
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.darkText)
                            .strikethrough(item.isCompleted)
                        
                        Spacer()
                        
                        if isEditing {
                            Button(action: {
                                if let index = manager.checklist.firstIndex(where: { $0.id == item.id }) {
                                    manager.deleteChecklistItem(at: IndexSet(integer: index))
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red.opacity(0.6))
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            
            // Add Item Button
            Button(action: {
                isAddingItem = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Checklist Item")
                }
                .font(.headline)
                .foregroundColor(.sageGreen)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.sageGreen.opacity(0.2))
                .cornerRadius(16)
            }
            .padding(.horizontal)
            .alert("Add Checklist Item", isPresented: $isAddingItem) {
                TextField("Item Name", text: $newItemTitle)
                Button("Add") {
                    if !newItemTitle.isEmpty {
                        manager.addChecklistItem(newItemTitle)
                        newItemTitle = ""
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

#Preview {
    ChecklistView()
        .background(Color.warmCream)
}
