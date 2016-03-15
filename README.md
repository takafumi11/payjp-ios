# PAY.JP iOS SDK

## Requirements

- iOS 9.2
- Xcode 7.0+ to build the source.

## Example apps

- open Example/ApplePaySample.xcodeproj
- open ViewController.swift and set your Apple Merchant ID (require iOS Developer Program Account)
- build and run

## Use PAY.JP SDK

```
import PAYJP

let apiClient = PAYJP.APIClient(username: "PAY.JP Username", password: "PAY.JP Password")
```
