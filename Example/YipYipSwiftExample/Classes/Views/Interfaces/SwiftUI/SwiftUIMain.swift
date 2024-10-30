//
//  SwiftUIMain.swift
//  YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//  Copyright © 2023 YipYip. All rights reserved.
//

import SwiftUI

internal protocol SwiftUIMainDelegate: AnyObject {
    func userDidTapBackButton()
    func userDidTapDemoButton()
}

internal struct SwiftUIMain: View {
    
    @ObservedObject private var state: SwiftUIMainState = SwiftUIMainState()
    
    private let mainPadding: CGFloat = 32
    private let subPadding: CGFloat = 16
    
    internal weak var delegate: SwiftUIMainDelegate?
    
    internal var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    VStack(spacing: 16) {
                        ZStack {
                            Text("SwiftUI View")
                            
                            HStack {
                                Button(action: { self.delegate?.userDidTapBackButton() }) {
                                    Image(systemName: "xmark.circle.fill")
                                }
                                .padding(EdgeInsets(
                                    top: 0,
                                    leading: self.subPadding,
                                    bottom: 0,
                                    trailing: 0
                                ))
                                Spacer()
                            }
                            
                        }
                        .padding(EdgeInsets(
                            top: self.subPadding + geometry.safeAreaInsets.top,
                            leading: 0,
                            bottom: self.subPadding,
                            trailing: 0
                        ))
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        
                        ButtonView(
                            action: self.state.userDidTapPagedTableViewButton,
                            label: "PagedTableView SwiftUI nav"
                        )
                        
                        ButtonView(
                            action: { self.delegate?.userDidTapDemoButton() },
                            label: "Open UIViewController UIKit nav"
                        )
                        
                        VStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("UIKit View Intrinsic Height:")
                                
                                CardViewIntrinsicHeightRepresentable(
                                    title: "Test",
                                    subtitle: String(
                                        repeating: "The cake is a lie! ",
                                        count: self.state.showLongTextUIKitView ? Int.random(in: 3...10) : 1
                                    ),
                                    maxLines: self.state.enableMultilineUIKitView ? 0 : 1
                                )
                                .fixedSize(horizontal: false,vertical: true) // Use the smallest size possible vertically
                                .background(Color.yellow)
                                .padding(EdgeInsets(
                                    top: 0,
                                    leading: self.mainPadding,
                                    bottom: 0,
                                    trailing: self.mainPadding
                                ))
                            }
                            
                            VStack(spacing: 8) {
                                Text("UIKit View Intrinsic Width:")
                                
                                CardViewIntrinsicWidthRepresentable(
                                    title: "Test",
                                    subtitle: String(
                                        repeating: "The cake is a lie! ",
                                        count: self.state.showLongTextUIKitView ? Int.random(in: 3...10) : 1
                                    ),
                                    maxLines: 1,
                                    maxWidth: geometry.size.width - (self.mainPadding * 2) - (self.subPadding * 2)
                                )
                                .frame(height: 50) // Set fixed height to be able to determine width
                                .fixedSize(horizontal: true, vertical: false) // Use the smallest size possible horizontally
                                .background(Color.yellow)
                                .padding(EdgeInsets(
                                    top: 0,
                                    leading: self.mainPadding,
                                    bottom: 0,
                                    trailing: self.mainPadding
                                ))
                                
                            }
                            
                            Toggle(isOn: self.$state.showLongTextUIKitView) {
                                Text("Show long subtitle")
                            }
                            
                            Toggle(isOn: self.$state.enableMultilineUIKitView) {
                                Text("Multiline subtitle")
                            }
                            
                        }
                        .padding(EdgeInsets(
                            top: 0,
                            leading: self.subPadding,
                            bottom: 0,
                            trailing: self.subPadding
                        ))
                        .background(Color.green)
                        .foregroundColor(Color.black)
                        
                        Spacer()
                    }
                    .background(Color.blue)
                    .edgesIgnoringSafeArea(.top)
                }
                
                NavigationLink(
                    destination: PagedTableViewViewControllerRepresentable(),
                    isActive: self.$state.showPagedTableView
                ) {
                    EmptyView()
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationBarHidden(true)
        }
    }
    
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIMain()
    }
}
