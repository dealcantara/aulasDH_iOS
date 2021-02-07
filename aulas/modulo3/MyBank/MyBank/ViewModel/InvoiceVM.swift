//
//  InvoiceVM.swift
//  MyBank
//
//  Created by Elder Alcantara on 05/11/20.
//

import Foundation


class InvoiceVM {
    
    private var cardID: String? = ""
    
    private var cardListElement: CardListElement?
    
    private var currentInvoice: Invoice?
    
    init(cardId: String?, cardListElement: CardListElement?, currentInvoice: Invoice? = nil ) {
        
        self.cardID = cardId
        self.cardListElement = cardListElement
        self.currentInvoice = currentInvoice
    }
    
    func loadCardListElement() {
        
        if let path = Bundle.main.path(forResource: "invoice", ofType: "json"){
            
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let cardList = try JSONDecoder().decode(CardList.self, from: data)
                
                print("=======>cardList\(cardList)")
                
                let list = cardList.cardList?.filter({$0.cardID == self.cardID ?? ""})
                
                self.cardListElement = list?.first
                
            }catch{
                print("Deu ruim no parse")
            }
        }
    }
    
    
    var numberOfRows: Int {
        return self.cardListElement?.invoice?.count ?? 0
    }
    
    func loadCurrentInvoice(index: Int) {
        self.currentInvoice = self.cardListElement?.invoice?[index]
    }
    
    var id: String {
        return self.currentInvoice?.id ?? ""
    }
    
    var nome: String {
        return self.currentInvoice?.nome ?? ""
    }
    
    var data:String {
        return self.currentInvoice?.data ?? ""
    }
    
    var valor:String{
        return "R$ \(String(format: "%.2f", self.currentInvoice?.valor ?? 0))"
    }
    
    var tipo: Tipo {
        
        if let _tipo = self.currentInvoice?.tipo {
            return _tipo
        }
        return .s
    }
    
   
    
}
