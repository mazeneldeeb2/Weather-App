//
//  HomeView.swift
//  weather_app
//
//  Created by mazen eldeeb on 11/09/2023.
//

import SwiftUI
import BottomSheet
enum BottomSheetPosition: CGFloat, CaseIterable {
    case top = 0.83
    case middle = 0.385 // according to design
}

struct HomeView: View {
    @State var bottomSheetPosition : BottomSheetPosition = .middle
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged : Bool = false
    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                let imageOffset = screenHeight + 36
                ZStack {
                    // MARK: Background Color
                    Color.background
                        .ignoresSafeArea()
                    // MARK: Background Image
                    Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                        .offset(y: -imageOffset * bottomSheetTranslationProrated)
                    // MARK: House Image
                    Image("House")
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 257)
                        .offset(y: -imageOffset * bottomSheetTranslationProrated)
                    // MARK: Info Vertical Stack
                    VStack(spacing: -1 * (1 - bottomSheetTranslationProrated)){
                        Text("Montreal")
                            .font(.largeTitle)
                        VStack {
                            Text(attributedString)
                            Text("H : 24°   L : 18°")
                                .font(.title3.weight(.semibold))
                                .opacity(1 - bottomSheetTranslationProrated)
                        }
                        
                        Spacer()
                    }
                    BottomSheetView(position: $bottomSheetPosition) {
                    } content: {
                        ForcastView(bottomSheetTranslationProrated : bottomSheetTranslationProrated)
                    }.onBottomSheetDrag { translation in
                        bottomSheetTranslation = translation / screenHeight
                        
                        
                        withAnimation(.easeInOut) {
                            if bottomSheetPosition == BottomSheetPosition.top {
                                hasDragged = true
                            } else {
                                hasDragged = false
                            }
                        }
                    }

                    TabBar {
                        
                    }.offset(y: 115 * bottomSheetTranslationProrated)

                }
            }
        }.toolbar(.hidden)
           
    }
    
    // created as attributed string of 3 texts instead of 3 different text views because when animated as design it gonna be one textview
    private var attributedString: AttributedString {
        var string = AttributedString("19°" + (hasDragged ? " | ": "\n ") + "Mostly Clear")
        
        if let temperature = string.range(of: "19°") {
            string[temperature].font = .system(size: (96 - (bottomSheetTranslationProrated * (96 - 20))), weight:
                                                hasDragged ? .semibold : .thin)
            string[temperature].foregroundColor = hasDragged ? .secondary : .primary
        }
        // the vertical bar only will be found when animated
        if let pipe = string.range(of: " | ") {
            string[pipe].font = .title3.weight(.semibold)
            string[pipe].foregroundColor = .secondary
        }
        if let weatherCondition = string.range(of: "Mostly Clear") {
            string[weatherCondition].font = .title3.weight(.semibold)
            string[weatherCondition].foregroundColor = .secondary
        }
        
        return string
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().preferredColorScheme(.dark)
    }
}
