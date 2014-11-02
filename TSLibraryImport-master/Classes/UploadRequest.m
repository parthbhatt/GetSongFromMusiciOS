//
//  UploadRequest.m
//  ImportSongDemo
//
//  Created by Parth's Mac on 02/11/14.
//
//

#import "UploadRequest.h"

@implementation UploadRequest

-(void)callUploadRequest:(NSString*)recordedFile
{
    NSData *audioData = [[NSData alloc] initWithContentsOfFile:recordedFile];
    NSString *prefixString = @"Audio";
    
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@_%@", prefixString, guid];
    
    NSString *urlString = @"http://www.myserver.com/uploadaudio.php";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"_187934598797439873422234";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    //[request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"http://google.com" forHTTPHeaderField:@"Origin"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"audio\"; filename=\"%@.mp3\"\r\n", uniqueFileName] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:audioData]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
    
    
    /*
     NSData *data = [NSData dataWithContentsOfFile:filePath];
     NSMutableString *urlString = [[NSMutableString alloc] initWithFormat:@"name=thefile&&filename=recording"];
     [urlString appendFormat:@"%@", data];
     NSData *postData = [urlString dataUsingEncoding:NSASCIIStringEncoding
     allowLossyConversion:YES];
     NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
     NSString *baseurl = @"https://www.yourWebAddress.com/yourServerScript.php";
     
     NSURL *url = [NSURL URLWithString:baseurl];
     NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
     [urlRequest setHTTPMethod: @"POST"];
     [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
     [urlRequest setValue:@"application/x-www-form-urlencoded"
     forHTTPHeaderField:@"Content-Type"];
     [urlRequest setHTTPBody:postData];
     
     NSURLConnection *connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
     [connection start];
     
     NSLog(@"Started!");
     
     */
}

@end
