//
//  StepContentView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/29/24.
//

import SwiftUI

struct StepContentView: View {
    @Binding var step: Int
    @Binding var personalEntries: [PersonalEntry]
    @Binding var experienceEntries: [ExperienceEntry]
    @Binding var loanEntries: [LoanEntry]
    @Binding var selectedInterests: [String]
    @Binding var educationEntries: [EducationEntry]
    @Binding var projectEntries: [ProjectEntry]
    @Binding var isDonor: Bool
    
    var body: some View {
        VStack {
            switch step {
            case 0:
                PersonalView(entries: $personalEntries)
            case 1:
                ExperienceView(experienceEntries: $experienceEntries)
//            case 2:
//                LoanView(entries: $loanEntries)
//            case 3:
//                InterestsView(selectedInterests: $selectedInterests)
//            case 4:
//                EducationView(entries: $educationEntries)
//            case 5:
//                ProjectView(entries: $projectEntries)
            default:
                Text("Invalid step")
            }
                
        }
        
    }
}

struct PersonalEntry {
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var gender: String = ""
    var dateOfBirth: String = ""
}

struct ExperienceEntry {
    var jobTitle: String = ""
    var company: String = ""
    var location: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var linkedin: String = ""
}

struct LoanEntry {
    var successfulAccomplishmentCategories: String = ""
    var studentLoanDueDate: String = ""
    var studentTotalLoanAmount: String = ""
}

struct EducationEntry {
    var university: String = ""
    var major: String = ""
    var gpa: String = ""
    var startDate: String = ""
    var endDate: String = ""
}

struct ProjectEntry {
    var name: String = ""
    var description: String = ""
    var contribution: String = ""
    var success: String = ""
    var benefit: String = ""
    var pictures: [UIImage] = []
}
