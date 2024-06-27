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
        cancellables = nil
        super.tearDown()
    }

    //MARK: - Resend button activation test
    func testResendButtonActivation() {
        let expectation = XCTestExpectation(description: "Resend button should be activated after timer ends")
        viewModel.verifyOTPUseCase.startTimer()
        
        viewModel.$timerExpired
            .sink { isActive in
                if isActive == true {
                    expectation.fulfill()
                } else {
                    print("Resend is not active")
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 6.0)
    }

    //MARK: - Valid and Invalid state tests
    func testInvalidCodeState() {
        let wrongPass = "1234"
        
        let expectation = XCTestExpectation(description: "Checking of OTP code")
        viewModel.verifyOTPUseCase.sendCodeVerifyingResult(code: wrongPass)
        viewModel.$codeIsVerified
            .sink { isVerified in
                if isVerified == false {
                    expectation.fulfill()
                } else {
                    print("true")
                }
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 6.0)
    }
    
    func testValidCodeState() {
        let rightPass = "1111"
        
        let expectation = XCTestExpectation(description: "Checking of OTP code")
        viewModel.verifyOTPUseCase.sendCodeVerifyingResult(code: rightPass)
        viewModel.$codeIsVerified
            .sink { isVerified in
                if isVerified == true {
                    expectation.fulfill()
                } else {
                    print("false")
                }
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 6.0)
    }
    
    //MARK: - OTP verifying logic tests
    func testCodeIsValid() {
        let validPass = "1111"
        
        let result = viewModel.verifyOTPUseCase.checkCode(code: validPass)
        XCTAssertTrue(result, "The password should be valid")
    }
    
    func testCodeIsInvalid() {
        let wrongPass = "1234"
        
        let result = viewModel.verifyOTPUseCase.checkCode(code: wrongPass)
        XCTAssertFalse(result, "The password should be invalid")
    }
}
