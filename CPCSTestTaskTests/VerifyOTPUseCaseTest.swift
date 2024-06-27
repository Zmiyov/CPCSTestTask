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
    
    var sut: VerifyOTPUseCaseProtocol!
    var cancellables: Set<AnyCancellable>!

    override func setUp()  {
        super.setUp()
        sut = MockVerifyOTPUseCase()
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }

    //MARK: - Resend button activation test
    func testResendButtonActivation() {
        let expectation = XCTestExpectation(description: "Resend button should be activated after timer ends")
        sut.startTimer()
        
        sut.timerExpired
            .sink { error in
                print(error)
            } receiveValue: { isActive in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 6.0)
    }

    //MARK: - Valid and Invalid state tests
    func testInvalidCodeState() {
        let wrongPass = "1234"
        
        let expectation = XCTestExpectation(description: "Checking invalid code state")
        sut.verified
            .sink { error in
                print(error)
            } receiveValue: { isVerified in
                if !isVerified {
                    expectation.fulfill()
                } else {
                    print("true")
                }
            }
            .store(in: &cancellables)
        
        sut.sendCodeVerifyingResult(code: wrongPass)
        
        wait(for: [expectation], timeout: 6.0)
    }
    
    func testValidCodeState() {
        let rightPass = "1111"
        
        let expectation = XCTestExpectation(description: "Checking valid code state")
        sut.verified
            .sink { error in
                print(error)
            } receiveValue: { isVerified in
                if isVerified {
                    expectation.fulfill()
                } else {
                    print("false")
                }
            }
            .store(in: &cancellables)
        sut.sendCodeVerifyingResult(code: rightPass)
        wait(for: [expectation], timeout: 6.0)
    }
    
    //MARK: - OTP verifying logic tests
    func testCodeIsValid() {
        let validPass = "1111"
        
        let result = sut.checkCode(code: validPass)
        XCTAssertTrue(result, "The password should be valid")
    }
    
    func testCodeIsInvalid() {
        let wrongPass = "1234"
        
        let result = sut.checkCode(code: wrongPass)
        XCTAssertFalse(result, "The password should be invalid")
    }
}
