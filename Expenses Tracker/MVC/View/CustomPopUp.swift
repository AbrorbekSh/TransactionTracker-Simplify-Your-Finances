
import UIKit

final class CustomPopUp: NSObject {
    
    unowned private var controller : TransactionsViewController!
    
    //MARK: - UI elements
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .black
        view.alpha = 0
        
        return view
    }()
    
    private let popUpView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F3F3F3")
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    func showPopUp(on viewController: TransactionsViewController){

        controller = viewController
        guard let targetView = controller.view else {
            return
        }
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(popUpView)
        
        //UI elements via frame
        popUpView.frame = CGRect(
            x: 30,
            y: (backgroundView.frame.size.height - 300)/2,
            width: backgroundView.frame.size.width-60,
            height: 300)
        
        let titleLabel = UILabel(frame: CGRect(
            x: 37,
            y: 16,
            width: popUpView.frame.size.width - 74,
            height: 36))
        
        
        let okButton = UIButton(frame: CGRect(
            x: (popUpView.frame.size.width - 310)/2,
            y: (popUpView.frame.size.height-76),
            width: 145,
            height: 60))
        
        let cancelButton = UIButton(frame: CGRect(
            x: (popUpView.frame.size.width - 310)/2 + okButton.frame.size.width + 20,
            y: (popUpView.frame.size.height-76),
            width: 145,
            height: 60))
        
        let textField = UITextField(frame: CGRect(
            x: (popUpView.frame.size.width - 250)/2,
            y: (popUpView.frame.size.height - 80)/2 - 10,
            width: 250,
            height: 80))
        
        titleLabel.text = "Add to the balance"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.customFont(type: .bold, size: 25)
        titleLabel.textColor = .black
        titleLabel.backgroundColor = UIColor(hexString: "#F3F3F3")
        titleLabel.textAlignment = .center
        
        okButton.setTitle("Ok", for: .normal)
        okButton.titleLabel?.font = UIFont.customFont(type: .bold, size: 22)
        okButton.setTitleColor( UIColor.black, for: .normal)
        okButton.layer.cornerRadius = 30
        okButton.backgroundColor = .white
        okButton.layer.borderWidth = 3
        okButton.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
        okButton.addTarget(self, action: #selector(okPressed), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.customFont(type: .bold, size: 22)
        cancelButton.setTitleColor( UIColor.black, for: .normal)
        cancelButton.layer.cornerRadius = 30
        cancelButton.backgroundColor = .white
        cancelButton.layer.borderWidth = 3
        cancelButton.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the amount",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.font = UIFont.customFont(type: .semibold, size: 25)
        textField.backgroundColor = UIColor(hexString: "#89CFEF")
        textField.layer.cornerRadius = 4
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.delegate = self
        
        popUpView.addSubview(titleLabel)
        popUpView.addSubview(okButton)
        popUpView.addSubview(cancelButton)
        popUpView.addSubview(textField)

        self.backgroundView.alpha = 0.6
    }
    
    @objc func okPressed(){
        if AddedAmount.addedAmount != 0 {
            CoreDataService.createNewTransaction(amount: Int32(Int(exactly: AddedAmount.addedAmount)!))
            
            controller.updateBalanceLabel()
            controller.transactionsTableView.reloadData()
            AddedAmount.addedAmount = 0
            
            self.popUpView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        }
    }
    
    @objc private func cancelPressed(){
        AddedAmount.addedAmount = 0
        self.popUpView.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
    }
}

extension CustomPopUp: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            print(textField.text!)
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
            AddedAmount.addedAmount = Int(currentString + string) ?? 0
            
            return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
}
