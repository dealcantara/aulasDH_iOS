//
//  AddCreditCardVC.swift
//  MyBank
//
//  Created by Felipe Miranda on 17/11/20.
//

import UIKit
import Lottie


protocol AddCreditCardVCDelegate: class {
    
    func successSaveCreditCard(card: CartoesElement?)
    
}



class AddCreditCardVC: BaseViewController {
    
    private var dateView: UIPickerView?
    //private var months: [String] = Calendar.current.monthSymbols
    private var months: [String] = []
    private var years: [String] = []
    
    

    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberCardTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var flagSegmented: UISegmentedControl!
    
    @IBOutlet weak var photoButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!

    
    weak var delegate: AddCreditCardVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configDelegates()
        self.configLayoutScreen()
        
        self.configDateView()
        self.loadYears()
        self.loadMonth()
        
        self.showLoading()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    @IBAction func tappedSelectFlagSegmented(_ sender: UISegmentedControl) {
        
    }
    
    
    @IBAction func tappedPhotoButton(_ sender: UIButton) {
        
        let alert: UIAlertController = UIAlertController(title: "Adicionar Foto", message: "Onde deseja pegar sua foto?", preferredStyle: .actionSheet)
        
        let photoButton: UIAlertAction = UIAlertAction(title: "Fotos", style: .default) { (action) in
            
            print("Tocou no botão álbum!")
        }
        
        let cameraButton: UIAlertAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
            
            print("Tocou no botão camera!")
            
        }
        
        let cancelButton: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            
            print("Tocou no botão cancelar!")
            
        }
        
        alert.addAction(photoButton)
        alert.addAction(cameraButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func tappedSaveButton(_ sender: UIButton) {
        
        if self.checkFields() {
            
            self.showAlert(title: "Parabéns", message: "Cadastro realizado com sucesso", isDismiss: true)
            print("deu bom pode salvar")
            
            self.delegate?.successSaveCreditCard(card: self.saveCreditCard())
            
            
        } else {
            
            self.showAlert(title: "Ops...", message: "Todos os campos devem ser preenchidos! :)")
            print("deu ruim nao vamos salvar")
            
        }
    }
    
    
    
    
    func showAlert(title: String, message: String, isDismiss: Bool = false){
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let button: UIAlertAction = UIAlertAction(title: "ok", style: .default) { (action) in
            
            if isDismiss {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    private func configDelegates(){
        
        self.nameTextField.delegate = self
        self.numberCardTextField.delegate = self
        self.dateTextField.delegate = self
        
    }
    
    private func configLayoutScreen() {
        
        self.saveButton.layer.cornerRadius = 4
        self.photoButton.layer.cornerRadius = 4
        
        self.nameTextField.layer.borderWidth = 0.5
        self.numberCardTextField.layer.borderWidth = 0.5
        self.dateTextField.layer.borderWidth = 0.5
        
        self.nameTextField.layer.borderColor = UIColor.red.cgColor
        self.numberCardTextField.layer.borderColor = UIColor.red.cgColor
        self.dateTextField.layer.borderColor = UIColor.red.cgColor
        
        self.nameTextField.layer.cornerRadius = 4
        self.numberCardTextField.layer.cornerRadius = 4
        self.dateTextField.layer.cornerRadius = 4
    }
    
    
    private func checkFields() -> Bool {
        
        if self.nameTextField.text?.isEmpty ?? true {
            return false
        }else if self.numberCardTextField.text?.isEmpty ?? true {
            return false
        }else if self.dateTextField.text?.isEmpty ?? true {
            return false
        }else if self.flagSegmented.selectedSegmentIndex == -1 {
            return false
        }
        
        return true
    }
    
    
    
    
    
    private func saveCreditCard() -> CartoesElement? {
        
        let card: CartoesElement? = CartoesElement(
            id: String(Int.random(in: 1...1000)),
            nome: self.nameTextField.text ?? "",
            data: self.dateTextField.text ?? "",
            numero: self.numberCardTextField.text ?? "",
            bandeira: Flag.loadFlag(index: self.flagSegmented.selectedSegmentIndex).rawValue)
        
        return card
    }
    
    
    private func configToolBar(){
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.backgroundColor = UIColor.red
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Pronto", style: .plain, target: self, action: #selector(doneClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.dateTextField.inputAccessoryView = toolBar
        
        
    }
    
    
    @objc private func cancelClick(){
        
        self.dateTextField.resignFirstResponder()
        
    }
    
    
    @objc private func doneClick(){
        
        let monthSelected = self.dateView?.selectedRow(inComponent: 0) ?? 0
        let yearSelected = self.dateView?.selectedRow(inComponent: 1) ?? 0
        
        self.dateTextField.text = "\(months[monthSelected])/\(years[yearSelected])"
        
        self.dateTextField.resignFirstResponder()
        
        
    }
    
    
    private func loadYears() {
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        
        self.years = (currentYear...2100).map {String($0)}
        
        
    }
    
    
    private func loadMonth() {

        self.months = (1...12).map {String($0)}
        
    }
    
    
    private func configDateView() {
        
        self.dateView = UIPickerView()
        self.dateView?.delegate = self
        self.dateView?.dataSource = self
        
        self.dateView?.backgroundColor = .red
        self.dateView?.setValue(UIColor.white, forKey: "textColor")
        self.dateTextField.inputView = self.dateView
        
        self.configToolBar()
        
        
    }
    
    
}


extension AddCreditCardVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.nameTextField:
            self.numberCardTextField.becomeFirstResponder()
        case self.numberCardTextField:
            self.dateTextField.becomeFirstResponder()
        case self.dateTextField:
            self.dateTextField.resignFirstResponder()
            
        default: break
        }
        
        return true
    }
}


extension AddCreditCardVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return self.months.count
            
        } else {
            
            return self.years.count
            
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            return self.months[row]
            
        } else {
            
            return self.years[row]
            
        }
        
    }
}
