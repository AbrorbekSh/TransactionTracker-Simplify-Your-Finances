import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: CustomTableViewCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private let newView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0.4
        return view
    }()
    
    let transactionAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(newView)
        contentView.addSubview(transactionAmountLabel)
        newView.clipsToBounds = false
        let size = 15
        let gradient = makeGradient()
        newView.layer.addSublayer(gradient)
        newView.layer.cornerRadius = CGFloat(size)
        activateLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func makeGradient() -> CAGradientLayer{
        let gradient = CAGradientLayer()
//        #ee9ca7 → #ffdde1 Pink gradient
        gradient.frame = newView.bounds
        let color1 = UIColor(hexString: "#2193b0")
        let color2 = UIColor(hexString: "#6dd5ed")
        gradient.colors = [
            color1.cgColor,
            color2.cgColor,
        ]
        return gradient
    }

    
    private func activateLayout(){
        NSLayoutConstraint.activate([
            newView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.5),
            newView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.5),
            newView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            newView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            transactionAmountLabel.centerYAnchor.constraint(equalTo: newView.centerYAnchor),
            transactionAmountLabel.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 20),
            transactionAmountLabel.widthAnchor.constraint(equalToConstant: newView.frame.width-40),
        ])
    }
}
