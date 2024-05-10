import SwiftUI
import RealityKit
import RealityKitContent
import UniformTypeIdentifiers

struct ImmersiveView: View {
    @Environment(ViewModel.self) private var viewModel
    @State var textEntity = Entity()
    
    var body: some View {

        RealityView { content, attachments in
            content.add(viewModel.setupContentEntity())
            textEntity = viewModel.addText(text: "BRUK15")
            
            if let attachment = attachments.entity(for: "cube1_label") {
                attachment.position = [0.1, 0, 0]
                textEntity.addChild(attachment)
            }
        
        } attachments: {
            Attachment(id: "cube1_label") {
                Button(action: {
                    UIPasteboard.general.setValue("BRUK15", forPasteboardType: "public.plain-text")
                    
                }, label: {
                    Text("Copy code")
                        .font(.system(size: 48))
                        .padding(10)
                        .foregroundColor(.black)
                        .glassBackgroundEffect()
                })
                
            }
        }
        .onDisappear {
            viewModel.removeSphere(entity: textEntity)
        }
        
    }
}
