//
//  VerifyOTPUseCaseProtocol.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 27.06.2024.
//

import Foundation
import Combine

protocol VerifyOTPUseCaseProtocol {
    var timeRemaining: CurrentValueSubject<Int, Error> { get }
    var timerExpired: CurrentValueSubject<Bool, Error> { get }
    var verified: PassthroughSubject<Bool, Error> { get }
    
    func sendCodeVerifyingResult(code: String)
    func checkCode(code: String) -> Bool
    func startTimer()
}
