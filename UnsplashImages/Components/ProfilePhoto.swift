//
//  ProfilePhoto.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 19.12.2023.
//

import UIKit

class ProfilePhoto: UIImageView {

    init() {
        super.init(image: .none)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.image = UIImage(named: "avatar")
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
    
    }
}
