//
//  File.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/client/RequestManager.ts

import Foundation
import NIO

struct RequestMap<T> {
    public var timer: Timer
    public var promise: EventLoopPromise<Any>
    public var requestType: T
}

/**
 * Manage all the requests made to the websocket, and their async responses
 * that come in from the WebSocket. Responses come in over the WS connection
 * after-the-fact, so this manager will tie that response to resolve the
 * original request.
 */
public class RequestManager {
    private var nextId = 0
    private var promisesAwaitingResponse: [Int: RequestMap<Any>] = [:]
    
    /**
     * Successfully resolves a request.
     *
     * @param id - ID of the request.
     * @param response - Response to return.
     * @throws Error if no existing promise with the given ID.
     */
    public func resolve(_ id: Int, _ response: Any?, _ error: Error?) throws {
        guard let index = self.promisesAwaitingResponse.firstIndex(where: { $0.key == id }) else {
            throw XrplError.noPromise("No existing promise with id \(id)")
        }
        let map = self.promisesAwaitingResponse[index].value
        map.timer.invalidate()
        map.promise.succeed(response!)
        self.deletePromise(id: id)
    }
    
    public func resolve(id: Int, error: Any) throws {
        guard let index = self.promisesAwaitingResponse.firstIndex(where: { $0.key == id }) else {
            throw XrplError.noPromise("No existing promise with id \(id)")
        }
        let map = self.promisesAwaitingResponse[index].value
        map.timer.invalidate()
        map.promise.succeed(error)
        self.deletePromise(id: id)
    }
    
    /**
     * Rejects a request.
     *
     * @param id - ID of the request.
     * @param error - Error to throw with the reject.
     * @throws Error if no existing promise with the given ID.
     */
    public func reject(id: Int, error: Error) throws {
        guard let index = self.promisesAwaitingResponse.firstIndex(where: { $0.key == id }) else {
            throw XrplError.noPromise("No existing promise with id \(id)")
        }
        let map = self.promisesAwaitingResponse[index].value
        map.timer.invalidate()
        // TODO: figure out how to have a better stack trace for an error
        map.promise.fail(error)
        self.deletePromise(id: id)
    }
    
    /**
     * Reject all pending requests.
     *
     * @param error - Error to throw with the reject.
     */
    public func rejectAll(error: Error) throws {
        try self.promisesAwaitingResponse.forEach { (key: Int, value: RequestMap) in
            try self.reject(id: key, error: error)
            self.deletePromise(id: key)
        }
    }
    
    /**
     * Creates a new WebSocket request. This sets up a timeout timer to catch
     * hung responses, and a promise that will resolve with the response once
     * the response is seen & handled.
     *
     * @param request - Request to create.
     * @param timeout - Timeout length to catch hung responses.
     * @returns Request ID, new request form, and the promise for resolving the request.
     * @throws XrplError if request with the same ID is already pending.
     */
    @objc func _resolve(_ sender: Timer) {
        guard let id = sender.userInfo as? Int else { return }
        try! resolve(id: id, error: XrplError.timeout())
    }
    public func createRequest<R: BaseRequest>(
        request: R,
        timeout: Int
    ) throws -> (Int, String, EventLoopFuture<Any>) {
        var newId: Int
        if request.id == nil {
            newId = self.nextId
            self.nextId += 1
        } else {
            newId = request.id!
        }
        request.id = newId
        let encoder = JSONEncoder()
        let newRequest = try! encoder.encode(request).to(type: String.self)
        let timer = Timer.scheduledTimer(
            timeInterval: Double(timeout),
            target: self,
            selector: #selector(self._resolve),
            userInfo: self.nextId,
            repeats: false
        )
        //    let timer = setTimeout(
        //      () => self.reject(newId, new TimeoutError()),
        //      timeout,
        //    )
        //    /*
        //     * Node.js won"t exit if a timer is still running, so we tell Node to ignore.
        //     * (Node will still wait for the request to complete).
        //     */
        //    // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition -- Reason above.
        //    if (timer.unref) {
        //      timer.unref()
        //    }
        //    if (self.promisesAwaitingResponse.has(newId)) {
        //      throw new XrplError(`Response with id "${newId}" is already pending`)
        //    }
        
        let newPromise = eventGroup.next().makePromise(of: Any.self)
        let reqMap: RequestMap = RequestMap<Any>(timer: timer, promise: newPromise, requestType: R.self)
        self.promisesAwaitingResponse[newId] = reqMap
        return (newId, newRequest, newPromise.futureResult)
    }
    
