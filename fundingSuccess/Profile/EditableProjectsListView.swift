//
//  EditableProjectsListView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/4/24.
//

import SwiftUI

struct EditableProjectsListView: View {
    @Binding var projects: [ProjectEntry]
    
    var body: some View {
        VStack(spacing: 20) {
        
            ForEach(projects.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Project Name", text: Binding(
                        get: { projects[index].name },
                        set: { projects[index].name = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Description", text: Binding(
                        get: { projects[index].description },
                        set: { projects[index].description = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Contribution", text: Binding(
                        get: { projects[index].contribution },
                        set: { projects[index].contribution = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Display images for this project
                    Text("Project Images")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(projects[index].pictures, id: \.self) { imageUrl in
                                if let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(5)
                                    } placeholder: {
                                        ProgressView() // Placeholder while image is loading
                                    }
                                } else {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.red)
                                        .padding(5)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        projects.remove(at: index)
                    }) {
                        Text("Remove Project")
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
                projects.append(ProjectEntry()) // Add a new empty project entry
            }) {
                Text("Add Project")
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
