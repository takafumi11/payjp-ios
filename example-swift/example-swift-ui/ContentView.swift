//
//  ContentView.swift
//  example-swift-ui
//
//  Created by Tatsuya Kitagawa on 2020/07/21.
//

import SwiftUI
import PAYJP

struct ContentView: View {
    @ObservedObject private weak var cardFormDelegate = CardFormDelegate()
    var body: some View {
        Button("Add Credit Card") {
            self.cardFormDelegate.isPresented.toggle()
        }
        .sheet(isPresented: self.$cardFormDelegate.isPresented) {
            CardFormViewControllerWrapper(delegate: self.cardFormDelegate)
        }
    }
}

// MARK: - CardFormViewControllerDelegate

class CardFormDelegate: ObservableObject, CardFormViewControllerDelegate {
    @Published var isPresented: Bool = false

    func cardFormViewController(_: CardFormViewController, didCompleteWith result: CardFormResult) {
        switch result {
        case .cancel:
            print("CardFormResult.cancel")
        case .success:
            print("CardFormResult.success")
            DispatchQueue.main.async { [weak self] in
                self?.isPresented.toggle()
            }
        }
    }

    func cardFormViewController(_: CardFormViewController,
                                didProduced token: Token,
                                completionHandler: @escaping (Error?) -> Void) {
        print("token = \(token.rawValue)")
        // TODO: send token to server
        completionHandler(nil)
    }
}

// MARK: - CardFormViewControllerWrapper

struct CardFormViewControllerWrapper: UIViewControllerRepresentable {
    weak var delegate: CardFormViewControllerDelegate

    func makeUIViewController(context: Context) -> UINavigationController {
        let cardFormVc =  CardFormViewController.createCardFormViewController(delegate: delegate,
                                                                              viewType: .displayStyled)
        let naviVc = UINavigationController(rootViewController: cardFormVc)
        naviVc.presentationController?.delegate = cardFormVc
        return naviVc
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    typealias UIViewControllerType = UINavigationController
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
