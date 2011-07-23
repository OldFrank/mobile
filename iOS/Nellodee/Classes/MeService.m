//
//  User.m
//  Nellodee
//
//  Created by Ada Hopper on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeService.h"
#import "SBJson.h"
#import "BasicInfo.h"

@implementation MeService

@synthesize responseData;

-(BOOL) meService{
	NSLog(@" ---- me Service ---");
	NSMutableURLRequest *request = [NSMutableURLRequest
									requestWithURL:[NSURL URLWithString:@"http://sakai3-demo.uits.indiana.edu:8080/system/me"]];
	[request setHTTPMethod: @"GET"];
	[request setHTTPShouldHandleCookies:NO];
	[request addValue:@"http://sakai3-demo.uits.indiana.edu:8080/system/me" forHTTPHeaderField:@"Referer"];
	NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]
						cookiesForURL:[NSURL URLWithString:@"http://sakai3-demo.uits.indiana.edu:8080"]];
	NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
	
	if(cookies != nil){
		[request setAllHTTPHeaderFields:headers];
	}
	else{
		NSLog(@"Error: user no authenticated");
	}
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];  
	return YES;
	
} 




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {  
	NSLog(@"didReceiveResponse");
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	if ([httpResponse statusCode] >= 400) {
		NSLog(@"Remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
	} else {
		NSLog(@"It is working. Status: %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
		
	}
    [responseData setLength:0];  
}  

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {  
    BasicInfo * basic = [[BasicInfo alloc]init];
    
	NSLog(@"didReceiveData");
	//NSString *theResponseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	//NSLog(@"Response : %@", theResponseString);
    
    
    // Store incoming data into a string
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Create a dictionary from the JSON string
    NSDictionary *results = [jsonString JSONValue];
    NSDictionary * properties = [[results objectForKey:@"user"] objectForKey:@"properties"];
    NSLog(@"Dictionary value for \"foo\" is \"%@\"",properties);
    
    [basic setFirstName:[properties objectForKey:@"firstName"]];
    [basic setLastName:[properties objectForKey:@"lastName"]];
    [basic setPrefName:[properties objectForKey:@"preferredName"]];
    [basic setRol:[properties objectForKey:@"role"]];
    [basic setDepartament:[properties objectForKey:@"department"]];
    [basic setCollege:[properties objectForKey:@"college"]];
    [basic setTags:[properties objectForKey:@"tags"]];
    

    
}  

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {  
	NSLog(@"Connection failed: %@", [error description]);
}  

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {  
	NSLog(@"connectionDidFinishLoading");

    [connection release];  
    [responseData release];  
	
}  


@end