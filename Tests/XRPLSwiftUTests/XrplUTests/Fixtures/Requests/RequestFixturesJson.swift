//
//  RequestFixturesJson.swift
//
//
//  Created by Denis Angell on 8/14/22.
//

import Foundation

let orderBookFixtureReq = """
{
  "takerPays": {
    "currency": "USD",
    "issuer": "rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B"
  },
  "takerGets": {
    "currency": "BTC",
    "issuer": "rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B"
  }
}
"""

let orderBookXRPFixtureReq = """
{
  "takerPays": {
    "currency": "USD",
    "issuer": "rp8rJYTpodf8qbSCHVTNacf8nSW8mRakFw"
  },
  "takerGets": {
    "currency": "XRP"
  }
}
"""

let hashLedgerFixtureReq = """
{
  "account_hash": "D9ABF622DA26EEEE48203085D4BC23B0F77DC6F8724AC33D975DA3CA492D2E44",
  "close_time": 492656470,
  "parent_close_time": 492656460,
  "close_flags": 0,
  "ledger_index": "15202439",
  "close_time_human": "2015-Aug-12 01:01:10.000000000 UTC",
  "close_time_resolution": 10,
  "closed": true,
  "hash": "F4D865D83EB88C1A1911B9E90641919A1314F36E1B099F8E95FE3B7C77BE3349",
  "ledger_hash": "F4D865D83EB88C1A1911B9E90641919A1314F36E1B099F8E95FE3B7C77BE3349",
  "parent_hash": "12724A65B030C15A1573AA28B1BBB5DF3DA4589AA3623675A31CAE69B23B1C4E",
  "total_coins": "99998831688050493",
  "transaction_hash": "325EACC5271322539EEEC2D6A5292471EF1B3E72AE7180533EFC3B8F0AD435C8"
}
"""

