//
//  WiproWeatherTests.swift
//  WiproWeatherTests
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import XCTest

@testable import WiproWeather

class WiproWeatherTests: XCTestCase {
    
    var sut: ViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storybooard = UIStoryboard.init(name: "Main", bundle: nil)
        sut = storybooard.instantiateViewController(withIdentifier: "mainVC") as! ViewController
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMainVC_CollectionViewShouldNotBeNil() {
        XCTAssertNotNil(sut.collectionView)
    }
    
    func testViewDidLoad_SetsCollectionViewDataSource() {
        XCTAssertNotNil(sut.collectionView.dataSource)
        XCTAssertTrue(sut.collectionView.dataSource is WheatherDataService)
        
    }
    
    func testViewDidLoad_SetsCollectionViewDelegate() {
        XCTAssertNotNil(sut.collectionView.delegate)
        XCTAssertTrue(sut.collectionView.delegate is WheatherDataService)
    }
    
    func testViewDidLoad_SetsCollectionViewDelegateAndDataSourceSameObject() {
        XCTAssertEqual(sut.collectionView.delegate as! WheatherDataService, sut.collectionView.dataSource as! WheatherDataService)
    }
    
    
    
}
