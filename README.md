# PAY.JP iOS SDK

[![CI Status](http://img.shields.io/travis/laiso/PayJP.svg?style=flat)](https://travis-ci.org/laiso/PayJP)
[![Version](https://img.shields.io/cocoapods/v/PayJP.svg?style=flat)](http://cocoapods.org/pods/PayJP)
[![License](https://img.shields.io/cocoapods/l/PayJP.svg?style=flat)](http://cocoapods.org/pods/PayJP)
[![Platform](https://img.shields.io/cocoapods/p/PayJP.svg?style=flat)](http://cocoapods.org/pods/PayJP)


## Usage

```
import PAYJP

let apiClient = PAYJP.APIClient(publicKey: "PAY.JP Public Key")
```

## Example

  - open Example/ApplePaySample.xcodeproj
- open ViewController.swift and set your Apple Merchant ID (require iOS Developer Program Account)
- build and run

## Requirements

- iOS 9.2
- Xcode 7.0+ to build the source.

## Installation

PAY.JP iOS SDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PAYJP"
```

## License

PAY.JP iOS SDK is available under the MIT license. See the LICENSE file for more info.
