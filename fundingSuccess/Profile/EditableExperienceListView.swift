//
//  EditableExperienceListView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/4/24.
//

import SwiftUI

struct EditableExperienceListView: View {
    @Binding var experience: [ExperienceEntry]
    
    // DateFormatter to format dates as dd/mm/yyyy
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
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

                    // DatePicker for Start Date
                    DatePicker("Start Date", selection: Binding(
                        get: {
                            // Convert the string date to Date object
                            dateFormatter.date(from: experience[index].startDate) ?? Date()
                        },
                        set: { newDate in
                            // Format the selected Date to string in dd/MM/yyyy format
                            experience[index].startDate = dateFormatter.string(from: newDate)
                        }
                    ), displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())

                    // DatePicker for End Date
                    DatePicker("End Date", selection: Binding(
                        get: {
                            // Convert the string date to Date object
                            dateFormatter.date(from: experience[index].endDate) ?? Date()
                        },
                        set: { newDate in
                            // Format the selected Date to string in dd/MM/yyyy format
                            experience[index].endDate = dateFormatter.string(from: newDate)
                        }
                    ), displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())

                    TextField("LinkedIn URL", text: Binding(
                        get: { experience[index].linkedin },
                        set: { experience[index].linkedin = $0 }
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
