//
//  ContentView.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        OTPView()
    }
}

#Preview {
    ContentView()
        .environmentObject(OTPDataViewModel(verifyOTPUseCase: DefaultVerifyOTPUseCase(takeCodeService: MockTakeCodeService())))
}
