
#import <XCTest/XCTest.h>
#import "MCLabel.h"

/*
 This label prefix signifies to the event processor that this particular log
 statement is intended to be treated as a label.
 */
const NSString *LABEL_PREFIX = @"[MobileCenterTest]: ";

/*
 We need some references to private API methods, so we'll declare them here.
 */
@interface XCAXClient_iOS : NSObject
+ (XCAXClient_iOS *)sharedClient;
- (NSData *)screenshotData;
@end

@interface XCActivityRecord : NSObject
@property (copy) NSData *screenImageData;
@property (copy) NSString *title;
@end

@interface _XCTestCaseImplementation : NSObject
@property(retain, nonatomic) NSMutableArray <XCActivityRecord *> *activityRecordStack;
@end

typedef void (^activityBlock)(XCActivityRecord *activityRecord);

@interface XCTestCase (MCTAccess)
@property(retain) _XCTestCaseImplementation *internalImplementation;
- (void)startActivityWithTitle:(NSString *)title block:(activityBlock)block;
@end

XCTestCase *_XCTCurrentTestCase(void);
void _XCINFLog(NSString *msg);

@implementation MCLabel

+ (void)label:(NSString *)fmt, ... {
    va_list args;
    va_start(args, fmt);
    [self labelStep:fmt args:args];
    va_end(args);
}

+ (XCTestCase *)currentTestCase {
    return _XCTCurrentTestCase();
}

+ (void)labelStep:(NSString *)msg {
    [self _label:msg];
}

+ (void)labelStep:(NSString *)fmt args:(va_list)args {
    NSString *lbl = [[NSString alloc] initWithFormat:fmt arguments:args];
    [self _label:lbl];
}

+ (void)labelFailedWithError:(NSString *)errorMessage labelMessage:(NSString *)labelMessage {
    /*
     These will appear in the Device Log.
     */
    NSLog(@"%@ERROR: %@", LABEL_PREFIX, errorMessage);
    NSLog(@"%@ERROR: Unable to process label(\"%@\")", LABEL_PREFIX, labelMessage);

    /*
     These will appear in the Debug Log of the test run.
     */
    _XCINFLog([NSString stringWithFormat:@"%@ERROR: %@", LABEL_PREFIX, errorMessage]);
    _XCINFLog([NSString stringWithFormat:@"%@ERROR: Unable to process label(\"%@\")", LABEL_PREFIX, labelMessage]);
}

+ (void)attachScreenshotUsingAXClientToActivityRecord:(XCActivityRecord *)activityRecord
                                              message:(NSString *)message {

    XCAXClient_iOS *client = [XCAXClient_iOS sharedClient];
    if (!client) {
        [MCLabel labelFailedWithError:@"Unable to fetch Accessibility Client."
                         labelMessage:message];
        return;
    }

    NSData *screenshotData = [client screenshotData];
    if (!screenshotData) {
        [MCLabel labelFailedWithError:@"Unable to fetch screenshot data from Accessibility Client."
                         labelMessage:message];
        return;
    }

    [activityRecord setScreenImageData:screenshotData];
}

// If this does not produce the correct results, there is this alternative
// https://gist.github.com/jmoody/f28cdfe69dd69e06b29122d8e3492340
+ (void)automaticallyAttachScreenshotToActivityRecord:(XCActivityRecord *)activityRecord {
    [MCLabel XCAttachmentKeepAlways];
    Class klass = NSClassFromString(@"XCActivityRecord");
    SEL selector = NSSelectorFromString(@"attachAutomaticScreenshot");

    NSMethodSignature *signature;
    signature = [klass instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = activityRecord;
    invocation.selector = selector;

    [invocation performSelectorOnMainThread:@selector(invoke)
                                 withObject:nil
                              waitUntilDone:YES];
}

+ (void)XCAttachmentKeepAlways {
    Class klass = NSClassFromString(@"XCTAttachment");
    SEL selector = NSSelectorFromString(@"setSystemAttachmentLifetime:");

    NSMethodSignature *signature;
    signature = [klass methodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = klass;
    invocation.selector = selector;

    NSInteger TestCloudKeepAlways = 0;
    [invocation setArgument:&TestCloudKeepAlways atIndex:2];

    [invocation performSelectorOnMainThread:@selector(invoke)
                                 withObject:nil
                              waitUntilDone:YES];
}

+ (BOOL)XCActivityRespondsToAttachAutomaticScreenshot:(XCActivityRecord *)activityRecord {
    SEL selector = NSSelectorFromString(@"attachAutomaticScreenshot");
    return [activityRecord respondsToSelector:selector];
}

+ (void)attachScreenshotToActivityRecord:(XCActivityRecord *)activityRecord
                                 message:(NSString *)message {
    if (!activityRecord) {
        [MCLabel labelFailedWithError:@"No XCActivityRecord currently exists."
                         labelMessage:message];
    } else if ([MCLabel XCActivityRespondsToAttachAutomaticScreenshot:activityRecord]) {
        // Xcode >= 9
        [MCLabel automaticallyAttachScreenshotToActivityRecord:activityRecord];
    } else {
        // Xcode < 9
        [MCLabel attachScreenshotUsingAXClientToActivityRecord:activityRecord
                                                       message:message];
    }
}

/*
 We add in the prefix and pass it along to XCTest
 */
+ (void)_label:(NSString *)message {
    XCTestCase *testCase = [self currentTestCase];
    if (testCase == nil) {
        [MCLabel labelFailedWithError:@"Unable to locate current test case."
                         labelMessage:message];
    } else {
        /*
         Declare that we are starting an activity, titled with the user's label.
         This activity merely captures a screenshot, which is then processed
         by MobileCenter/XTC.
         */
        [testCase
         startActivityWithTitle:[NSString stringWithFormat:@"%@%@",
                                 LABEL_PREFIX,
                                 message]
         block:^(XCActivityRecord *activityRecord) {
             [MCLabel attachScreenshotToActivityRecord:activityRecord
                                               message:message];
         }];
    }
}

@end
