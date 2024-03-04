//
//  DefaultButton.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

enum DefaultButtonStyle {
    case logoutButtonStyle
    case backwardButtonStyle
    case sharingButtonStyle
    case firstLoginButtonStyle
    case backButtonStyle
}

final class DefaultButton: UIButton {
    
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
            self.accessibilityIdentifier = "logout button"
        case .backwardButtonStyle:
            self.setImage(UIImage(named: "backwardButton"), for: .normal)
            self.accessibilityIdentifier = "back button red"
        case .sharingButtonStyle:
            self.setImage(UIImage(named: "sharingButton"), for: .normal)
        case .firstLoginButtonStyle:
            self.setTitle("Login", for: .normal)
            self.setTitleColor(.ypBlack, for: .normal)
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            self.backgroundColor = .ypWhite
            self.layer.cornerRadius = 16
            self.accessibilityIdentifier = "Authenticate"
        case .backButtonStyle:
            self.setImage(UIImage(named: "backButton"), for: .normal)
        }
    }
}
