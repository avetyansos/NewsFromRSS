//
//  NewsDetailsViewController.swift
//  SmartClickAITest
//

import UIKit

protocol NewsDetailsDisplayLogic: class {
    func displayPupUp(viewModel: NewsDetails.UseCase.ViewModel)
    func displaySuccessPopUp(viewModel: NewsDetails.UseCase.ViewModel)
}

class NewsDetailsViewController: UIViewController, NewsDetailsDisplayLogic, Storyboardable
{
    
    static var storyboardName: StringConvertible {
        return StoryboardType.newsDetails
    }
    
    var interactor: NewsDetailsBusinessLogic?
    var router: (NSObjectProtocol & NewsDetailsRoutingLogic & NewsDetailsDataPassing)?
    @IBOutlet weak var newsDetailsTextView: UITextView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var detailsTextViewHeight: NSLayoutConstraint!
    var news:News?
    var isArchive = false
    @IBOutlet weak var archiveButton: UIButton!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = NewsDetailsInteractor()
        let presenter = NewsDetailsPresenter()
        let router = NewsDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupView()
        
    }
    
    private func setupView() {
        guard let viewDetails = news else {return}
        if isArchive {
            guard let path = news?.localImageURL else {return}
            self.newsImageView.image = path.makeUIImage()
            archiveButton.isHidden = true
        } else {
            self.newsImageView.downloaded(from: viewDetails.fullimage)
        }
        
        self.newsTitleLabel.text = viewDetails.title
        self.newsDetailsTextView.text = viewDetails.description
        let sizeThatFitsTextView = newsDetailsTextView.sizeThatFits(CGSize(width: CGFloat(217), height: CGFloat(MAXFLOAT)))
        let heightOfTextFirstText = sizeThatFitsTextView.height
        self.detailsTextViewHeight.constant = heightOfTextFirstText
    }
    @IBAction func archiveButtonAction(_ sender: Any) {
        guard let newsItem = news else {return}
        interactor?.archiveNews(newsItem)
    }
    
    func displayPupUp(viewModel: NewsDetails.UseCase.ViewModel) {
        self.showErrorAlert(title: "Warning", textString: viewModel.popupMessage)
    }
    
    func displaySuccessPopUp(viewModel: NewsDetails.UseCase.ViewModel) {
        self.showSuccessAlert(textString: viewModel.popupMessage)
    }
    
}
