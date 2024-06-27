//
//  DefaultVerifyOTPUseCase.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import Foundation
import Combine

final class DefaultVerifyOTPUseCase: VerifyOTPUseCaseProtocol {
    
    private var timer: AnyCancellable?
    private let takeCodeService: TakeCodeServiceProtocol
    
    var timeRemaining: CurrentValueSubject<Int, Error>
    var timerExpired = CurrentValueSubject<Bool, Error>(false)
    var verified = PassthroughSubject<Bool, Error>()
    
    init(takeCodeService: TakeCodeServiceProtocol) {
        self.takeCodeService = takeCodeService
        self.timeRemaining = CurrentValueSubject<Int, Error>(takeCodeService.refreshTime)
        startTimer()
    }
    
    func sendCodeVerifyingResult(code: String) {
        let verificationResult = checkCode(code: code)
        verified.send(verificationResult)
    }
    
    func checkCode(code: String) -> Bool {
        let storedCode = takeCodeService.code
        return code == storedCode
    }
    
    func startTimer() {
        timerExpired.send(false)
        timeRemaining.send(takeCodeService.refreshTime)
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.countDownString()
            }
    }
    
    private func stopTimer() {
        timerExpired.send(true)
        self.timer?.cancel()
    }
    
    private func countDownString() {
        guard (timeRemaining.value > 0) else {
            stopTimer()
            return
        }
        
        timeRemaining.send(timeRemaining.value - 1)
    }
}
