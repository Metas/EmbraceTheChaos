//
//  WebserviceCall.m
//  EmbraceTheChaos
//
//  Created by ShrutiG on 8/3/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "WebserviceCall.h"
#import "SaveNewQuotes.h"

@implementation WebserviceCall

@synthesize webData;
@synthesize responseData;
//@synthesize delegate;

-(void) executeForToken:(NSString *)tokenVal
{
    NSString *urlString = @"http://www.embracethechaosquote.appspot.com/savetokens";
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *tokenIs = [NSString stringWithFormat:@"token=%@",tokenVal];
    NSData *postData =[tokenIs dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:[NSString stringWithFormat:@"%d",postData.length] forHTTPHeaderField:@"Content-Length"];
    [theRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:postData];
    NSURLConnection *connection =[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
        
    
    if(connection)
    {
       
    }

}
-(void) execute
{
    timeInterval = 300.0; //3 mins
    NSString *urlString = @"http://www.embracethechaosquote.appspot.com/getquotes";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    //[theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"GET"];
    NSURLConnection *connection =[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    //start timer
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(onTick:) userInfo:nil repeats:NO];
    

    if(connection)
    {
         webData = [NSMutableData data] ;
    }


}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)res
{
    [webData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //stop timer
    if ([timer isValid]) {
        [timer invalidate];
        
    }
    //NSLog(@"ERROR with Connection");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil ];
    [alert show];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //stop timer
    if ([timer isValid]) {
        [timer invalidate];
    }
    
    NSLog(@"DONE. Received bytes: %d",[webData length]) ;
    responseData = [[NSString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    if([responseData hasPrefix:@"<Quotes>"])
    {
        NSLog(@"the xml recieved %@",responseData);
        Quotes =[[NSMutableArray alloc]init];
        [self parseResponse:responseData] ;
    }
    else
    {
        NSLog(@"the xml recieved %@",responseData);
    }
    
}

-(void) onTick:(NSTimer *)timer
{
    //the connection timed out, send error m,essage
    //NSLog(@"Connection timeout");
    NSError *error = [[NSError alloc]initWithDomain:@"ConnectionTimedOut" code:001 userInfo:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil ];
    [alert show];
    //[delegate api:error];
    //this is for test so we can logon
    //[delegate apiFinished:@"temp"];
}

-(void) parseResponse:(NSString *)responseXML
{
    NSData *data = [responseXML dataUsingEncoding:NSUTF8StringEncoding];
    parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];

}

#pragma Parser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString*)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary*)attributeDict
{
    NSLog(@"found this element: %@", elementName);
    
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!currentElementValue) {
        // init the ad hoc string with the value
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        // append value to the ad hoc string
        [currentElementValue appendString:string];
    }
    NSLog(@"Processing value for : %@", string);
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"topic"])
    {
        NSString* stringVal = currentElementValue ;
         NSLog(@"%@",stringVal);
        if((stringVal ==Nil) ||(stringVal.length==0))
           TOPIC = @" " ;
       else
        TOPIC = stringVal ;
    }
    if([elementName isEqualToString:@"content"])
    {
        NSString* stringVal = currentElementValue ;
        NSLog(@"%@",stringVal);
        if((stringVal ==Nil) ||(stringVal.length==0))
            QUOTE = @" " ;
        else
        QUOTE = stringVal ;
    }
    if([elementName isEqualToString:@"imgkey"])
    {
        NSString* stringVal = currentElementValue ;
        NSLog(@"%@",stringVal);
    }
    if([elementName isEqualToString:@"userName"])
    {
        NSString* stringVal = currentElementValue ;
        NSLog(@"%@",stringVal);
    }
    if([elementName isEqualToString:@"imgUrl"])
    {
        NSString* stringVal = currentElementValue ;
        NSLog(@"%@",stringVal);
        if((stringVal ==Nil) ||(stringVal.length==0))
            PICURL = @" " ;
        else
        PICURL = stringVal;
    }
    if([elementName isEqualToString:@"imgVal"])
    {
        NSString * base64Val = [NSString stringWithFormat:@"data:image/png;base64,%@",currentElementValue];
       /* NSURL *urlString = [NSURL URLWithString:base64Val];
        NSData *imageData = [NSData dataWithContentsOfURL:urlString];
        UIImage *image =[UIImage imageWithData:imageData];*/
        NSString* stringVal = base64Val ;
        NSLog(@"%@",stringVal);
    }
    if([elementName isEqualToString:@"Quote"])//end of one Quote add it to array
    {
        NSString * oneQuoteElement =[NSString stringWithFormat:@"%@,%@,%@",TOPIC,QUOTE,PICURL];
        [Quotes addObject:oneQuoteElement];
        
    }
    if([elementName isEqualToString:@"Quotes"])//end of xml call the delegate we are done
    {
        //[delegate onParserComplete:newQuoteObject];
        [self addToDatabase];
        
    }
    currentElementValue = nil;    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    
}
-(void) addToDatabase
{
    SaveNewQuotes *saveQuote = [[SaveNewQuotes alloc]init];
    for(int i=0; i<Quotes.count; i++)
    {
        NSString *quoteVal = [Quotes objectAtIndex:i] ;

        NSArray *CommaSeperatedArray;
        CommaSeperatedArray=[quoteVal componentsSeparatedByString:@","];
        NSString *TopicVal = [CommaSeperatedArray objectAtIndex:0];
        NSString *QuoteVal = [CommaSeperatedArray objectAtIndex:1];
        NSString *PicUrlVal = [CommaSeperatedArray objectAtIndex:2];

        NewQuoteVals *quoteVals = [[NewQuoteVals alloc]init];
        quoteVals.topic = TopicVal;
        quoteVals.quote =QuoteVal;
        quoteVals.imgUrl = PicUrlVal ;
        [saveQuote AddQuote:quoteVals];
    }
    

}


@end
