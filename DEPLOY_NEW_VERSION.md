# YipYipSwift

## Create new version

If you create an new version you also have to add this version to the YipYip-CocoaPods.

### Step 1
*Skip this step if you already added the YipYip-CocoaPods to your device*

Add the YipYip-CocoaPods

```bash
pod repo add YipYip-CocoaPods git@github.com:weareyipyip/YipYip-CocoaPods.git
cd ~/.cocoapods/repos/YipYip-CocoaPods
pod repo lint .
```

### Step 2
```bash
cd [Project folder]
pod repo push YipYip-CocoaPods YipYipSwift.podspec
```

## Author
Rens Wijnmalen, r.wijnmalen@yipyip.nl

## Resources
```
https://medium.com/@shahabejaz/create-and-distribute-private-libraries-with-cocoapods-5b6507b57a03
```