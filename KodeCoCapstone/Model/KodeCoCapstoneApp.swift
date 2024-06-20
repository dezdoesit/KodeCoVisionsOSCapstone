//
//  KodeCoCapstoneApp.swift
//  KodeCoCapstone
//
//  Created by dmoney on 6/19/24.
//

import SwiftUI

@main
struct KodeCoCapstoneApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
