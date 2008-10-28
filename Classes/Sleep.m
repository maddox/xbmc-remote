//
//  Sleep.m
//  xbmcremote
//
//  Created by David Fumberger on 4/09/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "Sleep.h"


@implementation Sleep
int __nsleep(const struct timespec *req, struct timespec *rem)  
{  
    struct timespec temp_rem;  
    if(nanosleep(req,rem)==-1)  
        __nsleep(rem,&temp_rem);  
    else  
        return 1;  
}  

int msleep(unsigned long milisec)  
{  
    struct timespec req={0},rem={0};  
    time_t sec=(int)(milisec/1000);  
    milisec=milisec-(sec*1000);  
    req.tv_sec=sec;  
    req.tv_nsec=milisec*1000000L;  
    __nsleep(&req,&rem);  
    return 1;  
}  

@end
