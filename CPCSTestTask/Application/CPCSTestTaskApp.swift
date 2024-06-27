//
//  CPCSTestTaskApp.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import SwiftUI

@main
struct CPCSTestTaskApp: App {
    @StateObject var otpDataViewModel = OTPDataViewModel(verifyOTPUseCase: DefaultVerifyOTPUseCase(takeCodeService: MockTakeCodeService()))
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(otpDataViewModel)
        }
    }
}
