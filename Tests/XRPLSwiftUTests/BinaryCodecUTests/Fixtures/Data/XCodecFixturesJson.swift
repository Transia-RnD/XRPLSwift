//
//  XCodecFixturesJson.swift
//
//
//  Created by Denis Angell on 7/24/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/fixtures/data/x-codec-fixtures.json

import Foundation

let xcodecFixturesJson = """
{
  "transactions": [{
    "rjson": {
      "Account": "r3kmLJN5D28dHuH8vZNUZpMC43pEHpaocV",
      "Destination": "rLQBHVhFnaC5gLEkgr6HgBJJ3bgeZHg9cj",
      "TransactionType": "Payment",
      "TxnSignature": "3045022022EB32AECEF7C644C891C19F87966DF9C62B1F34BABA6BE774325E4BB8E2DD62022100A51437898C28C2B297112DF8131F2BB39EA5FE613487DDD611525F1796264639",
      "SigningPubKey": "034AADB09CFF4A4804073701EC53C3510CDC95917C2BB0150FB742D0C66E6CEE9E",
      "Amount": "10000000000",
      "DestinationTag": 1010,
      "SourceTag": 84854,
      "Fee": "10",
      "Flags": 0,
      "Sequence": 62
    },
    "xjson": {
      "Account": "X7tFPvjMH7nDxP8nTGkeeggcUpCZj8UbyT2QoiRHGDfjqrB",
      "Destination": "XVYmGpJqHS95ir411XvanwY1xt5Z2314WsamHPVgUNABUGV",
      "TransactionType": "Payment",
      "TxnSignature": "3045022022EB32AECEF7C644C891C19F87966DF9C62B1F34BABA6BE774325E4BB8E2DD62022100A51437898C28C2B297112DF8131F2BB39EA5FE613487DDD611525F1796264639",
      "SigningPubKey": "034AADB09CFF4A4804073701EC53C3510CDC95917C2BB0150FB742D0C66E6CEE9E",
      "Amount": "10000000000",
      "Fee": "10",
      "Flags": 0,
      "Sequence": 62
    }
  },
  {
    "rjson": {
      "Account": "r4DymtkgUAh2wqRxVfdd3Xtswzim6eC6c5",
      "Amount": "199000000",
      "Destination": "rsekGH9p9neiPxym2TMJhqaCzHFuokenTU",
      "DestinationTag": 3663729509,
      "Fee": "6335",
      "Flags": 2147483648,
      "LastLedgerSequence": 57313352,
      "Sequence": 105791,
      "SigningPubKey": "02053A627976CE1157461336AC65290EC1571CAAD1B327339980F7BF65EF776F83",
      "TransactionType": "Payment",
      "TxnSignature": "30440220086D3330CD6CE01D891A26BA0355D8D5A5D28A5C9A1D0C5E06E321C81A02318A0220027C3F6606E41FEA35103EDE5224CC489B6514ACFE27543185B0419DD02E301C"
    },
    "xjson": {
      "Account": "r4DymtkgUAh2wqRxVfdd3Xtswzim6eC6c5",
      "Amount": "199000000",
      "Destination": "X7cBoj6a5xSEfPCr6AStN9YPhbMAA2yaN2XYWwRJKAKb3y5",
      "Fee": "6335",
      "Flags": 2147483648,
      "LastLedgerSequence": 57313352,
      "Sequence": 105791,
      "SigningPubKey": "02053A627976CE1157461336AC65290EC1571CAAD1B327339980F7BF65EF776F83",
      "TransactionType": "Payment",
      "TxnSignature": "30440220086D3330CD6CE01D891A26BA0355D8D5A5D28A5C9A1D0C5E06E321C81A02318A0220027C3F6606E41FEA35103EDE5224CC489B6514ACFE27543185B0419DD02E301C"
    }
  },
  {
    "rjson": {
      "Account": "rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv",
      "Amount": "105302107",
      "Destination": "r33hypJXDs47LVpmvta7hMW9pR8DYeBtkW",
      "DestinationTag": 1658156118,
      "Fee": "60000",
      "Flags": 2147483648,
      "LastLedgerSequence": 57313566,
      "Sequence": 1113196,
      "SigningPubKey": "03D847C2DBED3ABF0453F71DCD7641989136277218DF516AD49519C9693F32727E",
      "TransactionType": "Payment",
      "TxnSignature": "3045022100FCA10FBAC65EA60C115A970CD52E6A526B1F9DDB6C4F843DA3DE7A97DFF9492D022037824D0FC6F663FB08BE0F2812CBADE1F61836528D44945FC37F10CC03215111"
    },
    "xjson": {
      "Account": "rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv",
      "Amount": "105302107",
      "Destination": "X7ikFY5asEwp6ikt2AJdTfBLALEs5JN35kkeqKVeT1GdvY1",
      "Fee": "60000",
      "Flags": 2147483648,
      "LastLedgerSequence": 57313566,
      "Sequence": 1113196,
      "SigningPubKey": "03D847C2DBED3ABF0453F71DCD7641989136277218DF516AD49519C9693F32727E",
      "TransactionType": "Payment",
      "TxnSignature": "3045022100FCA10FBAC65EA60C115A970CD52E6A526B1F9DDB6C4F843DA3DE7A97DFF9492D022037824D0FC6F663FB08BE0F2812CBADE1F61836528D44945FC37F10CC03215111"
    }
  },
  {
    "rjson": {
      "Account": "rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv",
      "Amount": "3899911571",
      "Destination": "rU2mEJSLqBRkYLVTv55rFTgQajkLTnT6mA",
      "DestinationTag": 255406,
      "Fee": "60000",
      "Flags": 2147483648,
      "LastLedgerSequence": 57313566,
      "Sequence": 1113197,
      "SigningPubKey": "03D847C2DBED3ABF0453F71DCD7641989136277218DF516AD49519C9693F32727E",
      "TransactionType": "Payment",
      "TxnSignature": "3044022077642D94BB3C49BF3CB4C804255EC830D2C6009EA4995E38A84602D579B8AAD702206FAD977C49980226E8B495BF03C8D9767380F1546BBF5A4FD47D604C0D2CCF9B"
    },
    "xjson": {
      "Account": "rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv",
      "Amount": "3899911571",
      "Destination": "XVfH8gwNWVbB5Kft16jmTNgGTqgw1dzA8ZTBkNjSLw6JdXS",
      "Fee": "60000",
      "Flags": 2147483648,
      "LastLedgerSequence": 57313566,
      "Sequence": 1113197,
      "SigningPubKey": "03D847C2DBED3ABF0453F71DCD7641989136277218DF516AD49519C9693F32727E",
      "TransactionType": "Payment",
      "TxnSignature": "3044022077642D94BB3C49BF3CB4C804255EC830D2C6009EA4995E38A84602D579B8AAD702206FAD977C49980226E8B495BF03C8D9767380F1546BBF5A4FD47D604C0D2CCF9B"
    }
  },
  {
    "rjson": {
      "Account": "r4eEbLKZGbVSBHnSUBZW8i5XaMjGLdqT4a",
      "Amount": "820370849",
      "Destination": "rDhmyBh4JwDAtXyRZDarNgg52UcLLRoGje",
      "DestinationTag": 2017780486,
      "Fee": "6000",
      "Flags": 2147483648,
      "LastLedgerSequence": 57315579,
      "Sequence": 234254,
      "SigningPubKey": "038CF47114672A12B269AEE015BF7A8438609B994B0640E4B28B2F56E93D948B15",
      "TransactionType": "Payment",
      "TxnSignature": "3044022015004653B1CBDD5CCA1F7B38555F1B37FE3F811E9D5070281CCC6C8A93460D870220679E9899184901EA69750C8A9325768490B1B9C1A733842446727653FF3D1DC0"
    },
    "xjson": {
      "Account": "r4eEbLKZGbVSBHnSUBZW8i5XaMjGLdqT4a",
      "Amount": "820370849",
      "Destination": "XV31huWNJQXsAJFwgE6rnC8uf8jRx4H4waq4MyGUxz5CXzS",
      "Fee": "6000",
      "Flags": 2147483648,
      "LastLedgerSequence": 57315579,
      "Sequence": 234254,
      "SigningPubKey": "038CF47114672A12B269AEE015BF7A8438609B994B0640E4B28B2F56E93D948B15",
      "TransactionType": "Payment",
      "TxnSignature": "3044022015004653B1CBDD5CCA1F7B38555F1B37FE3F811E9D5070281CCC6C8A93460D870220679E9899184901EA69750C8A9325768490B1B9C1A733842446727653FF3D1DC0"
    }
  },
  {
    "rjson": {
      "Account": "rsGeDwS4rpocUumu9smpXomzaaeG4Qyifz",
      "Amount": "1500000000",
      "Destination": "rDxfhNRgCDNDckm45zT5ayhKDC4Ljm7UoP",
      "DestinationTag": 1000635172,
      "Fee": "5000",
      "Flags": 2147483648,
      "Sequence": 55741075,
      "SigningPubKey": "02ECB814477DF9D8351918878E235EE6AF147A2A5C20F1E71F291F0F3303357C36",
      "SourceTag": 1000635172,
      "TransactionType": "Payment",
      "TxnSignature": "304402202A90972E21823214733082E1977F9EA2D6B5101902F108E7BDD7D128CEEA7AF3022008852C8DAD746A7F18E66A47414FABF551493674783E8EA7409C501D3F05F99A"
    },
    "xjson": {
      "Account": "rsGeDwS4rpocUumu9smpXomzaaeG4Qyifz",
      "Amount": "1500000000",
      "Destination": "XVBkK1yLutMqFGwTm6hykn7YXGDUrjsZSkpzMgRveZrMbHs",
      "Fee": "5000",
      "Flags": 2147483648,
      "Sequence": 55741075,
      "SigningPubKey": "02ECB814477DF9D8351918878E235EE6AF147A2A5C20F1E71F291F0F3303357C36",
      "SourceTag": 1000635172,
      "TransactionType": "Payment",
      "TxnSignature": "304402202A90972E21823214733082E1977F9EA2D6B5101902F108E7BDD7D128CEEA7AF3022008852C8DAD746A7F18E66A47414FABF551493674783E8EA7409C501D3F05F99A"
    }
  },
  {
    "rjson": {
      "Account": "rHWcuuZoFvDS6gNbmHSdpb7u1hZzxvCoMt",
      "Amount": "48918500000",
      "Destination": "rEb8TK3gBgk5auZkwc6sHnwrGVJH8DuaLh",
      "DestinationTag": 105959914,
      "Fee": "10",
      "Flags": 2147483648,
      "Sequence": 32641,
      "SigningPubKey": "02E98DA545CCCC5D14C82594EE9E6CCFCF5171108E2410B3E784183E1068D33429",
      "TransactionType": "Payment",
      "TxnSignature": "304502210091DCA7AF189CD9DC93BDE24DEAE87381FBF16789C43113EE312241D648982B2402201C6055FEFFF1F119640AAC0B32C4F37375B0A96033E0527A21C1366920D6A524"
    },
    "xjson": {
      "Account": "rHWcuuZoFvDS6gNbmHSdpb7u1hZzxvCoMt",
      "Amount": "48918500000",
      "Destination": "XVH3aqvbYGhRhrD1FYSzGooNuxdzbG3VR2fuM47oqbXxQr7",
      "Fee": "10",
      "Flags": 2147483648,
      "Sequence": 32641,
      "SigningPubKey": "02E98DA545CCCC5D14C82594EE9E6CCFCF5171108E2410B3E784183E1068D33429",
      "TransactionType": "Payment",
      "TxnSignature": "304502210091DCA7AF189CD9DC93BDE24DEAE87381FBF16789C43113EE312241D648982B2402201C6055FEFFF1F119640AAC0B32C4F37375B0A96033E0527A21C1366920D6A524"
    }
  },
  {
    "rjson": {
      "PreviousTxnLgrSeq": 239,
      "LedgerEntryType": "RippleState",
      "LowLimit": {
        "currency": "USD",
        "value": "0",
        "issuer": "rnziParaNb8nsU4aruQdwYE3j5jUcqjzFm"
      },
      "PreviousTxnID": "C6A2521BBCCF13282C4FFEBC00D47BBA18C6CE5F5E4E0EFC3E3FCE364BAFC6B8",
      "Flags": 131072,
      "Balance": {
        "currency": "USD",
        "value": "0",
        "issuer": "rrrrrrrrrrrrrrrrrrrrBZbvji"
      },
      "HighLimit": {
        "currency": "USD",
        "value": "10",
        "issuer": "rMYBVwiY95QyUnCeuBQA1D47kXA9zuoBui"
      }
    },
    "xjson": {
      "PreviousTxnLgrSeq": 239,
      "LedgerEntryType": "RippleState",
      "LowLimit": {
        "currency": "USD",
        "value": "0",
        "issuer": "X7jqKn4UidCF7AQ7Eeyfn3vJubztfhF1LwTD9PV2QhPpnvx"
      },
      "PreviousTxnID": "C6A2521BBCCF13282C4FFEBC00D47BBA18C6CE5F5E4E0EFC3E3FCE364BAFC6B8",
      "Flags": 131072,
      "Balance": {
        "currency": "USD",
        "value": "0",
        "issuer": "X7TYFRtYHMcHtT2qNycMwgXzFbcRvdrhMLy5kJrYHpJDkc2"
      },
      "HighLimit": {
        "currency": "USD",
        "value": "10",
        "issuer": "XVc7LPeF5cfwQ1XRmz6Ursck9i8yWpb1yqApvW4ZGuDNZbD"
      }
    }
  }]
}
"""
