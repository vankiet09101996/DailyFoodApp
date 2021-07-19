//
//  MenuViewController.swift
//  new sentinal
//
//  Created by NEM on 29/04/2021.
//

import UIKit

class MenuDrawer: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let size =  UIScreen.main.bounds.size
        //        let View1 = UIView(frame: CGRect(x: 0, y: 0, width:size.width, height: size.height))
        //        View1.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        //        self.view.addSubview(View1)
        
        //        view1.addGesture
        
        
        
        
        let View2 = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        View2.backgroundColor = UIColor.white
        self.view.addSubview(View2)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)) )
        View2.isUserInteractionEnabled = true
        View2.addGestureRecognizer(tap)
        
        
        
        let imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 30, y: 52, width: 60, height: 60));
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.image = UIImage(named:"ic_avatar.png")
        View2.addSubview(imageView)
        
        let nameLabel : UILabel
        nameLabel = UILabel(frame: CGRect(x: 98, y: 66, width: 105, height: 16))
        nameLabel.text = "Emma Holmes"
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        View2.addSubview(nameLabel)
        
        let viewProfileLabel : UILabel
        viewProfileLabel = UILabel(frame: CGRect(x: 98 , y: 92, width: 83, height: 12))
        viewProfileLabel.text = "View Profile"
        viewProfileLabel.textColor = .gray
        viewProfileLabel.textAlignment = .center
        viewProfileLabel.font = UIFont.systemFont(ofSize: 12)
        View2.addSubview(viewProfileLabel)
        
        let signOutButton = UIButton()
        signOutButton.backgroundColor = .white
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        signOutButton.setTitleColor(.gray, for: .normal)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.titleLabel?.font = .systemFont(ofSize: 14)
        signOutButton.addTarget(self, action: #selector(onSignOut), for: .touchUpInside)
        View2.addSubview(signOutButton)
        
        let imgSignOut : UIImageView
        imgSignOut  = UIImageView(frame: CGRect(x: 30 , y: 605, width: 17, height: 13))
        imgSignOut.image = UIImage(named:"ic_dw_out.png")
        View2.addSubview(imgSignOut)
        
        let HomeButton = UIButton()
        HomeButton.backgroundColor = .white
        HomeButton.setTitle("Home", for: .normal)
        HomeButton.setTitleColor(.orange, for: .normal)
        HomeButton.translatesAutoresizingMaskIntoConstraints = false
        HomeButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        HomeButton.titleLabel?.font = .systemFont(ofSize: 14)
        HomeButton.addTarget(self, action: #selector(onHome), for: .touchUpInside)
        View2.addSubview(HomeButton)
        
        let imgHome : UIImageView
        imgHome  = UIImageView(frame: CGRect(x: 30 , y: 202, width: 15, height: 15))
        imgHome.image = UIImage(named:"ic_dw_home.png")
        View2.addSubview(imgHome)
        
        let FavoritesButton = UIButton()
        FavoritesButton.backgroundColor = .white
        FavoritesButton.setTitle("Favorites", for: .normal)
        FavoritesButton.setTitleColor(.gray, for: .normal)
        FavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        FavoritesButton.titleLabel?.font = .systemFont(ofSize: 14)
        FavoritesButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        FavoritesButton.addTarget(self, action: #selector(onFavorites), for: .touchUpInside)
        View2.addSubview(FavoritesButton)
        
        let imgFavorites : UIImageView
        imgFavorites  = UIImageView(frame: CGRect(x: 30 , y: 270, width: 15, height: 13))
        imgFavorites.image = UIImage(named:"ic_dw_favorite.png")
        View2.addSubview(imgFavorites)
        
        let RecentlyViewedButton = UIButton()
        RecentlyViewedButton.backgroundColor = .white
        RecentlyViewedButton.setTitle("Recently Viewed", for: .normal)
        RecentlyViewedButton.setTitleColor(.gray, for: .normal)
        RecentlyViewedButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        RecentlyViewedButton.translatesAutoresizingMaskIntoConstraints = false
        RecentlyViewedButton.titleLabel?.font = .systemFont(ofSize: 14)
        RecentlyViewedButton.addTarget(self, action: #selector(onRecentlyViewed), for: .touchUpInside)
        View2.addSubview(RecentlyViewedButton)
        
        let imgRecently : UIImageView
        imgRecently  = UIImageView(frame: CGRect(x: 30 , y: 337, width: 12, height: 13))
        imgRecently.image = UIImage(named:"ic_dw_recen.png")
        View2.addSubview(imgRecently)
        
        let SettingsViewedButton = UIButton()
        SettingsViewedButton.backgroundColor = .white
        SettingsViewedButton.setTitle("Settings", for: .normal)
        SettingsViewedButton.setTitleColor(.gray, for: .normal)
        SettingsViewedButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        SettingsViewedButton.translatesAutoresizingMaskIntoConstraints = false
        SettingsViewedButton.titleLabel?.font = .systemFont(ofSize: 14)
        SettingsViewedButton.addTarget(self, action: #selector(onSettings), for: .touchUpInside)
        View2.addSubview(SettingsViewedButton)
        
        let imgSettings : UIImageView
        imgSettings  = UIImageView(frame: CGRect(x: 30 , y: 402, width: 15, height: 15))
        imgSettings.image = UIImage(named:"ic_dw_setting.png")
        View2.addSubview(imgSettings)
        
        let AboutUsButton = UIButton()
        AboutUsButton.backgroundColor = .white
        AboutUsButton.setTitle("About Us", for: .normal)
        AboutUsButton.setTitleColor(.gray, for: .normal)
        AboutUsButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        AboutUsButton.translatesAutoresizingMaskIntoConstraints = false
        AboutUsButton.titleLabel?.font = .systemFont(ofSize: 14)
        AboutUsButton.addTarget(self, action: #selector(onAboutUs), for: .touchUpInside)
        View2.addSubview(AboutUsButton)
        
        let imgAboutUs : UIImageView
        imgAboutUs  = UIImageView(frame: CGRect(x: 30 , y: 470, width: 15, height: 15))
        imgAboutUs.image = UIImage(named:"ic_dw_about.png")
        View2.addSubview(imgAboutUs)
        
        let HelpButton = UIButton()
        HelpButton.backgroundColor = .white
        HelpButton.setTitle("Help", for: .normal)
        HelpButton.setTitleColor(.gray, for: .normal)
        HelpButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        HelpButton.translatesAutoresizingMaskIntoConstraints = false
        HelpButton.titleLabel?.font = .systemFont(ofSize: 14)
        HelpButton.addTarget(self, action: #selector(onHelp), for: .touchUpInside)
        View2.addSubview(HelpButton)
        
        let imgHelp : UIImageView
        imgHelp  = UIImageView(frame: CGRect(x: 30 , y: 537, width: 15, height: 15))
        imgHelp.image = UIImage(named:"ic_dw_help.png")
        View2.addSubview(imgHelp)
        
        
        
        //        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender: )))
        //        rightSwipe.direction = .right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender: )))
        leftSwipe.direction = .left
        //        View1.addGestureRecognizer(rightSwipe)
        View2.addGestureRecognizer(leftSwipe)
        
        NSLayoutConstraint.activate([
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:53),
            signOutButton.widthAnchor.constraint(equalToConstant: 74),
            signOutButton.heightAnchor.constraint(equalToConstant: 14),
            signOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 605),
            
            HomeButton.widthAnchor.constraint(equalToConstant: 50),
            HomeButton.heightAnchor.constraint(equalToConstant: 14),
            HomeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 53),
            HomeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 204),
            
            FavoritesButton.widthAnchor.constraint(equalToConstant: 91),
            FavoritesButton.heightAnchor.constraint(equalToConstant: 14),
            FavoritesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 53),
            FavoritesButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 270),
            
            RecentlyViewedButton.widthAnchor.constraint(equalToConstant: 137),
            RecentlyViewedButton.heightAnchor.constraint(equalToConstant: 14),
            RecentlyViewedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 53),
            RecentlyViewedButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 337),
            
            SettingsViewedButton.widthAnchor.constraint(equalToConstant: 84),
            SettingsViewedButton.heightAnchor.constraint(equalToConstant: 14),
            SettingsViewedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 53),
            SettingsViewedButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 404),
            
            AboutUsButton.widthAnchor.constraint(equalToConstant: 91),
            AboutUsButton.heightAnchor.constraint(equalToConstant: 14),
            AboutUsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 53),
            AboutUsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 471),
            
            HelpButton.widthAnchor.constraint(equalToConstant: 65),
            HelpButton.heightAnchor.constraint(equalToConstant: 14),
            HelpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 53),
            HelpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 537),
        ])
        
        
        
    }
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        print("view has")
        let size = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.4, animations: {[weak self] in
            guard let self = self else { return }
            self.view.frame = CGRect(x: 0, y: 0, width: -size.width, height: self.view.bounds.height)
        })
    }
    @objc func onHome(sender: UIButton!) {
        
    }
    @objc func onFavorites(sender: UIButton!) {
        favoritesView()
    }
    @objc func onRecentlyViewed(sender: UIButton!) {
        
    }
    @objc func onAboutUs(sender: UIButton!) {
        
    }
    @objc func onSettings(sender: UIButton!) {
        
    }
    @objc func onHelp(sender: UIButton!) {
        
    }
    @objc func onSignOut(sender: UIButton!) {
        initView()
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        let size = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.4, animations: {[weak self] in
            guard let self = self else { return }
            self.view.frame = CGRect(x: 0, y: 0, width: -size.width, height: self.view.bounds.height)
        })
    }
    func initView() {
        let vic = NavViewController()
        self.view.window?.rootViewController = vic
        self.view.window?.makeKeyAndVisible()
    }
    func favoritesView() {
        let vic = FavoritesNavigationController()
        self.view.window?.rootViewController = vic
        self.view.window?.makeKeyAndVisible()
    }
}
