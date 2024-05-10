import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveGameView: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.openWindow) var openWindow
    @ObservedObject var arkitSessionManager = ARKitSessionManager()
    @State var showGiftCard = false
    
    @State var sphereEntity = Entity()
    @State var giftCardEntity = Entity()

    var body: some View {
        RealityView { content in
            content.add(viewModel.setupContentEntity())
            sphereEntity = viewModel.addSphere(name: "red")
        }
        .onChange(of: showGiftCard, { oldValue, newValue in
            giftCardEntity = viewModel.addGiftCard()
            let matrix = arkitSessionManager.getOriginFromDeviceTransform()
            viewModel.setEntityPosition(entity: giftCardEntity, matrix: matrix)
        })
        .gesture(SpatialTapGesture()
            .targetedToEntity(giftCardEntity)
            .onEnded { value in
                openWindow(id: "main")
                viewModel.removeSphere(entity: giftCardEntity)
            })
        .gesture(
            SpatialTapGesture()
                .targetedToEntity(sphereEntity)
                .onEnded { value in
                    viewModel.removeSphere(entity: sphereEntity)
                    showGiftCard = true
                }
        )
    }
}
