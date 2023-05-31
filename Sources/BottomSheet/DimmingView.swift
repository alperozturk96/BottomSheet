//
//  DimmingView.swift
//
//
//  Created by Alper Ozturk on 3.5.23..
//

import SwiftUI

struct DimmingView: View {
    
    let action: () -> ()
    let opacity: Double
    
    public init(opacity: Double = 0.4, _ action: @escaping () -> () = {}) {
        self.opacity = opacity
        self.action = action
    }
    
    public var body: some View {
        VStack { }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.gray.opacity(opacity)
                    .edgesIgnoringSafeArea(.all)
            )
            .onTapGesture {
                action()
            }
    }
}

struct DimmingView_Previews: PreviewProvider {
    static var previews: some View {
        DimmingView()
    }
}
