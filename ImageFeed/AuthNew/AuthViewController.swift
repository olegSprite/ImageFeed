//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 03.02.2024.
//

import Foundation
import UIKit

final class AuthViewController: UIViewController {
    private let identificator = "AuthViewController"

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identificator {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(identificator)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
