import SwiftUI
import HealthKit

struct ProgressReport: View {
    @State private var dailySteps: Double = 0
    @State private var goalSteps: Double = 10000
    @State private var stepHistory: [Double] = [3000, 4000, 5000, 8000, 7000, 9500, 4500]
    @State private var healthKitAvailable = HKHealthStore.isHealthDataAvailable()
    @State private var errorMessage: String? = nil
    private var healthStore = HKHealthStore()

    
    @State private var stepFetchTimer: Timer? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                if healthKitAvailable {
                    
                    Text("Daily Steps")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 15)
                        .frame(maxWidth: .infinity)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 40)
                            .frame(width: 250, height: 250)

                        Circle()
                            .trim(from: 0.0, to: CGFloat(min(dailySteps / goalSteps, 1.0)))
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.green]),
                                    center: .center
                                ),
                                style: StrokeStyle(lineWidth: 40, lineCap: .round)
                            )
                            .rotationEffect(Angle(degrees: -90))
                            .frame(width: 250, height: 250)
                            .animation(.easeInOut(duration: 1.5), value: dailySteps)

                        VStack {
                            Text("\(Int(dailySteps))")
                                .font(.largeTitle)
                                .bold()
                            Text("of \(Int(goalSteps)) steps")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    .padding(.top, 30)
                    
                    
                    VStack {
                        Text("Daily Steps Progress")
                            .font(.headline)
                            .padding(.top, 15)
                            .padding(.bottom, 20)
                        
                        HStack {
                            LineGraphView(dataPoints: stepHistory)
                                .frame(height: 200)
                                .padding(.horizontal, 16)
                        }
                        .padding(.leading, 20)
                        
                        
                        Button(action: {
                            fetchStepCount()
                        }) {
                            Text("Refresh Steps")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.top, 20)
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                } else {
                    
                    Text("HealthKit is not available on this device.")
                        .font(.title)
                        .padding()
                }
                
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 245/255, green: 245/255, blue: 220/255),
                    Color(red: 220/255, green: 220/255, blue: 200/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            requestHealthKitAuthorization()
            startStepFetchTimer()
        }
        .onDisappear {
            stopStepFetchTimer()
        }
    }
    
    private func startStepFetchTimer() {
        stepFetchTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            fetchStepCount()
        }
        stepFetchTimer?.tolerance = 10
    }
    
    
    private func stopStepFetchTimer() {
        stepFetchTimer?.invalidate()
        stepFetchTimer = nil
    }
    
    private func requestHealthKitAuthorization() {
        guard healthKitAvailable else { return }
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            if success {
                fetchStepCount()
            } else {
                errorMessage = "HealthKit authorization denied."
                print("HealthKit authorization denied: \(String(describing: error))")
            }
        }
    }
    
    private func fetchStepCount() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            if let error = error {
                
                print("Failed to fetch steps: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch step count."
                }
                return
            }
            
            guard let result = result, let sum = result.sumQuantity() else {
                
                DispatchQueue.main.async {
                    self.dailySteps = 0
                    self.errorMessage = "No steps data available for today."
                }
                return
            }
            
           
            let steps = sum.doubleValue(for: HKUnit.count())
            DispatchQueue.main.async {
                self.dailySteps = steps
                self.errorMessage = nil
                self.addDailyStepsToHistory()
            }
        }
        
        healthStore.execute(query)
    }
    
    
    private func addDailyStepsToHistory() {
        
        if stepHistory.count == 7 {
            stepHistory.removeFirst()
        }
        stepHistory.append(dailySteps)
    }
}








struct LineGraphView: View {
    var dataPoints: [Double]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GridLines(dataPoints: dataPoints, geometry: geometry)
                LinePath(dataPoints: dataPoints, geometry: geometry)
                DataPoints(dataPoints: dataPoints, geometry: geometry)
            }
        }
    }
}


struct GridLines: View {
    var dataPoints: [Double]
    var geometry: GeometryProxy

    var body: some View {
        let numberOfHorizontalLines = 10
        let numberOfVerticalLines = 7
        let maxValue = 10000.0

        
        ForEach(0...numberOfHorizontalLines, id: \.self) { i in
            let y = geometry.size.height - (geometry.size.height / CGFloat(numberOfHorizontalLines) * CGFloat(i))
            Path { path in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: geometry.size.width, y: y))
            }
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)

            
            Text("\(Int(maxValue / CGFloat(numberOfHorizontalLines) * CGFloat(i)))")
                .font(.caption)
                .foregroundColor(.gray)
                .position(x: -25, y: y)
        }

        
        let daysOfWeek = ["7", "6", "5", "4", "3", "Yday", "Now"]
        ForEach(0..<numberOfVerticalLines, id: \.self) { i in
            let x = geometry.size.width / CGFloat(numberOfVerticalLines - 1) * CGFloat(i)
            Path { path in
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: geometry.size.height))
            }
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)

            
            if i < daysOfWeek.count {
                Text(daysOfWeek[i])
                    .font(.caption)
                    .foregroundColor(.gray)
                    .position(x: x, y: geometry.size.height + 15)
            }
        }
    }
}





struct LinePath: View {
    var dataPoints: [Double]
    var geometry: GeometryProxy

    var body: some View {
        let maxValue = 10000.0
        let minValue = 0.0
        let range = maxValue - minValue

        Path { path in
            for index in dataPoints.indices {
                let xPosition = geometry.size.width / CGFloat(dataPoints.count - 1) * CGFloat(index)
                let yPosition = (1 - CGFloat((dataPoints[index] - minValue) / range)) * geometry.size.height

                if index == 0 {
                    path.move(to: CGPoint(x: xPosition, y: yPosition))
                } else {
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
        }
        .stroke(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.green]),
                startPoint: .leading,
                endPoint: .trailing
            ),
            lineWidth: 2
        )
    }
}


struct DataPoints: View {
    var dataPoints: [Double]
    var geometry: GeometryProxy

    var body: some View {
        let maxValue = 10000.0
        let range = maxValue

        ForEach(dataPoints.indices, id: \.self) { index in
            let xPosition = geometry.size.width / CGFloat(dataPoints.count - 1) * CGFloat(index)
            let yPosition = geometry.size.height - (geometry.size.height * CGFloat(dataPoints[index] / range))

            ZStack {
                
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                    .position(x: xPosition, y: yPosition)

                
                Text("\(Int(dataPoints[index]))")
                    .font(.caption)
                    .foregroundColor(.black)
                    .position(x: xPosition, y: yPosition - 15) 
            }
        }
    }
}

struct ProgressReport_Previews: PreviewProvider {
    static var previews: some View {
        ProgressReport()
    }
}
