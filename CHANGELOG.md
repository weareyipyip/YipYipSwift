# Changelog

Added swift extensions  support

## [2.2.1](https://github.com/weareyipyip/YipYipSwift/releases/tag/2.2.1)

- Fixed example project
- Updated minimum deployment target to iOS 15 for pod

## [2.2.0](https://github.com/weareyipyip/YipYipSwift/releases/tag/2.2.0)

- Fixed (deprecation) warnings/errors
- Updated minimum deployment target to iOS 15

## [2.1.0](https://github.com/weareyipyip/YipYipSwift/releases/tag/2.1.0)

- Added YipYipEmbeddedHostingController
- Added YipYipHostingController
- Added YipYipHostingView
- Added YipYIpIntrinsicHeightViewRepresentable and YipYipIntrinsicHeightContainerView
- Added YipYIpIntrinsicWidthViewRepresentable and YipYipIntrinsicWidthContainerView
- Updated README

## [2.0.2](https://github.com/weareyipyip/YipYipSwift/releases/tag/2.0.1)

- Removed AppStoreReviewManager

## [2.0.1](https://github.com/weareyipyip/YipYipSwift/releases/tag/2.0.1)

- Added a fix to ViewUtils that sets the container's translatesAutoresizingMaskIntoConstraints to false in addViewFromNib method

## [2.0.0](https://github.com/weareyipyip/YipYipSwift/releases/tag/2.0.0)

- Removed all yipyip base classes
- Removed services base code (now the app has to implement this for his own)
- Added YipYipContentSizedCollectionView and YipYipContentSizedTableView
- Added YipYipSafeAreaLayoutConstraint 
- Added KeyboardViewHelper
- Added PagedTableView functionality

## [1.3.4](https://github.com/weareyipyip/YipYipSwift/releases/tag/1.3.4)

Significant changes to the project will be documented here.

## [1.3.3](https://github.com/weareyipyip/YipYipSwift/releases/tag/1.3.3)

- Added Swift Package support

## [1.3.2](https://github.com/weareyipyip/YipYipSwift/releases/tag/1.3.2)

- Updated the readme file and removed the license

## [1.3.1](https://github.com/weareyipyip/YipYipSwift/releases/tag/1.3.1)

- Fixed a bug in the AppStoreReviewManager

## [1.3.0](https://github.com/weareyipyip/YipYipSwift/releases/tag/1.3.0)

- Added the AppStoreReviewManager

## [1.2.4](https://github.com/weareyipyip/YipYipSwift/releases/tag/1.2.4)

- Moved adding json variables to the http body to a separate method so it can be overridden if needed

## [1.2.3](https://github.com/weareyipyip/YipYipSwift/releases/tag/1.2.3)

- Updated to swift 5.0
- Changed the way of handling network errors. (Update required!)


## [1.2.2](https://github.com/weareyipyip/YipYipSwift/releases/tag/1.2.2)

- Added 2 new services error type: unauthorized and forbidden. 
- Added the method errorTypeForStatusCode to set the services error type for the http status code if needed.
- Fixed typo toManyRequests -> tooManyRequests
