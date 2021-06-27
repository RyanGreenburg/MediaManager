//
//  HeaderCollectionReusableView.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/10/21.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView, ReusableViewRegisterable {
    static var kind: String = "Header"
    @IBOutlet weak var titleLabel: UILabel!
    
    func setTitle(_ string: String) {
        titleLabel.text = string
    }
}
