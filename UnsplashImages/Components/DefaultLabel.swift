//
//  DefaultLabel.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 19.12.2023.
//

import UIKit

enum DefaultLabelStyle {
    case dateLabelStule
    case profileNameLabelStyle
    case userNameLabelStyle
    case descriptionLabelStyle
}

class DefaultLabel: UILabel {

    init(style: DefaultLabelStyle) {
        super.init(frame: .zero)
        commonInit(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(style: DefaultLabelStyle) {
        switch style {
            
        case .dateLabelStule:
            self.font = UIFont.systemFont(ofSize: 14)
            self.textColor = .ypWhite
            self.text = ""
        case .profileNameLabelStyle:
            self.font = UIFont.boldSystemFont(ofSize: 23)
            self.textColor = .ypWhite
            self.text = "Екатерина Новикова"
        case .userNameLabelStyle:
            self.font = UIFont.systemFont(ofSize: 13)
            self.textColor = .ypGray
            self.text = "@ekaterina_nov"
        case .descriptionLabelStyle:
            self.font = UIFont.systemFont(ofSize: 13)
            self.textColor = .ypWhite
            self.text = "Hello, world!"
        }
    }
}
