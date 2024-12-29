import SwiftUI

struct WorkoutTracker: View {
    @State private var caloriesBurned: Double = 0
    @State private var goalCalories: Double = 1000
    
    
    @State private var timeArms: Double = 0
    @State private var timeChest: Double = 0
    @State private var timeBack: Double = 0
    @State private var timeLegs: Double = 0
    @State private var timeCore: Double = 0

    
    @State private var intensity: Int = 1

    
    var totalWorkoutTime: Double {
        return timeArms + timeChest + timeBack + timeLegs + timeCore
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                Text("Workout Progress")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .shadow(color: .white, radius: 1, x: 0, y: 0)

                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.4), lineWidth: 40)
                        .frame(width: 250, height: 250)
                    
                    
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(caloriesBurned / goalCalories, 1.0)))
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [Color.cyan, Color.green]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 40, lineCap: .round)
                        )
                        .rotationEffect(Angle(degrees: -90))
                        .frame(width: 250, height: 250)
                        .animation(.easeInOut(duration: 1.5), value: caloriesBurned)

                    VStack {
                        Text("\(Int(caloriesBurned))")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Text("of \(Int(goalCalories)) cal burned")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                            
                    }
                }

                
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Time Spent on Each Muscle Group (in minutes)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    Group {
                        HStack {
                            Text("Arms: \(Int(timeArms)) min")
                                .foregroundColor(.white)
                            Spacer()
                            Slider(value: $timeArms, in: 0...60, step: 1)
                                .accentColor(.cyan)
                        }
                        
                        HStack {
                            Text("Chest: \(Int(timeChest)) min")
                                .foregroundColor(.white)
                            Spacer()
                            Slider(value: $timeChest, in: 0...60, step: 1)
                                .accentColor(.cyan)
                        }
                        
                        HStack {
                            Text("Back: \(Int(timeBack)) min")
                                .foregroundColor(.white)
                            Spacer()
                            Slider(value: $timeBack, in: 0...60, step: 1)
                                .accentColor(.cyan)
                        }
                        
                        HStack {
                            Text("Legs: \(Int(timeLegs)) min")
                                .foregroundColor(.white)
                            Spacer()
                            Slider(value: $timeLegs, in: 0...60, step: 1)
                                .accentColor(.cyan)
                        }
                        
                        HStack {
                            Text("Core: \(Int(timeCore)) min")
                                .foregroundColor(.white)
                            Spacer()
                            Slider(value: $timeCore, in: 0...60, step: 1)
                                .accentColor(.cyan)
                        }
                    }
                }

                
                VStack {
                    Text("Number of time workout")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(Int(totalWorkoutTime)) minutes")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                }
                
                
                VStack {
                    Text("Select Intensity")
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.8), radius: 2, x: 0, y: 1)
                    
                    
                    Picker("Intensity", selection: $intensity) {
                        Text("Low").tag(0)
                        Text("Medium").tag(1)
                        Text("High").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(10)
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                    )
                }

                
                
                Button(action: calculateCaloriesBurned) {
                    Text("Calculate")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }

            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .background(
            Image("tracker_logo")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }

    
    private func calculateCaloriesBurned() {
        let totalTime = timeArms + timeChest + timeBack + timeLegs + timeCore
        
        
        let intensityMultiplier: Double
        
        switch intensity {
        case 0:
            intensityMultiplier = 5.0
        case 2:
            intensityMultiplier = 10.0
        default:
            intensityMultiplier = 7.0
        }
        
        
        caloriesBurned = totalTime * intensityMultiplier
    }
}

struct WorkoutTracker_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutTracker()
    }
}
