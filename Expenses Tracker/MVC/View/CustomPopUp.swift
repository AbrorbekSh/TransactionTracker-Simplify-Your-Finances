
import UIKit

class CustomPopUp: NSObject {
    
    weak private var controller : TransactionsViewController!
    private var addedAmount = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .black
        view.alpha = 0
        
        return view
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F3F3F3")
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    func showAlert(on viewController: TransactionsViewController){
        guard let targetView = viewController.view else {
            return
        }
        controller = viewController
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        
        alertView.frame = CGRect(x: 30,
                                 y: (backgroundView.frame.size.height - 300)/2,
                                 width: backgroundView.frame.size.width-60,
                                 height: 300)
        
        let titleLabel = UILabel(frame: CGRect(x: 37,
                                               y: 16,
                                               width: alertView.frame.size.width - 74,
                                               height: 36))
        titleLabel.text = "Add to the balance"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 25)
        titleLabel.textColor = .black
        titleLabel.backgroundColor = UIColor(hexString: "#F3F3F3")
        titleLabel.textAlignment = .center
        
        let okButton = UIButton(frame: CGRect(x: (alertView.frame.size.width - 310)/2,
                                               y: (alertView.frame.size.height-76),
                                               width: 145,
                                               height: 60))
        okButton.setTitle("Ok", for: .normal)
        okButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 22)
        okButton.setTitleColor( UIColor.black, for: .normal)
        okButton.layer.cornerRadius = 30
        okButton.backgroundColor = .white
        okButton.layer.borderWidth = 3
        okButton.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
        
        okButton.addTarget(self, action: #selector(yesPressed), for: .touchUpInside)
        
        let cancelButton = UIButton(frame: CGRect(x: (alertView.frame.size.width - 310)/2 + okButton.frame.size.width + 20,
                                               y: (alertView.frame.size.height-76),
                                               width: 145,
                                               height: 60))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 22)
        cancelButton.setTitleColor( UIColor.black, for: .normal)
        cancelButton.layer.cornerRadius = 30
        cancelButton.backgroundColor = .white
        cancelButton.layer.borderWidth = 3
        cancelButton.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
        
        cancelButton.addTarget(self, action: #selector(yesPressed), for: .touchUpInside)
        
        let textField = UITextField(frame: CGRect(x: (alertView.frame.size.width - 250)/2,
                                                  y: (alertView.frame.size.height - 80)/2 - 10,
                                                  width: 250,
                                                  height: 80))
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the amount",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.font = UIFont(name: "Montserrat-SemiBold", size: 25)
        textField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 4
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        
        alertView.addSubview(titleLabel)
        alertView.addSubview(okButton)
        alertView.addSubview(cancelButton)
        alertView.addSubview(textField)
        textField.delegate = self

        
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0.6
        })
    }
    
    @objc func yesPressed(){
        
        if addedAmount != 0{
            
            let newTransaction = Transaction(context: context)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .medium
            let present = Date()
            
            newTransaction.date = dateFormatter.string(from: present)
            newTransaction.category = nil
            newTransaction.amount = Int32(-addedAmount)
            do{
                try context.save()
            } catch {
                print("Error with \(error)")
            }
            Transactions.transactions.append(newTransaction)
            
            controller.currentBalance = controller.currentBalance + addedAmount
            controller.balanceLabel.text = " \(controller.currentBalance) $"
            controller.transactionsTableView.reloadData()
            addedAmount = 0
            
            self.alertView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        }
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
            addedAmount = Int(currentString + string) ?? 0
            
            return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
}