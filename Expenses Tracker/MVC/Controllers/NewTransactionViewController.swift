import UIKit
import CoreData

protocol UpdateTableViewProtocol: AnyObject{
    func updateTableView()
}

final class NewTransactionViewController: UIViewController {
    
    // MARK: - Properties
    
    var currentBalance = 0
    
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
//        configureTextFields()
        configureButtons()
        
        activateLayout()
        
        view.backgroundColor = .white
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        view.addSubview(attitudeLabel)
        view.addSubview(counterTextField)
        view.addSubview(readyButton)
    }
    
    private func configureNavBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 25)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        title = "New transaction"
        
        let image = UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(dismissButton))
    }
    
//    private func configureTextFields() {
//        attitudeTextView.delegate = self
//        headerTextField.delegate = self
//        counterTextField.delegate = self
//    }
    
    private func configureButtons() {
        readyButton.addTarget(self, action: #selector(readyButtonPressed), for: .touchUpInside)
    }
    
    private func activateLayout(){
        NSLayoutConstraint.activate([
            
            attitudeLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
            attitudeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            attitudeLabel.heightAnchor.constraint(equalToConstant: 56),
            attitudeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 60),
            
            counterTextField.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 40),
            counterTextField.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            counterTextField.heightAnchor.constraint(equalToConstant: 40),
            counterTextField.widthAnchor.constraint(equalToConstant: 60),
            
            readyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readyButton.bottomAnchor.constraint(equalTo: counterTextField.bottomAnchor, constant: view.bounds.size.height/6.5),
            readyButton.heightAnchor.constraint(equalToConstant: 65),
            readyButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    @objc private func readyButtonPressed(){

        if  counterTextField.text != "" {
//            let newAttitude = Attitude(context: context)
//            newAttitude.attitude = attitudeTextView.text!
//            do{
//                try context.save()
//            } catch {
//                print("Error with \(error)")
//            }
//            Attitudes.attitudes.append(newAttitude)
//            delegate?.updateTableView()
//            dismiss(animated: true)
        }
        
    }
    
    @objc private func dismissButton(){
        dismiss(animated: true)
    }
    
    // MARK: - UI Elements
    

    
    private let attitudeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Category"
        label.font = UIFont(name: "Montserrat-Medium", size: 22)
        label.textColor = .black
        
        return label
    }()
    
    
    private let counterTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false

        text.textColor = .black
        text.attributedPlaceholder = NSAttributedString(
            string: "100",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        text.font = UIFont(name: "Montserrat-Regular", size: 25)
        text.backgroundColor = UIColor(hexString: "f4f4f4")
        text.layer.cornerRadius = 4
        text.keyboardType = .numberPad
        text.textAlignment = .center
        
        return text
    }()
    
    private let readyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Add", for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 20)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        
        return button
    }()
    
}

//// MARK: - UITextFieldDelegate
//extension NewTransactionViewController: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if counterTextField.isFirstResponder {
//            if textField.text?.count == 0 && string == "0" {
//                return false
//            }
//
//            if ((textField.text!) + string).count > 3 {
//                return false
//            }
//
//            let allowedCharacterSet = CharacterSet.init(charactersIn: "0123456789.")
//            let textCharacterSet = CharacterSet.init(charactersIn: textField.text! + string)
//
//            if !allowedCharacterSet.isSuperset(of: textCharacterSet) {
//                return false
//            }
//
//            return true
//        } else if headerTextField.isFirstResponder {
//            let maxLength = 40
//            let currentString = (textField.text ?? "") as NSString
//            let newString = currentString.replacingCharacters(in: range, with: string)
//
//            return newString.count <= maxLength
//        }
//
//        return true
//    }
//
//}
