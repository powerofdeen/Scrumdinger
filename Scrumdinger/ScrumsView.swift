//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by powerofdeen on 2023/01/13.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingNewScrumView = false
    @State private var newScrumDada = DailyScrum.Data()
    let saveAction: () -> Void
    
    var body: some View {
        List {
            ForEach($scrums) { $scrum in
                NavigationLink(destination: DetailView(scrum: $scrum)) {
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.theme.mainColor)
            }
//            삭제
//            .onDelete { indices in
//                scrums.remove(atOffsets: indices)
//            }
        }
        .navigationTitle("Daily Scrums")
        .toolbar {
            Button {
                isPresentingNewScrumView = true
            } label: {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Scrum")

        }
        .sheet(isPresented: $isPresentingNewScrumView) {
            NavigationView {
                DetailEditView(data: $newScrumDada)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewScrumView = false
                                newScrumDada = DailyScrum.Data()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let newScrum = DailyScrum(data: newScrumDada)
                                scrums.append(newScrum)
                                isPresentingNewScrumView = false
                                newScrumDada = DailyScrum.Data()
                            }
                        }
                    }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
        }
    }
}
