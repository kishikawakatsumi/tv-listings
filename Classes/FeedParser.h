#import <Foundation/Foundation.h>
#import <libxml/tree.h>

@interface FeedParser : NSObject {
    NSURLRequest *request;
	NSURLConnection *conn;
    xmlParserCtxtPtr parserContext;
    
    BOOL isChannel;
	BOOL isItem;
    NSMutableDictionary *channel;
    NSMutableDictionary *currentItem;
    NSMutableString *currentCharacters;
}

@property (nonatomic, retain) NSMutableDictionary *channel;

- (id)initWithRequest:(NSURLRequest*)aRequest;
- (void)start;

@end
