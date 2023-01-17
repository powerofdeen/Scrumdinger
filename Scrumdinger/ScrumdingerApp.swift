//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by powerofdeen on 2023/01/12.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.sampleData
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumsView(scrums: $scrums)
            }
            
        }
    }
}
