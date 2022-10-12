//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Юрченко Артем on 04.10.2022.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let alertButtonText: String
    var completion: () -> Void
        
}
