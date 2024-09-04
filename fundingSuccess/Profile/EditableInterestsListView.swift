//
//  EditableInterestsListView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/4/24.
//

import SwiftUI

struct EditableInterestsListView: View {
    @Binding var interests: [String]
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(interests.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Interest", text: Binding(
                        get: { interests[index] },
                        set: { interests[index] = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        interests.remove(at: index)
                    }) {
                        Text("Remove Interest")
                            .foregroundColor(.red)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            Button(action: {
                interests.append("") // Add a new empty interest entry
            }) {
                Text("Add Interest")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(fsblue)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
    }
}
