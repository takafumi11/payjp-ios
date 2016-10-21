# PAY.JP iOS SDK Beta

## 使い方

```
import PAYJP

// Apple Pay - payment: PKPayment
let apiClient = PAYJP.APIClient(publicKey: PAYJPPublicKey)
apiClient.createToken(with: payment.token) { (result) in
    switch result {
    case .success(let token):
        print("token: \(token.identifer)")
    case .failure(let error):
        print(error)
    }
}
```

## サンプルコード

- Apple Pay: https://github.com/payjp/apple-pay-example

## 動作環境

- Swift または Objective-C で開発された iOS アプリケーション
- iOS 8.4+
- Xcode 8.0+

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

## SDK開発環境

- Swift 3.x
- Result: https://github.com/antitypical/Result/
- Himotoki: https://github.com/ikesyo/Himotoki/

## License

PAY.JP iOS SDK is available under the MIT license. See the LICENSE file for more info.
