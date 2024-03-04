//
//  WebViewPresenterSpy.swift
//  UnsplashImagesTests
//
//  Created by Dmitry Dmitry on 28.2.2024.
//

import UnsplashImages
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
