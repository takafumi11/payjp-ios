# PAY.JP iOS SDK
[![CocoaPods](https://img.shields.io/cocoapods/v/PAYJP.svg)](https://github.com/payjp/payjp-ios)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Travis CI](https://api.travis-ci.org/payjp/payjp-ios.svg?branch=master)](https://travis-ci.org/payjp/payjp-ios)

オンライン決済サービス「[PAY.JP](https://pay.jp/)」のiOSアプリ組込み用のSDKです。

最新バージョンでは以下を実現するための機能が提供されています。
詳細はドキュメントを参照してください。

- Apple Payアプリ内決済
  - https://pay.jp/docs/apple-pay
- クレジットカードによる決済
  - https://pay.jp/docs/started
- カード情報入力フォームの組み込み

|CardFormTableStyledView|CardFormLabelStyledView|
|:--:|:--:|
|<img src="https://user-images.githubusercontent.com/38201241/67450886-c3dbe080-f659-11e9-91a2-c3cf87309ea5.png" width="240px">|<img src="https://user-images.githubusercontent.com/38201241/67450887-c4747700-f659-11e9-8f3b-e207200a01f6.png" width="240px">|

## サンプルコード

- Apple Pay: https://github.com/payjp/apple-pay-example
- CreditCard (Swift, Carthage): https://github.com/payjp/payjp-ios/tree/master/example-swift
- CreditCard (Objective-C, CocoaPods): https://github.com/payjp/payjp-ios/tree/master/example-objc

## 動作環境

- Swift または Objective-C で開発された iOS アプリケーション
- iOS 9.0以上
- 最新安定版のXcode

## インストール

[Carthage](https://github.com/Carthage/Carthage) でインストールする場合、以下のように記述してください
```
github "payjp/payjp-ios"
```

[CocoaPods](http://cocoapods.org) でもインストールすることができます。

```ruby
pod 'PAYJP'
```

詳しくは [サンプルコード](https://github.com/payjp/apple-pay-example) のプロジェクトを参照ください。

## SDK開発環境

- Swift 5

## リファレンス
- https://payjp.github.io/payjp-ios/

## License

PAY.JP iOS SDK is available under the MIT license. See the LICENSE file for more info.
