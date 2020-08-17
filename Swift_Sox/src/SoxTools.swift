//
//  SoxTools.swift
//  SnapOke
//
//  Created by Modi on 2020/8/4.
//  Copyright © 2020 Modi. All rights reserved.
//

import Foundation

class SoxTools {
    
    /// sox更改音频文件播放速度
    /// - Parameter input: 源文件
    /// - Parameter output: 目标文件
    /// - Parameter rate: 速度
    class func changeAudioSpeed(_ input: String?, to output: String?, rate: String?) -> Bool {
        
        var isSuccess = false
        
        guard let source = input else { return isSuccess }
        guard let dst = output else { return isSuccess }
        guard let speed = rate else { return isSuccess }
        // 输入源是否存在
        if !FileManager.default.fileExists(atPath: source) {
            return isSuccess
        }
        // 输出文件是否已经存在
        if FileManager.default.fileExists(atPath: dst) {
            isSuccess = true
            return isSuccess
        }
        
        sox_init()
        guard let sourceRead = sox_open_read(source, nil, nil, nil) else {return isSuccess}
        
        let inSignal =  UnsafeMutablePointer<sox_signalinfo_t>.allocate(capacity: MemoryLayout<sox_signalinfo_t>.size)
        inSignal.initialize(to: sourceRead.pointee.signal)
        
        guard let dstWrite = sox_open_write(dst, inSignal, nil, nil, nil, nil) else {return isSuccess}
        
        let inEncoding = UnsafeMutablePointer<sox_encodinginfo_t>.allocate(capacity: MemoryLayout<sox_encodinginfo_t>.size)
        inEncoding.initialize(to: sourceRead.pointee.encoding)
        
        let outEncoding = UnsafeMutablePointer<sox_encodinginfo_t>.allocate(capacity: MemoryLayout<sox_encodinginfo_t>.size)
        outEncoding.initialize(to: dstWrite.pointee.encoding)
        
        guard let handleChain = sox_create_effects_chain(inEncoding, outEncoding) else {return isSuccess}
        
        guard let eInput = sox_find_effect("input") else {return isSuccess}
        
        var effect = sox_create_effect(eInput)
        
        // char *const argv[] = UnsafePointer<UnsafeMutablePointer<Int8>?>?
        let argv: UnsafePointer<UnsafeMutablePointer<Int8>?>? = nil
        
        // how to convert sourceRead to UnsafePointer<UnsafeMutablePointer<Int8>?>?

        sox_effect_options(effect, 1, argv)
        // in out ??
        sox_add_effect(handleChain, effect, inSignal, inSignal)
        
        guard let eTempo = sox_find_effect("tempo") else {return isSuccess}
        
        effect = sox_create_effect(eTempo)
        
        // how to convert speed to UnsafePointer<UnsafeMutablePointer<Int8>?>?
        
        sox_effect_options(effect, 1, argv)
        
        sox_add_effect(handleChain, effect, inSignal, inSignal)
        
        guard let eOutput = sox_find_effect("output") else {return isSuccess}
        
        effect = sox_create_effect(eOutput)
        
        // how to convert dstWrite to UnsafePointer<UnsafeMutablePointer<Int8>?>?
        
        sox_effect_options(effect, 1, argv)
        
        sox_add_effect(handleChain, effect, inSignal, inSignal)
        
        sox_flow_effects(handleChain, nil, nil)
        
        sox_delete_effects_chain(handleChain)
        sox_close(dstWrite)
        sox_close(sourceRead)
        sox_quit()
        
        // 回收开辟的内存
        inSignal.deinitialize(count: MemoryLayout<sox_signalinfo_t>.size)
        inSignal.deallocate()
        
        inEncoding.deinitialize(count: MemoryLayout<sox_encodinginfo_t>.size)
        inEncoding.deallocate()
        
        outEncoding.deinitialize(count: MemoryLayout<sox_encodinginfo_t>.size)
        outEncoding.deallocate()
        
        return isSuccess
    }
}
