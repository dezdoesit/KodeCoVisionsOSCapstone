//
//  ImmersiveView.swift
//  KodeCoCapstone
//
//  Created by dmoney on 6/19/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                /* Occluded floor */
                let floor = ModelEntity(mesh: .generatePlane(width: 100, depth: 100), materials: [OcclusionMaterial()])
                floor.generateCollisionShapes(recursive: false)
                floor.components[PhysicsBodyComponent.self] = .init(
                  massProperties: .default,
                  mode: .static
                )
                content.add(floor)
                // Add an ImageBasedLight for the immersive content
                guard let resource = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
                let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.25)
                immersiveContentEntity.components.set(iblComponent)
                immersiveContentEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: immersiveContentEntity))

           
            }
        }
        .gesture(dragGesture)
    }
    var dragGesture: some Gesture {
      DragGesture()
        .targetedToAnyEntity()
          .onChanged { value in
            value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
            value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
          }
          .onEnded { value in
            value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
           }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
}
