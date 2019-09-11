//
//  MessagesViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 10.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

struct Message {
    var sender = ""
    var reciever = ""
    var message = ""
    var shippingTime = ""
    var read = false
}

class MessagesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var messages: [Message] = [] {
        didSet {
            tableView.reloadData()
            tableViewHeightConstraint.constant = tableView.contentSize.height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: "Cüneyt AYVAZ",
                                reciever: "Cüneyt AYVAZ",
                                message: "Öğrenciniz 10 Eylül 2019 Salı Günü 13:45'te Cüneyt AYVAZ'ın dersinde yok yazılmıştır.",
                                shippingTime: "13:45",
                                read: false))
        messages.append(Message(sender: "Ozan DAMCI",
                                reciever: "Cüneyt AYVAZ",
                                message: "Öğrenciniz 10 Eylül 2019 Salı Günü 13:45'te Ozan DAMCI'nın dersinde yok yazılmıştır.",
                                shippingTime: "13:45",
                                read: false))
        messages.append(Message(sender: "Cüneyt AYVAZ",
                                reciever: "Cüneyt AYVAZ",
                                message: "Öğrenciniz 10 Eylül 2019 Salı Günü 13:45'te Cüneyt AYVAZ'ın dersinde yok yazılmıştır.",
                                shippingTime: "13:45",
                                read: true))
        messages.append(Message(sender: "Ozan DAMCI",
                                reciever: "Cüneyt AYVAZ",
                                message: "Öğrenciniz 10 Eylül 2019 Salı Günü 13:45'te Ozan DAMCI'ın dersinde yok yazılmıştır. Öğrenciniz 10 Eylül 2019 Salı Günü 13:45'te Ozan DAMCI'ın dersinde yok yazılmıştır. Öğrenciniz 10 Eylül 2019 Salı Günü 13:45'te Ozan DAMCI'ın dersinde yok yazılmıştır. Öğrenciniz 10 Eylül 2019 Salı Günü 13:45'te Ozan DAMCI'ın dersinde yok yazılmıştır.",
                                shippingTime: "13:45",
                                read: true))
        
        // Do any additional setup after loading the view.
        tableView.register(MessageTableViewCell.nib, forCellReuseIdentifier: MessageTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func setText() {
        title = "Mesajlar".localized()
    }
    
    override func viewWillLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as! MessageTableViewCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}
