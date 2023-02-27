//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by powerofdeen on 2023/01/13.
//

import SwiftUI

struct ScrumsView: View {
    // @Binding 바안딩된 변수를 수정하면 부모 자식에게 모두 알리고 ui 및 데이터 모델을 모두 업데이트 함
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
    // @State 변수를 변경하면 해당 화면 안에서 참조하고 있는 ui를 자동으로 업데이트
    

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
