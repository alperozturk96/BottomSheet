//
//  BottomSheetModifier.swift
//
//
//  Created by Alper Ozturk on 27.4.23..
//

import Foundation
import SwiftUI

public struct BottomSheetModifier<BottomSheetContent: View>: ViewModifier {
    @State private var offset = CGSize.zero
    
    @Binding var show: Bool
    var backgroundColor: Color
    var indicatorColor: Color
    var cornerRadius: CGFloat
    var size: BottomSheetSize
    var bottomSheetContent: BottomSheetContent
    
    public init(show: Binding<Bool>, indicatorColor: Color, backgroundColor: Color, cornerRadius: CGFloat, size: BottomSheetSize, bottomSheetContent: BottomSheetContent) {
        self._show = show
        self.size = size
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.indicatorColor = indicatorColor
        self.bottomSheetContent = bottomSheetContent
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay {
                if show {
                    DimmingView() {
                        show.toggle()
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if show {
                    BottomSheet
                }
            }
    }
}

// MARK: - ChildViews
extension BottomSheetModifier {
    @ViewBuilder
    private var BottomSheet: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .shadow(radius: 1)
            
            OuterRectangle
            
            bottomSheetContent
        }
        .frame(width: UIScreen.width, height: size.height)
        .offset(y: UIScreen.height * 0.05)
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        self.offset.height = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height > 50 {
                        show = false
                    }
                    self.offset = .zero
                }
        )
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
    }
}

// MARK: - Components
extension BottomSheetModifier {
    @ViewBuilder
    private var OuterRectangle: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(backgroundColor)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(indicatorColor)
                    .cornerRadius(cornerRadius)
                    .frame(width: 35, height: 5)
                    .padding(.top, 15)
            }
    }
}

public extension View {
    func bottomSheet<V: View>(show: Binding<Bool>, indicatorColor: Color = .Gray, backgroundColor: Color = .LightGray, cornerRadius: CGFloat = 30, size: BottomSheetSize = .medium, _ bottomSheetContent: V) -> some View {
        modifier(BottomSheetModifier(show: show, indicatorColor: indicatorColor, backgroundColor: backgroundColor, cornerRadius: cornerRadius, size: size, bottomSheetContent: bottomSheetContent))
    }
}

struct BottomSheetModifier_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetModifierTestView()
            .previewDisplayName("Bottom Sheet Toggle With TabBar")
    }
}

struct BottomSheetModifierTestView: View {
    @State private var show = false
    
    var body: some View {
        SmallBottomSheet
            .previewDisplayName("SmallBottomSheet")
        
        MediumBottomSheet
            .previewDisplayName("MediumBottomSheet")
        
        LargeBottomSheet
            .previewDisplayName("LargeBottomSheet")
    }
    
    @ViewBuilder
    private var SmallBottomSheet: some View {
        VStack {
            Button {
                show.toggle()
            } label: {
                Text("Open Bottom Sheet")
            }
        }
        .frame(width: UIScreen.width, height: UIScreen.height)
        .bottomSheet(show: $show, size: .small, BottomSheetContent)
    }
    
    @ViewBuilder
    private var MediumBottomSheet: some View {
        VStack {
            Button {
                show.toggle()
            } label: {
                Text("Open Bottom Sheet")
            }
        }
        .frame(width: UIScreen.width, height: UIScreen.height)
        .bottomSheet(show: $show, size: .medium, BottomSheetContent)
    }
    
    @ViewBuilder
    private var LargeBottomSheet: some View {
        VStack {
            Button {
                show.toggle()
            } label: {
                Text("Open Bottom Sheet")
            }
        }
        .frame(width: UIScreen.width, height: UIScreen.height)
        .bottomSheet(show: $show, size: .large, BottomSheetContent)
    }
    
    @ViewBuilder
    private var BottomSheetContent: some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 60)
            
            Text("Bottom Sheet Element 1")
                .font(.title)
            Text("Bottom Sheet Element 2")
                .font(.title2)
            Text("Bottom Sheet Element 3")
                .font(.title3)
            Text("Bottom Sheet Element 4")
                .font(.body)
            Text("Bottom Sheet Element 5")
                .font(.body)
            
            Spacer()
        }
    }
}
