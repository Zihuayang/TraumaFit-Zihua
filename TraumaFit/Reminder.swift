import UserNotifications
import SwiftUI


struct Reminder: View {
    @State private var selectedDate = Date()
    @State private var showConfirmationAlert = false
    @State private var reminders: [ReminderItem] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Text("Workout Reminder")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .padding(.top, 20)

                
                DatePicker("Select Workout Time:", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                
                
                Button(action: {
                    scheduleNotification(for: selectedDate)
                }) {
                    Text("Set Reminder")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                        .padding(.horizontal, 50)
                        .shadow(radius: 5)
                }
                .alert(isPresented: $showConfirmationAlert) {
                    Alert(title: Text("Reminder Set"),
                          message: Text("Your workout reminder has been successfully set for \(formattedDate(selectedDate))."),
                          dismissButton: .default(Text("OK")))
                }

                
                Text("List of Reminders:")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding([.top, .leading])
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .underline()

                
                ForEach(reminders) { reminder in
                    HStack {
                        Text(formattedDate(reminder.date))
                            .foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            deleteNotification(identifier: reminder.id)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .padding(.horizontal, 8)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding([.horizontal, .bottom])
                }
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            
            requestNotificationPermission()
            UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
            loadReminders()
        }
    }
    
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    
    func scheduleNotification(for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Workout Time!"
        content.body = "It's time for your workout. Let's stay fit!"

        
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "ringtone.mp3"))

        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let id = UUID().uuidString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(date)")
                
                showConfirmationAlert = true
                
                let reminderItem = ReminderItem(id: id, date: date)
                reminders.append(reminderItem)
                saveReminders()
            }
        }
    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    
    func deleteNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        reminders.removeAll { $0.id == identifier }
        saveReminders()
    }
    
    
    func loadReminders() {
        if let data = UserDefaults.standard.data(forKey: "reminders"),
           let savedReminders = try? JSONDecoder().decode([ReminderItem].self, from: data) {
            reminders = savedReminders
        }
    }
    
    
    func saveReminders() {
        if let data = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(data, forKey: "reminders")
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()

    private override init() {
        super.init()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .sound])
    }
}


struct ReminderItem: Identifiable, Codable {
    let id: String
    let date: Date
}

struct Reminder_Previews: PreviewProvider {
    static var previews: some View {
        Reminder()
    }
}
