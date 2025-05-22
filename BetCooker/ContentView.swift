//
//  ContentView.swift
//  BetCooker
//
//  Created by Guest User on 22/05/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, BetCooker!")
            .onAppear {
                APIService.shared.fetchTennisOdds { _ in }
            }
            .onAppear {
                APIService.shared.fetchTennisScores { _ in }
            }
        }
}

#Preview {
    ContentView()
}
