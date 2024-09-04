//
//  EditableLoanListView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/4/24.
//

import SwiftUI

struct EditableLoanListView: View {
    @Binding var loans: [LoanEntry]
    
    // DateFormatter to format dates as dd/MM/yyyy
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(loans.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    // Loan Amount
                    TextField("Loan Amount", text: Binding(
                        get: { loans[index].studentTotalLoanAmount },
                        set: { loans[index].studentTotalLoanAmount = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    // DatePicker for Loan Due Date
                    DatePicker("Due Date", selection: Binding(
                        get: {
                            // Convert the string date to Date object
                            dateFormatter.date(from: loans[index].studentLoanDueDate) ?? Date()
                        },
                        set: { newDate in
                            // Format the selected Date to string in dd/MM/yyyy format
                            loans[index].studentLoanDueDate = dateFormatter.string(from: newDate)
                        }
                    ), displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())

                    // Use the reusable CategoryPickerView
                    CategoryPickerView(selectedCategories: $loans[index].successfulAccomplishmentCategories)

                    // Button to remove a loan entry
                    Button(action: {
                        loans.remove(at: index)
                    }) {
                        Text("Remove Loan")
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
            
            // Button to add a new loan entry
            Button(action: {
                loans.append(LoanEntry()) // Add a new empty loan entry
            }) {
                Text("Add Loan")
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
