//
//  OTPView.swift
//  CPCSTestTask
//
//  Created by Volodymyr Pysarenko on 26.06.2024.
//

import SwiftUI

struct OTPView: View {
    
    @StateObject var phoneViewModel = PhoneViewModel()
    
    var body: some View {
        VStack {
            
            Text("Verify your Email Address")
                .font(.title2)
                .fontWeight(.semibold)
            
            
            Text("Enter 4 digit code we'll text you on Email")
                .font(.caption)
                .fontWeight(.thin)
                .padding(.top)
            
            OTPTextFieldView(phoneViewModel: phoneViewModel)
                .padding()
            
            Button(action: {}, label: {
                Spacer()
                Text("Verify")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            })
            .padding(15)
            .background(Color.blue)
            .clipShape(Capsule())
            .padding()
        }
    }
}

#Preview {
    OTPView()
}
