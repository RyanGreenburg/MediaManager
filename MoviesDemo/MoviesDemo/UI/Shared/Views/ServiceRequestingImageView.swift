//
//  ServiceRequestingImageView.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/9/21.
//

import UIKit

@MainActor
class ServiceRequestingImageView: UIImageView, NetworkServicing {

    var url: URL? {
        willSet {
            guard let url = newValue else { return }
            Task.detached(priority: .high) {
                await self.fetchAndSetImage(url)
            }
        }
    }
    
    private func fetchAndSetImage(_ url: URL) async {
        do {
            let data = try await perform(URLRequest(url: url))
            self.image = UIImage(data: data)
        } catch {
            print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
        }
    }
}
