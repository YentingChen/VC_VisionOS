import RealityKit
import Observation

@Observable
class ViewModel {
    var showImmersiveSpace = false
    var showImmersiveGameSpace = false

    private var contentEntity = Entity()

    func setupContentEntity() -> Entity {
        return contentEntity
    }
    
    func getTargetEntity(name: String) -> Entity? {
        return contentEntity.children.first { $0.name == name}
    }
    
    func removeSphere(entity: Entity) {
        contentEntity.removeChild(entity)
    }
    
    func removeText(entity: Entity) {
        contentEntity.removeChild(entity)
    }
    
    func addSphere(name: String) -> Entity {
        let entity = ModelEntity(
            mesh: .generateSphere(radius: 0.2),
            materials: [SimpleMaterial(color: .red, isMetallic: false)],
            collisionShape: .generateSphere(radius: 0.2),
            mass: 0.0
        )

        entity.name = name

        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))

        let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
        entity.components.set(PhysicsBodyComponent(shapes: entity.collision!.shapes,
                                                   mass: 0.0,
                                                   material: material,
                                                   mode: .dynamic))

        entity.position = SIMD3(x: 0, y: 0, z: 10)

        contentEntity.addChild(entity)

        return entity
    }
    
    

    func addText(text: String) -> Entity {

        let textMeshResource: MeshResource = .generateText(text,
                                                           extrusionDepth: 0.05,
                                                           font: .systemFont(ofSize: 0.3),
                                                           containerFrame: .zero,
                                                           alignment: .center,
                                                           lineBreakMode: .byWordWrapping)

        let material = UnlitMaterial(color: .black)

        let textEntity = ModelEntity(mesh: textMeshResource, materials: [material])
        textEntity.position = SIMD3(x: -(textMeshResource.bounds.extents.x / 2), y: 1.5, z: -1)

        contentEntity.addChild(textEntity)

        return textEntity
    }
    
    
    
    func addGiftCard() -> Entity {
        
        let entity = ModelEntity(
            mesh: .generateSphere(radius: 0.2),
            materials: [SimpleMaterial(color: .red, isMetallic: false)],
            collisionShape: .generateBox(width: 1, height: 1, depth: 0.2),
            mass: 0.0
        )

       

        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
        guard
            let texture1 = try? TextureResource.load(named: "giftcard")
        else {
            fatalError("Unable to load texture.")
        }

    
        entity.name = "giftcard"

        var material1 = SimpleMaterial()
        

        material1.color = .init(texture: .init(texture1))
       

        entity.components.set(ModelComponent(
            mesh: .generateBox(width: 1, height: 1, depth: 0.2, splitFaces: true),
            materials: [material1, material1, material1, material1, material1, material1])
        )
        

        entity.position = SIMD3(x: -1, y: 1.5, z: 3)

        contentEntity.addChild(entity)
        return entity
    }
    
    func setEntityPosition(entity: Entity, matrix: simd_float4x4) {
        let forward = simd_float3(0, 0, -1)
        let cameraForward = simd_act(matrix.rotation, forward)

        let front = SIMD3<Float>(x: cameraForward.x, y: cameraForward.y, z: cameraForward.z)
        let length: Float = 0.5
        let offset = length * simd_normalize(front)

        let position = SIMD3<Float>(x: matrix.position.x, y: matrix.position.y, z: matrix.position.z)

        entity.position = position + offset
        entity.orientation = matrix.rotation
    }
}

extension simd_float4x4 {

    var position: SIMD3<Float> {
        SIMD3<Float>(self.columns.3.x, self.columns.3.y, self.columns.3.z)
    }

    var rotation: simd_quatf {
        let x = simd_float3(self.columns.0.x, self.columns.0.y, self.columns.0.z)
        let y = simd_float3(self.columns.1.x, self.columns.1.y, self.columns.1.z)
        let z = simd_float3(self.columns.2.x, self.columns.2.y, self.columns.2.z)

        let scaleX = simd_length(x)
        let scaleY = simd_length(y)
        let scaleZ = simd_length(z)

        let sign = simd_sign(self.columns.0.x * self.columns.1.y * self.columns.2.z +
                             self.columns.0.y * self.columns.1.z * self.columns.2.x +
                             self.columns.0.z * self.columns.1.x * self.columns.2.y -
                             self.columns.0.z * self.columns.1.y * self.columns.2.x -
                             self.columns.0.y * self.columns.1.x * self.columns.2.z -
                             self.columns.0.x * self.columns.1.z * self.columns.2.y)

        let rotationMatrix = simd_float3x3(x/scaleX, y/scaleY, z/scaleZ)
        let quaternion = simd_quaternion(rotationMatrix)

        return sign >= 0 ? quaternion : -quaternion
    }
}


/// Orbit information for an entity.
struct OrbitComponent: Component {
    var radius: Float
    var speed: Float
    var angle: Float
    var addOrientationRotation : Bool
    init(radius: Float = 2.0, speed: Float = 1.0, angle: Float = 0, addOrientationRotation: Bool = false) {
        self.radius = radius
        self.speed = speed
        self.angle = angle
        self.addOrientationRotation = addOrientationRotation
    }
}
/// A system that rotates entities with a rotation component.
struct OrbitSystem: System {
    static let query = EntityQuery(where: .has(OrbitComponent.self))
    public init(scene: RealityKit.Scene) {}
    func setOrientation(context: SceneUpdateContext, entity: Entity, component: OrbitComponent){
        entity.setOrientation(.init(angle: component.speed * Float(context.deltaTime), axis: [0, 1, 0]), relativeTo: entity)
    }
    
    func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            if var component: OrbitComponent = entity.components[OrbitComponent.self]
            {
                if component.radius == 0 {
                    setOrientation(context: context, entity: entity, component: component)
                }
                else
                {
                    if component.addOrientationRotation {
                        setOrientation(context: context, entity: entity, component: component)
                    }
                    
                    // Calculate the position on the circle
                    let x = component.radius * cos(component.angle);
                    let z = component.radius * sin(component.angle);
                    
                    // Update the Entity's position
                    entity.transform.translation = SIMD3(x, 0, z);
                    
                    // Increment the angle based on time and speed
                    component.angle += component.speed * Float(context.deltaTime)
                    
                    // write out component back to memory
                    entity.components.set(component)
                }
            }
            else { continue }
        }
    }
}
