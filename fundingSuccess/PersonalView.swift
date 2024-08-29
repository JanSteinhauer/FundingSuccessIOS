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
                    Spacer()
                    Text("Personal Information")
                        .foregroundColor(fsblue)
                        .font(.title2) // Set the font size to be larger
                        .fontWeight(.bold) // Make the font bold
                        .padding()
                        .lineLimit(1) // Ensure text is limited to one line
                        .frame(maxWidth: .infinity) // Allow the text to take up the full width
                        .minimumScaleFactor(0.5) // Scale down the text if necessary to fit on one line
                    Spacer()
                }) {
                    TextField("Name", text: $entries[index].name)
                    
                    // Phone number TextField restricted to numbers
                    TextField("Phone", text: $entries[index].phone)
                        .keyboardType(.numberPad) // Only show number pad
                        .onChange(of: entries[index].phone) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                entries[index].phone = filtered
                            }
                        }
                    
                    TextField("Email", text: $entries[index].email)
                    
                    Picker("Gender", selection: $entries[index].gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Non Binary").tag("Non Binary")
                        Text("Other").tag("Other")
                    }
                    
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
                }
            }
        }
        .scrollContentBackground(.hidden) // Hides the default gray background
        .background(Color.clear) // Set the background to clear or any other color you want
    }
}


struct PersonalEntry {
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var gender: String = ""
    var dateOfBirth: String = ""
}

