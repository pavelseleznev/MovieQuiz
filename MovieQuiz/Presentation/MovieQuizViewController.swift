import UIKit

final class MovieQuizViewController: UIViewController  {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticService()
    }
    
    // MARK: - IB Outlets
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    // MARK: - Private Properties
    /// Var containing index of the current question, initial value 0 (this index will search question in array, where first element's index is 0, not 1)
    private var currentQuestionIndex: Int = .zero
    /// Var containing the count of correct answers, initial value naturally .zero
    private var correctAnswers: Int = .zero
    /// Overall amount of questions
    private let questionsAmount: Int = 10
    /// Question factory used by controller
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    /// Question displayed to the user
    private var currentQuestion: QuizQuestion?
    /// Alert presenter used by controller
    private var alertPresenter: AlertPresenterProtocol?
    /// StatisticService protocol used by controller
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: Private methods
    /// Private conversion method which accepts mock question and returns view model to display question
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    /// Private method to display question on screen which accepts view question model and returns nill
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
     
    /// Private method that changes image frame color. Takes bool value - returns nil
    private func showAnswerResult(isCorrect: Bool) {
        changeStateButton(isEnabled: false)
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.YPGreen.cgColor : UIColor.YPRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    /// Private method which contains transition logic to one of scenarios (show next question/alert). Method accepts/returns nil
    private func showNextQuestionOrResults() {
        changeStateButton(isEnabled: true)
        
        guard let statisticService = statisticService else { return }
        
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let totalAccuracy = "\(String(format: "%.2f", statisticService.totalAccuracy))%"
            let message = """
                        Ваш результат: \(correctAnswers)/\(questionsAmount)
                        Количество сыгранных квизов: \(statisticService.gamesCount)
                        Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                        Средняя точность: \(totalAccuracy)
                        """
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: message,
                buttonText: "Сыграть ещё раз") { [weak self] _ in
                    guard let self = self else { return }
                    self.correctAnswers = .zero
                    self.currentQuestionIndex = .zero
                    self.questionFactory.requestNextQuestion()
                }
            
            alertPresenter?.showAlert(quiz: alertModel)
            imageView.layer.borderWidth = .zero
            imageView.layer.borderColor = UIColor.clear.cgColor
        } else {
            currentQuestionIndex += 1
            self.questionFactory.requestNextQuestion()
            
            imageView.layer.borderWidth = .zero
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    /// Private method that enables/disables yesButton&noButton
    private func changeStateButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        /// Checking that question is not nil
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}
