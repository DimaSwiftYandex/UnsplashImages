//
//  ImagesListCell.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?
    
    //MARK: - Static Properties
    static let reuseIdentifier = "ImagesListCell"
    
    //MARK: - Private Properties
    private lazy var dateLabelBackground: UIView = {
        let view = UIView()
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    private lazy var unsplashImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "like button off"
        button.setImage(UIImage(named: "LikeNo"), for: .normal)
        button.setImage(UIImage(named: "Like"), for: .selected)
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        unsplashImage.kf.cancelDownloadTask()
        unsplashImage.image = nil
    }
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        setupViewsAndConstraints()
        setupLikeButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public functions
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = dateLabelBackground.bounds
    }
    
    func configCell(with photo: Photo, index: Int) {
        let placeholder = UIImage(named: "stub")
        unsplashImage.kf.indicatorType = .activity
        if let url = URL(string: photo.thumbImageURL) {
            unsplashImage.kf.setImage(with: url, placeholder: placeholder)
        } else {
            unsplashImage.image = placeholder
        }
        
        let currentDate = dateFormatter.string(from: Date())
        dateLabel.text = currentDate
        
        let buttonImageName = photo.isLiked ? "Active" : "No Active"
        likeButton.isSelected = photo.isLiked
        
        if likeButton.isSelected == true {
            likeButton.accessibilityIdentifier = "like button on"
        } else {
            likeButton.accessibilityIdentifier = "like button off"
        }
        likeButton.setImage(UIImage(named: buttonImageName), for: .normal)
    }
    
    //MARK: - Private functions
    private func setupLikeButtonAction() {
        likeButton.addTarget(
            self,
            action: #selector(likeButtonClicked),
            for: .touchUpInside
        )
    }
    
    //MARK: - Event handler (Actions)
    @objc func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    //MARK: - Layout
    private func setupViewsAndConstraints() {
        [unsplashImage, likeButton, dateLabelBackground].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        dateLabelBackground.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            unsplashImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            unsplashImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            unsplashImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            unsplashImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            dateLabelBackground.leadingAnchor.constraint(equalTo: unsplashImage.leadingAnchor),
            dateLabelBackground.trailingAnchor.constraint(equalTo: unsplashImage.trailingAnchor),
            dateLabelBackground.bottomAnchor.constraint(equalTo: unsplashImage.bottomAnchor),
            dateLabelBackground.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.leadingAnchor.constraint(equalTo: dateLabelBackground.leadingAnchor, constant: 8),
            dateLabel.topAnchor.constraint(equalTo: dateLabelBackground.topAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: dateLabelBackground.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: dateLabelBackground.trailingAnchor, constant: -8)
        ])
    }
}
