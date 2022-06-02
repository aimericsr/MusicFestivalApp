//
//  LoadingView.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 15/12/2021.
//

import SwiftUI

struct LoadingView: View {
    let text: String
    var body: some View {
        VStack(spacing: 8){
            ProgressView()
            Text("\(self.text)")
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(text: "Test Loading")
    }
}
