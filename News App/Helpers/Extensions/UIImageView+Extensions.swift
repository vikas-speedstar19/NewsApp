//
//  UIImageView+Extensions.swift
//  News App
//
//  Created by monty on 28/02/21.
//

import Foundation
import Kingfisher

extension UIImageView {

    func setImage(imageURL: URL?, placeholderImage: UIImage? = UIImage(named: "placeholderImage")) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: imageURL,
                         placeholder: placeholderImage,
                         options: [.transition(.fade(1)),
                                   .keepCurrentImageWhileLoading])
    }
    
}
