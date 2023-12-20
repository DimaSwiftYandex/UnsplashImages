//
//  LogoutButton.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 19.12.2023.
//

import UIKit

class LogoutButton: UIButton {

    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.setImage(UIImage(named: "logoutButton"), for: .normal)
    }
}
