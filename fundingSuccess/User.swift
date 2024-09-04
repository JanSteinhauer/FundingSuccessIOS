//
//  User.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/30/24.
//

import Foundation
import FirebaseFirestore


struct User: Identifiable, Codable {
    @DocumentID var id: String? // Automatically maps the Firestore document ID
    var name: String
    var email: String
    var profilePictureURL: String?
    var currentStreak: Int?
    
    var education: [Education]?
    var educationData: [Education]?
    
    var experience: [Experience]?
    var experienceData: [Experience]?
    
    var interests: [String]?
    
    var isDonor: Int?
    var lastLoginDate: Date?
    
    var loanData: [Loan]?
    var loans: [Loan]?
    
    var successfulAccomplishmentCategories: [String]?
    
    var matches: [String]?
    var mobile: String?
    
    var personalData: [PersonalData]?
    
    var projectData: [Project]?
    var projects: [Project]?
    
    var rightSwipes: [String]?
    var score: Int?
    var sign_up_step_completed: Int?
}

// Supporting Structures

struct Education: Codable {
    var endDate: String?
    var gpa: String?
    var major: String?
    var startDate: String?
    var university: String?
}

struct Experience: Codable {
    var company: String?
    var endDate: String?
    var jobTitle: String?
    var linkedin: String?
    var location: String?
    var startDate: String?
}

struct Loan: Codable {
    var studentLoanDueDate: String?
    var studentTotalLoanAmount: String?
}

struct PersonalData: Codable {
    var dateOfBirth: String?
    var email: String?
    var gender: String?
    var name: String?
    var phone: String?
}

struct Project: Codable {
    var benefit: String?
    var contribution: String?
    var description: String?
    var name: String?
    var success: String?
    var pictures: [ProjectPicture]?
}

struct ProjectPicture: Codable {
    var name: String?
    var url: String?
}

