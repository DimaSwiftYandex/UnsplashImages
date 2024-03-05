//
//  ImagesListTests.swift
//  UnsplashImagesTests
//
//  Created by Dmitry Dmitry on 29.2.2024.
//

import Foundation
@testable import UnsplashImages

import XCTest

class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var imagesListview: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    
    var viewDidLoadCalled = false
    var fetchPhotosNextPageCalled = false
    var updateTableViewAnimatedCalled = false
    var imageListCellDidTapLikeCalled = false
    var indexPathForImageListCellDidTapLike: IndexPath?
    var fetchPhotosNextPageCompletion: (() -> Void)?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
        DispatchQueue.main.async {
            self.fetchPhotosNextPageCompletion?()
            self.updateTableViewAnimated()
        }
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
        imagesListview?.performTableViewUpdates(oldCount: 0, newCount: photos.count)
    }
    
    func imageListCellDidTapLike(at indexPath: IndexPath) {
        imageListCellDidTapLikeCalled = true
        indexPathForImageListCellDidTapLike = indexPath
    }
}

class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    var performTableViewUpdatesCalled = false
    var performTableViewUpdatesIndexPathsCalled = false
    
    func performTableViewUpdates(oldCount: Int, newCount: Int) {
        performTableViewUpdatesCalled = true
    }
    
    func performTableViewUpdates(indexPaths: [IndexPath]) {
        performTableViewUpdatesIndexPathsCalled = true
    }
}

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoadOnPresenter() {
        let presenterSpy = ImagesListPresenterSpy()
        let viewController = ImagesListViewController()
        viewController.presenter = presenterSpy
        
        viewController.viewDidLoad()
        
        XCTAssertTrue(presenterSpy.viewDidLoadCalled, "Expected viewDidLoad to be called on the presenter")
    }
    
    func testPresenterFetchesPhotosOnViewDidLoad() {
        let presenterSpy = ImagesListPresenterSpy()
        presenterSpy.viewDidLoad()
        
        XCTAssertTrue(presenterSpy.fetchPhotosNextPageCalled, "Expected fetchPhotosNextPage to be called on viewDidLoad")
    }
    
    func testPresenterCallsUpdateViewOnFetchCompletion() {
        let viewSpy = ImagesListViewControllerSpy()
        let presenterSpy = ImagesListPresenterSpy()
        presenterSpy.imagesListview = viewSpy
        
        let expectation = self.expectation(description: "Waiting for fetch to complete")
        presenterSpy.fetchPhotosNextPageCompletion = {
            expectation.fulfill()
        }
        
        presenterSpy.viewDidLoad()
        
        waitForExpectations(timeout: 5) { error in
            if error != nil {
                XCTFail("Fetch photos did not complete")
            }
        }
        
        XCTAssertTrue(viewSpy.performTableViewUpdatesCalled, "Expected performTableViewUpdates to be called on fetch completion")
    }
    
    func testPresenterHandlesLikeButtonTap() {
        let viewSpy = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        presenter.imagesListview = viewSpy
        
        presenter.imageListCellDidTapLike(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(presenter.imageListCellDidTapLikeCalled, "Expected imageListCellDidTapLike to be called on like button tap")
    }
}
