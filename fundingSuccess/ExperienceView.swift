//
//  ExperienceView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/29/24.
//

import SwiftUI

struct ExperienceView: View {
    @Binding var experienceEntries: [ExperienceEntry]
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
                        HStack {
                            TextField("Start Date (DD/MM/YYYY)", text: $experienceEntries[index].startDate)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(4)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                            
                            TextField("End Date (DD/MM/YYYY)", text: $experienceEntries[index].endDate)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(4)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                        }
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
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
}
