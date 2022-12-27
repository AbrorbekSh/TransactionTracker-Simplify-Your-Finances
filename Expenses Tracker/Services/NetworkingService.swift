
import UIKit

class NetworkingService {
    static private let url = "https://api.coindesk.com/v1/bpi/currentprice.json"
    
    static func fetchData() -> Double? {
        var double: Double? = nil
        
        let group = DispatchGroup()
        group.enter()
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch {
                print("\(error.localizedDescription)")
            }
            guard let json = result else {
                return
            }
            double = json.bpi.USD.rate_float
            group.leave()
        }
                                                
        
        task.resume()
        group.wait()
        
        return double
    }
}

