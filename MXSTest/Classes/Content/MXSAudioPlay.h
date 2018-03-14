//
//  MXSAudioPlay.h
//  MXSTest
//
//  Created by Alfred Yang on 14/3/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

/*
 •   数据类型
 1.AudioFileStreamID             文件流
 2.AudioQueueRef                     播放队列
 3.AudioStreamBasicDescription   格式化音频数据
 4.AudioQueueBufferRef             数据缓冲
 
 •   回调函数
 1.AudioFileStream_PacketsProc       解析音频数据回调
 2.AudioSessionInterruptionListener  音频会话被打断
 3.AudioQueueOutputCallback          一个AudioQueueBufferRef播放完
 
 •   主要函数
 0.AudioSessionInitialize (NULL, NULL, AudioSessionInterruptionListener, self);
 初始化音频会话
 
 1.AudioFileStreamOpen( (void*)self, &AudioFileStreamPropertyListenerProc, &AudioFileStreamPacketsProc, 0, &audio_file_stream);
 建立一个文件流AudioFileStreamID，传输解析的数据
 
 2.AudioFileStreamParseBytes(audio_file_stream, datalen, [data bytes], kAudioFileStreamProperty_FileFormat);
 解析音频数据
 
 3.AudioQueueNewOutput(&audio_format, AudioQueueOutputCallback, (void*)self, [[NSRunLoop currentRunLoop] getCFRunLoop], kCFRunLoopCommonModes, 0, &audio_queue);
 创建音频队列AudioQueueRef
 
 4.AudioQueueAllocateBuffer(queue, [data length], &buffer);
 创建音频缓冲数据AudioQueueBufferRef
 
 5.AudioQueueEnqueueBuffer(queue, buffer, num_packets, packet_descriptions);
 把缓冲数据排队加入到AudioQueueRef等待播放
 
 6.AudioQueueStart(audio_queue, nil);    播放
 7.AudioQueueStop(audio_queue, true);
 AudioQueuePause(audio_queue);          停止、暂停
 
 •   断点续传
 1。在http请求头中设置数据的请求范围，请求头中都是key-value成对
 key：Range           value:bytes=0-1000
 [request setValue:range  forHTTPHeaderField:@"Range"];
 可以实现:
 a.网络断开后再连接能继续从原来的断点下载
 b.可以实现播放进度可随便拉动
 
 */

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>

#define NUM_BUFFERS				3

@interface MXSAudioPlay : NSObject {
	//播放音频文件ID
	AudioFileID audioFile;
	//音频流描述对象
	AudioStreamBasicDescription dataFormat;
	//音频队列
	AudioQueueRef queue;
	SInt64 packetIndex;
	UInt32 numPacketsToRead;
	UInt32 bufferByteSize;
	AudioStreamPacketDescription *packetDescs;
	AudioQueueBufferRef buffers[NUM_BUFFERS];
}

//定义队列为实例属性
@property AudioQueueRef queue;

//播放方法定义
-(id)initWithAudio:(NSString *) path;

//定义缓存数据读取方法
-(void) audioQueueOutputWithQueue:(AudioQueueRef)audioQueue queueBuffer:(AudioQueueBufferRef)audioQueueBuffer;
-(UInt32)readPacketsIntoBuffer:(AudioQueueBufferRef)buffer;

//定义回调(Callback)函数
static void BufferCallack(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef buffer);

@end
