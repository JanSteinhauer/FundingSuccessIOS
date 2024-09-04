//
//  EditableLoanListView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 9/4/24.
//

import SwiftUI

struct EditableLoanListView: View {
    @Binding var loans: [LoanEntry]
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(loans.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Loan Amount", text: Binding(
                        get: { loans[index].studentTotalLoanAmount },
                        set: { loans[index].studentTotalLoanAmount = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Due Date", text: Binding(
                        get: { loans[index].studentLoanDueDate },
                        set: { loans[index].studentLoanDueDate = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

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
