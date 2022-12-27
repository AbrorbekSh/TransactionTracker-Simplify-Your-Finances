import UIKit
import CoreData

final class TransactionsViewController: UIViewController {
    
    // MARK: - Constants, Texts
    
    private enum Constants {
        static let horizontalMargin: CGFloat = 20
        static let tableViewTopAnchor: CGFloat = 290
        static let historyLabelWidth: CGFloat = 140
        static let balanceLabelHeight: CGFloat = 90
        static let addButtonSize: CGFloat = 60
    }
    
    private enum Texts {
        static let navigationBarTitle = "Balance:"
        static let addTransactionButtonTitle = "Add transaction"
        static let transactionHistoryLabel = "Transaction history"
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBitcoinPrice() // Fetchs data and updates Bitcoin label
        CoreDataService.makeRequestForTransactions() //Requests CoreData for transactions
        calculateTheBalance() //Calculates the balance by iteration through all transactions
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        activateLayout()
    }
    
    // MARK: - UI related methods
    
    private func setupView() {
        
        addSubviews()
        configureTableView()
        configureButtons()
        view.backgroundColor = .white
    }
    
    private func addSubviews(){
        [transactionsTableView, addButton, balanceLabel, addTransactionButton, historyLabel, bitcoinLabel].forEach{
            view.addSubview($0)
        }
    }
    
    private func configureTableView(){
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
    }
    
    private func configureButtons(){
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addTransactionButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.customFont(type: .semibold, size: 25),
            NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        title = Texts.navigationBarTitle
    }
    
    private func designCell(index: Int, cell: CustomTableViewCell){
        if traitCollection.userInterfaceStyle == .dark {
            cell.backgroundColor = .label
        }
        cell.transactionAmountLabel.text = "\(TransactionsData.transactions[index].amount) $"
        cell.dateLabel.text = TransactionsData.transactions[index].date
        if let category = TransactionsData.transactions[index].category {
            cell.categoryLabel.text = category
        } else {
            cell.categoryLabel.text = ""
        }
        cell.selectionStyle = .none
    }
    
    func updateBalanceLabel(){
        balanceLabel.text = " \(TransactionsData.currentBalance) $"
    }
    
    private func activateLayout(){
        NSLayoutConstraint.activate([
            
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            transactionsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.tableViewTopAnchor),
            
            historyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalMargin),
            historyLabel.heightAnchor.constraint(equalToConstant: 20),
            historyLabel.topAnchor.constraint(equalTo: addTransactionButton.bottomAnchor, constant: 5),
            historyLabel.widthAnchor.constraint(equalToConstant: Constants.historyLabelWidth),
            
            balanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            balanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalMargin),
            balanceLabel.heightAnchor.constraint(equalToConstant: Constants.balanceLabelHeight),
            balanceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            
            addTransactionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 70),
            addTransactionButton.widthAnchor.constraint(equalToConstant: 200),
            addTransactionButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 15),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalMargin),
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            addButton.heightAnchor.constraint(equalToConstant: Constants.addButtonSize),
            addButton.widthAnchor.constraint(equalToConstant: Constants.addButtonSize),
            
            bitcoinLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalMargin),
            bitcoinLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            bitcoinLabel.heightAnchor.constraint(equalToConstant: 40),
            bitcoinLabel.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    

    // MARK: - Private Methods
    
    private func updateBitcoinPrice(){
        DispatchQueue.global().async {
            let value = NetworkingService.fetchData()
            DispatchQueue.main.async {
                if let value = value {
                    BitcoinData.bitcoinValue = value
                    self.bitcoinLabel.text = "Bitcoin:\n\(value)"
                }
            }
        }
    }
    
    private func calculateTheBalance(){
        TransactionsData.currentBalance = 0
        for transaction in TransactionsData.transactions {
            TransactionsData.addToTheBalance(amount: Int(transaction.amount))
        }
    }
    
    private func removeFromBalance(index: Int){
        let toRemove = TransactionsData.transactions[index].amount
        TransactionsData.addToTheBalance(amount: -Int(toRemove))
        updateBalanceLabel()
    }
    
    // MARK: - @objc methods
    
    @objc private func addTransaction(){
        let vc = NewTransactionViewController()
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(nav, animated: true, completion: nil)
    }
    
    private let customPopUp = CustomPopUp()
    @objc private func addButtonPressed(){
        customPopUp.showPopUp(on: self)
    }
    
    // MARK: - UI Elements
    
    private lazy var bitcoinLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        if let bitcoinValue = BitcoinData.bitcoinValue {
            label.text = "Bitcoin:\n\(bitcoinValue)"
        } else {
            label.text = "Bitcoin:\nLoading..."
        }
        label.font = UIFont.customFont(type: .medium, size: 14)
        
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemGray
        
        label.backgroundColor = .clear
        label.textAlignment = .center
        
        label.numberOfLines = 2
        
        return label
    }()
    
    private let  historyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = Texts.transactionHistoryLabel
        label.font = UIFont.customFont(type: .regular, size: 15)
        label.textColor = .systemGray
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        label.backgroundColor = .clear
  
        return label
    }()
    
    private let addTransactionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(Texts.addTransactionButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.customFont(type: .bold, size: 20)

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
        label.font = .customFont(type: .bold, size: 25)
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
        
        var customConfiguration = UIButton.Configuration.filled()
        customConfiguration.image = UIImage(systemName: "plus",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        customConfiguration.cornerStyle = .capsule
        button.configuration = customConfiguration
        button.tintColor = .systemBlue
        
        return button
    }()
    
}
//MARK: -TableView Extension

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate{
    
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
            for: indexPath) as? CustomTableViewCell
        else {
            return UITableViewCell()
        }
        let index = TransactionsData.transactions.count - indexPath.row - 1
        designCell(index: index, cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let index = TransactionsData.transactions.count - indexPath.row - 1
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            
            self.removeFromBalance(index: index)
            CoreDataService.deleteTheTransaction(at: index)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
}

//MARK: -Protocol Extensions
extension TransactionsViewController: UpdateTableViewProtocol {
    func updateTableView() {
        transactionsTableView.reloadData()
        updateBalanceLabel()
    }
}
