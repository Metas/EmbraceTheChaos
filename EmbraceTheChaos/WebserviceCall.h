//
//  WebserviceCall.h
//  EmbraceTheChaos
//
//  Created by ShrutiG on 8/3/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewQuoteVals.h"

//@protocol XMLParserDelegate;


@interface WebserviceCall : NSObject <NSURLConnectionDelegate, NSXMLParserDelegate >
{
    NSTimer *timer ;
    NSTimeInterval timeInterval;
    //parser
    NSXMLParser *parser;
    // an ad hoc string to hold element value
    NSMutableString *currentElementValue;

    NSMutableArray *Quotes ;
    NSString *TOPIC;
    NSString *QUOTE;
    NSString *PICURL;
    
    //id < XMLParserDelegate > delegate;
}
@property(nonatomic,strong)   NSMutableData *webData ;
@property(nonatomic,strong) NSString *responseData ;

-(void) execute ;
-(void) executeForToken:(NSString *) tokenVal ;
//parse
-(void) parseResponse:(NSString *) responseXML ;
//add to database
-(void) addToDatabase ;
//@property(nonatomic,strong)id <XMLParserDelegate>  delegate;
@end

//@protocol XMLParserDelegate <NSObject>
//@required
//- (void) onParserComplete: (NewQuoteVals *) data ;

//@end
