//
//  LogoutButton.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 19.12.2023.
//

import UIKit

enum DefaultButtonStyle {
    case logoutButtonStyle
    case backwardButtonStyle
}

class DefaultButton: UIButton {
    
    init(style: DefaultButtonStyle) {
        super.init(frame: .zero)
        commonInit(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(style: DefaultButtonStyle) {
        switch style {
            
        case .logoutButtonStyle:
            self.setImage(UIImage(named: "logoutButton"), for: .normal)
        case .backwardButtonStyle:
            self.setImage(UIImage(named: "backwardButton"), for: .normal)
        }
    }
}
