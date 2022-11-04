//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Юрченко Артем on 04.11.2022.
//

import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
}
