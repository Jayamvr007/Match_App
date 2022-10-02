//
//  ViewController.swift
//  Match App
//
//  Created by 10683973 on 03/06/22.
//

import UIKit

class ViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var model = CardModel()
    var cardArray=[Card]()
    
    var firstflippedCardIndex:IndexPath?
    
    var timer:Timer?
    var miliseconds:Float=50*1000
    
    var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardArray=model.getCards()
        collectionView.delegate=self
        collectionView.dataSource=self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target:self
                                     , selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    override func viewDidAppear(_ animated: Bool) {
        soundManager.playSound(.shuffle)
    }
    
    @objc func timerElapsed(){
        miliseconds-=1
        
        let seconds=String(format: "%.2f", miliseconds/1000)
        
        timerLabel.text="Time Remaining:\(seconds)"
        
        if miliseconds <= 0 {
            timer?.invalidate()
            
            checkGameEnded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        let card=cardArray[indexPath.row]
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if miliseconds<=0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        if card.isFlipped==false && card.isMatched==false {
            cell.flip()
            
            soundManager.playSound(.flip)
            card.isFlipped=true
            
            if firstflippedCardIndex == nil{
                
                firstflippedCardIndex = indexPath
            }
            else{
                checkformatches(indexPath)
            }
        }
        
    }
    
    // MARK: Game logic methods
    func checkformatches(_ secondflippedCardIndex:IndexPath){
        
        let cardOneCell = collectionView.cellForItem(at:firstflippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell=collectionView.cellForItem(at: secondflippedCardIndex) as? CardCollectionViewCell
        
        let cardOne=cardArray[firstflippedCardIndex!.row]
        let cardTwo=cardArray[secondflippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName {
            
            soundManager.playSound(.match)
            
            cardOne.isMatched=true
            cardTwo.isMatched=true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            checkGameEnded()
        }
        else
        {
            soundManager.playSound(.nomatch)
            
            cardOne.isFlipped=false
            cardTwo.isFlipped=false
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        if cardOneCell==nil{
            collectionView.reloadItems(at: [firstflippedCardIndex!])
        }
        
        firstflippedCardIndex=nil
    }
    
    func checkGameEnded(){
        var isWon=true
        
        for card in cardArray{
            if card.isMatched==false{
                isWon=false
                break
            }
        }
        
        var title=""
        var message=""
        
        if isWon == true{
            if miliseconds > 0 {
                timer?.invalidate()
            }
            
            title="Congratulations"
            message="You've Won"
        }
        else{
            if miliseconds>0 {
                return
        }
            title = "Game Over"
            message = "You've Lost"
    }
     showAlert(title, message)
}
    func showAlert(_ title:String,_ message:String)
    {
        let alert=UIAlertController(title:title, message: message, preferredStyle: .alert)
             
             let alertAction=UIAlertAction(title: "Ok", style: .default, handler: nil)
             
             alert.addAction(alertAction)
             
             present(alert, animated: true, completion: nil)
         
    }

}
