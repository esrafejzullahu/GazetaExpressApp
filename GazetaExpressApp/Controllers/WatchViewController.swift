//
//  WatchViewController.swift
//  GazetaExpressApp
//
//  Created by Esra on 10/18/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class WatchViewController: UIViewController {
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var videotEfunditPlayerView: WKYTPlayerView!
    @IBOutlet weak var lajmeQendrorePlayerView: WKYTPlayerView!
    @IBOutlet weak var pressinguPlayerView: WKYTPlayerView!
    @IBOutlet weak var mendimiPerMotinPlayerView: WKYTPlayerView!
    @IBOutlet weak var expressRozePlayerView: WKYTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.load(withPlaylistId: "PLqdsNJkTKizWLePmLxUG9cpJKhakMd7xU")
        lajmeQendrorePlayerView.load(withPlaylistId: "PLqdsNJkTKizWiCacl7dwIMWQQwg7jEuYL")
        videotEfunditPlayerView.load(withPlaylistId: "UUWJe7loIldFtmfaVHYaQw0g")
        pressinguPlayerView.load(withPlaylistId: "PLqdsNJkTKizVlUtLMtuw24ojJDRbtxwVG")
        mendimiPerMotinPlayerView.load(withPlaylistId: "PLqdsNJkTKizVT2TRbVSBidJlVuy9lGiTo")
        expressRozePlayerView.load(withPlaylistId: "PLqdsNJkTKizWHuLvmF10B6Hep922oANNP")
        
    }
}
