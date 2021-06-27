//
//  CellRegisterable.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/9/21.
//

import UIKit

typealias ReusableViewRegisterable = CellRegisterable & ReusableViewType

protocol ReusableViewType {
    static var kind: String { get }
}

protocol CellRegisterable where Self: UIView {
    static var reuseID: String { get }
    static var nibID: String { get }
    static var nib: UINib { get }
}

extension CellRegisterable {
    static var reuseID: String {
        "\(Self.self)"
    }
    
    static var nibID: String {
        "\(Self.self)"
    }
    
    static var nib: UINib {
        UINib(nibName: nibID, bundle: nil)
    }
}
