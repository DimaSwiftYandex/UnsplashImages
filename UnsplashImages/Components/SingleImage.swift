//
//  SingleImage.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

final class SingleImage: UIImageView {

    init() {
        super.init(image: .none)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.contentMode = .scaleAspectFit
    }
}

