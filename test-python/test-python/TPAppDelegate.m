//
//  TPAppDelegate.m
//  test-python
//
//  Created by Jaime Marquínez Ferrándiz on 27/09/13.
//  Copyright (c) 2013 Jaime Marquínez. All rights reserved.
//

#import "TPAppDelegate.h"
#import "Python.h"

@implementation TPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	[self initPythonInterpreter];
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

-(void)initPythonInterpreter
{
	NSString *program = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/"];
	NSString *python_folder = [program stringByAppendingString:@"python"];
	NSString *python_modules = [python_folder stringByAppendingString:@"/modules"];
	// TODO: undo the cd
	// The initial python path python/pylib/lib is relative to the current directory (initially "/")
	NSLog(@"Changing working directory");
	chdir([program UTF8String]);
	NSLog(@"initialising python");
	Py_Initialize();
	NSLog(@"Running simple string");
	PyRun_SimpleString("print('Hey, I\\'m running python')");
	[self runPythonScript];
	NSLog(@"Finalize python");
	Py_Finalize();
}

-(void)runPythonScript
{
	NSLog(@"Running example script");
	NSString *script_string = [[NSBundle mainBundle] pathForResource:@"script" ofType:@"py"];
	char *script_name = [script_string UTF8String];
	FILE *sf = fopen(script_name, "rt");
	PyRun_SimpleFile(sf, script_name);
	fclose(sf);
}

@end
