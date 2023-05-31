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
    var useContentRectangle: Bool
    var contentRectangleBackgroundColor: Color
    var backgroundColor: Color
    var indicatorColor: Color
    var cornerRadius: CGFloat
    var height: CGFloat
    var bottomSheetContent: BottomSheetContent
    
    public init(show: Binding<Bool>, useContentRectangle: Bool, contentRectangleBackgroundColor: Color, indicatorColor: Color, backgroundColor: Color, cornerRadius: CGFloat, height: CGFloat, bottomSheetContent: BottomSheetContent) {
        self._show = show
        self.useContentRectangle = useContentRectangle
        self.contentRectangleBackgroundColor = contentRectangleBackgroundColor
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.indicatorColor = indicatorColor
        self.bottomSheetContent = bottomSheetContent
    }
    
    public func body(content: Content) -> some View {
        content
            .frame(width: show ? UIScreen.width : nil, height: show ? UIScreen.height : nil)
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
            
            if useContentRectangle {
                InnerRectangle
            } else {
                bottomSheetContent
            }
        }
        .frame(width: UIScreen.width, height: height)
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
    
    @ViewBuilder
    private var InnerRectangle: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(contentRectangleBackgroundColor)
            .frame(width: UIScreen.width * 0.92, height: height * 0.79)
            .overlay(ScrollView {
                VStack(alignment: .center) {
                    bottomSheetContent
                        .padding(.vertical, 40)
                }
            })
    }
}

public extension View {
    func bottomSheet<V: View>(show: Binding<Bool>, useContentRectangle: Bool = true, contentRectangleBackgroundColor: Color = .white, indicatorColor: Color = .LightGray, backgroundColor: Color = .LightGray, cornerRadius: CGFloat = 30, height: CGFloat = 300, _ bottomSheetContent: V) -> some View {
        modifier(BottomSheetModifier(show: show, useContentRectangle: useContentRectangle, contentRectangleBackgroundColor: contentRectangleBackgroundColor, indicatorColor: indicatorColor, backgroundColor: backgroundColor, cornerRadius: cornerRadius, height: height, bottomSheetContent: bottomSheetContent))
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
        NavigationView {
            ZStack {
                Color.LightGray
                
                Button {
                    show.toggle()
                } label: {
                    Text("Open Bottom Sheet")
                }
            }
            .bottomSheet(show: $show, BottomSheetContent)
        }
    }
    
    @ViewBuilder
    private var BottomSheetContent: some View {
        VStack(alignment: .center) {
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
        }
    }
}
