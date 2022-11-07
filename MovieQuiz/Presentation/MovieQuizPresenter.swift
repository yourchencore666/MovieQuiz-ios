//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Юрченко Артем on 04.11.2022.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    var currentQuestion: QuizQuestion?
    var statisticService: StatisticService = StatisticServiceImplementation()
    
    weak var viewController: MovieQuizViewController?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isCorrectAnswer
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func showNextQuestionOrResults() {
        
        if self.isLastQuestion() {
            
            statisticService.store(correct: correctAnswers, total: self.questionsAmount)
            
            let text = "Ваш результат: \(correctAnswers) из \(self.questionsAmount)\nКоличество сыграных квизов: \(statisticService.gamesCount)\nРекорд:  \(statisticService.bestGame.correct)/\(self.questionsAmount) \(statisticService.bestGame.date)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy as CVarArg))%"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            viewController?.show(quiz: viewModel) // show result
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
        
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if (isCorrect) { correctAnswers += 1 }
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        viewController?.buttonEnableToggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            // запускаем задачу через 1 секунду
            self.viewController?.buttonEnableToggle()
            self.viewController?.discardImageBorder()
            self.showNextQuestionOrResults()
            
        }
        
    }
    
    func yesButtonClicked() {
        didAnswer(isCorrectAnswer: true)
    }
    
    func noButtonClicked() {
        didAnswer(isCorrectAnswer: false)
    }
    
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
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
}
