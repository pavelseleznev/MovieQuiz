import UIKit

final class MovieQuizViewController: UIViewController  {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()
        activityIndicator.startAnimating()
        questionFactory?.loadData()
        
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    // MARK: - IB Outlets
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    /// Var containing index of the current question, initial value 0 (this index will search question in array, where first element's index is 0, not 1)
    private var currentQuestionIndex: Int = .zero
    /// Var containing the count of correct answers, initial value naturally .zero
    private var correctAnswers: Int = .zero
    /// Overall amount of questions
    private let questionsAmount: Int = 10
    /// Question factory used by controller
    private var questionFactory: QuestionFactoryProtocol?
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
    
    // MARK: Private Methods
    /// Private conversion method which accepts mock question and returns view model to display question
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
            showNextQuestionOrResults()
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
                buttonText: "Сыграть ещё раз") { [weak self ] in
                    guard let self = self else { return }
                    correctAnswers = .zero
                    currentQuestionIndex = .zero
                    activityIndicator.startAnimating()
                    questionFactory?.requestNextQuestion()
                    activityIndicator.stopAnimating()
                }
            
            alertPresenter?.showAlert(quiz: alertModel)
            imageView.layer.borderWidth = .zero
            imageView.layer.borderColor = UIColor.clear.cgColor
            
        } else {
            currentQuestionIndex += 1
            activityIndicator.startAnimating()
            questionFactory?.requestNextQuestion()
            activityIndicator.stopAnimating()
            
            imageView.layer.borderWidth = .zero
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    /// Private method that enables/disables noButton&yesButton
    private func changeStateButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    /// Private method that shows network error in case of connection failure
    private func showNetworkError(message: String) {
        activityIndicator.stopAnimating()
        
        let alertConnectionError = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self ] in
                guard let self = self else { return }
                correctAnswers = .zero
                currentQuestionIndex = .zero
                activityIndicator.startAnimating()
                questionFactory?.loadData()
            }
        
        alertPresenter?.showAlert(quiz: alertConnectionError)
    }
    
    /// Private method that shows image error in case of failure to load image
    private func showImageError(message: String) {
        activityIndicator.stopAnimating()
        
        let alertImageError = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Загрузить следующий вопрос") { [weak self ] in
                guard let self = self else { return }
                activityIndicator.startAnimating()
                questionFactory?.loadData()
            }
        
        alertPresenter?.showAlert(quiz: alertImageError)
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.stopAnimating()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didFailToLoadDataMessage(with ErrorMessage: String) {
        showNetworkError(message: ErrorMessage)
    }
    
    func didFailToLoadImage(with error: Error) {
        showImageError(message: "Failed to load image.")
    }
}
