//
//  Utils.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 26/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

func rotateLeft(v:UInt32, n:UInt32) -> UInt32 {
    return ((v << n) & 0xFFFFFFFF) | (v >> (32 - n))
}

func rotateLeft(x:UInt64, n:UInt64) -> UInt64 {
    return (x << n) | (x >> (64 - n))
}

func rotateRight(x:UInt32, n:UInt32) -> UInt32 {
    return (x >> n) | (x << (32 - n))
}

func rotateRight(x:UInt64, n:UInt64) -> UInt64 {
    return ((x >> n) | (x << (64 - n)))
}

func reverseBytes(value: UInt32) -> UInt32 {
    // rdar://18060945 - not working since Xcode6-Beta6, need to split in two variables
    // return = ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8) | ((value & 0x00FF0000) >> 8)  | ((value & 0xFF000000) >> 24);
    
    // workaround
    var tmp1 = ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8)
    var tmp2 = ((value & 0x00FF0000) >> 8)  | ((value & 0xFF000000) >> 24)
    return tmp1 | tmp2
}


/** array of bytes, little-endian representation */
func bytesArray<T>(value:T, totalBytes:Int) -> [Byte] {
    var bytes = [Byte](count: totalBytes, repeatedValue: 0)
    var data = NSData(bytes: [value] as [T], length: min(sizeof(T),totalBytes))
    
    // then convert back to bytes, byte by byte
    for i in 0..<data.length {
        data.getBytes(&bytes[totalBytes - 1 - i], range:NSRange(location:i, length:sizeof(Byte)))
    }
    
    return bytes
}