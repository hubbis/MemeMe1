//
//  ViewController.swift
//  MemeMe1
//
//  Created by Pekka Kaariainen on 26/09/15.
//  Copyright (c) 2015 Pekka Kaariainen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var meme : Meme!
    var memedImage : UIImage!
    var currentTextField : UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.hidden = true
        bottomText.hidden = true
        
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        
        topText.delegate = self
        bottomText.delegate = self
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
        
        shareButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if currentTextField == bottomText {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if currentTextField == bottomText {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        currentTextField = textField
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        topText.hidden = false
        bottomText.hidden = false
        shareButton.enabled = true
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = saveMemeAfterSharing
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func saveMemeAfterSharing(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) {
        if completed {
            //in this version memes are not saved in the device
            meme = Meme(topText: topText.text, bottomText: bottomText.text, image: imagePickerView.image!, memedImage: memedImage)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func generateMemedImage() -> UIImage {
        topNavigationBar.hidden = true
        bottomToolbar.hidden = true
        
        //render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topNavigationBar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }
}

