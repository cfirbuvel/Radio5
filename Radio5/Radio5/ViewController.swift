//
//  ViewController.swift
//  Radio5
//
//  Created by Cfir Shor on 08/12/2015.
//  Copyright © 2015 Cfir Shor. All rights reserved.
//

import UIKit
import AVFoundation
import Social
import MessageUI
import MediaPlayer

extension UIImage{
    
    func alpha(value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext();
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        CGContextSetBlendMode(ctx, CGBlendMode.Multiply);
        CGContextSetAlpha(ctx, value);
        CGContextDrawImage(ctx, area, self.CGImage);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var backgroungImage: UIImageView!
    @IBOutlet weak var chatPlayButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var sliderView: UIView!
    
    var tempSliderVolume : Float?
    var player : AVPlayer?
    var isPlaying = false
    var isMute = false
    let muteImage = UIImage (named: "mute")
    let unMuteImage = UIImage (named: "volume")
    var volumeView = MPVolumeView()
    let audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        volumeView = MPVolumeView(frame: sliderView.bounds)
        self.sliderView.addSubview(volumeView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
//        backgroungImage.alpha = 0.3
        
        // 1
        let nav = self.navigationController?.navigationBar
        // 2
        nav?.barStyle = UIBarStyle.Default
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        // 4
        let image = UIImage(named: "radio5_logo_nav")
        imageView.image = image
        // 5
        navigationItem.titleView = imageView
    }
    
    func schemeAvailable(scheme: String) -> Bool {
        if let url = NSURL.init(string: scheme) {
            return UIApplication.sharedApplication().canOpenURL(url)
        }
        return false
    }
    
    //MARK: IBAction Mail
    @IBAction func sendFeedback(sender: UIButton) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["lior@radio5.co.il"])
        mailComposerVC.setSubject("רדיו5 - תקלות והצעות")
        mailComposerVC.setMessageBody("רשום כאן הצעות ובאגים", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        if #available(iOS 8.0, *) {
//            let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
//            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
//            sendMailErrorAlert.addAction(okAction)
//            self.navigationController?.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            let alert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }

    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: IBAction Share FB
    @IBAction func shareButtonActionFB(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            fbShare.addImage(UIImage (named: "share_image"))
            fbShare.addURL(NSURL(string: "https://www.facebook.com/Radio5.co.il"))
//            fbShare.setInitialText("אני מאזין לרדיו 5!!!")
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            if #available(iOS 8.0, *) {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                let alert = UIAlertView(title: "Accounts", message: "Please login to a Facebook account to share", delegate: self, cancelButtonTitle: "", otherButtonTitles: "", "")
                alert.show()
            }
            

        }
    }
    
    //MARK: Share Apps
    @IBAction func shareButtonAction(sender: UIButton) {
        
        let radio5Str = String("אני מאזין לרדיו-5")
        
        let linkSite = String("https://www.radio5.co.il")
        let siteStr = String("אתר אינטרנט:")
        let siteBrowserURL = NSURL(string: linkSite)
        
        let linkFB = String("https://www.facebook.com/Radio5.co.il")
        let fbStr = String("פייסבוק: \(linkFB) /n\(siteStr) /n\(siteBrowserURL)")
        let fbBrowserURL = NSURL(string: linkFB)

        let activityVC = UIActivityViewController(activityItems: [radio5Str, fbStr, fbBrowserURL!], applicationActivities: nil)
        self.navigationController?.presentViewController(activityVC, animated: true, completion: nil)

    }
    
    //MARK: IBAction Like
    @IBAction func likeButtonAction(sender: UIButton) {
        let fbNativeURL = "fb://page/?id=516129785104108"
        let fbBrowserURL = "https://www.facebook.com/Radio5.co.il"
        
        let application = UIApplication.sharedApplication()
        
        if application.canOpenURL(NSURL(string: fbNativeURL)!) {
            application.openURL(NSURL(string: fbNativeURL)!)
        }else{
            application.openURL(NSURL(string: fbBrowserURL)!)
        }

    }
    
    //MARK: IBAction Mute
    @IBAction func muteButton(sender: UIButton) {

            if isMute {
                //This runs if the user wants music
                isMute = false
                muteButton.setImage(unMuteImage, forState: UIControlState.Normal)
                player?.volume = 1.0
                
                
            } else {
                //This happens when the user doesn't want music
                isMute = true
                muteButton.setImage(muteImage, forState: UIControlState.Normal)
                player?.volume = 0.0
            }
    }
    
    //MARK: IBAction Slider
    @IBAction func sliderAction(sender: UISlider) {
        
        player?.volume = sender.value

        if player?.volume == sender.minimumValue{
            muteButton.setImage(muteImage, forState: UIControlState.Normal)
        }else{
            muteButton.setImage(unMuteImage, forState: UIControlState.Normal)
        }
    }
    
    //MARK: IBAction Play
    @IBAction func playButton(sender: UIButton) {
        
        if isPlaying{
            pauseRadio()
        } else {
            playRadio()
        }
    }
    
    func playRadio() {
        self.player = AVPlayer(URL: NSURL(string: "http://stream.shushudate.com:4312/listen.pls")!)
        player?.play()
        
        chatPlayButton.setImage(UIImage(named: "pause_button"), forState: UIControlState.Normal)
        isPlaying = true
    }
    
    func pauseRadio() {
        player?.pause()
        chatPlayButton.setImage(UIImage(named: "play_button"), forState: UIControlState.Normal)
        isPlaying = false
    }
}

