//
//  GridImage.swift
//  Assignment2WibuApp
//
//  Created by Riza Adi Kurniawan on 14/02/24.
//

import SwiftUI

struct GridImage: View {
    @StateObject private var animeVM = AnimeViewModel()
    @State private var searchText: String = ""
    @State private var isShowingDialog = false
    @State private var indexAnime: Int = 0
    
    let colums: [GridItem] = [
        GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 10, alignment: .top)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: colums) {
                    ForEach(filteredAnimes(animes: animeVM.animes)) { anime in
                        VStack(alignment: .leading, spacing: 10) {
                            AsyncImage(url: URL(string: anime.image)) { phase in
                                switch phase {
                                    
                                case .empty :
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.pink)
                                    
                                case .success(let image):
                                    image.resizable().scaledToFill()
                                    
                                case .failure(_):
                                    Image(systemName: "photo.fill")
                                    
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text(anime.name)
                                .bold()
                                .lineLimit(2, reservesSpace: true)
                            
                            Text(anime.anime)
                                .lineLimit(1)
                        }
                        .frame(width: 100, height: 190)
                        .sheet(isPresented: $animeVM.showOptions) {
                            Group {
                                let defaultText = "You are about to share this items"
                                if let imageToShare = animeVM.imageToShare {
                                    ActivityView(activityItem: [defaultText, imageToShare])
                                } else {
                                    ActivityView(activityItem: [defaultText])
                                }
                            }
                            .presentationDetents([.medium, .large])
                            
                        }
                        .contextMenu {
                            Button {
                                Task {
                                    await animeVM.prepareImageAndShowSeet(from: anime.image)
                                }
                            } label: {
                                Label("Share", image: "square.and.arrow.up")
                            }
                            Button {
                                if let index = animeVM.animes.firstIndex(of: anime) {
                                    indexAnime = index
                                }
                                isShowingDialog = true
                            } label: {
                                Label("Delete", image: "trash")
                            }
                            
                        }
                        
                        .confirmationDialog("Are you sure you want to delete this item?",
                                            isPresented: $isShowingDialog,
                                            titleVisibility: .visible
                        ) {
                            Button("Yes, sure!", role: .destructive) {
                                animeVM.deleteAnime(indexAnime)
                                
                            }
                            Button("Cancel", role: .cancel) {
                                isShowingDialog = false
                            }
                        } message: {
                            Text("This action cannot be undone!")
                        }
                        
                    }
                }
            }
            .task {
                await animeVM.fetchAnimes()
            }
            .navigationTitle("Wibu")
            .searchable(text: $searchText, prompt: "e.g Yor Briar" )
            
        }
        
    }
    
    func filteredAnimes(animes: [Anime]) -> [Anime] {
        guard !searchText.isEmpty else {
            return animes
        }
        return animes.filter { anime in
            
            anime.name.lowercased().contains(searchText.lowercased()) ||
            anime.anime.lowercased().contains(searchText.lowercased())
        }
    }
}

#Preview {
    GridImage()
}
