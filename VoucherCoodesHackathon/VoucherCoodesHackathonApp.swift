//
//  VoucherCoodesHackathonApp.swift
//  VoucherCoodesHackathon
//
//  Created by Yenting Chen on 09/05/2024.
//

import SwiftUI

@main
struct VoucherCoodesHackathonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
