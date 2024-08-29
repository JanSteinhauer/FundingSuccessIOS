//
//  ButtonContainerView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/29/24.
//

import SwiftUI

struct ButtonContainerView: View {
    var prevStep: () -> Void
    var nextStep: () -> Void
    
    var body: some View {
        HStack {
            Button(action: prevStep) {
                Text("Back")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(darkBlue)
                    .cornerRadius(5)
            }
            Button(action: nextStep) {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(darkBlue)
                    .cornerRadius(5)
            }
        }
    }
}

