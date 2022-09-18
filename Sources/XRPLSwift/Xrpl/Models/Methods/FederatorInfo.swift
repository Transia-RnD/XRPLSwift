////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/federatorInfo.ts
//
// import Foundation
//
/// **
// The `federator_info` command asks the federator for information
// about the door account and other bridge-related information. This
// method only exists on sidechain federators. Expects a response in
// the form of a {@link FederatorInfoResponse}.
// *
// @category Requests
// */
// open class FederatorInfoRequest: BaseRequest {
//  command: String = "federator_info"
// }
//
/// **
// Response expected from a {@link FederatorInfoRequest}.
// *
// @category Responses
// */
// open class FederatorInfoResponse: BaseResponse {
//  result: {
//    info: {
//      mainchain: {
//        door_status: {
//          initialized: Bool
//          status: 'open' | 'opening' | 'closed' | 'closing'
//        }
//        last_transaction_sent_seq: Int
//        listener_info: {
//          state: 'syncing' | 'normal'
//        }
//        pending_transactions: Array<{
//          amount: String
//          destination_account: String
//          signatures: Array<{
//            public_key: String
//            seq: Int
//          }>
//        }>
//        sequence: Int
//        tickets: {
//          initialized: Bool
//          tickets: Array<{
//            status: 'taken' | 'available'
//            ticket_seq: Int
//          }>
//        }
//      }
//      public_key: String
//      sidechain: {
//        door_status: {
//          initialized: Bool
//          status: 'open' | 'opening' | 'closed' | 'closing'
//        }
//        last_transaction_sent_seq: Int
//        listener_info: {
//          state: 'syncing' | 'normal'
//        }
//        pending_transactions: Array<{
//          amount: String
//          destination_account: String
//          signatures: Array<{
//            public_key: String
//            seq: Int
//          }>
//        }>
//        sequence: number
//        tickets: {
//          initialized: Bool
//          tickets: Array<{
//            status: 'taken' | 'available'
//            ticket_seq: Int
//          }>
//        }
//      }
//    }
//  }
// }
