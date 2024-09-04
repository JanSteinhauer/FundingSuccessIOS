import SwiftUI

struct EditableInterestsListView: View {
    @Binding var interests: [String]
    @State private var categoryInput: String = ""
    @State private var autocompleteSuggestions: [String] = []
    @State private var addedCategoryIndex: Int? = nil // Track which category was recently added

    let categories = [
        "Mathematics", "Physics", "Chemistry", "Biology", "Computer Science",
        "Engineering", "Medicine", "Art", "Music", "Dance",
        "Theater", "Literature", "History", "Philosophy", "Linguistics",
        "Psychology", "Sociology", "Political Science", "Economics", "Business",
        "Law", "Education", "Sports", "Athletics", "Gymnastics",
        "Swimming", "Tennis", "Basketball", "Football", "Baseball"
    ]

    let maxInterests = 5 // Maximum number of interests

    var body: some View {
        VStack(spacing: 20) {

            // Displaying the list of interests with delete button
            ForEach(interests.indices, id: \.self) { index in
                HStack {
                    Text(interests[index])
                        .padding(.leading, 10)
                    Spacer()
                    Button(action: {
                        interests.remove(at: index)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .padding(.trailing, 10)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
                // Highlight the recently added category
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: addedCategoryIndex == index ? 3 : 0)
                        .animation(.easeInOut(duration: 1), value: addedCategoryIndex == index)
                )
            }

            // Add Interest Button - only show if there are less than 5 interests
           

            // Input field and suggestions for adding interests
            if interests.count < maxInterests {
                TextField("Enter Interest", text: $categoryInput, onEditingChanged: { _ in
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
                                addInterest(interest: suggestion)
                            }
                    }
                    .frame(maxHeight: 150)
                }
            }
            
            if interests.count < maxInterests {
                Button(action: {
                    if interests.count < maxInterests {
                        interests.append("") // Add a new empty interest entry
                    }
                }) {
                    Text("Add Interest")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(fsblue) // Replace with your custom color
                        .cornerRadius(8)
                }
                .padding(.top)
            }
        }
        .padding()
    }

    // Helper functions for handling autocomplete suggestions
    private func updateSuggestions(query: String) {
        autocompleteSuggestions = query.isEmpty ? [] : categories.filter { $0.lowercased().contains(query.lowercased()) }
    }

    private func addInterest(interest: String) {
        if interests.count < maxInterests && !interests.contains(interest) {
            interests.append(interest)
            addedCategoryIndex = interests.count - 1 // Track the recently added category index
        }
        categoryInput = ""
        autocompleteSuggestions = []

        // Automatically clear the highlight after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            addedCategoryIndex = nil
        }
    }
}
