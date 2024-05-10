import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.openURL) private var openURL
    @Environment(\.openWindow) var openWindow
    
    
    var body: some View {
        VStack {
            Spacer(minLength: 100)
            
            Image("banner")
                .onTapGesture {
                    viewModel.showImmersiveGameSpace = !viewModel.showImmersiveGameSpace
                }.glassBackgroundEffect()
                .contentShape(.hoverEffect, .rect(cornerRadius: 50))
                .hoverEffect()
            
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: 15) {
                    CardView(offer: Offer(imageName: "dash", title: "15% Off Selected Offer", code: "Get Code", action: {
                        viewModel.showImmersiveSpace = !viewModel.showImmersiveSpace
                    }))
                    .glassBackgroundEffect()
                    .contentShape(.hoverEffect, .rect(cornerRadius: 50))
                    .hoverEffect()
                    
                    CardView(offer: Offer(imageName: "booking", title: "Free Click and Collect on Orders", code: "Get Deal", action: {
                        if let url = URL(string: "https://www.vouchercodes.co.uk/") {
                            openURL(url)
                        }
                    }))
                    .glassBackgroundEffect()
                    .contentShape(.hoverEffect, .rect(cornerRadius: 50))
                    .hoverEffect()
                    
                    
                    CardView(offer: Offer(imageName: "adidas", title: "20% Off Orders", code: "Get Sale", action: {
                        openWindow(id: "detail")
                    }))
                    .glassBackgroundEffect()
                    .contentShape(.hoverEffect, .rect(cornerRadius: 50))
                    .hoverEffect()
                   
                }
                
                .padding(.horizontal, 150)
                .padding(.vertical, 20)
                .onChange(of: viewModel.showImmersiveSpace) { _, newValue in
                    Task {
                        if newValue {
                            await openImmersiveSpace(id: "ImmersiveSpace")
                        } else {
                            await dismissImmersiveSpace()
                        }
                    }
                }
                .onChange(of: viewModel.showImmersiveGameSpace) { _, newValue in
                    Task {
                        if newValue {
                            await openImmersiveSpace(id: "ImmersiveGameSpace")
                            dismissWindow()
                            
                        } else {
                            await dismissImmersiveSpace()
                        }
                    }
                }
                
            }
            
            
        }
        
        
    }
    
    
}


struct CardView: View {
    let offer: Offer
    
    var body: some View {
        
        VStack(alignment: .leading) {

            Image(offer.imageName).resizable().frame(width: 320, height: 150).aspectRatio(contentMode: .fill)
            
            
            Text(offer.title)
                .font(.system(size: 25))
                .fixedSize(horizontal: false, vertical: true)
                .padding(10)
                
            
            
            
            Spacer(minLength: 100)
            
            
            //            Button(offer.code) {
            //                offer.action()
            //            }
        }
        .frame(width: 320)
        .onTapGesture {
            offer.action()
        }
        
    }
}

struct Offer {
    var imageName: String
    var title: String
    var code: String
    var action: () -> Void
}
