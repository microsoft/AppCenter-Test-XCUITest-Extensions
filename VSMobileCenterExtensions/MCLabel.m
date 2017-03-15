
#import <XCTest/XCTest.h>
#import "MCLabel.h"

/*
 This label prefix signifies to the event processor that this particular log
 statement is intended to be treated as a label.
 */
const NSString *LABEL_PREFIX = @"CBX|";

/*
 Use XCUITest's _XCINFLog() function to transfer our label over the wire.
 */
void _XCINFLog(NSString *msg);

@implementation MCLabel

+ (void)label:(NSString *)fmt, ... {
    va_list args;
    va_start(args, fmt);
    [self labelStep:fmt args:args];
    va_end(args);
}

+ (void)labelStep:(NSString *)msg {
    [self _label:msg];
}

+ (void)labelStep:(NSString *)fmt args:(va_list)args {
    NSString *lbl = [[NSString alloc] initWithFormat:fmt arguments:args];
    [self _label:lbl];
}

/*
    We add in the prefix and pass it along to XCTest
 */
+ (void)_label:(NSString *)message {
    _XCINFLog([NSString stringWithFormat:@"%@ %@", LABEL_PREFIX, message]);
}

@end
