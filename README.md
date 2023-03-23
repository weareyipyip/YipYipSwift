# YipYipSwift

This is an internal library, not intended for use outside of YipYip.

Current version: 1.3.3

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YipYipSwift is available privately through [CocoaPods](http://cocoapods.org) or [SPM](https://developer.apple.com/documentation/xcode/swift-packages). 

### Cocoapods

To install
it, simply add the following lines to your Podfile:

```ruby
source 'git@github.com:weareyipyip/YipYip-CocoaPods.git'

pod "YipYipSwift"
```
or
```ruby
pod 'YipYipSwift', :git => 'git@github.com:weareyipyip/YipYipSwift.git'
```

### SPM (since v1.3.3)

To install it, follow the steps below.

Open the project in Xcode -> Click File -> Swift Packages -> Add Package Dependency, enter the repo url. Make sure you have logged in with your Github account in Xcode

After select the package, you can choose the dependency type (tagged version, branch or commit). Then Xcode will setup all the stuff for you.

## How to use

### YipYipHostingController & YipYipHostingView

`YipYipHostingController` and `YipYipHostingView` are protocols which will accomodate the placement of a UIHostingController to be able to use SwiftUI views in a UIKit environment. Implement the required methods/properties and call `self.placeContentView()` to place the SwiftUI view. Both views use the `YipYipEmbeddedHostingController` to keep control of the navigation controller in the parent view/viewcontroller.

For an example of the `YipYipHostingController`, see `SwiftUIViewController` in the example project. 

For an example of the `YipYipHostingView`, see `ButtonViewHostingView` and `SwiftUIDemoViewController` in the example project.

### YipYipIntrinsicWidthRepresentable & YipYipIntrinsicHeightRepresentable
`YipYipIntrinsicWidthRepresentable` and `YipYipIntrinsicHeightRepresentable` are protocols which will accomodate the placement of UIKit views in a SwiftUI environment. Both protocols rely on their own type of container view to layout the view properly, since SwiftUI's layout mechanism works different from autolayout in UIKit.

For an example see `SwiftUIMain`, `CardViewIntrinsicHeightRepresentable` and `CardViewIntrinsicWidthRepresentable` in the example project.


## Author

- Marcel Bloemendaal, YipYip B.V. ([m.bloemendaal@yipyip.nl](mailto:m.bloemendaal@yipyip.nl))
- Rens Wijnmalen, YipYip B.V. ([r.wijnmalen@yipyip.nl](mailto:r.wijnmalen@yipyip.nl))
- Lars Moesman, YipYip B.V. ([l.moesman@yipyip.nl](mailto:l.moesman@yipyip.nl))

## Changelog

[Changelog](https://github.com/weareyipyip/YipYipSwift/blob/master/CHANGELOG.md)
