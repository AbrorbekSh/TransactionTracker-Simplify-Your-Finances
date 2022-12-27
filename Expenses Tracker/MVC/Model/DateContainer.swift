// To be implemented in the future :)

//import UIKit
//
//class DateContainer {
//    static var date: DateForBitcoin? = nil
//}

//DispatchQueue.global().async {
//    let request : NSFetchRequest<DateForBitcoin> = DateForBitcoin.fetchRequest()
//    do {
//        DateContainer.date = try self.dateContext.fetch(request).first
//    } catch {
//        print("Error fetching data from context \(error)")
//    }
//    if let date = DateContainer.date?.lastEntryDate {
//
//        let currentDate = Date()
//        if date.get(.hour) == currentDate.get(.hour){
//            self.bitcoinValue = DateContainer.date?.lastEntryBitcoinPrice
//        } else {
//            let value = self.service.fetchData()
//
//            DispatchQueue.main.async {
//                if let value = value {
//                    self.bitcoinValue = value
//                    self.bitcoinLabel.text = "Bitcoin:\n\(value)"
//                    self.dateContext.delete(DateContainer.date!)
//                    let newDate = DateForBitcoin(context: self.dateContext)
//                    newDate.lastEntryDate = Date()
//                    newDate.lastEntryBitcoinPrice = value
//                    do{
//                        try self.dateContext.save()
//                    } catch {
//                        print("Error with \(error)")
//                    }
//                }
//            }
//        }
//    } else {
//        let value = self.service.fetchData()
//        DispatchQueue.main.async {
//            if let value = value {
//                self.bitcoinValue = value
//                self.bitcoinLabel.text = "Bitcoin:\n\(value)"
//            }
//        }
//        if let value = value {
//            let newDate = DateForBitcoin(context: self.dateContext)
//            newDate.lastEntryDate = Date()
//            newDate.lastEntryBitcoinPrice = value
//            do{
//                try self.dateContext.save()
//            } catch {
//                print("Error with\(error)")
//            }
//        }
//    }
//}
