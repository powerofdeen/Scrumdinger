//
//  DailyScrum.swift
//  Scrumdinger
//
//  Created by powerofdeen on 2023/01/13.
//

import Foundation

struct DailyScrum: Identifiable {
    let id: UUID
    var title: String
    var attendees: [Attendee]
    var lengthInMinutes: Int
    var theme: Theme
    
    init(id: UUID = UUID(), title: String, attendees: [String], lengthInMinutes: Int, theme: Theme) {
        self.id = id
        self.title = title
        self.attendees = attendees.map { Attendee(name: $0) }
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
    }
}

extension DailyScrum {
    struct Attendee: Identifiable {
        let id: UUID
        var name: String
        
        init(id: UUID = UUID(), name: String) {
            self.id = id
            self.name = name
        }
    }
}

extension DailyScrum {
    static let sampleData: [DailyScrum] =
    [
        DailyScrum(title: "Design", attendees: ["Kim", "Lee", "Park", "Seo", "Choi", "Cho"], lengthInMinutes: 10, theme: .yellow),
        DailyScrum(title: "App Dev", attendees: ["Kim", "Lee", "Park", "Seo", "Choi", "Cho"], lengthInMinutes: 5, theme: .bubblegum),
        DailyScrum(title: "Web Dev", attendees: ["Kim", "Lee", "Park", "Seo", "Choi", "Cho"], lengthInMinutes: 7, theme: .orange)
    ]
}
