//
//  CurrencyRatesModel.swift
//  poloniex-app
//
//  Created by Павел Дреманович on 02.07.17.
//  Copyright © 2017 Павел Дреманович. All rights reserved.
//

import Foundation
import Swamp

class CurrencyRatesModel: ModelProtocol, SwampSessionDelegate{
    private var configuration:ApiConfiguration
    private var swampSession:SwampSession
    private var tickerSubscription:Subscription?
    private var listeners:[(_ referenceCurrencyName:String, _ currencyName:String, _ currency:CurrencyRate) ->Void] = []
    
    required init(configuration: ApiConfiguration) {
        self.configuration = configuration
        
        let swampTransport = WebSocketSwampTransport(wsEndpoint:  NSURL(string: configuration.wsBase)! as URL)
        swampSession = SwampSession(realm: "realm1", transport: swampTransport)
        swampSession.delegate = self
    }
    
    public func start() {
        swampSession.connect()
    }
    
    public func stop(){
        if let subs = self.tickerSubscription {
            subs.cancel({ 
                print("Success unsubscribtion!")
            }, onError: {_,_ in 
                print("Error unsubscription!")
            })
        }
        swampSession.disconnect()
    }
    
    public func listen(callback: @escaping (_ referenceCurrencyName: String, _ currencyName: String, _ currency: CurrencyRate) -> Void) {
        listeners.append(callback)
    }
    
    public func swampSessionHandleChallenge(_ authMethod: String, extra: [String: Any]) -> String{
        print("challenged")
        print(authMethod)
        print(extra)
        return ""
    }
    
    public func swampSessionConnected(_ session: SwampSession, sessionId: Int){
        swampSession.subscribe(
            "ticker",
            onSuccess: {(subscription) in self.tickerSubscription = subscription},
            onError: { (details, error) in print(error)},
            onEvent: { (details, result, kwResults) in
                let currencyPair = (result![0] as! String).components(separatedBy: "_")
                let referenceCurrencyName = currencyPair[0]
                let currencyName = currencyPair[1]
                let currencyValue = Double(result![1] as! String)
                
                let currency = CurrencyRate(currencyName: currencyName, currencyValue: currencyValue!)
            
                for listener in self.listeners {
                    listener(referenceCurrencyName, currencyName, currency)
                }
            }
        )
    }
    
    public func swampSessionEnded(_ reason: String){
        print("session ended!")
        print(reason)
    }
}
