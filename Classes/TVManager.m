#import "TVManager.h"
#import "FeedParser.h"
#import "TVProgram.h"
#import "NSString_FJNFullwidthHalfwidth.h"
#import "RegexKitLite.h"
#import "RKLMatchEnumerator.h"
#import "Debug.h"

@implementation TVManager

static NSDictionary *abbreviationMappings = NULL;

- (id)init {
	if (self = [super init]) {
		if (!abbreviationMappings) {
			abbreviationMappings = [[NSDictionary dictionaryWithObjectsAndKeys:
									 [NSString stringWithUTF8String:"[新]"], [NSString stringWithUTF8String:"新番組"],
									 [NSString stringWithUTF8String:"[再]"], [NSString stringWithUTF8String:"再放送"],
									 [NSString stringWithUTF8String:"[前]"], [NSString stringWithUTF8String:"前編"],
									 [NSString stringWithUTF8String:"[後]"], [NSString stringWithUTF8String:"後編"],
									 [NSString stringWithUTF8String:"[終]"], [NSString stringWithUTF8String:"最終回"],
									 [NSString stringWithUTF8String:"[初]"], [NSString stringWithUTF8String:"初回放送"],
									 [NSString stringWithUTF8String:"[映]"], [NSString stringWithUTF8String:"映画"],
									 [NSString stringWithUTF8String:"[N]"], [NSString stringWithUTF8String:"ニュース"],
									 [NSString stringWithUTF8String:"[天]"], [NSString stringWithUTF8String:"天気予報"],
									 [NSString stringWithUTF8String:"[交]"], [NSString stringWithUTF8String:"交通情報"],
									 [NSString stringWithUTF8String:"[二]"], [NSString stringWithUTF8String:"二カ国語放送"],
									 [NSString stringWithUTF8String:"[多]"], [NSString stringWithUTF8String:"音声多重放送"],
									 [NSString stringWithUTF8String:"[B]"], [NSString stringWithUTF8String:"Ｂモードステレオ"],
									 [NSString stringWithUTF8String:"[S]"], [NSString stringWithUTF8String:"ステレオ放送"],
									 [NSString stringWithUTF8String:"[SS]"], [NSString stringWithUTF8String:"サラウンドステレオ"],
									 [NSString stringWithUTF8String:"[デ]"], [NSString stringWithUTF8String:"データ放送"],
									 [NSString stringWithUTF8String:"[双]"], [NSString stringWithUTF8String:"双方向サービス"],
									 [NSString stringWithUTF8String:"[W]"], [NSString stringWithUTF8String:"ワイドビジョン"],
									 [NSString stringWithUTF8String:"[吹]"], [NSString stringWithUTF8String:"吹き替え"],
									 [NSString stringWithUTF8String:"[H]"], [NSString stringWithUTF8String:"ハイビジョン"],
									 [NSString stringWithUTF8String:"[手]"], [NSString stringWithUTF8String:"手話放送"],
									 [NSString stringWithUTF8String:"[S1]"], [NSString stringWithUTF8String:"ＳＤＴＶ１"],
									 [NSString stringWithUTF8String:"[S2]"], [NSString stringWithUTF8String:"ＳＤＴＶ２"],
									 [NSString stringWithUTF8String:"[S3]"], [NSString stringWithUTF8String:"ＳＤＴＶ３"],
									 [NSString stringWithUTF8String:"[PV]"], [NSString stringWithUTF8String:"ペイパービュー"],
									 [NSString stringWithUTF8String:"[MV]"], [NSString stringWithUTF8String:"マルチビューテレビ"],
									 [NSString stringWithUTF8String:"[CC]"], [NSString stringWithUTF8String:"クローズドキャプション"],
									 [NSString stringWithUTF8String:"[司]"], [NSString stringWithUTF8String:"司会者"],
									 [NSString stringWithUTF8String:"[実]"], [NSString stringWithUTF8String:"実況者"],
									 [NSString stringWithUTF8String:"[解]"], [NSString stringWithUTF8String:"解説者"],
									 [NSString stringWithUTF8String:"[出]"], [NSString stringWithUTF8String:"出演者"],
									 [NSString stringWithUTF8String:"[ゲ]"], [NSString stringWithUTF8String:"ゲスト"],
									 [NSString stringWithUTF8String:"[脚]"], [NSString stringWithUTF8String:"脚本"],
									 [NSString stringWithUTF8String:"[監]"], [NSString stringWithUTF8String:"監督"],
									 [NSString stringWithUTF8String:"[原]"], [NSString stringWithUTF8String:"原作"],
									 [NSString stringWithUTF8String:"[語]"], [NSString stringWithUTF8String:"語り"],
									 [NSString stringWithUTF8String:"[声]"], [NSString stringWithUTF8String:"声の出演"], nil] retain];
		}
	}
	return self;
}

