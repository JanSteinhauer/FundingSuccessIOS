//
//  MainPagevView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/27/24.
//

import SwiftUI

// Simple Main Page View
struct MainPageView: View {
    var body: some View {
        VStack {
            Text("Welcome to the Main Page!")
                .font(.largeTitle)
                .padding()
            
            Text("This is where your main content will be displayed.")
                .font(.subheadline)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Main Page")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hides the back button
    }
}

