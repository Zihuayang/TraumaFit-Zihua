import SwiftUI
import AVFoundation

class SetTimer: ObservableObject {
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    @Published var timerSet: Bool = false
    @Published var timeLeft: String = ""
    @Published var isPlayingSound: Bool = false
    @Published var isTimerRunning: Bool = false
    @Published var progress: Double = 1.0
    
    var timer: Timer?
    var totalSecondsRemaining: Int = 0 {
        didSet {
            updateTimeDisplay()
            updateProgress()
        }
    }
    var totalSeconds: Int = 0
    var audioPlayer: AVAudioPlayer?
}

struct SetTimerView: View {
    @ObservedObject private var viewModel = SetTimer()

    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                Image("countdown")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .zIndex(0)
                
                VStack(spacing: 30) {
                    
                    Text("Set Timer")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(.top, 60)
                    
                    
                    HStack {
                        Picker("Hours", selection: $viewModel.hours) {
                            ForEach(0..<24) { Text("\($0) h").tag($0) }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 120)
                        .clipped()
                        
                        Picker("Minutes", selection: $viewModel.minutes) {
                            ForEach(0..<60) { Text("\($0) m").tag($0) }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 120)
                        .clipped()
                        
                        Picker("Seconds", selection: $viewModel.seconds) {
                            ForEach(0..<60) { Text("\($0) s").tag($0) }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 120)
                        .clipped()
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    
                    if !viewModel.isTimerRunning {
                        Button(action: {
                            viewModel.setTimer()
                        }) {
                            Text("Start Timer")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color(red: 0.2, green: 0.2, blue: 0.2)]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(15)
                                .padding(.horizontal, 50)
                                .shadow(radius: 5)
                        }
                    }
                    
                    
                    if viewModel.isTimerRunning {
                        Button(action: {
                            viewModel.stopTimer()
                        }) {
                            Text("Stop Timer")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(15)
                                .padding(.horizontal, 50)
                                .shadow(radius: 5)
                        }
                    }
                    
                    
                    if viewModel.timerSet {
                        Text("Time Remaining: \(viewModel.timeLeft)")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .shadow(radius: 5)
                        
                        
                        ProgressView(value: viewModel.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: progressColor()))
                            .scaleEffect(x: 1, y: 4, anchor: .center)
                            .padding(.horizontal, 40)
                    }
                    
                    
                    if viewModel.isPlayingSound {
                        Button(action: {
                            viewModel.stopSound()
                        }) {
                            Text("Stop Sound")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(15)
                                .padding(.horizontal, 50)
                                .shadow(radius: 5)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    
    func progressColor() -> Color {
        let redValue = min(1.0, 2.0 - viewModel.progress * 2.0)
        let greenValue = min(1.0, viewModel.progress * 2.0)
        return Color(red: redValue, green: greenValue, blue: 0.0)
    }
}

extension SetTimer {
    
    func setTimer() {
        totalSecondsRemaining = hours * 3600 + minutes * 60 + seconds
        totalSeconds = totalSecondsRemaining
        guard totalSecondsRemaining > 0 else {
            timerSet = false
            return
        }

        timerSet = true
        isTimerRunning = true
        updateTimeDisplay()
        
        
        timer?.invalidate()
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.totalSecondsRemaining > 0 {
                self.totalSecondsRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.timerSet = false
                self.isTimerRunning = false
                self.timeLeft = "Time's up!"
                self.playSoundAndVibrate()
            }
        }
    }
    
    
    func stopTimer() {
        timer?.invalidate()
        timerSet = false
        isTimerRunning = false
        updateTimeDisplay()
    }
    
    
    func updateTimeDisplay() {
        let hoursLeft = totalSecondsRemaining / 3600
        let minutesLeft = (totalSecondsRemaining % 3600) / 60
        let secondsLeft = totalSecondsRemaining % 60
        timeLeft = String(format: "%02dh %02dm %02ds", hoursLeft, minutesLeft, secondsLeft)
    }
    
    
    func updateProgress() {
        if totalSeconds > 0 {
            progress = Double(totalSecondsRemaining) / Double(totalSeconds)
        } else {
            progress = 0.0
        }
    }
    
    
    func playSoundAndVibrate() {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        
        if let soundURL = Bundle.main.url(forResource: "ringtone", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
                isPlayingSound = true
            } catch {
                print("Error: Could not load sound file - \(error.localizedDescription)")
            }
        } else {
            print("Error: Sound file not found")
        }
    }
    
    
    func stopSound() {
        audioPlayer?.stop()
        isPlayingSound = false
    }
}

struct SetTimerView_Previews: PreviewProvider {
    static var previews: some View {
        SetTimerView()
    }
}
