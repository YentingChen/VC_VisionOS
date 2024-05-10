import SwiftUI

@main
struct VoucherCoodesHackathonApp: App {
    @State private var viewModel = ViewModel()
    var body: some Scene {
        WindowGroup(id: "main") {
            ContentView()
                .environment(viewModel)
        }
        
        WindowGroup(id: "detail"){
            DetailView()
                .environment(viewModel)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1.5, height: 1, depth: 10, in: .meters)
        

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(viewModel)
        }
        
        ImmersiveSpace(id: "ImmersiveGameSpace") {
            ImmersiveGameView()
                .environment(viewModel)
        }
    }
}
