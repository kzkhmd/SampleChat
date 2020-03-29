//
//  ChatViewController.swift
//  SampleChat
//
//  Created by 濱田一輝 on 2020/03/15.
//  Copyright © 2020 Kazuki Hamada. All rights reserved.
//

import UIKit
import MapKit
import MessageKit
import InputBarAccessoryView
import FirebaseDatabase
import FirebaseAuth


class ChatViewController: MessagesViewController {
    
    var messageList: [MockMessage] = []
    
    var databaseReference: DatabaseReference!
    
    var handle: AuthStateDidChangeListenerHandle!
    
    var uid: String = ""
    var displayName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageColloctionView()
        configureMessageInputBar()
        
        databaseReference = Database.database().reference()
        
        observeDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.uid = user.uid
                
                if let displayName = user.displayName {
                    self.displayName = displayName
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func configureMessageColloctionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
    }
    
    func observeDatabase() {
        self.databaseReference.observe(DataEventType.childAdded, with: {(snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            if let senderId = postDict["senderId"] as? String, let displayName = postDict["displayName"] as? String, let message = postDict["message"] as? String, let messageId = postDict["messageId"] as? String {
                let user = MockUser(senderId: senderId, displayName: displayName)
                let message = MockMessage(text: message, user: user, messageId: messageId, date: Date())
                
                self.messageList.append(message)
                self.messagesCollectionView.reloadData()
            }
        })
    }
    
    @IBAction func didTapSignOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}


// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return MockUser(senderId: self.uid, displayName: self.displayName)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let formatter = DateFormatter()
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}


// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
    
}


// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 18
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 17
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
}


// MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let messageData = [
            "senderId" : self.uid,
            "displayName" : self.displayName,
            "messageId" : UUID().uuidString,
            "message" : text
        ]
        
        self.messagesCollectionView.scrollToBottom(animated: true)
        
        self.databaseReference.childByAutoId().setValue(messageData)
    }
}
