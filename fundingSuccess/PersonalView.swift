//
//  PersonalView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/29/24.
//

import SwiftUI

struct PersonalView: View {
    @Binding var entries: [PersonalEntry]
    let fsblue = Color(hex: "#003366") // Replace with your custom color if necessary
    
    var body: some View {
        Form {
            ForEach(entries.indices, id: \.self) { index in
                Section(header: HStack {
                   
                    Text("Personal Information")
                        .foregroundColor(fsblue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .minimumScaleFactor(0.5)
                    Spacer()
                }) {
                    TextField("Name", text: $entries[index].name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                    
                    // Phone number TextField restricted to numbers
                    TextField("Phone", text: $entries[index].phone)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                        .keyboardType(.numberPad) // Only show number pad
                        .onChange(of: entries[index].phone) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                entries[index].phone = filtered
                            }
                        }
                    
                    TextField("Email", text: $entries[index].email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                    
                    Picker("Gender", selection: $entries[index].gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Non Binary").tag("Non Binary")
                        Text("Other").tag("Other")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                    
                    // Date of Birth with DatePicker
                    DatePicker("Date of Birth", selection: Binding(
                        get: {
                            entries[index].dateOfBirth.isEmpty ? Date() : DateFormatter().date(from: entries[index].dateOfBirth) ?? Date()
                        },
                        set: { newDate in
                            entries[index].dateOfBirth = DateFormatter().string(from: newDate)
                        }
                    ), displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                }
            }
        }
        .scrollContentBackground(.hidden) // Hides the default gray background
        .background(Color.clear) // Set the background to clear or any other color you want
    }
}



