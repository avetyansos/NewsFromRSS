//
//  ActiveNewsViewController.swift
//  SmartClickAITest
//

import UIKit

protocol ActiveNewsDisplayLogic: class {
    func displayNews(viewModel: ActiveNews.UseCase.ViewModel)
}

class ActiveNewsViewController: UIViewController, ActiveNewsDisplayLogic, Storyboardable
{
    
    static var storyboardName: StringConvertible {
        return StoryboardType.activeNews
    }
    
    var interactor: ActiveNewsBusinessLogic?
    var router: (NSObjectProtocol & ActiveNewsRoutingLogic & ActiveNewsDataPassing)?
    @IBOutlet weak var newTableView: UITableView!
    private var news  = [News]()
    
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
        let interactor = ActiveNewsInteractor()
        let presenter = ActiveNewsPresenter()
        let router = ActiveNewsRouter()
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
        interactor?.getNews()
        
    }
    @IBAction func archiveButtonAction(_ sender: Any) {
        router?.routeToArchivedNews()
    }
    
    func displayNews(viewModel: ActiveNews.UseCase.ViewModel) {
        self.news = viewModel.news
        DispatchQueue.main.async {
            self.newTableView.reloadData()
        }
    }
    
}

extension ActiveNewsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellIdentifer", for: indexPath) as! NewsTableViewCell
        cell.news = news[indexPath.row]
        return cell
    }
}

extension ActiveNewsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routToNewsDetails(news: news[indexPath.row])
    }
}
