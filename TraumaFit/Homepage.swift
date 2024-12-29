import SwiftUI

struct Homepage: View {
    @State private var journalText: String = ""
    @Binding var showSignIn: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
           
                HStack {
                    Text("Welcome Back!!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    NavigationLink(destination: Reminder()) {
                        Image(systemName: "bell.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 20
                    ) {
                    
                        NavigationLink(destination: WorkoutRec()) {
                            StyledBoxView(title: "Workout Recommendation", iconName: "flame.fill", backgroundColor: Color.red)
                        }
                        
           
                        NavigationLink(destination: SetTimerView()) {
                            StyledBoxView(title: "Set Timer", iconName: "timer", backgroundColor: Color.blue)
                        }
                        
                      
                        NavigationLink(destination: WorkoutTracker()) {
                            StyledBoxView(title: "Stats", iconName: "chart.bar.fill", backgroundColor: Color.green)
                        }
                        
                     
                        NavigationLink(destination: Userstats()) {
                            StyledBoxView(title: "User Information", iconName: "person.fill", backgroundColor: Color.orange)
                        }
                        
                  
                        NavigationLink(destination: DietRec()) {
                            StyledBoxView(title: "Dietary Suggestions", iconName: "fork.knife.circle.fill", backgroundColor: Color.purple)
                        }
                        
                        
                        NavigationLink(destination: ProgressReport()) {
                            StyledBoxView(title: "Progress Report", iconName: "chart.line.uptrend.xyaxis", backgroundColor: Color.teal)
                        }
                        
                  
                        NavigationLink(destination: Journal()) {
                            StyledBoxView(title: "Journal", iconName: "pencil.and.outline", backgroundColor: Color.gray)
                        }
                        
                       
                        NavigationLink(destination: MusicRec()) {
                            StyledBoxView(title: "Music Recommendation", iconName: "music.note.list", backgroundColor: Color.cyan)
                        }
                    }
                    .padding()
                }
                
              
                NavigationLink(destination: SettingsView(showSignIn: $showSignIn)) {
                    Text("Settings")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}


struct StyledBoxView: View {
    let title: String
    let iconName: String
    let backgroundColor: Color
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Spacer()
            Image(systemName: iconName)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .padding(.bottom, 5)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding([.leading, .trailing, .bottom])
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(color: backgroundColor.opacity(0.5), radius: 5, x: 0, y: 5)
    }
}

struct Homepage_Previews: PreviewProvider {
    @State static var showSignIn = false 
    
    static var previews: some View {
        Homepage(showSignIn: $showSignIn)
    }
}

