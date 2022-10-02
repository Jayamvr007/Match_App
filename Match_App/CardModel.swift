//
//  CardModel.swift
//  Match App
//
//  Created by 10683973 on 04/06/22.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card]{
        
        var generatedNumbersArray=[Int]()
        
         var generatedCardsArray=[Card]()
        
        
        while generatedNumbersArray.count < 8 {
            let randomNumber=arc4random_uniform(13)+1
            
            if generatedNumbersArray.contains(Int(randomNumber)) == false{
                print(randomNumber)
                
                generatedNumbersArray.append(Int(randomNumber))
                
                let CardOne = Card()
                CardOne.imageName="card\(randomNumber)"
                generatedCardsArray.append(CardOne)
                            
                let CardTwo = Card()
                CardTwo.imageName="card\(randomNumber)"
                generatedCardsArray.append(CardTwo)
            }
            
        }
        
        for i in 0...generatedCardsArray.count-1 {
            
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i]=generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber]=temporaryStorage
        }
        return generatedCardsArray
    }
}
