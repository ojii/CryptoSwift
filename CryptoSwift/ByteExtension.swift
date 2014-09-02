//
//  ByteExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension Byte {

    init(bits: [Bit]) {
        var bitPattern:Byte = 0
        for (idx,b) in enumerate(bits) {
            if (b == Bit.Zero) {
                var bit:Byte = Byte(1) << Byte(idx)
                bitPattern = bitPattern | bit
            }
        }
        
        self.init(bitPattern)
    }
    
    /** array of bits */
    func bits() -> [Bit] {
        let totalBitsCount = sizeofValue(self) * 8
        
        var bitsArray = [Bit](count: totalBitsCount, repeatedValue: Bit.Zero)
        
        for j in 0..<totalBitsCount {
            let bitVal:Byte = 1 << Byte(totalBitsCount - 1 - j)
            let check = self & bitVal
            
            if (check != 0) {
                bitsArray[j] = Bit.One;
            }
        }
        return bitsArray
    }

    func bits() -> String {
        var s = String()
        let arr:[Bit] = self.bits()
        for (idx,b) in enumerate(arr) {
            s += (b == Bit.One ? "1" : "0")
            if ((idx + 1) % 8 == 0) { s += " " }
        }
        return s
    }

    /** Shift bits to the right. All bits are shifted (including sign bit) */
    mutating func shiftRight(count: Byte) -> Byte {
        if (self == 0) {
            return self;
        }

        var bitsCount = Byte(sizeof(Byte) * 8)

        if (count >= bitsCount) {
            return 0
        }

        var maxBitsForValue = Byte(floor(log2(Double(self) + 1)))
        var shiftCount = Swift.min(count, maxBitsForValue - 1)
        var shiftedValue:Byte = 0;
        
        for bitIdx in 0..<bitsCount {
            var byte = 1 << bitIdx
            if ((self & byte) == byte) {
                shiftedValue = shiftedValue | (byte >> shiftCount)
            }
        }
        self = shiftedValue
        return self
    }
}

/** shift right and assign with bits truncation */
func &>> (lhs: Byte, rhs: Byte) -> Byte {
    var l = lhs;
    l.shiftRight(rhs)
    return l
}