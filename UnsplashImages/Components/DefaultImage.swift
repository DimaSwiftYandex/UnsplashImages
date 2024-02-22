//
//  DefaultImage.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

enum DefaultImageStyle {
    case profilePhoto
    case unsplashImage
}

final class DefaultImage: UIImageView {

    init(style: DefaultImageStyle) {
        super.init(image: .none)
        commonInit(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(style: DefaultImageStyle) {
        switch style {
            
        case .profilePhoto:
            self.image = UIImage(named: "avatar")
            self.layer.cornerRadius = self.frame.width / 2
            self.clipsToBounds = true
            
        case .unsplashImage:
            self.image = UIImage(named: "unsplashLogo")
            self.clipsToBounds = true
        }
    }
}

