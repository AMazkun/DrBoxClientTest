//
//  DrBoxClientTestApp.swift
//  DrBoxClientTest
//
//  Created by admin on 29.09.2023.
//
import Logging
import Pulse
import PulseLogHandler
import PulseUI
import SwiftUI

@main
struct App: SwiftUI.App {
    init() {
        LoggingSystem.bootstrap(PersistentLogHandler.init)
        Experimental.URLSessionProxy.shared.isEnabled = true
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            // terminating
            removeTempFiles()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    AppView()
                }
                .tabItem {
                    Label("App", systemImage: "play")
                }
                
                NavigationStack {
                    ConsoleView(store: .shared)
                }
                .tabItem {
                    Label("Console", systemImage: "list.dash.header.rectangle")
                }
            }
        }
    }
}
