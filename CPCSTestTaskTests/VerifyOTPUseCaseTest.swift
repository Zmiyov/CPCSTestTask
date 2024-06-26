//
//  VerifyOTPUseCaseTest.swift
//  CPCSTestTaskTests
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import XCTest
import Combine
@testable import CPCSTestTask

final class VerifyOTPUseCaseTest: XCTestCase {
    
    var viewModel: OTPDataViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp()  {
        super.setUp()
        viewModel = OTPDataViewModel(verifyOTPUseCase: MockVerifyOTPUseCase())
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testResendButtonActivation() {
        let expectation = XCTestExpectation(description: "Button should be activated after timer ends")
        viewModel.verifyOTPUseCase.startTimer()
        
        viewModel.$timerExpired
            .sink { isActive in
                if isActive {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 6.0)
    }

    func testCodeChecking() {
        
        
    }
}
