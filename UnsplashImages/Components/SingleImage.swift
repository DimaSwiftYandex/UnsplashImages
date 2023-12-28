//
//  SingleImage.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 22.12.2023.
//

import UIKit

class SingleImage: UIImageView {

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
