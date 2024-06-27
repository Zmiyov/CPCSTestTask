//
//  TakeCodeServiceProtocol.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import Foundation

protocol TakeCodeServiceProtocol {
    var code: String { get }
    var refreshTime: Int { get }
    
    func fetchOtpCode(codeServiceModel: CodeServiceModel)
}
