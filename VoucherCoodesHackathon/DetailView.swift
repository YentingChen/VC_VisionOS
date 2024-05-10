import SwiftUI
import RealityKit
import RealityKitContent

struct DetailView: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.openURL) private var openURL
    @State private var sneaker = Entity()
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            
            RealityView { content in
                
                guard let sneaker = try? await ModelEntity(named: "sneaker") else {
                    fatalError("Unable to load scene model")
                }
                
                sneaker.position.z = -0.5
                
                content.add(sneaker)
            }
            
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    Image("adidas")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom)
                    
                    Image("adidas-logo").resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .cornerRadius(25)
                        .offset(x: 25, y: 50).zIndex(1)
                    
                }
                VStack {
                    Text("Free £5 Amazon Voucher with Orders Over £50 at adidas")
                        .font(.system(size: 45))
                        .padding(.horizontal)
                        .offset(y: 100)
                    
                    Spacer(minLength: 100)
                    
                        Button {
                            if let url = URL(string: "https://www.adidas.co.uk/") {
                                            openURL(url)
                                        }
                            
                        } label: {
                          Text("Get Deal")
                                .font(.system(size: 40)).padding(50)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 50)
                        .buttonBorderShape(.roundedRectangle(radius: 25))
  
                }
                
                   
                    
                
            }.glassBackgroundEffect()
            
        }
        
        
    }
    
    
}

#Preview {
    DetailView()
        .environment(ViewModel())
}

//Model3D(named: offer.imageName) { model in
//    model
//        .resizable()
//        .aspectRatio(contentMode: .fit)
//        .frame(width: 200, height: 200)
//} placeholder: {
//    ProgressView()
//}.padding(.bottom, 20)
