//
//  SplashView.swift
//  sirichain-ios
//
//  Created by mgarciate on 16/11/24.
//

import SwiftUI

struct SplashView: View {
    @State private var circleIsHiden = true
    @State private var isMainViewPresented = false
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
                .opacity(circleIsHiden ? 0 : 1)
        }
        .fullScreenCover(isPresented: $isMainViewPresented) {
            MainView()
        }
        .onAppear() {
            withAnimation(.easeInOut(duration: 1.5)) {
                circleIsHiden.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isMainViewPresented.toggle()
            }
        }
    }
}

#Preview {
    SplashView()
}
