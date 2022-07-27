//
//  File.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/client/RequestManager.ts

import Foundation
import NIO

struct RequestMap {
    public var timer: Timer
    public var promise: EventLoopPromise<Any>
}

/**
 * Manage all the requests made to the websocket, and their async responses
 * that come in from the WebSocket. Responses come in over the WS connection
 * after-the-fact, so this manager will tie that response to resolve the
 * original request.
 */
public class RequestManager {
  private var nextId = 0
    private var promisesAwaitingResponse: [Int: RequestMap] = [:]

  /**
   * Successfully resolves a request.
   *
   * @param id - ID of the request.
   * @param response - Response to return.
   * @throws Error if no existing promise with the given ID.
   */
  public func resolve(id: Int, response: Response) throws {
      guard let index = self.promisesAwaitingResponse.firstIndex(where: { $0.key == id }) else {
          throw XrplError.noPromise("No existing promise with id \(id)")
      }
      let promise = self.promisesAwaitingResponse[index].value
    promise.timer.invalidate()
      promise.promise.succeed(response)
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
      let promise = self.promisesAwaitingResponse[index].value
      promise.timer.invalidate()
      // TODO: figure out how to have a better stack trace for an error
      promise.promise.fail(error)
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
//  public func createRequest(
//    request: T,
//    timeout: Int,
//  ): [Int, string, EventLoopPromise<Response>] {
//    var newId: Int
//    if (request.id == null) {
//      newId = self.nextId
//        self.nextId += 1
//    } else {
//      newId = request.id
//    }
//    let newRequest = JSON.stringify({ ...request, id: newId })
//    let timer = setTimeout(
//      () => this.reject(newId, new TimeoutError()),
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
//    let newPromise = new Promise<Response>(
//      (resolve: (value: Response | PromiseLike<Response>) => void, reject) => {
//        this.promisesAwaitingResponse.set(newId, { resolve, reject, timer })
//      },
//    )
//
//    return [newId, newRequest, newPromise]
//  }

//  /**
//   * Handle a "response". Responses match to the earlier request handlers,
//   * and resolve/reject based on the data received.
//   *
//   * @param response - The response to handle.
//   * @throws ResponseFormatError if the response format is invalid, RippledError if rippled returns an error.
//   */
//  public func handleResponse(response: Partial<Response | ErrorResponse>): void {
//    if (
//      response.id == null ||
//      !(typeof response.id === "string" || typeof response.id === "number")
//    ) {
//      throw new ResponseFormatError("valid id not found in response", response)
//    }
//    if (!this.promisesAwaitingResponse.has(response.id)) {
//      return
//    }
//    if (response.status == null) {
//      const error = new ResponseFormatError("Response has no status")
//      this.reject(response.id, error)
//    }
//    if (response.status === "error") {
//      // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- We know this must be true
//      const errorResponse = response as Partial<ErrorResponse>
//      const error = new RippledError(
//        errorResponse.error_message ?? errorResponse.error,
//        errorResponse,
//      )
//      this.reject(response.id, error)
//      return
//    }
//    if (response.status !== "success") {
//      const error = new ResponseFormatError(
//        `unrecognized response.status: ${response.status ?? ""}`,
//        response,
//      )
//      this.reject(response.id, error)
//      return
//    }
//    // status no longer needed because error is thrown if status is not "success"
//    delete response.status
//    // eslint-disable-next-line @typescript-eslint/consistent-type-assertions -- Must be a valid Response here
//    this.resolve(response.id, response as unknown as Response)
//  }

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
