import UIKit

struct Response: Codable {
    let bpi: Values
}

struct Values: Codable {
    let USD: Description
}

struct Description: Codable {
    let rate_float: Double
}