    /**
     * Handle a "response". Responses match to the earlier request handlers,
     * and resolve/reject based on the data received.
     *
     * @param response - The response to handle.
     * @throws ResponseFormatError if the response format is invalid, RippledError if rippled returns an error.
     */
    public func handleResponse(_response: [String: AnyObject]?) throws -> Void {
        print(_response)
        let decoder = JSONDecoder()
        let baseData = try JSONSerialization.data(withJSONObject: _response!, options: .prettyPrinted)
        let response = try RippleBaseResponse(data: baseData)
        if (response.id == nil || !(response.id is String || response.id is Int)) {
            throw ValidationError.invalidFormat("valid id not found in response")
            return
        }
        guard let index = self.promisesAwaitingResponse.firstIndex(where: { $0.key == response.id }) else {
            return
            //            throw XrplError.noPromise("No existing promise with id \(response.id)")
        }
        if response.status == nil {
            let error: XrplError = ValidationError.invalidFormat("valid id not found in response")
            try self.reject(id: response.id, error: error)
            return
        }
        if response.status == "error" {
            let errorData = try JSONSerialization.data(withJSONObject: _response!, options: .prettyPrinted)
            let returnedDecodable = try decoder.decode(ErrorResponse.self, from: errorData)
            try self.reject(id: response.id, error: XrplError.unknown(returnedDecodable.errorMessage!))
            return
        }
        if response.status != "success" {
            let error = ResponseFormatError.responseError("unrecognized response.status: \(response.status ?? "")")
            try self.reject(id: response.id, error: error)
            return
        }
        
        let map = self.promisesAwaitingResponse[index].value
        let jsonData = try JSONSerialization.data(
            withJSONObject: _response!["result"] as! [String: AnyObject],
            options: .prettyPrinted
        )
        print(_response!["result"])
        
        
//        var responseObj: BaseResponse<Any>? = nil
        if map.requestType.self is AccountChannelsRequest.Type {
            let responseObj = BaseResponse(
                response: response,
                result: CodableHelper.decode(AccountChannelsResponse.self, from: jsonData).decodableObj
            )
            try! self.resolve(responseObj.id, responseObj, nil)
            return
        }
        if map.requestType.self is AccountObjectsRequest.Type {
            let responseObj = BaseResponse(
                response: response,
                result: CodableHelper.decode(AccountObjectsResponse.self, from: jsonData).decodableObj
            )
            try! self.resolve(responseObj.id, responseObj, nil)
            return
        }
        
//        guard let responseObj = RippleRequestFactory(
//            requestType: map.requestType
//        ).getResponse(
//            response: response,
//            data: jsonData
//        ) as? BaseResponse<Any> else {
//            throw XrplError.noPromise("The request \(map.requestType) has not been mapped")
//        }
//        try! self.resolve(responseObj!.id, responseObj, nil)
//        return
        let error: XrplError = XrplError.noPromise("The request \(map.requestType) has not been mapped")
        try self.reject(id: response.id, error: error)
    }
    
    /**
     * Delete a promise after it has been returned.
     *
     * @param id - ID of the request.
     */
    private func deletePromise(id: Int) {
        if let index = self.promisesAwaitingResponse.firstIndex(where: { $0.key == id }) {
            self.promisesAwaitingResponse.remove(at: index)
        }
    }
}
