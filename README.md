# PAY.JP iOS SDK Beta

## 使い方

```
import PAYJP

let apiClient = PAYJP.APIClient(publicKey: "PAY.JP Public Key")
```

## サンプルコード

- Apple Pay: https://github.com/payjp/apple-pay-example

## 動作環境

- Swift 3
- iOS 8.4+
- Xcode 8.0+
- Result: https://github.com/antitypical/Result/
- Himotoki: https://github.com/ikesyo/Himotoki/

## インストール

[Carthage](https://github.com/Carthage/Carthage) でインストールする場合、以下のように記述してください
```
git "git@github.com:payjp/payjp-ios.git" "master"
```

[CocoaPods](http://cocoapods.org) でもインストールすることができます。

```ruby
pod 'PAYJP', git: 'git@github.com:payjp/payjp-ios.git'
```

詳しくは [サンプルコード](https://github.com/payjp/apple-pay-example) のプロジェクトを参照ください。

## License

PAY.JP iOS SDK is available under the MIT license. See the LICENSE file for more info.
