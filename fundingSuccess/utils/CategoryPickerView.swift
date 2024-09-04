//
//  CategoryPickerView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/4/24.
//

import SwiftUI

struct CategoryPickerView: View {
    @Binding var selectedCategories: [String]
    @State private var categoryInput: String = ""
    @State private var autocompleteSuggestions: [String] = []

    let categories = [
        "Mathematics", "Physics", "Chemistry", "Biology", "Computer Science",
        "Engineering", "Medicine", "Art", "Music", "Dance",
        "Theater", "Literature", "History", "Philosophy", "Linguistics",
        "Psychology", "Sociology", "Political Science", "Economics", "Business",
        "Law", "Education", "Sports", "Athletics", "Gymnastics",
        "Swimming", "Tennis", "Basketball", "Football", "Baseball"
    ]
    
    let maxCategories = 5 // Set the maximum number of categories
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if selectedCategories.count < maxCategories {
                TextField("Enter Category", text: $categoryInput, onEditingChanged: { _ in
                    updateSuggestions(query: categoryInput)
                })
                .padding()
                .background(Color.white)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                
                if !autocompleteSuggestions.isEmpty {
                    List(autocompleteSuggestions, id: \.self) { suggestion in
                        Text(suggestion)
                            .onTapGesture {
                                addCategory(category: suggestion)
                            }
                    }
                    .frame(maxHeight: 150)
                }
            } else {
                Text("You can add up to \(maxCategories) categories.")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            HStack {
                ForEach(selectedCategories, id: \.self) { category in
                    HStack {
                        Text(category)
                        Image(systemName: "xmark.circle.fill")
                            .onTapGesture {
                                removeCategory(category: category)
                            }
                    }
                    .padding(5)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.black)
                    .cornerRadius(4)
                }
            }
        }
    }
    
    // Helper functions
    private func updateSuggestions(query: String) {
        autocompleteSuggestions = query.isEmpty ? [] : categories.filter { $0.lowercased().contains(query.lowercased()) }
    }
    
    private func addCategory(category: String) {
        if selectedCategories.count < maxCategories && !selectedCategories.contains(category) {
            selectedCategories.append(category)
        }
        categoryInput = ""
        autocompleteSuggestions = []
    }
    
    private func removeCategory(category: String) {
        selectedCategories.removeAll { $0 == category }
    }
}
