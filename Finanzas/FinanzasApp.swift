//
//  FinanzasApp.swift
//  Finanzas
//
//  Created by Paulo Menezes on 03/09/22.
//

import SwiftUI

@main
struct FinanzasApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
