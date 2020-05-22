//
//  ActiveNewsViewController.swift
//  SmartClickAITest
//

import UIKit

protocol ActiveNewsDisplayLogic: class {
    func displayNews(viewModel: ActiveNews.UseCase.ViewModel)
    func displaySomethingWhenWrongPopUp()
}

class ActiveNewsViewController: UIViewController, ActiveNewsDisplayLogic, Storyboardable
{
    
    static var storyboardName: StringConvertible {
        return StoryboardType.activeNews
    }
    
    var interactor: ActiveNewsBusinessLogic?
    var router: (NSObjectProtocol & ActiveNewsRoutingLogic & ActiveNewsDataPassing)?
    @IBOutlet weak var newsTableView: UITableView!
    private var news  = [News]()
    private var newNewsCount:Int?
    var refreshControl = UIRefreshControl()
    
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
        setupView()
        setupPullToRefresh()
        registerForNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getNews()
    }
    
    func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.getNews), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
    }
    
    @objc private func getNews() {
        self.refreshControl.endRefreshing()
        interactor?.getNews()
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(
          forName: .newNews,
          object: nil,
          queue: nil) { (notification) in
            print("notification received")
            if let uInfo = notification.userInfo,
               let addedNewsCount = uInfo["count"] as? Int {
                self.newNewsCount = addedNewsCount
            }
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func archiveButtonAction(_ sender: Any) {
        router?.routeToArchivedNews()
    }
    
    private func setupView () {
        self.newsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func displayNews(viewModel: ActiveNews.UseCase.ViewModel) {
        self.news = viewModel.news
        NewsToBackgroudWorker.shareed.fetchedNews = self.news
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
        }
    }
    
    func displaySomethingWhenWrongPopUp() {
        DispatchQueue.main.async {
            self.askQuestionAlert(title: "Warning", textString: "Something went wrong with News\n do you want to see you archived news?") {
                DispatchQueue.main.async {
                    self.router?.routeToArchivedNews()
                }
            }
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
        if let newNewsCount = self.newNewsCount {
            if indexPath.row < newNewsCount {
                cell.highLightBackground()
            } else {
                cell.removeHighlight()
            }
        } else {
            cell.removeHighlight()
        }
        return cell
    }
}

extension ActiveNewsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routToNewsDetails(news: news[indexPath.row])
    }
}
