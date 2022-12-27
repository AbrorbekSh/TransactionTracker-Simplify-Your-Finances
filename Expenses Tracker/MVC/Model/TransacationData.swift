import UIKit
import CoreData

struct TransactionsData{
    static var currentBalance = 0
    static var transactions: [Transaction] = []
    
    static func addToTheBalance(amount: Int){
        currentBalance = currentBalance + amount
    }
}
