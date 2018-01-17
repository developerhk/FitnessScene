//
//  DataLogger.m
//  CoreMotionLogger
//
//  Created by Patrick O'Keefe on 10/27/11.
//  Copyright (c) 2011 Patrick O'Keefe.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this
//  software and associated documentation files (the "Software"), to deal in the Software
//  without restriction, including without limitation the rights to use, copy, modify,
//  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies
//  or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
//  THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "DataLogger.h"

@interface DataLogger ()
/**
 * processMotion:withError:
 *
 * Appends the new motion data to the appropriate instance variable strings.
 */
- (void) processMotion:(CMDeviceMotion*)motion withError:(NSError*)error;

@end


@implementation DataLogger
- (id)init {

    self = [super init];
    if (self) {

        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 0.1; //100 Hz
        _motionManager.accelerometerUpdateInterval = 0.1;
        _motionManager.gyroUpdateInterval = 0.1;


        _deviceMotionQueue = [[NSOperationQueue alloc] init];
        [_deviceMotionQueue setMaxConcurrentOperationCount:1];

        _userAccelerationString = [[NSString alloc] init];
    }
    return self;
}

- (void) startLoggingMotionData {

    if([_motionManager isAccelerometerAvailable])
    {
        CMDeviceMotionHandler motionHandler = ^(CMDeviceMotion *motion, NSError *error) {
            [self processMotion:motion withError:error];
        };
        
        [_motionManager startDeviceMotionUpdatesToQueue:_deviceMotionQueue withHandler:motionHandler];
    }
    else
    {
    }
}

- (void) stopLoggingMotionDataAndSave {

    NSLog(@"Stopping data logging.");

    [_motionManager stopDeviceMotionUpdates];
    [_deviceMotionQueue cancelAllOperations];
}

- (void) processMotion:(CMDeviceMotion*)motion withError:(NSError*)error {

    //深蹲
    _userAccelerationString = [_userAccelerationString stringByAppendingFormat:@"%f,%f,%f,%f\n", motion.timestamp,
                               motion.userAcceleration.x,
                               motion.userAcceleration.y,
                               motion.userAcceleration.z,
                               nil];
    
    if(self.xyzDelegate && [self.xyzDelegate respondsToSelector:@selector(xyz:y:z:timestamp:)])
    {
        [self.xyzDelegate xyz:[NSString stringWithFormat:@"%.04f",motion.userAcceleration.x]
                            y:[NSString stringWithFormat:@"%.04f",motion.userAcceleration.y]
                            z:[NSString stringWithFormat:@"%.04f",motion.userAcceleration.z]
                    timestamp:[NSString stringWithFormat:@"%.02f",motion.timestamp]];
    }
}

@end
