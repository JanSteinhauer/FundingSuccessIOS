//
//  EditableExperienceListView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/4/24.
//

import SwiftUI


struct EditableExperienceListView: View {
    @Binding var experience: [ExperienceEntry]
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(experience.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Job Title", text: Binding(
                        get: { experience[index].jobTitle },
                        set: { experience[index].jobTitle = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Company", text: Binding(
                        get: { experience[index].company },
                        set: { experience[index].company = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Location", text: Binding(
                        get: { experience[index].location },
                        set: { experience[index].location = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        experience.remove(at: index)
                    }) {
                        Text("Remove Experience")
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
                experience.append(ExperienceEntry()) // Add a new empty experience entry
            }) {
                Text("Add Experience")
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