let hashLedgerTxFixtureReq = """
[
  {
    "TransactionType": "Payment",
    "Flags": 2147483648,
    "Sequence": 1608,
    "LastLedgerSequence": 15202446,
    "Amount": "120000000",
    "Fee": "15000",
    "SigningPubKey": "03BC0973F997BC6384BE455B163519A3E96BC2D725C37F7172D5FED5DD38E2A357",
    "TxnSignature": "3045022100D80A1802B00AEEF9FDFDE594B0D568217A312D54E6337B8519C0D699841EFB96022067F6913B13D0EC2354C5A67CE0A41AE4181A09CD08A1BB0638D128D357961006",
    "Account": "rDPL68aNpdfp9h59R4QT5R6B1Z2W9oRc51",
    "Destination": "rE4S4Xw8euysJ3mt7gmK8EhhYEwmALpb3R",
    "metaData": {
      "TransactionIndex": 6,
      "AffectedNodes": [
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202381,
            "PreviousTxnID": "8FFB65C6907C9679C5F8AADA97072CD1B8FE4955FC6A614AC87408AE7C9088AD",
            "LedgerIndex": "B07B367ABF05243A536986DEC74684E983BBBDDF443ADE9CDC43A22D6E6A1420",
            "PreviousFields": {
              "Sequence": 1608,
              "Balance": "61455842701"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 1609,
              "OwnerCount": 0,
              "Balance": "61335827701",
              "Account": "rDPL68aNpdfp9h59R4QT5R6B1Z2W9oRc51"
            }
          }
        },
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202438,
            "PreviousTxnID": "B01591A2353CD39EFAC989D542EE37591F60CF9BB2B66526C8C958774813407E",
            "LedgerIndex": "F77EB82FA9593E695F22155C00C569A570CF32316BEFDFF0B16BADAFF2ACFF19",
            "PreviousFields": {
              "Balance": "26762033252"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 6448,
              "OwnerCount": 3,
              "Balance": "26882033252",
              "Account": "rE4S4Xw8euysJ3mt7gmK8EhhYEwmALpb3R"
            }
          }
        }
      ],
      "TransactionResult": "tesSUCCESS"
    }
  },
  {
    "TransactionType": "Payment",
    "Flags": 2147483648,
    "Sequence": 18874,
    "LastLedgerSequence": 15202446,
    "Amount": "120000000",
    "Fee": "15000",
    "SigningPubKey": "035D097E75D4B35345CEB30F9B1D18CB81165FE6ADD02481AA5B02B5F9C8107EE1",
    "TxnSignature": "304402203D80E8BC71908AB345948AB71FB7B8DE239DD79636D96D3C5BDA2B2F192A5EEA0220686413D69BF0D813FC61DABD437AEFAAE69925D3E10FCD5B2C4D90B5AF7B883D",
    "Account": "rnHScgV6wSP9sR25uYWiMo3QYNA5ybQ7cH",
    "Destination": "rwnnfHDaEAwXaVji52cWWizbHVMs2Cz5K9",
    "metaData": {
      "TransactionIndex": 5,
      "AffectedNodes": [
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202429,
            "PreviousTxnID": "B1F39887411C1771998F38502EDF33170F9F5659503DB9DE642EBA896B5F198B",
            "LedgerIndex": "2AAA3361C593C4DE7ABD9A607B3CA7070A3F74E3C3F2FDE4DDB9484E47ED056E",
            "PreviousFields": {
              "Sequence": 18874,
              "Balance": "13795295558367"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 18875,
              "OwnerCount": 0,
              "Balance": "13795175543367",
              "Account": "rnHScgV6wSP9sR25uYWiMo3QYNA5ybQ7cH"
            }
          }
        },
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202416,
            "PreviousTxnID": "00CF9C7BE3EBAF76893C6A3F6D10B4D89F8D856C97B9D44938CF1682132ACEB8",
            "LedgerIndex": "928582D6F6942B18F3462FA04BA99F476B64FEB9921BFAD583182DC28CB74187",
            "PreviousFields": {
              "Balance": "17674359316"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 1710,
              "OwnerCount": 0,
              "Balance": "17794359316",
              "Account": "rwnnfHDaEAwXaVji52cWWizbHVMs2Cz5K9"
            }
          }
        }
      ],
      "TransactionResult": "tesSUCCESS"
    }
  },
  {
    "TransactionType": "Payment",
    "Flags": 2147483648,
    "Sequence": 1615,
    "LastLedgerSequence": 15202446,
    "Amount": "400000000",
    "Fee": "15000",
    "SigningPubKey": "03ACFAA11628C558AB5E7FA64705F442BDAABA6E9D318B30E010BC87CDEA8D1D7D",
    "TxnSignature": "3045022100A3530C2E983FB05DFF27172C649494291F7BEBA2E6A59EEAF945CB9728D1DB5E022015BCA0E9D69760224DD7C2B68F3BC1F239D89C3397161AA3901C2E04EE31C18F",
    "Account": "razcSDpwds1aTeqDphqzBr7ay1ZELYAWTm",
    "Destination": "rhuqJAE2UfhGCvkR7Ve35bvm39JmRvFML4",
    "metaData": {
      "TransactionIndex": 4,
      "AffectedNodes": [
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202394,
            "PreviousTxnID": "99E8F8988390F5A8DF69BBA4F04705E5085EE91B27583D28210D37B7513F10BB",
            "LedgerIndex": "17CF549DFC0813DDC44559C89E99B4C1D033D59FF379AD948CBEC141F179293D",
            "PreviousFields": {
              "Sequence": 1615,
              "Balance": "45875786250"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 1616,
              "OwnerCount": 0,
              "Balance": "45475771250",
              "Account": "razcSDpwds1aTeqDphqzBr7ay1ZELYAWTm"
            }
          }
        },
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202438,
            "PreviousTxnID": "9EC0784393DA95BB3B38FABC59FEFEE34BA8487DD892B9EAC1D70E483D1B0FA6",
            "LedgerIndex": "EB13399E9A69F121BEDA810F1AE9CB4023B4B09C5055CB057B572029B2FC8DD4",
            "PreviousFields": {
              "Balance": "76953067090"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 601,
              "OwnerCount": 4,
              "Balance": "77353067090",
              "Account": "rhuqJAE2UfhGCvkR7Ve35bvm39JmRvFML4"
            }
          }
        }
      ],
      "TransactionResult": "tesSUCCESS"
    }
  },
  {
    "TransactionType": "Payment",
    "Flags": 2147483648,
    "Sequence": 1674,
    "LastLedgerSequence": 15202446,
    "Amount": "800000000",
    "Fee": "15000",
    "SigningPubKey": "028F28D78FDA74222F4008F012247DF3BBD42B90CE4CFD87E29598196108E91B52",
    "TxnSignature": "3044022065A003194D91E774D180BE47D4E086BB2624BC8F6DB7C655E135D5C6C03BBC7C02205DC961C2B7A06D701B29C2116ACF6F84CC84205FF44411576C15507852ECC31C",
    "Account": "rQGLp9nChtWkdgcHjj6McvJithN2S2HJsP",
    "Destination": "rEUubanepAAugnNJY1gxEZLDnk9W5NCoFU",
    "metaData": {
      "TransactionIndex": 3,
      "AffectedNodes": [
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202409,
            "PreviousTxnID": "6A9B73C13B8A74BCDB64B5ADFE3D8FFEAC7928B82CFD6C9A35254D7798AD0688",
            "LedgerIndex": "D1A7795E8E997E7DE65D64283FD7CEEB5E43C2E5C4A794C2CFCEC6724E03F464",
            "PreviousFields": {
              "Sequence": 1674,
              "Balance": "8774844732"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 1675,
              "OwnerCount": 0,
              "Balance": "7974829732",
              "Account": "rQGLp9nChtWkdgcHjj6McvJithN2S2HJsP"
            }
          }
        },
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202388,
            "PreviousTxnID": "ECE994DA817228D9170D22C01CE1BF5B17FFE1AE6404FF215719C1049E9939E0",
            "LedgerIndex": "E5EA9215A6D41C4E20C831ACE436E5B75F9BA2A9BD4325BA65BD9D44F5E13A08",
            "PreviousFields": {
              "Balance": "9077529029"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 1496,
              "OwnerCount": 0,
              "Balance": "9877529029",
              "Account": "rEUubanepAAugnNJY1gxEZLDnk9W5NCoFU"
            }
          }
        }
      ],
      "TransactionResult": "tesSUCCESS"
    }
  },
  {
    "TransactionType": "OfferCreate",
    "Sequence": 289444,
    "OfferSequence": 289443,
    "LastLedgerSequence": 15202441,
    "TakerPays": {
      "value": "19.99999999991",
      "currency": "EUR",
      "issuer": "rMwjYedjc7qqtKYVLiAccJSmCwih4LnE2q"
    },
    "TakerGets": {
      "value": "20.88367500010602",
      "currency": "USD",
      "issuer": "rMwjYedjc7qqtKYVLiAccJSmCwih4LnE2q"
    },
    "Fee": "10000",
    "SigningPubKey": "024D129D4F5A12D4C5A9E9D1E4AC447BBE3496F182FAE82F7709C7EB9F12DBC697",
    "TxnSignature": "3044022041EBE6B06BA493867F4FFBD72E5D6253F97306E1E82DABDF9649E15B1151B59F0220539C589F40174471C067FDC761A2B791F36F1A3C322734B43DB16880E489BD81",
    "Account": "rD8LigXE7165r3VWhSQ4FwzJy7PNrTMwUq",
    "Memos": [
      {
        "Memo": {
          "MemoType": "6F666665725F636F6D6D656E74",
          "MemoData": "72655F6575722368656467655F726970706C65",
          "parsed_memo_type": "offer_comment"
        }
      }
    ],
    "metaData": {
      "TransactionIndex": 2,
      "AffectedNodes": [
        {
          "CreatedNode": {
            "LedgerEntryType": "Offer",
            "LedgerIndex": "2069A6F3B349C246630536B3A0D18FECF0B088D6846ED74D56762096B972ADBE",
            "NewFields": {
              "Sequence": 289444,
              "BookDirectory": "D3C7DF102A0CEDB307D6F471B0CE679C5C206D8227D9BB2E5422061A1FB5AF31",
              "TakerPays": {
                "value": "19.99999999991",
                "currency": "EUR",
                "issuer": "rMwjYedjc7qqtKYVLiAccJSmCwih4LnE2q"
              },
              "TakerGets": {
                "value": "20.88367500010602",
                "currency": "USD",
                "issuer": "rMwjYedjc7qqtKYVLiAccJSmCwih4LnE2q"
              },
              "Account": "rD8LigXE7165r3VWhSQ4FwzJy7PNrTMwUq"
            }
          }
        },
        {
          "ModifiedNode": {
            "LedgerEntryType": "DirectoryNode",
            "LedgerIndex": "68E8826D6545315B54943AF0D6A45264598F2DE8A71CB9EFA97C9F4456078BE8",
            "FinalFields": {
              "Flags": 0,
              "RootIndex": "68E8826D6545315B54943AF0D6A45264598F2DE8A71CB9EFA97C9F4456078BE8",
              "Owner": "rD8LigXE7165r3VWhSQ4FwzJy7PNrTMwUq"
            }
          }
        },
        {
          "DeletedNode": {
            "LedgerEntryType": "Offer",
            "LedgerIndex": "9AC6C83397287FDFF4DB7ED6D96DA060CF32ED6593B18C332EEDFE833AE48E1C",
            "FinalFields": {
              "Flags": 0,
              "Sequence": 289443,
              "PreviousTxnLgrSeq": 15202438,
              "BookNode": "0000000000000000",
              "OwnerNode": "0000000000000000",
              "PreviousTxnID": "6C1B0818CA470DBD5EFC28FC863862B0DF9D9F659475612446806401C56E3B28",
              "BookDirectory": "D3C7DF102A0CEDB307D6F471B0CE679C5C206D8227D9BB2E5422061A1FB5AF31",
              "TakerPays": {
                "value": "19.99999999991",
                "currency": "EUR",
                "issuer": "rMwjYedjc7qqtKYVLiAccJSmCwih4LnE2q"
              },
              "TakerGets": {
                "value": "20.88367500010602",
                "currency": "USD",
                "issuer": "rMwjYedjc7qqtKYVLiAccJSmCwih4LnE2q"
              },
              "Account": "rD8LigXE7165r3VWhSQ4FwzJy7PNrTMwUq"
            }
          }
        },
        {
          "ModifiedNode": {
            "LedgerEntryType": "DirectoryNode",
            "LedgerIndex": "D3C7DF102A0CEDB307D6F471B0CE679C5C206D8227D9BB2E5422061A1FB5AF31",
            "FinalFields": {
              "Flags": 0,
              "ExchangeRate": "5422061A1FB5AF31",
              "RootIndex": "D3C7DF102A0CEDB307D6F471B0CE679C5C206D8227D9BB2E5422061A1FB5AF31",
              "TakerPaysCurrency": "0000000000000000000000004555520000000000",
              "TakerPaysIssuer": "DD39C650A96EDA48334E70CC4A85B8B2E8502CD3",
              "TakerGetsCurrency": "0000000000000000000000005553440000000000",
              "TakerGetsIssuer": "DD39C650A96EDA48334E70CC4A85B8B2E8502CD3"
            }
          }
        },
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202438,
            "PreviousTxnID": "6C1B0818CA470DBD5EFC28FC863862B0DF9D9F659475612446806401C56E3B28",
            "LedgerIndex": "D8614A045CBA0F0081B23FD80CA87E7D08651FA02450C7BEE1B480836F0DC95D",
            "PreviousFields": {
              "Sequence": 289444,
              "Balance": "3712981021"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 289445,
              "OwnerCount": 13,
              "Balance": "3712971021",
              "Account": "rD8LigXE7165r3VWhSQ4FwzJy7PNrTMwUq"
            }
          }
        }
      ],
      "TransactionResult": "tesSUCCESS"
    }
  },
  {
    "TransactionType": "AccountSet",
    "Flags": 2147483648,
    "Sequence": 387262,
    "LastLedgerSequence": 15202440,
    "Fee": "10500",
    "SigningPubKey": "027DFE042DC2BD07D2E88DD526A5FBF816C831C25CA0BB62A3BF320A3B2BA6DB5C",
    "TxnSignature": "30440220572D89688D9F9DB9874CDDDD3EBDCB5808A836982864C81F185FBC54FAD1A7B902202E09AAA6D65EECC9ACDEA7F70D8D2EE024152C7B288FA9E42C427260CF922F58",
    "Account": "rn6uAt46Xi6uxA2dRCtqaJyM3aaP6V9WWM",
    "metaData": {
      "TransactionIndex": 1,
      "AffectedNodes": [
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202429,
            "PreviousTxnID": "212D4BFAD4DFB0887B57AB840A8385F31FC2839FFD4169A824280565CC2885C0",
            "LedgerIndex": "317481AD6274D399F50E13EF447825DA628197E6262B80642DAE0D8300D77E55",
            "PreviousFields": {
              "Sequence": 387262,
              "Balance": "207020609"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 387263,
              "OwnerCount": 22,
              "Balance": "207010109",
              "Account": "rn6uAt46Xi6uxA2dRCtqaJyM3aaP6V9WWM"
            }
          }
        }
      ],
      "TransactionResult": "tesSUCCESS"
    }
  },
  {
    "TransactionType": "Payment",
    "Flags": 2147483648,
    "Sequence": 1673,
    "LastLedgerSequence": 15202446,
    "Amount": "1700000000",
    "Fee": "15000",
    "SigningPubKey": "02C26CF5D395A1CB352BE10D5AAB73FE27FC0AFAE0BD6121E55D097EBDCF394E11",
    "TxnSignature": "304402204190B6DC7D14B1CC8DDAA87F1C01FEDA6D67D598D65E1AA19D4ADE937ED14B720220662EE404438F415AD3335B9FBA1A4C2A5F72AA387740D8A011A8C53346481B1D",
    "Account": "rEE77T1E5vEFcEB9zM92jBD3rPs3kPdS1j",
    "Destination": "r3AsrDRMNYaKNCofo9a5Us7R66RAzTigiU",
    "metaData": {
      "TransactionIndex": 0,
      "AffectedNodes": [
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202352,
            "PreviousTxnID": "6B3D159578F8E1CEBB268DBC5209ADB35DD075F463855886421D307026D27C67",
            "LedgerIndex": "AB5EBD00C6F12DEC32B1687A51948ADF07DC2ABDD7485E9665DCE5268039B461",
            "PreviousFields": {
              "Balance": "23493344926"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 1775,
              "OwnerCount": 0,
              "Balance": "25193344926",
              "Account": "r3AsrDRMNYaKNCofo9a5Us7R66RAzTigiU"
            }
          }
        },
        {
          "ModifiedNode": {
            "LedgerEntryType": "AccountRoot",
            "PreviousTxnLgrSeq": 15202236,
            "PreviousTxnID": "A2C23A20377BA7A90F77F01F8E337B64E22C929C5490E2E9698A7A9BFFEC592A",
            "LedgerIndex": "C67232D5308CBE1A8C3D75284D98CC1623D906DB30774C06B3F4934BC1DE5CEE",
            "PreviousFields": {
              "Sequence": 1673,
              "Balance": "17034504878"
            },
            "FinalFields": {
              "Flags": 0,
              "Sequence": 1674,
              "OwnerCount": 0,
              "Balance": "15334489878",
              "Account": "rEE77T1E5vEFcEB9zM92jBD3rPs3kPdS1j"
            }
          }
        }
      ],
      "TransactionResult": "tesSUCCESS"
    }
  }
]
"""

