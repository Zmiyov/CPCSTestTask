//
//  MockTakeCodeService.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import Foundation

class MockTakeCodeService: TakeCodeServiceProtocol {
    
    var code: String = ""
    var refreshTime: Int = 60
    
    init() {
        fetchOtpCode(codeServiceModel: mockCodeServiceModel)
    }
    
    func fetchOtpCode(codeServiceModel: CodeServiceModel) {
        code = codeServiceModel.code
        refreshTime = codeServiceModel.refreshTime
    }
}
