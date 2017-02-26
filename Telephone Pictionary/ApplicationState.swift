//
//  ApplicationState.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/25/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import Foundation
import CoreFoundation

class ApplicationState : NSObject, StreamDelegate {
    
    
    //MARK: - Input and Output Streams
    
    static var state = ApplicationState()
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    private override init() {
        super.init()
        var cfReadStream: Unmanaged<CFReadStream>? = nil
        var cfWriteStream: Unmanaged<CFWriteStream>? = nil
        CFStreamCreatePairWithSocketToHost(nil, "172.16.100.122" as CFString!, 1337, &cfReadStream, &cfWriteStream)
        
        self.inputStream = cfReadStream!.takeRetainedValue() as InputStream
        self.outputStream = cfWriteStream!.takeRetainedValue() as OutputStream
        
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        inputStream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        outputStream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        
        self.inputStream.open()
        self.outputStream.open()
    }
    
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        if eventCode == .openCompleted { print("Stream opened") }
        else if eventCode == .errorOccurred { print("Could not connect to host") }
            
        else if eventCode == .hasBytesAvailable || eventCode == .hasSpaceAvailable {
            if let inputStream = aStream as? InputStream {
                while inputStream.hasBytesAvailable {
                    
                    var buffer = [UInt8](repeating: 0, count: 102400)
                    let numberOfBytes = inputStream.read(&buffer, maxLength: 102400)
                    
                    let response = (NSString(bytes: &buffer, length: numberOfBytes, encoding: String.Encoding.utf8.rawValue) ?? "") as String
                    
                    receiveResponse(possibleResponse: response)
                    
                }
            }
        }
    }
    
    
    //MARK: - Directing Responses
    var callbacks = [String : (String) -> ()]()
    var listeners = [String : [String : (String) -> ()]]()
    
    var partialResponse: String?
    
    func receiveResponse(possibleResponse: String) {
        if !possibleResponse.contains("\n") {
            self.partialResponse = (self.partialResponse ?? "") + possibleResponse
            return
        }
        
        //if the possible response contained a newline
        var response = possibleResponse
        if let partialResponse = self.partialResponse {
            response = partialResponse + possibleResponse
            self.partialResponse = nil
        }
        
        let responseComponents = response.components(separatedBy: "\r\n").filter { !$0.isEmpty }
        
        if responseComponents.count == 1 {
            response = responseComponents.first!
        } else {
            responseComponents.forEach { self.receiveResponse(possibleResponse: $0 + "\r\n") }
        }
        
        if response.lengthOfBytes(using: .utf8) > 100 {
            print(">>>>>> \"\(response.components(separatedBy: "/")[0])/<binary data>\"")
        } else {
            print(">>>>>> \"\(response)\"")
        }
        
        
        //process the response
        let splits = response.components(separatedBy: "/")
        
        if splits.count < 1 { return }
        
        let id = splits[0]
        let body = (splits.count == 1) ? "" : splits[1]
        
        if let callback = self.callbacks[id] {
            callback(body)
            callbacks.removeValue(forKey: id)
        } else if let listeners = self.listeners[id] {
            listeners.values.forEach { listener in
                listener(body)
            }
        }
        
    }
    
    
    //MARK: - Requests and Listeners
    
    @discardableResult func sendMessage(_ message: String) -> String {
        let id = "\(Date().timeIntervalSince1970)"
        let messageWithId = "\(id)/\(message)\r\n"
        
        //print("<<<<<< \(messageWithId)")
        
        let data = messageWithId.data(using: .utf8)!
        _ = data.withUnsafeBytes { bytes in
            outputStream.write(bytes, maxLength: messageWithId.lengthOfBytes(using: .utf8))
        }
        
        return id
    }
    
    func sendMessage(_ message: String, callback: @escaping (String) -> ()) {
        let id = sendMessage(message)
        self.callbacks[id] = callback
    }
    
    func registerListener(forNodeMethod nodeMethod: String, named name: String, callback: @escaping (String) -> ()) {
        var methodListeners = self.listeners[nodeMethod] ?? [:]
        methodListeners[name] = callback
        self.listeners[nodeMethod] = methodListeners
    }
    
}
