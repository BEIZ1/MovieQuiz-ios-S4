import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoadingProtocol
    private var movies: [MostPopularMovie] = []

    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }

    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self, let movie = self.movies.randomElement() else { return }
            do {
                let imageData = try Data(contentsOf: movie.resizedImageURL)
                let rating = Float(movie.rating) ?? 0
                let ratingQuestion = Float.random(in: 7.9..<9.4)
                let moreLess = ["меньше", "больше"].randomElement()
                let text = String(format: "Рейтинг этого фильма \(moreLess!) чем %.2f?", ratingQuestion)
                let correctAnswer = moreLess == "больше" ? rating > ratingQuestion : rating < ratingQuestion
                let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
                self.delegate?.didReceiveNextQuestion(question: question)
            } catch {
                self.delegate?.didFailNextQuestion(with: error)
            }
        }
    }

    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let mostPopularMovies):
                    self?.movies = mostPopularMovies.items
                    self?.delegate?.didLoadData()
                case .failure(let error):
                    self?.delegate?.didFailData(with: error)
                }
            }
        }
    }
}
