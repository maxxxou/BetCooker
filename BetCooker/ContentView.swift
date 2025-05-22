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
                APIService.shared.fetchOdds { _ in }
            }
            .onAppear {
                APIService.shared.fetchScores { _ in }
            }
        Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/) {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
        }
        }
}

#Preview {
    ContentView()
}



