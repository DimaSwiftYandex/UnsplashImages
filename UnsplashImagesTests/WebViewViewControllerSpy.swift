//
//  WebViewViewControllerSpy.swift
//  UnsplashImagesTests
//
//  Created by Dmitry Dmitry on 28.2.2024.
//

import UnsplashImages
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenter: UnsplashImages.WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}
