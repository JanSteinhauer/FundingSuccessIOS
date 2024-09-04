//
//  EditableProjectsListView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/4/24.
//

import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

struct EditableProjectsListView: View {
    @Binding var projects: [ProjectEntry]
    @State private var newProjectImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var uploadInProgress = false // To show progress indicator
    @State private var currentProjectIndex: Int? // Track the index of the project being edited

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

                    // Display project images
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

                    // Button to add a new project image
                    Button(action: {
                        currentProjectIndex = index // Set the current project index
                        isShowingImagePicker = true
                    }) {
                        Text("Add Project Image")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(fsblue)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                        if let image = newProjectImage, let currentProjectIndex = currentProjectIndex {
                            uploadImageToFirebase(image: image, for: currentProjectIndex)
                        }
                    }, content: {
                        ImagePicker(selectedImage: $newProjectImage)
                    })

                    // Show loading spinner while image is uploading
                    if uploadInProgress {
                        ProgressView("Uploading image...")
                    }

                    // Button to remove the project
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
            
            // Button to add a new project
            Button(action: {
                projects.append(ProjectEntry()) // Add a new empty project entry
                currentProjectIndex = projects.count - 1 // Set the current project to the new project
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
    
    // Function to upload image to Firebase and save URL to the project
    func uploadImageToFirebase(image: UIImage, for projectIndex: Int) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        uploadInProgress = true
        
        // Create a reference to Firebase Storage
        let storageRef = Storage.storage().reference().child("projectImages/\(UUID().uuidString).jpg")
        
        // Upload the image data
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let _ = metadata, error == nil else {
                print("Error uploading image: \(String(describing: error?.localizedDescription))")
                uploadInProgress = false
                return
            }
            
            // Get the download URL
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(String(describing: error?.localizedDescription))")
                    uploadInProgress = false
                    return
                }
                
                // Update the project with the new image URL
                projects[projectIndex].pictures.append(downloadURL.absoluteString)
                uploadInProgress = false
            }
        }
    }
}
