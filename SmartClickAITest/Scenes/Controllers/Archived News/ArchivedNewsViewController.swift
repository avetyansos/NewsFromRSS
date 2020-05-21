//
//  ArchivedNewsViewController.swift
//  SmartClickAITest
//

import UIKit

protocol ArchivedNewsDisplayLogic: class {
    func displayNews(viewModel: ArchivedNews.UseCase.ViewModel)
}

class ArchivedNewsViewController: UIViewController, ArchivedNewsDisplayLogic, Storyboardable
{
    
    static var storyboardName: StringConvertible {
        return StoryboardType.archivedNews
    }
    
    var interactor: ArchivedNewsBusinessLogic?
    var router: (NSObjectProtocol & ArchivedNewsRoutingLogic & ArchivedNewsDataPassing)?
    @IBOutlet weak var archivedNewsTableView: UITableView!
    private var news = [News]()
    
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
        let interactor = ArchivedNewsInteractor()
        let presenter = ArchivedNewsPresenter()
        let router = ArchivedNewsRouter()
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchNews()
    }
    
    func fetchNews() {
        interactor?.fetchArchivedNews()
    }
    
    func displayNews(viewModel: ArchivedNews.UseCase.ViewModel) {
        self.news = viewModel.news
        self.archivedNewsTableView.reloadData()
    }
    
}

extension ArchivedNewsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archivedNewsCellIdentifer", for: indexPath) as! ArchivedNewsTableViewCell
        cell.news = news[indexPath.row]
        return cell
    }
    
    
}
