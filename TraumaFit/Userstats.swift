import SwiftUI

struct Userstats: View {
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var bodyType: String = ""
    
    @State private var prChest: String = ""
    @State private var prArms: String = ""
    @State private var prBack: String = ""
    @State private var prLegs: String = ""
    @State private var prCore: String = ""
    @State private var prMilesRan: String = ""

    @State private var showAlert = false
    @State private var isFlipped: [Bool] = Array(repeating: false, count: 6) 

    let bodyTypes = ["Ectomorph", "Mesomorph", "Endomorph"]
    

    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text("User Stats")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .shadow(color: Color.black.opacity(0.8), radius: 2, x: 0, y: 2)
                    

                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        VStack(alignment: .leading) {
                            Text("Body Type:")
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.8), radius: 1, x: 0, y: 2)

                            Menu {
                                ForEach(bodyTypes, id: \.self) { type in
                                    Button(action: {
                                        bodyType = type
                                    }) {
                                        Text(type)
                                            .foregroundColor(.black)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(bodyType.isEmpty ? "Select your body type" : bodyType)
                                        .foregroundColor(.black)
                                        .padding(10)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.black)
                                }
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)

                        
                        Image(getBodyTypeImage())
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    Spacer()

                    
                    VStack(alignment: .leading, spacing: 10) {
                        customInputSection(title: "Weight (lbs):", text: $weight)
                            .shadow(color: Color.black.opacity(0.8), radius: 1, x: 0, y: 2)
                        customInputSection(title: "Height (cm):", text: $height)
                            .shadow(color: Color.black.opacity(0.8), radius: 1, x: 0, y: 2)
                    }
                    .padding(.leading, 10)
                }
                .padding(.horizontal)

                Text("Personal Records")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .underline()
                    .shadow(color: Color.black.opacity(0.8), radius: 1, x: 0, y: 2)
                    
                
                
                LazyVGrid(columns: columns, spacing: 20) {
                    flipCardSection(title: "PR for Chest", text: $prChest, image: "chest_icon", isFlipped: $isFlipped[0])
                    flipCardSection(title: "PR for Arms", text: $prArms, image: "arms_icon", isFlipped: $isFlipped[1])
                    flipCardSection(title: "PR for Back", text: $prBack, image: "back_icon", isFlipped: $isFlipped[2])
                    flipCardSection(title: "PR for Legs", text: $prLegs, image: "legs_icon", isFlipped: $isFlipped[3])
                    flipCardSection(title: "PR for Core", text: $prCore, image: "core_icon", isFlipped: $isFlipped[4])
                    flipCardSection(title: "Miles Ran", text: $prMilesRan, image: "run_icon", isFlipped: $isFlipped[5])
                }
                .shadow(color: Color.black.opacity(0.8), radius: 2, x: 0, y: 2)
                .padding(.horizontal)
                
                Button(action: {
                    saveStats()
                    showAlert = true
                }) {
                    Text("Save Stats")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                        .padding(.horizontal, 50)
                        .shadow(radius: 10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Stats Saved"),
                        message: Text("Your stats have been successfully saved."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Spacer()
            }
        }
        .background(
            Image("user_logo")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            loadStats()
        }
    }
    
    
    func customInputSection(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            TextField("Enter \(title.lowercased())", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
                .padding(4)
        }
    }

    
    func flipCardSection(title: String, text: Binding<String>, image: String, isFlipped: Binding<Bool>) -> some View {
        ZStack {
            if isFlipped.wrappedValue {
                VStack {
                    TextField("\(title) (lbs or miles)", text: text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .rotation3DEffect(Angle(degrees: isFlipped.wrappedValue ? 0 : 180), axis: (x: 0, y: 1, z: 0))
            } else {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                    .rotation3DEffect(Angle(degrees: isFlipped.wrappedValue ? 0 : 180), axis: (x: 0, y: 1, z: 0))
            }
        }
        
        .onTapGesture(count: 2) {
            withAnimation(.easeInOut) {
                isFlipped.wrappedValue.toggle()
            }
        }
    }
    
    
    func getBodyTypeImage() -> String {
        switch bodyType {
        case "Ectomorph":
            return "ectomorph_image"
        case "Mesomorph":
            return "mesomorph_image"
        case "Endomorph":
            return "endomorph_image"
        default:
            return "default_image"
        }
    }

    
    func saveStats() {
        UserDefaults.standard.set(weight, forKey: "weight")
        UserDefaults.standard.set(height, forKey: "height")
        UserDefaults.standard.set(bodyType, forKey: "bodyType")
        UserDefaults.standard.set(prChest, forKey: "prChest")
        UserDefaults.standard.set(prArms, forKey: "prArms")
        UserDefaults.standard.set(prBack, forKey: "prBack")
        UserDefaults.standard.set(prLegs, forKey: "prLegs")
        UserDefaults.standard.set(prCore, forKey: "prCore")
        UserDefaults.standard.set(prMilesRan, forKey: "prMilesRan")
    }
    
    
    func loadStats() {
        weight = UserDefaults.standard.string(forKey: "weight") ?? ""
        height = UserDefaults.standard.string(forKey: "height") ?? ""
        bodyType = UserDefaults.standard.string(forKey: "bodyType") ?? "Ectomorph"
        prChest = UserDefaults.standard.string(forKey: "prChest") ?? ""
        prArms = UserDefaults.standard.string(forKey: "prArms") ?? ""
        prBack = UserDefaults.standard.string(forKey: "prBack") ?? ""
        prLegs = UserDefaults.standard.string(forKey: "prLegs") ?? ""
        prCore = UserDefaults.standard.string(forKey: "prCore") ?? ""
        prMilesRan = UserDefaults.standard.string(forKey: "prMilesRan") ?? ""
    }
}

struct Userstats_Previews: PreviewProvider {
    static var previews: some View {
        Userstats()
    }
}
