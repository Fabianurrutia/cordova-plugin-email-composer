#import "APPEmailComposer.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface APPEmailComposer () <MFMailComposeViewControllerDelegate>
@end

@implementation APPEmailComposer

- (void)open:(CDVInvokedUrlCommand*)command {
    self.callbackId = command.callbackId;

    NSDictionary* props = command.arguments[0];

    NSString* subject = props[@"subject"] ?: @"Hi";
    NSString* body = props[@"body"] ?: @"Hi from MFMailComposeViewController";
    NSString* base64Attachment = props[@"base64Attachment"];
    NSString* attachmentFilename = props[@"attachmentFilename"] ?: @"attachment.pdf";

    if (![MFMailComposeViewController canSendMail]) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Cannot send mail"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;

    [mailVC setSubject:subject];
    [mailVC setMessageBody:body isHTML:YES];

    if (base64Attachment) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Attachment options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if (data) {
            [mailVC addAttachmentData:data mimeType:@"application/pdf" fileName:attachmentFilename];
        }
    }

    [self.viewController presentViewController:mailVC animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {

    [controller dismissViewControllerAnimated:YES completion:nil];

    BOOL success = result == MFMailComposeResultSent;

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}
@end