- (void)dealloc {
	LOG_CURRENT_METHOD;
	[abbreviationMappings release];
    [super dealloc];
}

- (NSTimeInterval)timeIntervalSince1970:(NSString *)pubDate {
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
	[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease]];
	NSDate *date = [formatter dateFromString:pubDate];
	[formatter setDateFormat:@"yyyyMMdd"];
	return [[formatter dateFromString:[formatter stringFromDate:date]] timeIntervalSince1970];
}

- (NSString *)roundTimeOfDay:(NSString *)pubDate {
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
	[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease]];
	NSDate *date = [formatter dateFromString:pubDate];
	[formatter setDateFormat:@"HH:00 - "];
	return [formatter stringFromDate:date];
}

- (NSDictionary *)getTVList:(NSString *)feedURL {
	return [self getTVList:feedURL dateIndexed:NO];
}

- (NSDictionary *)getTVList:(NSString *)feedURL dateIndexed:(BOOL)dateIndexed {
	NSMutableDictionary *programs = nil;
	@synchronized (self) {
		if (!feedURL) {
			return nil;
		}
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		NSURL *URL = [NSURL URLWithString:feedURL];
        LOG(@"feed URL: <%@>", URL);
		
		FeedParser *parser = [[FeedParser alloc] initWithRequest:[NSURLRequest requestWithURL:URL]];
		[parser start];
		NSArray *items = [[parser channel] objectForKey:@"items"];
        LOG(@"feed data: %@", items);
        [parser release];
		
		programs = [NSMutableDictionary dictionaryWithCapacity:10];
		for (id item in items) {
			TVProgram *program = [[[TVProgram alloc] init] autorelease];
			
			NSString *category = [item objectForKey:@"category"];
			if ([category length] > 0) {
				program.category = [category stringByHalfwideningLatinCharacters];
			} else {
				break;
			}
			
			NSString *link = [item objectForKey:@"link"];
			if ([link length] > 0) {
				program.link = link;
			} else {
				//break;
			}
			
			NSString *text = [item objectForKey:@"title"];
			if ([text length] > 0) {
				NSArray *compornents = [text componentsSeparatedByString:@" "];
				NSInteger count = [compornents count];
				if (count > 0) {
					program.date = [compornents objectAtIndex:0];
				}
				if (count > 1) {
					program.time = [compornents objectAtIndex:1];
				}
				if (count > 3) {
					NSString *title = [compornents lastObject];
					program.title = [title stringByHalfwideningLatinCharacters];
				}
			}
			NSString *pubDate = [item objectForKey:@"pubDate"];
			if ([pubDate length] > 0) {
				program.pubDate = pubDate;
			}
			NSString *details = [[item objectForKey:@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if ([details length] > 0) {
				NSString *searchString = [details stringByHalfwideningLatinCharacters];
				
				NSEnumerator *matchEnumerator = NULL;
				NSString *regex = @"<img[^>]+alt=\"([^>]+)\"[^>]*>";
				matchEnumerator = [searchString matchEnumeratorWithRegex:regex];
				NSUInteger line = 0;
				NSString *matchedString = NULL;
				while((matchedString = [matchEnumerator nextObject]) != NULL) {
					NSString *imgTag = matchedString;
					NSMutableString *alt = [NSMutableString stringWithString:imgTag];
					
					NSString *replaceWithString = @"$1";
					NSUInteger replacedCount = [alt replaceOccurrencesOfRegex:regex withString:replaceWithString];
					if (replacedCount) {
						NSString *abbr = [abbreviationMappings objectForKey:alt];
						if (!abbr) {
							abbr = [NSString stringWithFormat:@"[%@]", alt];
						}
						searchString = [searchString stringByReplacingOccurrencesOfString:imgTag withString:abbr];
					}
					line++;
				}
				program.details = searchString;
			}
			
			NSString *sectionHeader;
			if (dateIndexed) {
				sectionHeader = [NSString stringWithFormat:@"%f|||%@|||%@", [self timeIntervalSince1970:program.pubDate], program.date, program.category];
			} else {
				sectionHeader = [NSString stringWithFormat:@"%f|||%@|||%@", 0.0, @"", program.category];
			}
			
			NSMutableArray *section = [programs objectForKey:sectionHeader];
			if (!section) {
				section = [NSMutableArray arrayWithCapacity:10];
				[programs setObject:section forKey:sectionHeader];
			}
			[section addObject:program];
		}
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return programs;
}

@end
