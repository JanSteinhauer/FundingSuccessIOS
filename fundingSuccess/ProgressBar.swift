//
//  ProgressBar.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/29/24.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var step: Int
    var steps: [String]
    
    var body: some View {
        HStack {
            Image("BeaverLogo") // Replace with your actual logo
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            ForEach(0..<steps.count) { index in
                ProgressStepView(step: $step, index: index, text: steps[index])
                if index < steps.count - 1 {
                    ProgressLine(active: step >= index + 1)
                }
            }
        }
    }
}

struct ProgressStepView: View {
    @Binding var step: Int
    var index: Int
    var text: String
    @State private var showToolTip: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Circle()
                    .fill(step >= index ? darkBlue : Color.gray)
                    .frame(width: 30, height: 30)
                    .overlay(Text("\(index + 1)").foregroundColor(.white))
                    .onTapGesture {
                        step = index
                        showToolTip.toggle()
                    }
                    .onHover { hovering in
                        showToolTip = hovering
                    }
            
            }
        }
    }
}

struct ProgressLine: View {
    var active: Bool
    
    var body: some View {
        Rectangle()
            .fill(active ? darkBlue : Color.gray)
            .frame(height: 5)
            .frame(maxWidth: .infinity)
    }
}

