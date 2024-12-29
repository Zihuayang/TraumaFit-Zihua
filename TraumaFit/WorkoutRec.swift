import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct WorkoutRec: View {
    @State private var selectedWorkout: String = "Arms"
    @State private var workoutPlan: [Exercise] = []
    @State private var showWorkout: Bool = false
    @State private var currentIndex: Int = 0

    let bodyParts = ["Arms", "Chest", "Back", "Legs", "Core"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text("Select Your Workout")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .foregroundColor(.white)

                
                Picker("Select Workout", selection: $selectedWorkout) {
                    ForEach(bodyParts, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)

                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        cycleWorkoutPlan(for: selectedWorkout)
                        showWorkout = true
                    }
                }) {
                    Text("Generate Workout Plan")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.top, 10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)

                
                if showWorkout {
                    WorkoutSection(title: selectedWorkout, exercises: workoutPlan)
                        .transition(.slide)
                }
            }
            .padding()
        }
        .background(
            Image("workout_logo")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }

    
   
    func cycleWorkoutPlan(for bodyPart: String) {
        let plans: [[Exercise]]
        
        switch bodyPart {
        case "Arms":
            plans = [
                [Exercise(name: "Alternating Dumbbell Curl", description: "3 sets of 12-15 reps.", videoURL: "https://www.youtube.com/watch?v=sAq_ocpRh_I", creator:"ScottHermanFitness"),
                 Exercise(name: "Triceps Dumbbell Extensions", description: "3 sets of 10-12 reps.", videoURL: "https://www.youtube.com/watch?v=nRiJVZDpdL0", creator:"LIVESTRONG.COM"),
                 Exercise(name: "Dumbbell Hammer Curl", description: "3 sets of 12 reps.", videoURL: "https://www.youtube.com/watch?v=zC3nLlEvin4", creator:"ScottHermanFitness")],
                 
                [Exercise(name: "Tricep Dips", description: "3 sets of 10 reps.", videoURL: "https://www.youtube.com/watch?v=6kALZikXxLc", creator: "Howcast"),
                 Exercise(name: "Barbell Curls", description: "4 sets of 8 reps.", videoURL: "https://www.youtube.com/watch?v=kwG2ipFRgfo", creator: "Howcast"),
                 Exercise(name: "Concentration Curls", description: "3 sets of 12 reps.", videoURL: "https://www.youtube.com/watch?v=0AUGkch3tzc", creator: "Howcast")],

                [Exercise(name: "Tricep Pushdowns", description: "4 sets of 12 reps.", videoURL: "https://www.youtube.com/watch?v=2-LAMcpzODU", creator: "ScottHermanFitness"),
                 Exercise(name: "Dumbbell Biceps Curl", description: "4 sets of 10 reps.", videoURL: "https://www.youtube.com/watch?v=ykJmrZ5v0Oo", creator: "Howcast"),
                 Exercise(name: "Skull Crushers", description: "3 sets of 10 reps.", videoURL: "https://www.youtube.com/watch?v=d_KZxkY_0cM", creator: "ScottHermanFitness")]
            ]
            
        case "Chest":
            plans = [
                [Exercise(name: "Bench Press", description: "4 sets of 8-10 reps.", videoURL: "https://www.youtube.com/watch?v=gRVjAtPip0Y", creator: "Buff Dudes"),
                 Exercise(name: "Push-Ups", description: "3 sets of 15-20 reps.", videoURL: "https://www.youtube.com/watch?v=IODxDxX7oi4", creator: "Calisthenicmovement"),
                 Exercise(name: "Dumbbell Incline Chest Press", description: "3 sets of 10 reps.", videoURL: "https://www.youtube.com/watch?v=8iPEnn-ltC8", creator: "ScottHermanFitness")],

                [Exercise(name: "Dumbbell Flyes", description: "4 sets of 10-12 reps.", videoURL: "https://www.youtube.com/watch?v=eozdVDA78K0", creator: "ScottHermanFitness"),
                 Exercise(name: "Cable Crossovers", description: "4 sets of 12 reps.", videoURL: "https://www.youtube.com/watch?v=taI4XduLpTk", creator: "LIVESTRONG.COM"),
                 Exercise(name: "Dips", description: "3 sets of 12 reps.", videoURL: "https://www.youtube.com/watch?v=2z8JmcrW-As", creator: "Calisthenicmovement")],

                [Exercise(name: "Chest Press Machine", description: "4 sets of 10 reps.", videoURL: "https://www.youtube.com/watch?v=sqNwDkUU_Ps", creator: "PureGym"),
                 Exercise(name: "Pec Deck Flye", description: "4 sets of 12 reps.", videoURL: "https://www.youtube.com/watch?v=O-OBCfyh9Fw", creator: "Renaissance Periodization"),
                 Exercise(name: "Decline Bench Press", description: "3 sets of 8-10 reps.", videoURL: "https://www.youtube.com/watch?v=OR6WM5Z2Hqs", creator: "Instructionalfitness")]
            ]

            
        case "Back":
            plans = [
                [Exercise(name: "Pull-Ups", description: "3 sets of 8-10 reps.", videoURL: "https://www.youtube.com/watch?v=eGo4IYlbE5g", creator: "Calisthenicmovement"),
                 Exercise(name: "Bent-Over Barbell Rows", description: "4 sets of 10 reps.", videoURL: "https://www.youtube.com/watch?v=3vT-JVrOfmA", creator: "Max Euceda"),
                 Exercise(name: "Deadlifts", description: "3 sets of 6-8 reps.", videoURL: "https://www.youtube.com/watch?v=AweC3UaM14o", creator: "Renaissance Periodization")],

                [Exercise(name: "Lat Pulldowns", description: "4 sets of 10-12 reps.", videoURL: "https://www.youtube.com/watch?v=lueEJGjTuPQ", creator: "Renaissance Periodization"),
                 Exercise(name: "T-Bar Rows", description: "4 sets of 12 reps.", videoURL: "https://www.youtube.com/watch?v=yPis7nlbqdY", creator: "Renaissance Periodization"),
                 Exercise(name: "Cable Face Pulls", description: "3 sets of 15 reps.", videoURL: "https://www.youtube.com/watch?v=0Po47vvj9g4", creator: "PureGym")],

                [Exercise(name: "Seated Low Row", description: "4 sets of 10 reps.", videoURL: "https://www.youtube.com/watch?v=GZbfZ033f74", creator: "ScottHermanFitness"),
                 Exercise(name: "Wide-Grip Lat Pulldown", description: "4 sets of 10 reps.", videoURL: "https://www.youtube.com/watch?v=lueEJGjTuPQ", creator: "Renaissance Periodization"),
                 Exercise(name: "Rack Pulls", description: "3 sets of 6-8 reps.", videoURL: "https://www.youtube.com/watch?v=9vYBWV5OeKg", creator: "PureGym")]
            ]
            
        case "Legs":
            plans = [
                [Exercise(name: "Squats", description: "4 sets of 10-12 reps.", videoURL: "https://www.youtube.com/watch?v=aclHkVaku9U", creator: "BowFlex"),
                 Exercise(name: "Lunges", description: "3 sets of 12 reps.", videoURL: "https://www.youtube.com/watch?v=COKYKgQ8KR0", creator: "Howcast"),
                 Exercise(name: "Leg Press", description: "4 sets of 8 reps.", videoURL: "https://www.youtube.com/watch?v=IZxyjW7MPJQ", creator: "ScottHermanFitness")],

                [Exercise(name: "Romanian Deadlifts", description: "4 sets of 6-8 reps.", videoURL: "https://www.youtube.com/watch?v=7j-2w4-P14I", creator: "Nuffield Health"),
                 Exercise(name: "Leg Extensions", description: "3 sets of 12 reps.", videoURL: "https://www.youtube.com/watch?v=YyvSfVjQeL0", creator: "ScottHermanFitness"),
                 Exercise(name: "Prone Leg Curl", description: "4 sets of 10 reps.", videoURL: "https://www.youtube.com/watch?v=1Tq3QdYUuHs", creator: "ScottHermanFitness")],

                [Exercise(name: "Bulgarian Split Squats", description: "3 sets of 10 reps.", videoURL: "https://www.youtube.com/watch?v=2C-uNgKwPLE", creator: "ScottHermanFitness"),
                 Exercise(name: "Dumbbell Step-up", description: "3 sets of 12 reps.", videoURL: "https://www.youtube.com/watch?v=9ZknEYboBOQ", creator: "Bobby Maximus"),
                 Exercise(name: "Calf Raises", description: "4 sets of 15 reps.", videoURL: "https://www.youtube.com/watch?v=gwLzBJYoWlI", creator: "LIVESTRONG.COM")]
            ]

        case "Core":
            plans = [
                [Exercise(name: "Plank", description: "3 sets of 45 seconds.", videoURL: "https://www.youtube.com/watch?v=B296mZDhrP4", creator: "LivestrongWoman"),
                 Exercise(name: "Russian Twists", description: "3 sets of 20 twists per side.", videoURL: "https://www.youtube.com/watch?v=wkD8rjkodUI", creator: "Howcast"),
                 Exercise(name: "Leg Raises", description: "3 sets of 15 reps.", videoURL: "https://www.youtube.com/watch?v=l4kQd9eWclE", creator: "Howcast")],

                [Exercise(name: "Crunches", description: "4 sets of 20 reps.", videoURL: "https://www.youtube.com/watch?v=MKmrqcoCZ-M", creator: "Howcast"),
                 Exercise(name: "Bicycle Crunches", description: "4 sets of 20 reps.", videoURL: "https://www.youtube.com/watch?v=9FGilxCbdz8", creator: "LIVESTRONG.COM"),
                 Exercise(name: "Mountain Climbers", description: "3 sets of 30 seconds.", videoURL: "https://www.youtube.com/watch?v=wQq3ybaLZeA", creator: "Leap Fitness")],

                [Exercise(name: "Lying Leg Raises", description: "4 sets of 12 reps.", videoURL: "https://www.youtube.com/watch?v=Wp4BlxcFTkE", creator: "LivestrongWoman"),
                 Exercise(name: "V-Ups", description: "3 sets of 15 reps.", videoURL: "https://www.youtube.com/watch?v=iP2fjvG0g3w", creator: "XHIT Daily"),
                 Exercise(name: "Flutter Kicks", description: "4 sets of 20 reps.", videoURL: "https://www.youtube.com/watch?v=ANVdMDaYRts", creator: "ScottHermanFitness")]
            ]

        
        default:
            plans = []
        }
        
        
        workoutPlan = plans[currentIndex % plans.count]
        currentIndex += 1
    }
}

struct WorkoutSection: View {
    let title: String
    let exercises: [Exercise]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("\(title) Workout")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 10)
                .foregroundColor(Color.white.opacity(0.9))
                .shadow(color: Color.black.opacity(0.9), radius: 2, x: 0, y: 1)

            ForEach(exercises) { exercise in
                VStack(alignment: .leading, spacing: 10) {
                    Text(exercise.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.9), radius: 2, x: 0, y: 1)
                    Text(exercise.description)
                        .font(.subheadline)
                        .foregroundColor(Color.black.opacity(0.9))
                    
                    
                    if let url = URL(string: exercise.videoURL) {
                        WebView(url: url)
                            .frame(height: 200)
                            .cornerRadius(10)
                    }

                    
                    HStack {
                        Image("YouTubeLogo")
                            .resizable()
                            .frame(width: 80, height: 20)
                        Text("Video by \(exercise.creator)")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                }
                .padding(.vertical, 5)
                Divider()
                    .background(Color.white.opacity(0.7))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.secondarySystemBackground).opacity(0.9))
        )
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}


struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let videoURL: String
    let creator: String
}

struct WorkoutRec_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRec()
    }
}
