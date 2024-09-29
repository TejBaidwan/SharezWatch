//
//  ViewController.swift
//  SharezWatch
//
//  Created by Tejvir Baidwan on 2024-09-28.
//

import UIKit

/**
 This class represents the launch screen of the application with the content about the app and my app logo
 */
class LaunchViewController: UIViewController {
    
    //MARK: - Oulets
    
    @IBOutlet weak var pageTitle: UILabel!
    
    @IBOutlet weak var appLogo: UIImageView!
    
    @IBOutlet weak var pageContent: UITextView!
    
    //MARK: - View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating the fonts for the title and content which uses the custom font from GoogleFonts
        if let customFontTitle = UIFont(name: "KulimPark-Bold", size: 30) {
            pageTitle.text = "Welcome to SharezWatch"
            pageTitle.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFontTitle)
        }
        
        if let customFontContent = UIFont(name: "KulimPark-Regular", size: 16) {
            pageContent.text = """
                                Ready to dive into the world of trading stocks? SharezWatch has you
                             covered!
                             
                             This app acts as an all-in-one spot for starting your trading journey. You can search for stocks with our stock bar and get details about the price, volume, and other metrics related to it.

                             You can add stocks to your watch list, delete them, and even practice paper trading to see the value of a potential position!

                             Ready to get started? Navigate with the tabs below to explore the app. Happy trading!
                             """
            pageContent.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
        }


    }


}

