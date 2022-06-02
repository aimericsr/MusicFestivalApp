//
//  ArtistCellView.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import SwiftUI

struct ArtistCellAdminView: View {
    var artist: ArtistViewModel
    var body: some View {
        HStack{
            Text("\(artist.name)")
                .padding()
                .fixedSize()
            VStack{
                Text("\(artist.nationality)")
                    .padding([.bottom, .top])
                Text("\(artist.musicStyles)")
            }
        }.swipeActions(edge: .leading,allowsFullSwipe: false){
            Button(action:{
                print("modified artists")},
                   label: {
                Image(systemName: "pencil")
            }).tint(.green)
        }.swipeActions(edge: .trailing){
            Button(action:{
                print("delete artists")},
                   label: {
                Image(systemName: "trash.fill")
            }).tint(.red)
        }
    }
}

struct ArtistCellAdminView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistCellAdminView(artist: ArtistViewModel(artist: Artist.dummyData[2])).previewLayout(.sizeThatFits)
    }
}
