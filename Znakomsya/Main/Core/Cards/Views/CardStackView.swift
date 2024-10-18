import SwiftUI

struct CardStackView: View {
    @EnvironmentObject var matchManager: MatchManager
    
    @State private var showMatchView = false
    
    @StateObject var viewModel = CardsViewModel(service: CardService())
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16) {
                    Image("baritem")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 140)
                        .padding(.top, -50)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    

                    ZStack {
                        ForEach(viewModel.cardModels) { card in
                            CardView(viewModel: viewModel, model: card)
                                .padding(.top, -50)
                        }
                    }
                    
                    if !viewModel.cardModels.isEmpty {
                        SwipeActionButtonsView(viewModel: viewModel)
                    }
                }
                .blur(radius: showMatchView ? 20 : 0)
                
                if showMatchView {
                    UserMatchView(show: $showMatchView)
                }
            }
            .animation(.easeInOut, value: showMatchView)
            .onReceive(matchManager.$matchedUser) { user in
                showMatchView = user != nil
            }
        }
    }
}

#Preview {
    CardStackView()
        .environmentObject(MatchManager())
}
