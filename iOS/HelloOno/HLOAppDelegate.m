//
//  HLOAppDelegate.m
//  HelloOno
//
//  Created by slightair on 2014/03/08.
//  Copyright (c) 2014年 slightair. All rights reserved.
//

#import "HLOAppDelegate.h"
#import "Ono.h"

@implementation HLOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];


    NSURL *url = [NSURL URLWithString:@"http://www.cookpad.com"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            NSLog(@"error: %@", [error localizedDescription]);
            return;
        }

        if ([(NSHTTPURLResponse *)response statusCode] == 200) {
            NSError *localError = nil;
            ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:&localError];
            if (localError) {
                NSLog(@"error: %@", [localError localizedDescription]);
                return;
            }

            [doc enumerateElementsWithXPath:@"//div[@id=\"past_featured_content\"]//li/a"
                                      block:^(ONOXMLElement *item){
                                          NSString *title = [[item stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                                          NSLog(@"%@ - %@", title, item.attributes[@"href"]);
                                      }];

            // not working...
            [doc enumerateElementsWithCSS:@"#past_featured_content li a" block:^(ONOXMLElement *item){
                NSString *title = [[item stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                NSLog(@"%@ - %@", title, item.attributes[@"href"]);
            }];
        }
    }];
    [task resume];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
