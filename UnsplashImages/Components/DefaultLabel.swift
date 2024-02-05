//
//  DefaultLabel.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

enum DefaultLabelStyle {
    case dateLabelStyle
    case profileNameLabelStyle
    case userNameLabelStyle
    case descriptionLabelStyle
}

final class DefaultLabel: UILabel {

    init(style: DefaultLabelStyle) {
        super.init(frame: .zero)
        commonInit(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(style: DefaultLabelStyle) {
        switch style {
            
        case .dateLabelStyle:
            self.font = UIFont.systemFont(ofSize: 14)
            self.textColor = .ypWhite
            self.text = ""
        case .profileNameLabelStyle:
            self.font = UIFont.boldSystemFont(ofSize: 23)
            self.textColor = .ypWhite
        case .userNameLabelStyle:
            self.font = UIFont.systemFont(ofSize: 13)
            self.textColor = .ypGray
        case .descriptionLabelStyle:
            self.font = UIFont.systemFont(ofSize: 13)
            self.textColor = .ypWhite
        }
    }
}
