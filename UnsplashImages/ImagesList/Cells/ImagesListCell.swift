//
//  ImagesListCell.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.12.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
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
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
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
        return button
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        setupViews(subViews: unsplashImage, dateLabel, likeButton, dateLabelBackground)
        dateLabelBackground.addSubview(dateLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public functions
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = dateLabelBackground.bounds
    }
    
    func configCell(with imageName: String, index: Int) {
        guard let image = UIImage(named: imageName) else { return }
        unsplashImage.image = image
        
        let currentDate = dateFormatter.string(from: Date())
        dateLabel.text = currentDate
        
        setImageForLikeButton(index: index)
    }
    
    //MARK: - Public functions
    private func setImageForLikeButton(index: Int) {
        let likeButtonTapped = "Active"
        let likeButtonUntapped = "No Active"
        
        let chosenImageForLikeButton = index % 2 == 0 
        ? likeButtonTapped
        : likeButtonUntapped
        
        likeButton.setImage(UIImage(named: chosenImageForLikeButton), for: .normal)
    }
    
    
    //MARK: - Layout
    private func setupViews(subViews: UIView...) {
        subViews.forEach { subView in
            contentView.addSubview(subView)
        }
    }
    
    private func setupConstraints() {
        unsplashImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            unsplashImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            unsplashImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            unsplashImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            unsplashImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: unsplashImage.trailingAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: unsplashImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: unsplashImage.bottomAnchor, constant: -8),
            dateLabel.widthAnchor.constraint(equalToConstant: 152),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        dateLabelBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabelBackground.leadingAnchor.constraint(equalTo: unsplashImage.leadingAnchor, constant: 8),
            dateLabelBackground.bottomAnchor.constraint(equalTo: unsplashImage.bottomAnchor, constant: -8),
            dateLabelBackground.widthAnchor.constraint(equalToConstant: 152),
            dateLabelBackground.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: dateLabelBackground.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: dateLabelBackground.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: dateLabelBackground.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: dateLabelBackground.bottomAnchor)
        ])
    }
}


