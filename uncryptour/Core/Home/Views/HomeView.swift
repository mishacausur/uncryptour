//
//  HomeView.swift
//  uncryptour
//
//  Created by Misha Causur on 27.03.2022.
//

import SwiftUI
// Home
struct HomeView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                Text("Header")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
