//
//  HeaderView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/29/24.
//

import SwiftUI

struct HeaderView: View {
    @Binding var step: Int
    @Binding var isDonor: Bool
    
    var body: some View {
        HStack {
            Image("BeaverLogo") // Replace with your actual logo
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            Spacer()
            
            Text(isDonor ? "Donor Signup" : "User Signup")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Spacer()
            
            Text("Step \(step + 1)")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
    
