//
//  MockVerifyOTPUseCase.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import Foundation
import Combine

final class MockVerifyOTPUseCase: VerifyOTPUseCaseProtocol {
    
    let takeCodeService = MockTakeCodeService()
    
    var timeRemaining = CurrentValueSubject<Int, Error>(5)
    var timerExpired = CurrentValueSubject<Bool, Error>(false)
    var verified = PassthroughSubject<Bool, Error>()
    
    func sendCodeVerifyingResult(code: String) {
        let verificationResult = checkCode(code: code)
        verified.send(verificationResult)
    }
    
    func checkCode(code: String) -> Bool {
        let storedCode = takeCodeService.code
        return code == storedCode
    }
    
    func startTimer() {
        timerExpired.send(true)
    }

}
