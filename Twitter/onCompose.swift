//
//  onCompose.swift
//  Twitter
//
//  Created by Dimple Jethani on 6/29/16.
//  Copyright © 2016 Dimple Jethani. All rights reserved.
//

import UIKit

class onCompose: UIViewController, UITextViewDelegate {
    
    let client = TwitterClient.sharedInstance
    
    @IBAction func sendTweet(sender: AnyObject) {
        print("TWEET TEXT", textView.text)
        if textView.text != ""{
            client.makeTweet( textView.text, success: {()->() in
            
            }, failure: {()->() in})
        }
    }
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "What's happening?"
        
        textView.textColor = UIColor.grayColor()
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
    }
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.grayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "What's happening?"
            textView.textColor = UIColor.grayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
