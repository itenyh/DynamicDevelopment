//
//  FileSystemWatch.m
//  SmallCity
//
//  Created by Iten on 2018/6/21.
//  Copyright © 2018年 Essence. All rights reserved.
//

#import "FileSystemWatch.h"

#include <sys/event.h>
#include <sys/time.h>
#include <fcntl.h>

@interface FileSystemWatch ()

@property (nonatomic,retain) NSString* path;
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;
@property (nonatomic,assign) int fildes;
@property (nonatomic,assign) int kq;
@property (nonatomic,retain) NSThread* watchThread;

@end

@implementation FileSystemWatch
@synthesize path = _path;
@synthesize target = _target;
@synthesize action = _action;
@synthesize fildes = _fildes;
@synthesize kq = _kq;
@synthesize watchThread = _watchThread;

- (void)watchFileAtPath:(NSString*)path target:(id)target action:(SEL)action
{
    self.path = path;
    self.target = target;
    self.action = action;
    
    self.fildes = open([self.path fileSystemRepresentation], O_RDONLY);
    if(self.fildes <= 0)
    {
        return;
    }
    self.kq = kqueue();
    
    self.watchThread = [[NSThread alloc] initWithTarget:self selector:@selector(watchInBackground) object:nil];
    [self.watchThread start];
}

- (void)stopWatching
{
    close(self.kq);
    close(self.fildes);
    [self.watchThread cancel];
}

- (void)watchInBackground
{
    int status;
    struct kevent change;
    struct kevent event;
    
    EV_SET(&change, self.fildes, EVFILT_VNODE,
           EV_ADD | EV_ENABLE | EV_ONESHOT,
           NOTE_DELETE | NOTE_EXTEND | NOTE_WRITE | NOTE_ATTRIB,
           0, 0);
    
    while(status > 0)
    {
        status = kevent(self.kq, &change, 1, &event, 1, NULL);
        
        if(status > 0)
        {
            if([self.target respondsToSelector:self.action])
            [self.target performSelectorOnMainThread:self.action withObject:self waitUntilDone:YES];
        }
    }
    
    close(self.kq);
    close(self.fildes);
}

@end
