//
//  WeatherSwiftApp.swift
//  WeatherSwift
//
//  Created by Oleh on 11.02.2025.
//

import SwiftUI
import SwiftData

@main
struct WeatherSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView()
                .modelContainer(for: Preference.self)
        }
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
