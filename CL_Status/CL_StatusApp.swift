//
//  CL_StatusApp.swift
//  CL_Status
//
//  Created by Andreas Loizides on 20/10/2022.
//

import SwiftUI
import WidgetKit

@main
struct CL_StatusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
				.onAppear{
					WidgetCenter.shared.reloadAllTimelines()
				}
        }
    }
}
