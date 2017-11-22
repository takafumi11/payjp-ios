# PAY.JP iOS SDK Beta

オンライン決済サービス「[PAY.JP](https://pay.jp/)」のiOSアプリ組込み用のSDKです。

現在のBetaバージョンではApple Payアプリ内決済を実現するための機能が提供されています。
詳しくはドキュメントを参照してください。
https://pay.jp/docs/apple-pay

## 今後の開発予定

- クレジットカードによる決済(トークン化、カード情報入力フォーム)

## サンプルコード

- Apple Pay: https://github.com/payjp/apple-pay-example

## 動作環境

- Swift または Objective-C で開発された iOS アプリケーション
- iOS 8.4以上
- Xcode 9.0以上

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

- Swift 4
- Result: https://github.com/antitypical/Result/
- Himotoki: https://github.com/ikesyo/Himotoki/

## License

PAY.JP iOS SDK is available under the MIT license. See the LICENSE file for more info.
