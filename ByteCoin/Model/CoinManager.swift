import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"

    let apiKey = "856F342E-E7C6-48CE-9B7F-208420B78900"

    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]


    func getCoinPrice(for currency: String) {

        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)

        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }

            if let safeData = data {
                if let bitcoinPrice = self.parseJSON(safeData) {
                    let priceString = String(format: "%.2f", bitcoinPrice)
                    self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                }
            }
        }
        task.resume()
    }

    func parseJSON(_ coinData: Data) -> Double? {
        let decodable = JSONDecoder()
        do {
            let decodedData = try decodable.decode(CoinData.self, from: coinData)
            let lastPrice = decodedData.rate
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

