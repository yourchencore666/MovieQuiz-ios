//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Юрченко Артем on 04.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    
}


