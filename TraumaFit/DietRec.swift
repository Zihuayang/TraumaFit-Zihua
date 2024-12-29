import SwiftUI

struct DietRec: View {
    @State private var currentBodyType: String = "Ectomorph"
    @State private var targetBodyType: String = "Ectomorph"
    @State private var focusBodyPart: String = "Arms"
    @State private var generatedDiet: String = ""
    @State private var scrollOffset: CGFloat = 0.0

    let bodyTypes = ["Ectomorph", "Mesomorph", "Endomorph"]
    let bodyParts = ["Arms", "Chest", "Back", "Legs", "Core"]

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    
                    LinearGradient(
                        gradient: Gradient(colors: dynamicGradientColors()),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)

                    ScrollView {
                        VStack(spacing: 10) {
                            
                            Text("Dietary Suggestion")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 1, x: 0, y: 0)
                                .padding(.top, 30)

                            
                            HStack(spacing: 10) {
                                Image("ectomorph_image")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 200)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(15)
                                    .shadow(color: .black, radius: 2, x: 0, y: 0)

                                Image("mesomorph_image")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 200)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(15)
                                    .shadow(color: .black, radius: 2, x: 0, y: 0)

                                Image("endomorph_image")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 200)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(15)
                                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                            }

                            
                            VStack(alignment: .leading) {
                                Text("Current Body Type:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.leading, 5)
                                Picker("Current Body Type", selection: $currentBodyType) {
                                    ForEach(bodyTypes, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal)
                            }

                            
                            VStack(alignment: .leading) {
                                Text("Target Body Type:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.leading, 5)
                                Picker("Target Body Type", selection: $targetBodyType) {
                                    ForEach(bodyTypes, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal)
                            }

                            
                            VStack(alignment: .leading) {
                                Text("Focus on Body Part:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.leading, 5)
                                Picker("Focus Body Part", selection: $focusBodyPart) {
                                    ForEach(bodyParts, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal)
                            }

                            
                            Button(action: {
                                generateDietPlan()
                            }) {
                                Text("Generate Diet Plan")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 50)
                                    .shadow(radius: 5)
                            }
                            .padding(.top, 20)

                            
                            if !generatedDiet.isEmpty {
                                Text(generatedDiet)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.4))
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                                    .padding(.top, 20)
                            }

                            Spacer()
                        }
                        .padding(.top, 20)
                        .background(GeometryReader {
                            Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: -$0.frame(in: .global).origin.y)
                        })
                    }
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        scrollOffset = value
                    }
                }
            }
        }
    }

    
    func dynamicGradientColors() -> [Color] {
        let normalizedOffset = min(max(scrollOffset / 500, 0), 1)
        let topColor = Color.green.opacity(0.6 - normalizedOffset * 0.3)
        let bottomColor = Color.blue.opacity(0.6 - normalizedOffset * 0.3)
        return [topColor, bottomColor]
    }

    
    func generateDietPlan() {
        var diet = "For a \(targetBodyType) body type focusing on \(focusBodyPart.lowercased()):\n\n"
        
        diet += "Recommended Daily Caloric Intake:\n"
        
        switch (currentBodyType, targetBodyType) {
        case ("Ectomorph", "Ectomorph"):
            diet += "- Maintain around 2,800 - 3,000 calories daily to build lean muscle mass.\n"
        case ("Ectomorph", "Mesomorph"):
            diet += "- Gradually increase calorie intake to about 3,000 - 3,200 calories daily with a focus on balanced nutrients to support muscle growth.\n"
        case ("Ectomorph", "Endomorph"):
            diet += "- Increase to around 3,200 - 3,500 calories with emphasis on healthy fats and proteins to facilitate weight gain.\n"
        case ("Mesomorph", "Ectomorph"):
            diet += "- Decrease to around 2,400 - 2,600 calories daily with more carbs to maintain a leaner physique.\n"
        case ("Mesomorph", "Mesomorph"):
            diet += "- Maintain around 2,600 - 2,800 calories daily with balanced macros for muscle maintenance.\n"
        case ("Mesomorph", "Endomorph"):
            diet += "- Increase to about 3,000 calories with higher protein to support muscle mass and gain healthy weight.\n"
        case ("Endomorph", "Ectomorph"):
            diet += "- Decrease calorie intake to 2,000 - 2,200 calories and focus on high-protein, low-carb diet to reduce body fat.\n"
        case ("Endomorph", "Mesomorph"):
            diet += "- Aim for 2,200 - 2,400 calories with balanced nutrients to support a leaner physique while maintaining strength.\n"
        case ("Endomorph", "Endomorph"):
            diet += "- Maintain around 2,400 - 2,600 calories daily focusing on high protein, low carb to keep weight in check.\n"
        default:
            diet += "- Maintain a balanced caloric intake suitable for overall health and fitness goals.\n"
        }
        
        diet += "\nDiet Recommendation Based on Target Body Type:\n"
        
        switch targetBodyType {
        case "Ectomorph":
            diet += "High-calorie diet focusing on proteins and carbs. Recommended foods include lean meats, whole grains, and starchy vegetables.\n"
        case "Mesomorph":
            diet += "Balanced diet with an emphasis on proteins, healthy fats, and complex carbs. Recommended foods include chicken, fish, quinoa, and leafy greens.\n"
        case "Endomorph":
            diet += "Low-carb, high-protein diet. Include healthy fats and lots of vegetables. Recommended foods include lean meats, eggs, and non-starchy vegetables.\n"
        default:
            diet += "Balanced diet focusing on all macronutrients.\n"
        }
        
        diet += "\nFocus on \(focusBodyPart):\n"
        switch focusBodyPart {
            case "Arms":
                diet += "- Increase protein intake to support muscle growth.\n"
                diet += "Foods:\n"
                diet += "1. Chicken breast\n"
                diet += "2. Almonds\n"
                diet += "3. Greek yogurt\n"
                diet += "4. Beans (e.g., black beans, kidney beans)\n"
                diet += "Drinks:\n"
                diet += "1. Protein shake\n"
                diet += "2. Almond milk\n"

            case "Chest":
                diet += "- Focus on lean proteins and complex carbohydrates.\n"
                diet += "Foods:\n"
                diet += "1. Turkey breast\n"
                diet += "2. Sweet potatoes\n"
                diet += "3. Quinoa\n"
                diet += "4. Chickpeas\n"
                diet += "Drinks:\n"
                diet += "1. Low-fat milk\n"
                diet += "2. Coconut water\n"

            case "Back":
                diet += "- Emphasize proteins and healthy fats.\n"
                diet += "Foods:\n"
                diet += "1. Salmon\n"
                diet += "2. Avocado\n"
                diet += "3. Spinach\n"
                diet += "4. Eggs\n"
                diet += "Drinks:\n"
                diet += "1. Green smoothie (spinach, banana, and almond milk)\n"
                diet += "2. Herbal tea\n"

            case "Legs":
                diet += "- Carbs and protein are key.\n"
                diet += "Foods:\n"
                diet += "1. Brown rice\n"
                diet += "2. Lean beef\n"
                diet += "3. Lentils\n"
                diet += "4. Sweet corn\n"
                diet += "Drinks:\n"
                diet += "1. Chocolate milk\n"
                diet += "2. Beetroot juice\n"

            case "Core":
                diet += "- Low-fat, high-protein diet to reduce body fat.\n"
                diet += "Foods:\n"
                diet += "1. Egg whites\n"
                diet += "2. Broccoli\n"
                diet += "3. Chicken breast\n"
                diet += "4. Cottage cheese\n"
                diet += "Drinks:\n"
                diet += "1. Green tea\n"
                diet += "2. Lemon water\n"

            default:
                diet += "- Balanced diet with focus on overall health.\n"
                diet += "Foods:\n"
                diet += "1. Mixed nuts\n"
                diet += "2. Oats\n"
                diet += "3. Lean meats\n"
                diet += "4. Mixed greens (spinach, kale)\n"
                diet += "Drinks:\n"
                diet += "1. Water with lemon\n"
                diet += "2. Herbal infusion\n"
        }
        
        diet += "\nNote: Become an exclusive member of TraumaFit for a personalized diet plan tailored just for you."
        
        generatedDiet = diet
    }

}


struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct DietRec_Previews: PreviewProvider {
    static var previews: some View {
        DietRec()
    }
}
