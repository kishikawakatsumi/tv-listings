//
//  $Id: NSString_FJNFullwidthHalfwidth.h 84 2008-03-18 13:25:05Z fujidana $
//
//  Copyright (c) 2006-2008 FUJIDANA. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! @category NSString (FJNFullwidthHalfwidth)
 @discussion This category extends the function of NSString so that Japanese  
 fullwidth kana (so-called "zenkaku") and halfwidth kana (so-called "hankaku")
 can be converted to each other.
 @copyright FUJIDANA
 */
@interface NSString (FJNFullwidthHalfwidth)


/*!
 @typedef FJNUnicharOptions
 @discussion NSString (FJNFullwidthHalfwidth) defines these constants to specify what type of characters is passed or blocked.
 @constant FJNWhiteSpace represents while space.
 @constant FJNDecimalDigits represents decimal digits. 
 @constant FJNBasicLatinLetters represents basic Latin letters. 
 @constant FJNBasicLatinSymbols represents basic Latin symbols. 
 @constant FJNBasicLatinAllCharacters represents combination of FJNDecimalDigits, FJNBasicLatinLetters, and FJNBasicLatinSymbols.
 @constant FJNJapaneseKanaCharacters represents basic Japanese kana characters.
 */
typedef enum {
	FJNWhiteSpace = 0x01, 
	
	FJNDecimalDigits = 0x02,
	FJNBasicLatinLetters = 0x04,
	FJNBasicLatinSymbols = 0x08,
	FJNBasicLatinAllCharacters = 0x02 | 0x04 | 0x08,
	
	FJNJapaneseKanaCharacters = 0x10 
} FJNUnicharOptions;

/*!
 @method halfwidthString
 @abstract Returns a halfwidth string.
 @discussion Other characters than Japanese kana, basic Latin, or white space remain unchaned.
 @result A string with each character in the receiver replaced with its corresponding halfwidth characters.
 */
- (NSString *)halfwidthString;

/*!
 @method fullwidthString
 @abstract Returns a fullwidth string.
 @discussion Other characters than Japanese kana, basic Latin, or white space remain unchaged.
 @result A string with each character in the receiver replaced with its corresponding fullwidth characters.
 */
- (NSString *)fullwidthString;

/*!
 @method stringByHalfwideningLatinCharacters
 @abstract Returns a string in which fullwidth basic Latin characters are replaced with their corresponding halfwidth characters.
 @discussion This method is similar to <code>halfwidthString</code>, but differs from the point where fullwidth Japanese kana characters are not changed.
 @result A string with each fullwidth basic Latin character in the receiver replaced with its corresponding halfwidth characters.
 */
- (NSString *)stringByHalfwideningLatinCharacters;

/*!
 @method stringByFullwideningKanaCharacters
 @abstract Returns a string in which halfwidth kana characters are replaced with fullwidth kana.
 @discussion This method is similar to <code>fullwidthString</code>, but differs from the point where halfwidth Latin characters are not changed. This method will be useful when you want to omit halfwidth kana characters, which are in general undesirable to internet communication.
 @result A string with each halfwidth kana character in the receiver replaced with its corresponding fullwidth characters. 
 */
- (NSString *)stringByFullwideningKanaCharacters;

/*!
 @method hiraganaString
 @abstract Returns a hiragana string.
 @discussion Other characters than katakana remain unchaged. Remind that the following katakana characters remain unchanged since they do not have the corresponding hiragana characters in Unicode: fullwidth katakana characters VA, VI, VE, VO (0x30f7 to 0x30fa). Halfwidth katakana characters also remain unchanged.
 @result A string with each katakana character in the receiver replaced with its corresponding hiragana characters. 
 */
- (NSString *)hiraganaString;

/*!
 @method katakanaString
 @abstract Returns a katakana string.
 @discussion Other characters than hiragana remain unchanged.
 @result A string with each hiragana character in the receiver replaced with its corresponding katakana characters. 
 */
- (NSString *)katakanaString;

/*!
 @method stringByHalfwideningCharacters:passingOtherCharacters:
 @abstract Returns a string in which fullwidth character of a given mask replaced with halfwidth characters.
 @discussion This method is invoked by <code>halfwidthString</code> and <code>stringByHalfwideningLatinCharacters</code>. If those methods are not enough for your usage, you can invoke this method directly.
 @param mask Options for characters to be converted. You can combine any of the <code>FJNUnicharOptions</code> using bitwise OR operator.
 @param remainsOther If yes, other characters than choosed in mask will remain.
 @result A string with each fullwidth character of a given mask in the receiver replaced with its corresponding halfwidth characters.
 */
- (NSString *)stringByHalfwideningCharacters:(unsigned int)mask 
					  passingOtherCharacters:(BOOL)remainsOther;

/*!
 @method stringByFullwideningCharacters:passingOtherCharacters:
 @abstract Returns a string in which halfwidth character of a given mask replaced with fullwidth characters.
 @discussion This method is invoked by <code>fullwidthString</code> and <code>stringByReplacingHalfwidthLatinWithFullwidthLatin</code>. If those methods are not enough for your usage, you can invoke this method directly.
 @param mask Options for characters to be converted. You can combine any of the <code>FJNUnicharOptions</code> using bitwise OR operator.
 @param remainsOther If yes, other characters than choosed in mask will remain.
 @result A string with each fullwidth character of a given mask in the receiver replaced with its corresponding halfwidth characters.
 */
- (NSString *)stringByFullwideningCharacters:(unsigned int)mask 
					  passingOtherCharacters:(BOOL)remainsOther;

/*!
 @method filteredStringUsingCharacterSet:
 @abstract Returns a new string where characters in the receiver but not in a given character set are discarded.
 @discussion Other characters than contained in a given character set 
 @param charSet The character set which filters the receiver.
 @result A string of characters which is a member of a given character set.
 */
- (NSString *)filteredStringUsingCharacterSet:(NSCharacterSet *)charSet;

@end
