//
//  ExperienceView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/29/24.
//

import SwiftUI

struct ExperienceView: View {
    @Binding var experienceEntries: [ExperienceEntry]
    @State private var linkedInURL: String = ""
    let fsblue = Color(hex: "#003366") // Replace with your custom color if necessary
    
    var body: some View {
        Form {
            Section(header: HStack {
                Spacer()
                Text("Job Experience")
                    .foregroundColor(fsblue)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .minimumScaleFactor(0.5)
                Spacer()
            }) {
                ForEach(experienceEntries.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        if experienceEntries.count > 1 {
                            // Delete Button
                            HStack {
                                Spacer()
                                Button(action: {
                                    experienceEntries.remove(at: index)
                                }) {
                                    Text("Delete")
                                        .foregroundColor(.red)
                                        .padding(5)
                                        .background(Color.red.opacity(0.2))
                                        .cornerRadius(5)
                                }
                            }
                        }
                        
                        // Job Title
                        TextField("Job Title", text: $experienceEntries[index].jobTitle)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                        
                        // Company
                        TextField("Company", text: $experienceEntries[index].company)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                        
                        // Location
                        TextField("Location", text: $experienceEntries[index].location)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                        
                        // Start Date and End Date
                        DatePicker("Start Date", selection: Binding(
                            get: {
                                experienceEntries[index].startDate.isEmpty ? Date() : DateFormatter().date(from: experienceEntries[index].startDate) ?? Date()
                            },
                            set: { newDate in
                                experienceEntries[index].startDate = DateFormatter().string(from: newDate)
                            }
                        ), displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                        
                        DatePicker("End Date", selection: Binding(
                            get: {
                                experienceEntries[index].endDate.isEmpty ? Date() : DateFormatter().date(from: experienceEntries[index].endDate) ?? Date()
                            },
                            set: { newDate in
                                experienceEntries[index].endDate = DateFormatter().string(from: newDate)
                            }
                        ), displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                        
                    }
                    .padding(.vertical)
                    
                }
                
                // Add More Button
                Button(action: {
                    experienceEntries.append(ExperienceEntry(jobTitle: "", company: "", location: "", startDate: "", endDate: ""))
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .foregroundColor(fsblue)
                        Text("Add More")
                            .font(.subheadline)
                            .foregroundColor(fsblue)
                    }
                    .padding()
                    .background(Color(hex: "#e7f5fe"))
                    .cornerRadius(4)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // LinkedIn URL Field
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("LinkedIn Profile")
                        .foregroundColor(fsblue)
                        .font(.headline)
                    
                    TextField("LinkedIn URL", text: $linkedInURL)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                }
                .padding(.vertical)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
}
