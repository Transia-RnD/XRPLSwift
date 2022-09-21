//
//  File.swift
//  
//
//  Created by Denis Angell on 9/18/22.
//

import Foundation

let rippledLedgerJson = """
{
  "id": 0,
  "status": "success",
  "type": "response",
  "result": {
    "ledger": {
      "account_hash": "EC028EC32896D537ECCA18D18BEBE6AE99709FEFF9EF72DBD3A7819E918D8B96",
      "close_time": 464908910,
      "parent_close_time": 464908900,
      "close_time_human": "2014-Sep-24 21:21:50",
      "close_time_resolution": 10,
      "closed": true,
      "close_flags": 0,
      "ledger_hash": "0F7ED9F40742D8A513AE86029462B7A6768325583DF8EE21B7EC663019DD6A0F",
      "ledger_index": "9038214",
      "parent_hash": "4BB9CBE44C39DC67A1BE849C7467FE1A6D1F73949EA163C38A0121A15E04FFDE",
      "total_coins": "99999973964317514",
      "transaction_hash": "ECB730839EB55B1B114D5D1AD2CD9A932C35BA9AB6D3A8C2F08935EAC2BAC239",
      "transactions": [
        "1FC4D12C30CE206A6E23F46FAC62BD393BE9A79A1C452C6F3A04A13BC7A5E5A3",
        "E25C38FDB8DD4A2429649588638EE05D055EE6D839CABAF8ABFB4BD17CFE1F3E"
      ]
    },
    "ledger_hash": "1723099E269C77C4BDE86C83FA6415D71CF20AA5CB4A94E5C388ED97123FB55B",
    "ledger_index": 9038214,
    "validated": true
  }
}
"""

let rippledServerInfoJson = """
{
  "id": 0,
  "status": "success",
  "type": "response",
  "result": {
    "info": {
      "build_version": "0.24.0-rc1",
      "complete_ledgers": "32570-6595042",
      "hostid": "ARTS",
      "io_latency_ms": 1,
      "last_close": {
        "converge_time_s": 2.007,
        "proposers": 4
      },
      "load_factor": 1,
      "peers": 53,
      "pubkey_node": "n94wWvFUmaKGYrKUGgpv1DyYgDeXRGdACkNQaSe7zJiy5Znio7UC",
      "server_state": "full",
      "validated_ledger": {
        "age": 5,
        "base_fee_xrp": 0.00001,
        "hash": "4482DEE5362332F54A4036ED57EE1767C9F33CF7CE5A6670355C16CECE381D46",
        "reserve_base_xrp": 20,
        "reserve_inc_xrp": 5,
        "seq": 6595042
      },
      "validation_quorum": 3
    }
  }
}
"""

let rippledAccountInfoJson = """
{
  "id": 0,
  "status": "success",
  "type": "response",
  "result": {
    "account_data": {
      "Account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
      "Balance": "922913243",
      "Domain": "6578616D706C652E636F6D",
      "EmailHash": "23463B99B62A72F26ED677CC556C44E8",
      "Flags": 655360,
      "LedgerEntryType": "AccountRoot",
      "OwnerCount": 1,
      "PreviousTxnID": "19899273706A9E040FDB5885EE991A1DC2BAD878A0D6E7DBCFB714E63BF737F7",
      "PreviousTxnLgrSeq": 6614625,
      "Sequence": 23,
      "TransferRate": 1002000000,
      "TickSize": 5,
      "WalletLocator": "00000000000000000000000000000000000000000000000000000000DEADBEEF",
      "index": "396400950EA27EB5710C0D5BE1D2B4689139F168AC5D07C13B8140EC3F82AE71",
      "urlgravatar": "http://www.gravatar.com/avatar/23463b99b62a72f26ed677cc556c44e8",
      "signer_lists": [
        {
          "Flags": 0,
          "LedgerEntryType": "SignerList",
          "OwnerNode": "0000000000000000",
          "PreviousTxnID": "D2707DE50E1244B2C2AAEBC78C82A19ABAE0599D29362C16F1B8458EB65CCFE4",
          "PreviousTxnLgrSeq": 3131157,
          "SignerEntries": [
            {
              "SignerEntry": {
                "Account": "rpHit3GvUR1VSGh2PXcaaZKEEUnCVxWU2i",
                "SignerWeight": 1
              }
            }, {
              "SignerEntry": {
                "Account": "rN4oCm1c6BQz6nru83H52FBSpNbC9VQcRc",
                "SignerWeight": 1
              }
            }, {
              "SignerEntry": {
                "Account": "rJ8KhCi67VgbapiKCQN3r1ZA6BMUxUvvnD",
                "SignerWeight": 1
            }
          }],
          "SignerListID": 0,
          "SignerQuorum": 3,
          "index": "5A9373E02D1DEF7EC9204DEB4819BA42D6AA6BCD878DC8C853062E9DD9708D11"
        }
      ]
    },
    "ledger_index": 9592219
  }
}
"""
