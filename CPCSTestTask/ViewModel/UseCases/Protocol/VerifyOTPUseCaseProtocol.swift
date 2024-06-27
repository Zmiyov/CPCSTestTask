//
//  VerifyOTPUseCaseProtocol.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 27.06.2024.
//

import Foundation
import Combine

protocol VerifyOTPUseCaseProtocol {
    var timeRemaining: CurrentValueSubject<Int, Error> { get set }
    var timerExpired: CurrentValueSubject<Bool, Error> { get set }
    var verified: PassthroughSubject<Bool, Error> { get set }
    
    func sendCodeVerifyingResult(code: String) -> Void
    func checkCode(code: String) -> Bool
    func startTimer() -> Void
}
