//
//  EditableEducationListView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/4/24.
//

import SwiftUI

struct EditableEducationListView: View {
    @Binding var education: [EducationEntry]
    
    // DateFormatter to format dates as dd/mm/yyyy
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(education.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("University", text: Binding(
                        get: { education[index].university },
                        set: { education[index].university = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Major", text: Binding(
                        get: { education[index].major },
                        set: { education[index].major = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("GPA", text: Binding(
                        get: { education[index].gpa },
                        set: { education[index].gpa = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    // DatePicker for Start Date
                    DatePicker("Start Date", selection: Binding(
                        get: {
                            // Convert the string date to Date object
                            dateFormatter.date(from: education[index].startDate) ?? Date()
                        },
                        set: { newDate in
                            // Format the selected Date to string in dd/MM/yyyy format
                            education[index].startDate = dateFormatter.string(from: newDate)
                        }
                    ), displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())

                    // DatePicker for End Date
                    DatePicker("End Date", selection: Binding(
                        get: {
                            // Convert the string date to Date object
                            dateFormatter.date(from: education[index].endDate) ?? Date()
                        },
                        set: { newDate in
                            // Format the selected Date to string in dd/MM/yyyy format
                            education[index].endDate = dateFormatter.string(from: newDate)
                        }
                    ), displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())

                    Button(action: {
                        education.remove(at: index)
                    }) {
                        Text("Remove Education")
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
                education.append(EducationEntry()) // Add a new empty education entry
            }) {
                Text("Add Education")
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
