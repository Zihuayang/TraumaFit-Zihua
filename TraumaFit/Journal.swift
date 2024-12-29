import SwiftUI


struct JournalEntry: Identifiable, Codable {
    let id: UUID
    let entry: String
    let date: Date
    let mood: String

    
    init(entry: String, date: Date, mood: String) {
        self.id = UUID()
        self.entry = entry
        self.date = date
        self.mood = mood
    }
}

struct Journal: View {
    @State private var journalEntry: String = ""
    @State private var journalEntries: [JournalEntry] = []
    @State private var selectedMood: String = "Neutral"
    
    let moods = ["Happy", "Sad", "Angry", "Excited", "Neutral"]
    
    var body: some View {
        ZStack {

            Image("journal_logo")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .zIndex(0)
            
            VStack {
                
                Text("My Journal")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    
                    
                
                Spacer()
                
                
                Picker("Select Mood", selection: $selectedMood) {
                    ForEach(moods, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                .background(Color.gray)
                
                
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 1)
                )
                .padding(.top, 10)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .shadow(radius: 1)


                


               
                TextEditor(text: $journalEntry)
                    .frame(width: 285, height: 310)
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .padding(.top, 15)
                    .multilineTextAlignment(.leading)
                    

                
                Button(action: {
                    saveEntry()
                }) {
                    Text("Save Entry")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 300)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.top, 15)
                
                if !journalEntries.isEmpty {
                    Text("History")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .offset(x: -5)
                        .underline()
                }

                
                ScrollView {
                    ForEach(journalEntries.reversed()) { entry in
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text(entry.entry)
                                    .font(.body)
                                    .padding(8)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(12)
                                    .shadow(radius: 3)
                                    .multilineTextAlignment(.leading)

                                
                                HStack {
                                    Text("Date: \(formattedDate(entry.date))")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    Text("Mood: \(entry.mood)")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)

                            
                            Button(action: {
                                deleteEntry(entry: entry)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .padding(.trailing)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            loadEntries()
        }
    }
    
    
    private func saveEntry() {
        if !journalEntry.isEmpty {
            let newEntry = JournalEntry(entry: journalEntry, date: Date(), mood: selectedMood)
            journalEntries.append(newEntry)
            saveEntriesToUserDefaults()
            journalEntry = ""
        }
    }
    
    
    private func deleteEntry(entry: JournalEntry) {
        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries.remove(at: index)
            saveEntriesToUserDefaults()
        }
    }
    
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    
    private func saveEntriesToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(journalEntries) {
            UserDefaults.standard.set(encodedData, forKey: "journalEntries")
        }
    }
    
    
    private func loadEntries() {
        if let savedData = UserDefaults.standard.data(forKey: "journalEntries"),
           let decodedEntries = try? JSONDecoder().decode([JournalEntry].self, from: savedData) {
            journalEntries = decodedEntries
        }
    }
}

struct Journal_Previews: PreviewProvider {
    static var previews: some View {
        Journal()
    }
}
