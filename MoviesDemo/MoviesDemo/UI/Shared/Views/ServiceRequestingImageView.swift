//
//  ServiceRequestingImageView.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/9/21.
//

import UIKit

class ServiceRequestingImageView: UIImageView, NetworkServicing {

    var url: URL? {
        willSet {
            guard let url = newValue else { return }
            fetchAndSetImage(url)
        }
    }
    
    private func fetchAndSetImage(_ url: URL) {
        perform(URLRequest(url: url)) { [weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self?.image = image
            case .failure(let error):
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
}
