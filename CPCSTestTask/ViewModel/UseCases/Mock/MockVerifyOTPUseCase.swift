//
//  MockVerifyOTPUseCase.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import Foundation
import Combine

class MockVerifyOTPUseCase: VerifyOTPUseCase {
    
    let takeCodeService = MockTakeCodeService()
    
    var timeRemaining = CurrentValueSubject<Int, Error>(5)
    var timerExpired = CurrentValueSubject<Bool, Error>(false)
    var verified = PassthroughSubject<Bool, Error>()
    
    func verifyCode(code: String) {
        let storedCode = takeCodeService.code
        let verificationResult = code == storedCode
        verified.send(verificationResult)
    }
    
    func startTimer() {
        
        timerExpired.send(true)
    }

}
