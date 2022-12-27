import UIKit
import CoreData

protocol UpdateTableViewProtocol: AnyObject{
    func updateTableView()
}

final class NewTransactionViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let horizontalMargin: CGFloat = 20
        static let addTransactionButtonWidth: CGFloat = 200
        static let addTransactionButtonHeight: CGFloat = 70
        static let categoryLabelHeight: CGFloat = 60
        static let amountTextFieldHeight: CGFloat = 120
        static let categorySegmentationControlHeight: CGFloat = 90
    }
    
    // MARK: - Delegates
    
    weak var delegate: UpdateTableViewProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    // MARK: - Layout related methods
    
    private func setupView() {
        addSubviews()
        configureNavigationBar()
        configureTextFields()
        configureButtons()
        
        activateLayout()
        
        view.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.addSubview(categoryLabel)
        view.addSubview(amountTextField)
        view.addSubview(categorySegmentationControl)
        view.addSubview(addTransactionButton)
    }
    
    private func configureTextFields() {
        amountTextField.delegate = self
    }
    
    private func configureButtons() {
        addTransactionButton.addTarget(self, action: #selector(readyButtonPressed), for: .touchUpInside)
        categorySegmentationControl.addTarget(self, action: #selector(segmentDidChange(_:)), for: .valueChanged)
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.customFont(type: .semibold, size: 25),
            NSAttributedString.Key.foregroundColor: UIColor.black]
        title = "New transaction"
        
        let image = UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(dismissButton))
    }
    
    private func activateLayout(){
        NSLayoutConstraint.activate([
            
            categoryLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryLabel.heightAnchor.constraint(equalToConstant: Constants.categoryLabelHeight),
            
            amountTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            amountTextField.heightAnchor.constraint(equalToConstant: Constants.amountTextFieldHeight),
            
            categorySegmentationControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categorySegmentationControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categorySegmentationControl.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            
            categorySegmentationControl.heightAnchor.constraint(equalToConstant: Constants.categorySegmentationControlHeight),
            
            addTransactionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTransactionButton.topAnchor.constraint(equalTo: categorySegmentationControl.bottomAnchor, constant: 30),
            addTransactionButton.heightAnchor.constraint(equalToConstant: Constants.addTransactionButtonHeight),
            addTransactionButton.widthAnchor.constraint(equalToConstant: Constants.addTransactionButtonWidth)
        ])
    }
    
    //MARK: - Private Methods
    
    private func checkUserInput(){
        if Category.category == nil {
            categorySegmentationControl.layer.borderColor = UIColor.systemRed.cgColor
            categorySegmentationControl.layer.borderWidth = 2
        } else {
            categorySegmentationControl.layer.borderWidth = 0
        }
        
        if amountTextField.text == "" {
            amountTextField.layer.borderColor = UIColor.systemRed.cgColor
            amountTextField.layer.borderWidth = 2
        } else {
            amountTextField.layer.borderWidth = 0
        }
    }
    
    //MARK: - ObjectiveC methods
    
    @objc private func segmentDidChange(_ segmentationControl: UISegmentedControl){
        switch segmentationControl.selectedSegmentIndex {
        case 0:
            Category.category = "groceries"
        case 1:
            Category.category = "taxi"
        case 2:
            Category.category = "electronics"
        case 3:
            Category.category = "restaurant"
        case 4:
            Category.category = "other"
        default:
            Category.category = nil
        }
    }
    
    @objc private func readyButtonPressed(){
        checkUserInput()
        
        if  amountTextField.text != "" && Category.category != nil {
            
            if let amount = amountTextField.text {
                CoreDataService.createNewTransaction(amount: -Int32(Int(amount)!))
            }
            Category.category = nil
            delegate?.updateTableView()
            dismiss(animated: true)
        }
    }
    
    @objc private func dismissButton(){
        Category.category = nil
        dismiss(animated: true)
    }
    
    // MARK: - UI Elements
    
    private let categorySegmentationControl: UISegmentedControl = {
        let items = ["grocceries", "taxi", "electronics", "restaurant", "other"]
        
        let segment = UISegmentedControl(items: items)
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        segment.selectedSegmentTintColor = UIColor.systemBlue.withAlphaComponent(0.8)
        segment.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        
        return segment
    }()

    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Category"
        label.font = UIFont.customFont(type: .semibold, size: 23)
        label.textColor = .black
        
        return label
    }()
    
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the amount",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.font = UIFont.customFont(type: .bold, size: 25)
        textField.adjustsFontSizeToFitWidth = true
        textField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 4
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        
        return textField
    }()
    
    private let addTransactionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Add transaction", for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.customFont(type: .bold, size: 20)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        
        return button
    }()
    
}

// MARK: - UITextFieldDelegate
extension NewTransactionViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString = textField.text ?? ""

            if currentString.count == 0 && string == "0" {
                return false
            }

            if (currentString + string).count > 7 {
                return false
            }

            let allowedCharacterSet = CharacterSet.init(charactersIn: "0123456789")
            let textCharacterSet = CharacterSet.init(charactersIn: currentString + string)

            if !allowedCharacterSet.isSuperset(of: textCharacterSet) {
                return false
            }

            return true
    }
}
