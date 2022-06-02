//
//  AdminHomeView.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 16/12/2021.
//

import SwiftUI

struct AdminHomeView: View {
    @State private var selection: Tab = .artists

     enum Tab {
         case artists
         case events
     }
    
    var body: some View {
        TabView(selection: $selection) {
                    ArtistsAdminView()
                        .tabItem {
                            Label("Artists", systemImage: "star")
                        }
                        .tag(Tab.artists)

                    EventsAdminView()
                        .tabItem {
                            Label("Events", systemImage: "list.bullet")
                        }
                        .tag(Tab.events)
                }
    }
}

struct AdminHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AdminHomeView()
    }
}
