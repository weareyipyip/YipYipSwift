# Changelog

Significant changes to the project will be documented here.

## [1.2.4](https://github.com/weareyipyip/YipYipSwift/releases/tag/1.2.4)

- Moved adding json variables to the http body to a separate method so it can be overridden if needed

## [1.2.3](https://github.com/weareyipyip/YipYipSwift/releases/tag/1.2.3)

- Updated to swift 5.0
- Changed the way of handling network errors. (Update required!)


## [1.2.2](https://github.com/weareyipyip/YipYipSwift/releases/tag/1.2.2)

- Added 2 new services error type: unauthorized and forbidden. 
- Added the method errorTypeForStatusCode to set the services error type for the http status code if needed.
- Fixed typo toManyRequests -> tooManyRequests
