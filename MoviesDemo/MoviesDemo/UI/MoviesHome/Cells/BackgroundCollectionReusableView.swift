//
//  BackgroundCollectionReusableView.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/10/21.
//

import UIKit

class BackgroundCollectionReusableView: UICollectionReusableView, ReusableViewRegisterable {
    static var kind: String = "Background"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .secondarySystemFill
    }
}