let signFixtureReq = """
{
  "TransactionType":"AccountSet",
  "Flags":2147483648,
  "Sequence":23,
  "LastLedgerSequence":8820051,
  "Fee":"12",
  "SigningPubKey":"02A8A44DB3D4C73EEEE11DFE54D2029103B776AA8A8D293A91D645977C9DF5F544",
  "Domain":"6578616D706C652E636F6D",
  "Account":"r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59"
}
"""

let signAsFixtureReq = """
{
  "Account": "rnUy2SHTrB9DubsPmkJZUXTf5FcNDGrYEA",
  "Amount": "1000000000",
  "Destination": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
  "Fee": "50",
  "Sequence": 2,
  "TransactionType": "Payment"
}
"""

let signEscrowFixtureReq = """
{
  "TransactionType":"EscrowFinish",
  "Account":"rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
  "Owner":"rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
  "OfferSequence":2,
  "Condition":"712C36933822AD3A3D136C5DF97AA863B69F9CE88B2D6CE6BDD11BFDE290C19D",
  "Fulfillment":"74686973206D757374206861766520333220636861726163746572732E2E2E2E",
  "Flags":2147483648,
  "LastLedgerSequence":102,
  "Fee":"12",
  "Sequence":1
}
"""

let signClaimFixtureReq = """
{
  "channel": "3E18C05AD40319B809520F1A136370C4075321B285217323396D6FD9EE1E9037",
  "amount": ".00001"
}
"""

let signTicketFixtureReq = """
{
  "TransactionType": "TicketCreate",
  "TicketCount":1,
  "Account":"r4SDqUD1ZcfoZrhnsZ94XNFKxYL4oHYJyA",
  "Sequence":0,
  "TicketSequence":23,
  "Fee":"10000"
}
"""
