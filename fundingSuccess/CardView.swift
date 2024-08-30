//
//  CardView.swift
//  fundingSuccess
//
//  Created by Steinhauer, Jan on 8/30/24.
//

import SwiftUI

struct CardView: View, Identifiable {
    let id = UUID()
    let image: String
    let title: String
    
    @State private var loadedImage: UIImage? = nil
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 15)
            
            if let loadedImage = loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                // Placeholder for loading image
            }
        }
        .onAppear {
            loadImageAsync(from: image)
        }
        .overlay(alignment: .bottom) {
            VStack {
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(5)
            }
            .padding([.bottom], 20)
        }
    }
    
    func loadImageAsync(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.loadedImage = image
                }
            } else {
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
}

#Preview {
    CardView(image: "https://firebasestorage.googleapis.com/v0/b/studentevaluation-9d972.appspot.com/o/profilePictures%2F3ekNmd1KN9g6TmW754cngrJqevA3?alt=media&token=03991bd4-091a-4c27-954c-9aa45857c2d6", title: "Hong Kong")
}
