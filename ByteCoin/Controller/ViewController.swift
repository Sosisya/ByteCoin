import UIKit

class ViewController: UIViewController {

    var coinManager = CoinManager()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 50)
        label.textAlignment = .center
        label.text = "ByteCoin"
        return label
    }()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 40
        return contentView
    }()

    private let convertStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution  = .fill
        stackView.spacing = 10
        return stackView
    }()


    private let bitcoinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "bitcoinsign.circle.fill")
        imageView.tintColor = .white
        return imageView
    }()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .right
        label.text = "..."
        return label
    }()

    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        label.text = CoinManager().currencyArray[0]
        return label
    }()

    private let currencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupLayout()
        setupConstraint()
        coinManager.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    func setupLayout() {
        view.addSubview(headerLabel)
        view.addSubview(contentView)
        contentView.addSubview(convertStackView)
        convertStackView.addArrangedSubview(bitcoinImage)
        convertStackView.addArrangedSubview(resultLabel)
        convertStackView.addArrangedSubview(currencyLabel)
        view.addSubview(currencyPicker)
    }
}


extension ViewController {
    func setupConstraint() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 80),

            contentView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),

            convertStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            convertStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            convertStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            convertStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            bitcoinImage.widthAnchor.constraint(equalToConstant: 80),
            bitcoinImage.heightAnchor.constraint(equalToConstant: 80),

            currencyPicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            currencyPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currencyPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currencyPicker.heightAnchor.constraint(equalToConstant: 216)
        ])
    }
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}


extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.resultLabel.text = price
            self.currencyLabel.text = currency
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}
