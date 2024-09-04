//
//  EditableUniversityPreferencesListView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/4/24.
//

import SwiftUI

struct EditableUniversityPreferencesListView: View {
    @Binding var universities: [EducationEntry]
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(universities.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("University", text: Binding(
                        get: { universities[index].university },
                        set: { universities[index].university = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Major", text: Binding(
                        get: { universities[index].major },
                        set: { universities[index].major = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        universities.remove(at: index)
                    }) {
                        Text("Remove University")
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
                universities.append(EducationEntry()) // Add a new empty university entry
            }) {
                Text("Add University")
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

