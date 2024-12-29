import SwiftUI

struct WelcomeView: View {
    @State private var showSignIn = false

    var body: some View {
        NavigationView {
            ZStack {
             
                Image("coverpage")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

         
                VStack {
                    Spacer()

                    Text("TraumaFit")
                        .font(Font.custom("FascinateInline-Regular", size: 55))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 5)
                        .overlay(
                            Text("TraumaFit")
                                .font(Font.custom("FascinateInline-Regular", size: 55))
                                .foregroundColor(.yellow)
                                .offset(x: -2, y: 2)
                                .mask(
                                    Text("TraumaFit")
                                        .font(Font.custom("FascinateInline-Regular", size: 55))
                                )
                        )

                    Text("One Day or Day 1")
                        .font(Font.custom("TitanOne", size: 20))
                        .foregroundColor(.yellow)
                        .padding(.bottom, 50)

                    NavigationLink(destination: RootView()) {
                        Text("Tap to Start")
                            .font(Font.custom("TitanOne", size: 16))
                            .foregroundColor(.orange)
                            .padding(.top, 300)
                            .frame(maxWidth: 380, maxHeight: 480, alignment: .center)
                            .background(Color.clear)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationBarHidden(true) 
        }
    }
}




struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
