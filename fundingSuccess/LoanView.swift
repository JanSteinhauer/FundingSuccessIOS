import SwiftUI

struct LoanView: View {
    @Binding var loanEntries: [LoanEntry]
    @State private var categoryInputs: [String] = []
    @State private var autocompleteSuggestions: [String] = []
    
    let categories = [
        "Mathematics", "Physics", "Chemistry", "Biology", "Computer Science",
        "Engineering", "Medicine", "Art", "Music", "Dance",
        "Theater", "Literature", "History", "Philosophy", "Linguistics",
        "Psychology", "Sociology", "Political Science", "Economics", "Business",
        "Law", "Education", "Sports", "Athletics", "Gymnastics",
        "Swimming", "Tennis", "Basketball", "Football", "Baseball"
    ]
    
    let fsblue = Color(hex: "#003366") // Replace with your custom color if necessary
    
    var body: some View {
        Form {
            Section(header: HStack {
                Spacer()
                Text("Loans")
                    .foregroundColor(fsblue)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .minimumScaleFactor(0.5)
                Spacer()
            }) {
            ForEach(loanEntries.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 10) {
                    if loanEntries.count > 1 {
                        // Divider
                        Divider()
                    }
                    
                    // Successful Accomplishment Categories
                    VStack(alignment: .leading, spacing: 10) {
                        
                        TextField("Enter Category", text: Binding(
                            get: { categoryInputs.indices.contains(index) ? categoryInputs[index] : "" },
                            set: { newValue in
                                if categoryInputs.indices.contains(index) {
                                    categoryInputs[index] = newValue
                                } else {
                                    categoryInputs.append(newValue)
                                }
                                updateSuggestions(query: newValue)
                            }
                        ))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                        
                        if !autocompleteSuggestions.isEmpty {
                            List(autocompleteSuggestions, id: \.self) { suggestion in
                                Text(suggestion)
                                    .onTapGesture {
                                        addCategory(index: index, category: suggestion)
                                    }
                            }
                            .frame(maxHeight: 150)
                        }
                        
                        HStack {
                            ForEach(loanEntries[index].successfulAccomplishmentCategories, id: \.self) { category in
                                HStack {
                                    Text(category)
                                    Image(systemName: "xmark.circle.fill")
                                        .onTapGesture {
                                            removeCategory(index: index, category: category)
                                        }
                                }
                                .padding(5)
                                .background(fsblue)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                            }
                        }
                    }
                    
                    // Student Loan Due Date
                    VStack(alignment: .leading, spacing: 10) {
                        
                        DatePicker("Enter Due Date", selection: Binding(
                            get: { DateFormatter().date(from: loanEntries[index].studentLoanDueDate) ?? Date() },
                            set: { newDate in
                                loanEntries[index].studentLoanDueDate = DateFormatter().string(from: newDate)
                            }
                        ), displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                    }
                    
                    // Student Total Loan Amount
                    VStack(alignment: .leading, spacing: 10) {
                        
                        
                        TextField("Enter Amount", text: Binding(
                            get: { loanEntries[index].studentTotalLoanAmount },
                            set: { newValue in loanEntries[index].studentTotalLoanAmount = newValue }
                        ))
                        .keyboardType(.numberPad)
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
                loanEntries.append(LoanEntry(successfulAccomplishmentCategories: [], studentLoanDueDate: "", studentTotalLoanAmount: ""))
                categoryInputs.append("")
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
    
    // Helper functions to manage suggestions and categories
    private func updateSuggestions(query: String) {
        autocompleteSuggestions = query.isEmpty ? [] : categories.filter { $0.lowercased().contains(query.lowercased()) }
    }
    
    private func addCategory(index: Int, category: String) {
        if loanEntries[index].successfulAccomplishmentCategories.count < 3 &&
            !loanEntries[index].successfulAccomplishmentCategories.contains(category) {
            loanEntries[index].successfulAccomplishmentCategories.append(category)
        }
        categoryInputs[index] = ""
        autocompleteSuggestions = []
    }
    
    private func removeCategory(index: Int, category: String) {
        loanEntries[index].successfulAccomplishmentCategories.removeAll { $0 == category }
    }
}
