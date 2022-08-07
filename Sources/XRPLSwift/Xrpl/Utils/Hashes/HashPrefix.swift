//
//  HashPrefix.swift
//  
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/hashes/HashPrefix.ts

import Foundation

/**
 * Prefix for hashing functions.
 *
 * These prefixes are inserted before the source material used to
 * generate various hashes. This is done to put each hash in its own
 * "space." This way, two different types of objects with the
 * same binary data will produce different hashes.
 *
 * Each prefix is a 4-byte value with the last byte set to zero
 * and the first three bytes formed from the ASCII equivalent of
 * some arbitrary string. For example "TXN".
 */
public enum HashPrefix: Int {
    // transaction plus signature to give transaction ID 'TXN'
    case TRANSACTION_ID = 0x54584e00
    
    // transaction plus metadata 'TND'
    case TRANSACTION_NODE = 0x534e4400
    
    // inner node in tree 'MIN'
    case INNER_NODE = 0x4d494e00
    
    // leaf node in tree 'MLN'
    case LEAF_NODE = 0x4d4c4e00
    
    // inner transaction to sign 'STX'
    case TRANSACTION_SIGN = 0x53545800
    
    // inner transaction to sign (TESTNET) 'stx'
    case TRANSACTION_SIGN_TESTNET = 0x73747800
    
    // inner transaction to multisign 'SMT'
    case TRANSACTION_MULTISIGN = 0x534d5400
    
    // ledger 'LWR'
    case LEDGER = 0x4c575200
}
