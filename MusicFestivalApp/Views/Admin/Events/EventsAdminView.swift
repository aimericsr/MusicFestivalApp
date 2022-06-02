//
//  EventsAdminView.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 21/12/2021.
//

import SwiftUI

struct EventsAdminView: View {
    @StateObject private var eventVM = EventListAdminVM(service: EventService())
    var body: some View {
        VStack {
            Group {
                switch eventVM.state {
                case .success:
                    List(eventVM.events, id:\.id){ event in
                        EventCellAdminView()
                    }
                    .refreshable{
                        Task{
                            await eventVM.getEvents()
                        }
                    }
                case .loading :
                    LoadingView(text: "Fetching Events")
                default:
                    EmptyView()
                }
            }
        }
        .navigationTitle("Events")
        .task{
            await eventVM.getEvents()
        }
        .alert("Error",
               isPresented:  $eventVM.hasError,
               presenting: eventVM.state) {detail in
            Button("Retry"){
                Task {
                    await eventVM.getEvents()
                }
            }
        } message : {detail in
            if case let .failed(error) = detail {
                Text(error)
            }
        }
    }
}

struct EventsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        EventsAdminView()
    }
}
