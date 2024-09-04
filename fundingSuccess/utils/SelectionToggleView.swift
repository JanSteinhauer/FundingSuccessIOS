//
//  SelectionToggleView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/4/24.
//

import SwiftUI

struct SectionToggleView: View {
    @Binding var showSection: Bool
    var title: String
    
    var body: some View {
        Button(action: {
            withAnimation {
                showSection.toggle()
            }
        }) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: showSection ? "chevron.up" : "chevron.down")
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(8)
        }
    }
}

