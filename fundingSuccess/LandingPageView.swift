import SwiftUI

struct LandingPageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        VStack {
            FundingSuccessLogoSVGView()
            
            VStack(spacing: 20) {
                // First Text block
                Text("Donor")
                    .foregroundColor(deepBlue)
                    .font(.title2)
                + Text(", support and invest in students who have consistently demonstrated exceptional talent and expertise in their respective disciplines.")
                    .foregroundColor(mutedBlue)
                    .font(.title2)
                   
                
                
                // Second Text block
                Text("Students")
                    .foregroundColor(deepBlue)
                    .font(.title2)
                + Text(", access funds available to pay your student loans by showing and demonstrating your success.")
                    .foregroundColor(mutedBlue)
                    .font(.title2)
                   
                
                // Start Now Button
                Button(action: {
                    // Navigate to login view or other action
                }) {
                    Text("Start Now")
                        .font(.title2)
                        .padding()
                        .background(darkBlue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    LandingPageView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
