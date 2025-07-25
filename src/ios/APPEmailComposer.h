#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Cordova/CDVPlugin.h>

@interface APPEmailComposer : CDVPlugin <MFMailComposeViewControllerDelegate>

- (void)open:(CDVInvokedUrlCommand*)command;

@property (nonatomic, strong) NSString *callbackId;

@end
