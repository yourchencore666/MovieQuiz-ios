//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Юрченко Артем on 05.10.2022.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didShowAlert(controller: UIAlertController?)
}
