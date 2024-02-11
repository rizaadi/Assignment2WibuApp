//
//  AnimeViewModel.swift
//  Assignment2WibuApp
//
//  Created by Riza Adi Kurniawan on 11/02/24.
//

import Foundation
import UIKit

class AnimeViewModel: ObservableObject {
    @Published var animes: [Anime] = []
    @Published var imageToShare: UIImage?
    @Published var showOptions: Bool = false
    
    func fetchAnimes() async {
        do {
            let loadedAnimes = try await loadAnime()
            self.animes = loadedAnimes
        } catch {
            print(error)
        }
    }
    
    private func loadAnime() async throws -> [Anime] {
        guard let animeUrl = URL(string: "https://waifu-generator.vercel.app/api/v1") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: animeUrl)
        
        let animes = try JSONDecoder().decode([Anime].self, from: data)
        return animes;
    }
    
    func prepareImageAndShowSeet(from urlString: String) async {
        imageToShare = await downloadImage(from: urlString)
        showOptions = true
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else {return nil}
        
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("ERROR downloading image \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteAnime(_ index: Int)  {
        animes.remove(at: index)
    }
}
