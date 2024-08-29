//
//  SignupInformationView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/29/24.
//

import SwiftUI

struct SignupInformationView: View {
    @State private var step: Int = 0
    @State private var personalEntries: [PersonalEntry] = [PersonalEntry()]
    @State private var experienceEntries: [ExperienceEntry] = [ExperienceEntry()]
    @State private var loanEntries: [LoanEntry] = [LoanEntry()]
    @State private var educationEntries: [EducationEntry] = [EducationEntry()]
    @State private var projectEntries: [ProjectEntry] = [ProjectEntry()]
//    @State private var experienceEntries = []
//    @State private var loanEntries = []
//    @State private var educationEntries = []
//    @State private var projectEntries = []
    @State private var selectedInterests: [String] = []
    @State private var showBeaver: Bool = false
    @State private var isDonor: Bool = false
    
    // Step names for regular users
       let steps = ["Personal Information", "Experience", "Loans", "Interests", "Education", "Projects"]

       // Step names for donors
       let donorSteps = ["Personal Information", "Universities", "Interests", "Stipend Money"]

    
    var body: some View {
        VStack {
//            HeaderView(step: $step, isDonor: $isDonor)
            ProgressBar(step: $step, steps: isDonor ? donorSteps : steps)
            StepContentView(step: $step,
                            personalEntries: $personalEntries,
                            experienceEntries: $experienceEntries,
                            loanEntries: $loanEntries,
                            selectedInterests: $selectedInterests,
                            educationEntries: $educationEntries,
                            projectEntries: $projectEntries,
                            isDonor: $isDonor)
            ButtonContainerView(prevStep: prevStep, nextStep: nextStep)
        }
        .frame(maxWidth: 600)
        .padding(20)
//        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 8)
    }
    
    private func prevStep() {
        if step > 0 {
            step -= 1
        }
    }
    
    private func nextStep() {
        step += 1
    }
}

#Preview {
    SignupInformationView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
