import UIKit
import CoreData

final class TransactionsViewController: UIViewController {
    
    let alert = CustomPopUp()
    
    //MARK: - CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        
        let request : NSFetchRequest<Transaction> = Transaction.fetchRequest()
        do {
            TransactionsData.transactions = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        sumTheBalance()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        activateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            configureNavBar()
    }
    
    // MARK: - Layout
    
    private func setupView() {
        
        addSubviews()
        configureTableView()
        configureButtons()
    }

    // MARK: - Private Methods
    
    private func configureButtons(){
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addTransactionButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
    }
    
    @objc private func addButtonPressed(){
        alert.showAlert(on: self)
    }
    
    private func addSubviews(){
        [transactionsTableView, addButton, balanceLabel, addTransactionButton, historyLabel].forEach{
            view.addSubview($0)
        }
    }
    
    private func configureTableView(){
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
    }
    
    private func configureNavBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 25)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        title = "Balance:"
    }
    
    private func sumTheBalance(){
        TransactionsData.currentBalance = 0
        for transaction in TransactionsData.transactions {
            TransactionsData.currentBalance = TransactionsData.currentBalance + Int(transaction.amount)
        }
    }
    
    private func designCell(index: Int, cell: CustomTableViewCell){
        cell.transactionAmountLabel.text = "\(TransactionsData.transactions[index].amount) $"
        cell.dateLabel.text = TransactionsData.transactions[index].date
        if let category = TransactionsData.transactions[index].category {
            cell.categoryLabel.text = category
        } else {
            cell.categoryLabel.text = ""
        }
        
        cell.backgroundColor = .white
        cell.selectionStyle = .none
    }
    
    private func activateLayout(){
        NSLayoutConstraint.activate([
            
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            transactionsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 290),
            
            historyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            historyLabel.heightAnchor.constraint(equalToConstant: 20),
            historyLabel.topAnchor.constraint(equalTo: addTransactionButton.bottomAnchor, constant: 5),
            historyLabel.widthAnchor.constraint(equalToConstant: 140),
            
            balanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            balanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            balanceLabel.heightAnchor.constraint(equalToConstant: 90),
            balanceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            
            addTransactionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 70),
            addTransactionButton.widthAnchor.constraint(equalToConstant: 200),
            addTransactionButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 15),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    // MARK: - UI Elements
    
    private let  historyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Transactions history:"
        label.font = UIFont(name: "Montserrat-Regular", size: 15)
        label.textColor = .systemGray
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        label.backgroundColor = .clear
  
        return label
    }()
    
    private let addTransactionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Add transaction", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 20)

        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
        button.backgroundColor = .white
        
        return button
    }()
    
    let transactionsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        table.backgroundColor = .white
        
        return table
     }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "\(TransactionsData.currentBalance) $"
        label.font = UIFont(name: "Montserrat-Bold", size: 25)
        label.textColor = .black

        label.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        label.layer.masksToBounds = true //For corners
        label.layer.cornerRadius = 4
        label.textAlignment = .center

        return label
    }()
    
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        config.cornerStyle = .capsule
        button.configuration = config
        button.tintColor = .systemBlue
        
        return button
    }()
    
    // MARK: - @objc methods
    
    @objc private func addTransaction(){
        let vc = NewTransactionViewController()
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(nav, animated: true, completion: nil)
    }
}

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let index = TransactionsData.transactions.count - indexPath.row - 1
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            self.context.delete(TransactionsData.transactions[index])
            TransactionsData.transactions.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do{
                try self.context.save()
            } catch {
                print("Error with \(error)")
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [ deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TransactionsData.transactions.count
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = (view.frame.height - 290)/20
        return CGFloat(size)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier,
            for: indexPath) as?     CustomTableViewCell
        else {
            return UITableViewCell()
        }
        
        let index = TransactionsData.transactions.count - indexPath.row - 1
        designCell(index: index, cell: cell)
        return cell
    }
}

extension TransactionsViewController: UpdateTableViewProtocol {
    func updateTableView() {
//        sumTheBalance()
        transactionsTableView.reloadData()
    }
}
