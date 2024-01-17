//
//  ChatViewController.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2023/11/29.
//

import UIKit
import WebKit




class ChatViewController: UIViewController,WKScriptMessageHandler {
    
    struct ChatEvent: Codable {
        let event: String
        let bestResponse: BestResponse?
    }

    struct BestResponse: Codable {
        let utterance: String
        let options: [String]
        let extensions: Extensions?
    }

    struct Extensions: Codable {
        let appAction: String?
        let searchGenre:String?
        let bookFeatures:String?
    }

    struct ChatError: Codable {
        let error: ChatErrorResponse
    }

    struct ChatErrorResponse: Codable {
        let code: Int
        let message: String
    }
    
    private var webView:WKWebView!
    private let apiKey = "953dfe40-f81c-484e-abc9-0840dce3069f18c19caffaf202"
    private let uid = UUID().uuidString
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        let userContentController:WKUserContentController = WKUserContentController()
        userContentController.add(self,name: "meboCallBack")
        config.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: config)
        webView.load(URLRequest(url: URL(string: "https://miibo.jp/chat/8a74482a-7436-48c2-b280-0bc38c75eedb18c19902fa83bb?name=%E6%9C%AC%E5%A4%A7%E5%A5%BD%E3%81%8D%E5%A4%AA%E9%83%8E&platform=webview")!))
        view = webView
        
        print()

    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let json = (message.body as? String)?.data(using: .utf8) else{
            return
        }
        let decoder = JSONDecoder()
        guard let chatEvent:ChatEvent = try? decoder.decode(ChatEvent.self, from: json) else{
            if let error:ChatError = try? decoder.decode(ChatError.self, from: json) {
                print(error.error.message)
                return
            }
            fatalError("不明なエラー")
        }
        
        
        switch chatEvent.event {
        case "agentLoaded":
            webView.evaluateJavaScript("setAppInfo(\"\(apiKey)\",\"\(uid)\");")
        case "agentResponded":
            print("sucsess")
            print(chatEvent.bestResponse?.extensions?.appAction)
        default:
                break
        }
        
    }
    
    

}
