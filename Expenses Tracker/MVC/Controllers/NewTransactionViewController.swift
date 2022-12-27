import UIKit
import CoreData

protocol UpdateTableViewProtocol: AnyObject{
    func updateTableView()
}

final class NewTransactionViewController: UIViewController {
    
    // MARK: - Properties
    private var category: String? = nil
    
    weak var delegate: UpdateTableViewProtocol?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    // MARK: - Layout
    
    private func setupView() {
        addSubviews()
        configureNavBar()
        configureTextFields()
        configureButtons()
        
        activateLayout()
        
        view.backgroundColor = .white
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        view.addSubview(categoryLabel)
        view.addSubview(counterTextField)
        view.addSubview(categorySegmentationControl)
        view.addSubview(addTransactionButton)
    }
    
    private func configureNavBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 25)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        title = "New transaction"
        
        let image = UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(dismissButton))
    }
    
    private func configureTextFields() {
        counterTextField.delegate = self
    }
    
    private func configureButtons() {
        addTransactionButton.addTarget(self, action: #selector(readyButtonPressed), for: .touchUpInside)
        categorySegmentationControl.addTarget(self, action: #selector(segmentDidChange(_:)), for: .valueChanged)
    }
    
    private func activateLayout(){
        NSLayoutConstraint.activate([
            
            categoryLabel.topAnchor.constraint(equalTo: counterTextField.bottomAnchor, constant: 20),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryLabel.heightAnchor.constraint(equalToConstant: 60),
            
            counterTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            counterTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            counterTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            counterTextField.heightAnchor.constraint(equalToConstant: 120),
            
            categorySegmentationControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categorySegmentationControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categorySegmentationControl.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            
            categorySegmentationControl.heightAnchor.constraint(equalToConstant: 60),
            
            addTransactionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTransactionButton.topAnchor.constraint(equalTo: categorySegmentationControl.bottomAnchor, constant: 30),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 70),
            addTransactionButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func segmentDidChange(_ segmentationControl: UISegmentedControl){
        switch segmentationControl.selectedSegmentIndex {
        case 0:
            category = "groceries"
        case 1:
            category = "taxi"
        case 2:
            category = "electronics"
        case 3:
            category = "restaurant"
        case 4:
            category = "other"
        default:
            category = nil
        }
    }
    
    @objc private func readyButtonPressed(){
        if category == nil {
            categorySegmentationControl.layer.borderColor = UIColor.systemRed.cgColor
            categorySegmentationControl.layer.borderWidth = 2
        } else {
            categorySegmentationControl.layer.borderWidth = 0
        }
        
        if counterTextField.text == "" {
            counterTextField.layer.borderColor = UIColor.systemRed.cgColor
            counterTextField.layer.borderWidth = 2
        } else {
            counterTextField.layer.borderWidth = 0
        }

        if  counterTextField.text != "" && category != nil {
            let newTransaction = Transaction(context: context)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let present = Date()
            
            newTransaction.date = dateFormatter.string(from: present)
            newTransaction.category = category
            newTransaction.amount = Int32(-Int(counterTextField.text!)!)
            do{
                try context.save()
            } catch {
                print("Error with \(error)")
            }
            TransactionsData.transactions.append(newTransaction)
            delegate?.updateTableView()
            dismiss(animated: true)
        }
        
    }
    
    @objc private func dismissButton(){
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
        label.font = UIFont(name: "Montserrat-SemiBold", size: 23)
        label.textColor = .black
        
        return label
    }()
    
    
    private let counterTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the amount",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.font = UIFont(name: "Montserrat-Bold", size: 25)
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
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 20)
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
