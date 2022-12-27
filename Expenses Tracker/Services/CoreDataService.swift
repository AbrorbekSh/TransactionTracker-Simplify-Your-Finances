
import UIKit
import CoreData

final class CoreDataService {
    
    static private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func makeRequestForTransactions(){
        let request : NSFetchRequest<Transaction> = Transaction.fetchRequest()
        do {
            TransactionsData.transactions = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    static func deleteTheTransaction(at index: Int){
        context.delete(TransactionsData.transactions[index])
        TransactionsData.transactions.remove(at: index)
        
        saveContext()
    }
    
    static func createNewTransaction(amount: Int32){
        let newTransaction = Transaction(context: context)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let present = Date()
        
        newTransaction.date = dateFormatter.string(from: present)
        newTransaction.category = Category.category
        
        newTransaction.amount = amount
        saveContext()
        
        TransactionsData.addToTheBalance(amount: Int(exactly: amount)!)
        TransactionsData.transactions.append(newTransaction)
    }
    
    private static func saveContext(){
        do{
            try self.context.save()
        } catch {
            print("Error with \(error)")
        }
    }
}
