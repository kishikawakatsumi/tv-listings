//
//  $Id: NSString_FJNFullwidthHalfwidth.m 84 2008-03-18 13:25:05Z fujidana $
//
//  Copyright (c) 2006-2008 FUJIDANA. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. Neither the name of the author nor the names of its contributors
//    may be used to endorse or promote products derived from this software
//    without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "NSString_FJNFullwidthHalfwidth.h"


enum
{
	FJNNotVoiced = 0, 
	FJNVoiced, 
	FJNSemiVoiced
};


@implementation NSString (FJNFullwidthHalfwidth)

- (NSString *)halfwidthString
{
	return [self stringByHalfwideningCharacters:(FJNWhiteSpace | FJNBasicLatinAllCharacters | FJNJapaneseKanaCharacters)
						 passingOtherCharacters:YES];
}

- (NSString *)fullwidthString
{
	return [self stringByFullwideningCharacters:(FJNWhiteSpace | FJNBasicLatinAllCharacters | FJNJapaneseKanaCharacters)
						 passingOtherCharacters:YES];
}

- (NSString *)stringByHalfwideningLatinCharacters
{
	return [self stringByHalfwideningCharacters:FJNBasicLatinLetters
						 passingOtherCharacters:YES];
}

- (NSString *)stringByFullwideningKanaCharacters
{
	return [self stringByFullwideningCharacters:FJNJapaneseKanaCharacters
						 passingOtherCharacters:YES];
}

- (NSString *)hiraganaString
{
	unichar	c;
	int		i, length = [self length];
	unichar	newChar[length];
	
	for (i = 0; i < length; i++)
	{
		c = [self characterAtIndex:i];
		
		if (c >= 0x30a1 && c <= 0x30f6)
		{
			newChar[i] = c - 0x0060;
		}
		else
		{
			newChar[i] = c;
		}
	}
	return [NSString stringWithCharacters:newChar length:length];
}

- (NSString *)katakanaString
{
	unichar	c;
	int		i, length = [self length];
	unichar	newChar[length];
	
	for (i = 0; i < length; i++)
	{
		c = [self characterAtIndex:i];
		
		if (c >= 0x3041 && c <= 0x3096)
		{
			newChar[i] = c + 0x0060;
		}
		else
		{
			newChar[i] = c;
		}
	}
	return [NSString stringWithCharacters:newChar length:length];
}

- (NSString *)stringByHalfwideningCharacters:(unsigned int)mask 
					  passingOtherCharacters:(BOOL)remainsOther 
{
	unichar c;
	int	    length = [self length];
	unichar newChar[length * 2];
	
	int i, j = 0;
	
	for (i = 0; i < length; i++)
	{
		c = [self characterAtIndex:i];
		
		// --- process halfwidth basic Latin characters --- 
		
		if ((mask & FJNWhiteSpace) && c == 0x0020)
		{
			// --- --- halfwidth white space --- --- 
			newChar[j++] = c;
		}
		else if ((mask & FJNDecimalDigits) && c >= 0x0030 && c <= 0x0039)
		{
			// --- --- halfwidth arabic number --- --- 
			newChar[j++] = c;
		}
		else if ((mask & FJNBasicLatinLetters) && c >= 0x0041 && c <= 0x005a)
		{
			// --- --- halfwidth latin capital letters (alphabets) --- ---
			newChar[j++] = c;
		}
		else if ((mask & FJNBasicLatinLetters) && c >= 0x0061 && c <= 0x007a)
		{
			// --- --- halfwidth latin small letters (alphabets) --- ---
			newChar[j++] = c;
		}
		else if ((mask & FJNBasicLatinSymbols) && c >= 0x0021 && c <= 0x007e) {
			// --- --- halfwidth latin symbols --- ---
			newChar[j++] = c;
		}
		
		// --- process fullwidth basic latin characters ---
		
		else if ((mask & FJNWhiteSpace) && c == 0x3000)
		{
			// --- --- fullwidth white space --- ---
			newChar[j++] = 0x0020;
		}
		else if ((mask & FJNDecimalDigits) && c >= 0xff10 && c <= 0xff19)
			// --- --- fullwidth arabic number --- ---
		{
			newChar[j++] = c - 0xff00 + 0x0020;
		}
		else if ((mask & FJNBasicLatinLetters) && c >= 0xff21 && c <= 0xff3a)
		{
			// --- --- fullwidth latin capital letters (alphabets) --- ---
			newChar[j++] = c - 0xff00 + 0x0020;
		}
		else if ((mask & FJNBasicLatinLetters) && c >= 0xff41 && c <= 0xff5a)
		{
			// --- --- fullwidth latin small letters (alphabets) --- ---
			newChar[j++] = c - 0xff00 + 0x0020;
		}
		else if ((mask & FJNBasicLatinSymbols) && c >= 0xff01 && c <= 0xff5e)
		{
			// --- --- fullwidth latin symbols --- ---
			newChar[j++] = c - 0xff00 + 0x0020;
		}
		
		// --- halfwidth Japanese characters ---
		
		else if ((mask & FJNJapaneseKanaCharacters) && c >= 0xff61 && c < c <= 0xff9f)
		{
			newChar[j++] = c;
			
		}
		
		// ---fullwidth Japanese characters ---
		
		else if ((mask & FJNJapaneseKanaCharacters) &&
				 (c == 0x3001 || // IDEOGRAPHIC COMMA
				  c == 0x3002 || // IDEOGRAPHIC FULL STOP
				  c >= 0x3041 && c <= 0x309c || // HIRAGANA LETTER SMALL A to KATAKANA-HIRAGANA SEMI-VOICED SOUND 
				  c >= 0x30a1 && c <= 0x30fc)) // KATAKANA LETTER SMALL A to KATAKANA-HIRAGANA PROLONGED SOUND MARK
		{
			// at first convert KATAKANA to HIRAGANA
			if (c >= 0x30a1 && c <= 0x30f6) 
			{
				// KATAKANA LETTER SMALL A to KATAKANA LETTER SMALL KE			
				c -= 0x0060;
			}
			
			if (c == 0x3001) 
			{
				// IDEOGRAPHIC COMMA
				newChar[j++] = 0xff64;
			}
			else if (c == 0x3002)
			{
				// IDEOGRAPHIC FULL STOP
				newChar[j++] = 0xff61;
			}
			else if (c <= 0x304a)
			{
				// HIRAGANA LETTER SMALL A to HIRAGANA LETTER O
				if (c % 2)
				{
					// small letter (i.e., xa, xi, xu, xe, xo)
					newChar[j++] = (c - 0x3041) / 2 + 0xff67;
				}
				else
				{
					// regular letter (i.e., a, i, u, e, o)
					newChar[j++] = (c - 0x3041) / 2 + 0xff71;
				}
			}
			else if (c <= 0x3062)
			{
				// HIRAGANA LETTER KA to HIRAGANA LETTER DI			
				if (c % 2)
				{
					// not voiced sound letter
					newChar[j++] = (c - 0x304b) / 2 + 0xff76;
				}
				else
				{
					// voiced sound letter
					newChar[j++] = (c - 0x304b) / 2 + 0xff76;
					newChar[j++] = 0xff9e;
				}
			}
			else if (c == 0x3063)
			{
				// HIRAGANA LETTER SMALL TU
				newChar[j++] = 0xff6f;
			}
			else if (c <= 0x3069)
			{
				// HIRAGANA LETTER TU to HIRAGANA LETTER DO
				if (c % 2)
				{
					// voiced sound letter
					newChar[j++] = (c - 0x3064) / 2 + 0xff82;
					newChar[j++] = 0xff9e;
				}
				else
				{
					// not voiced sound letter
					newChar[j++] = (c - 0x3064) / 2 + 0xff82;
				}
			}
			else if (c <= 0x306e)
			{
				// HIRAGANA LETTER NA to HIRAGANA LETTER NO
				newChar[j++] = (c - 0x306a) + 0xff85;
				
			}
			else if (c <= 0x307d)
			{ // HIRAGANA LETTER HA to HIRAGANA LETTER PO
				if (c % 3 == 2)
				{
					// semi-voiced sound letter
					newChar[j++] = (c - 0x306f) / 3 + 0xff8a;
					newChar[j++] = 0xff9f;
				}
				else if (c % 3 == 1)
				{
					// voiced sound letter
					newChar[j++] = (c - 0x306f) / 3 + 0xff8a;
					newChar[j++] = 0xff9e;
				}
				else
				{
					// not voiced sound letter
					newChar[j++] = (c - 0x306f) / 3 + 0xff8a;
				}
			}
			else if (c <= 0x3082)
			{
				// HIRAGANA LETTER MA to HIRAGANA LETTER MO
				newChar[j++] = (c - 0x307e) + 0xff8f;
			}
			else if (c <= 0x3088)
			{
				// HIRAGANA LETTER SMALL YA to HIRAGANA LETTER YO
				if (c % 2)
				{
					// small letter
					newChar[j++] = (c - 0x3083) / 2 + 0xff6c;
				}
				else
				{
					// not small letter
					newChar[j++] = (c - 0x3083) / 2 + 0xff94;
				}
			}
			else if (c <= 0x308d)
			{
				// HIRAGANA LETTER RA to HIRAGANA LETTER RO
				newChar[j++] = (c - 0x3089) + 0xff97;
			}
			else
			{
				switch (c)
				{
					case 0x308e: // HIRAGANA LETTER SMALL WA (converted to WA)
					case 0x308f: newChar[j++] = 0xff9c; break; // HIRAGANA LETTER WA
					case 0x3090: newChar[j++] = 0xff72; break; // HIRAGANA LETTER WI (converted to I)
					case 0x3091: newChar[j++] = 0xff74; break; // HIRAGANA LETTER WI (converted to E)
					case 0x3092: newChar[j++] = 0xff66; break; // HIRAGANA LETTER WO
					case 0x3093: newChar[j++] = 0xff9d; break; // HIRAGANA LETTER N
					case 0x3094: newChar[j++] = 0xff9e; newChar[j--] = 0xff73; break; // HIRAGANA LETTER VU
					case 0x3095: newChar[j++] = 0xff76; break; // HIRAGANA LETTER SMALL KA (converted to KA)
					case 0x3096: newChar[j++] = 0xff79; break; // HIRAGANA LETTER SMALL KE (converted to KE)
					case 0x3099: // COMBINING KATAKANA-HIRAGANA VOICED SOUND MARK
					case 0x309b: newChar[j++] = 0xff9e; break;  //KATAKANA-HIRAGANA VOICED SOUND MARK
					case 0x309a: // COMBINING KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK
					case 0x309c: newChar[j++] = 0xff9f; break; // KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK
						
					case 0x30f7: newChar[j++] = 0xff9c; newChar[j++] = 0xff9e; break; // KATAKANA LETTER VA
					case 0x30f8: newChar[j++] = 0xff72; newChar[j++] = 0xff9e; break; // KATAKANA LETTER VI (converted to 
					case 0x30f9: newChar[j++] = 0xff74; newChar[j++] = 0xff9e; break; // KATAKANA LETTER VE
					case 0x30fa: newChar[j++] = 0xff66; newChar[j++] = 0xff9e; break; // KATAKANA LETTER VO
					case 0x30fb: newChar[j++] = 0xff65; break; // KATAKANA MIDDLE DOT
					case 0x30fc: newChar[j++] = 0xff70; break; // KATAKANA-HIRAGANA PROLONGED SOUND MARK
				}
			}
			
			// --- other characters ---
			
		}
		else if (remainsOther)
		{
			newChar[j++] = c;
		}
	}
	
	return [NSString stringWithCharacters:newChar length:j];
}

- (NSString *)stringByFullwideningCharacters:(unsigned int)mask 
					  passingOtherCharacters:(BOOL)remainsOther
{
	unichar c;
	int	    length = [self length];
	unichar newChar[length];
	
	int previousCharVoice = FJNNotVoiced;
	
	int i, j = length;
	
	for (i = length - 1; i > -1; i--)
	{
		c = [self characterAtIndex:i];
		int currentCharVoice = FJNNotVoiced;
		
		// --- process halfwidth basic Latin characters --- 
		
		if ((mask & FJNWhiteSpace) && c == 0x0020)
		{
			// --- --- halfwidth white space --- --- 
			newChar[--j] = 0x3000;
		}
		else if ((mask & FJNDecimalDigits) && c >= 0x0030 && c <= 0x0039)
		{
			// --- --- halfwidth arabic number --- --- 
			newChar[--j] = c - 0x0020 + 0xff00;
		}
		else if ((mask & FJNBasicLatinLetters) && c >= 0x0041 && c <= 0x005a)
		{
			// --- --- halfwidth latin capital letters (alphabets) --- ---
			newChar[--j] = c - 0x0020 + 0xff00;
		}
		else if ((mask & FJNBasicLatinLetters) && c >= 0x0061 && c <= 0x007a)
		{
			// --- --- halfwidth latin small letters (alphabets) --- ---
			newChar[--j] = c - 0x0020 + 0xff00;
		}
		else if ((mask & FJNBasicLatinSymbols) && c >= 0x0021 && c <= 0x007e)
		{
			// --- --- halfwidth latin symbols --- ---
			newChar[--j] = c - 0x0020 + 0xff00;
		}
		// --- process fullwidth basic latin characters ---
		else if ((mask & FJNWhiteSpace) && c == 0x3000)
		{
			// --- --- fullwidth white space --- ---
			newChar[--j] = c;
		}
		else if ((mask & FJNDecimalDigits) && c >= 0xff10 && c <= 0xff19)
		{
			// --- --- fullwidth arabic number --- ---
			newChar[--j] = c;
		}
		else if ((mask & FJNBasicLatinLetters) && c >= 0xff21 && c <= 0xff3a)
		{
			// --- --- fullwidth latin capital letters (alphabets) --- ---
			newChar[--j] = c;
		}
		else if ((mask & FJNBasicLatinLetters) && c >= 0xff41 && c <= 0xff5a)
		{
			// --- --- fullwidth latin small letters (alphabets) --- ---
			newChar[--j] = c;
		}
		else if ((mask & FJNBasicLatinSymbols) && c >= 0xff01 && c <= 0xff5e)
		{
			newChar[--j] = c;
		}
		// --- halfwidth Japanese characters ---
		else if ((mask & FJNJapaneseKanaCharacters) && c >= 0xff61 && c < c <= 0xff9f)
		{
			switch (c)
			{
				case 0xff61: // HALFWIDTH IDEOGRAPHIC FULL STOP
					newChar[--j] = 0x3002; break;
				case 0xff62: // HALFWIDTH LEFT CORNER BRACKET
					newChar[--j] = 0x300c; break;
				case 0xff63: // HALFWIDTH RIGHT CORNER BRACKET
					newChar[--j] = 0x300d; break;
				case 0xff64: // HALFWIDTH IDEOGRAPHIC COMMA
					newChar[--j] = 0x3001; break;
				case 0xff65: // HALFWIDTH KATAKANA MIDDLE DOT
					newChar[--j] = 0x30fb; break;
				case 0xff66: // HALFWIDTH KATAKANA LETTER WO
					newChar[--j] = 0x30f2; break;
				case 0xff6f: // HALFWIDTH KATAKANA LETTER SMALL TU
					newChar[--j] = 0x30c3; break;
				case 0xff70: // HALFWIDTH KATAKANA-HIRAGANA PROLONGED SOUND MARK
					newChar[--j] = 0x30fc; break;
				case 0xff9c: // HALFWIDTH KATAKANA LETTER WA
					newChar[--j] = 0x30ef; break;
				case 0xff9d: // HALFWIDTH KATAKANA LETTER N
					newChar[--j] = 0x30f3; break;
				case 0xff9e: // HALFWIDTH KATAKANA VOICED SOUND MARK
					newChar[--j] = 0x309b; currentCharVoice = FJNVoiced; break;
				case 0xff9f: //HALFWIDTH KATAKANA SEMI-VOICED SOUND MARK
					newChar[--j] = 0x309c; currentCharVoice = FJNSemiVoiced; break;
				default:
					if (c >= 0xff67 && c <= 0xff6b)
					{
						// HALFWIDTH KATAKANA LETTER SMALL A to HALFWIDTH KATAKANA LETTER SMALL O
						newChar[j--] = 0x30a1 + (c - 0xff67) * 2;
					}
					else if (c >= 0xff6c && c <= 0xff6e)
					{
						// HALFWIDTH KATAKANA LETTER SMALL YA to HALFWIDTH KATAKANA LETTER SMALL YO
						newChar[j--] = 0x30e3 + (c - 0xff6c) * 2;
					}
					else if (c >= 0xff71 && c <= 0xff75)
					{
						// HALFWIDTH KATAKANA LETTER A to HALFWIDTH KATAKANA LETTER O
						if (c == 0xff73 && previousCharVoice == FJNVoiced)
						{
							j++;
							newChar[--j] = 0x30f4;
							previousCharVoice = FJNNotVoiced;
						}
						else
						{
							newChar[--j] = 0x30a2 + (c - 0xff71) * 2;
						}
					}
					else if (c >= 0xff76 && c<= 0xff81) {
						// HALFWIDTH KATAKANA LETTER KA to HALFWIDTH KATAKANA LETTER TI
						if (previousCharVoice == FJNVoiced)
						{
							j++;
							newChar[--j] = 0x30ac + (c - 0xff76) * 2;
							previousCharVoice = FJNNotVoiced;
						}
						else
						{
							newChar[--j] = 0x30ab + (c - 0xff76) * 2;
						}
					}
					else if (c >= 0xff82 && c <= 0xff84)
					{
						// HALFWIDTH KATAKANA LETTER TU to HALFWIDTH KATAKANA LETTER TO
						if (previousCharVoice == FJNVoiced)
						{
							j++;
							newChar[--j] = 0x30c5 + (c - 0xff82) * 2;
							previousCharVoice = FJNNotVoiced;
						}
						else
						{
							newChar[--j] = 0x30c4 + (c - 0xff82) * 2;
						}
					}
					else if (c >= 0xff85 && c <= 0xff89)
					{
						// HALFWIDTH KATAKANA LETTER NA to HALFWIDTH KATAKANA LETTER NO
						newChar[--j] = 0x30ca + (c - 0xff85);
					}
					else if (c >= 0xff8a && c <= 0xff8e)
					{
						// HALFWIDTH KATAKANA LETTER HA to HALFWIDTH KATAKANA LETTER HO
						if (previousCharVoice == FJNVoiced)
						{
							j++;
							newChar[--j] = 0x30d0 + (c - 0xff8a) * 3;
							previousCharVoice = FJNNotVoiced;
						}
						else if (previousCharVoice == FJNSemiVoiced)
						{
							j++;
							newChar[--j] = 0x30d1 + (c - 0xff8a) * 3;
							previousCharVoice = FJNNotVoiced;
						}
						else
						{
							newChar[--j] = 0x30cf + (c - 0xff8a) * 3;
						}
						
					}
					else if (c >= 0xff8f && c <= 0xff93)
					{
						// HALFWIDTH KATAKANA LETTER MA to HALFWIDTH KATAKANA LETTER MO
						newChar[--j] = 0x30de + (c - 0xff8f);
					}
					else if (c >= 0xff94 && c <= 0xff96)
					{
						// HALFWIDTH KATAKANA LETTER YA to HALFWIDTH KATAKANA LETTER YO
						newChar[--j] = 0x30e4 + (c - 0xff94) * 2;
					}
					else if (c >= 0xff97 && c <= 0xff9b)
					{
						// HALFWIDTH KATAKANA LETTER RA to HALFWIDTH KATAKANA LETTER RO
						newChar[--j] = 0x30e9 + (c - 0xff97);
					}
			}
			
			// ---fullwidth Japanese characters ---
			
		}
		else if ((mask & FJNJapaneseKanaCharacters) &&
				 (c == 0x3001 || // IDEOGRAPHIC COMMA
				  c == 0x3002 || // IDEOGRAPHIC FULL STOP
				  c >= 0x3041 && c <= 0x309c || // HIRAGANA LETTER SMALL A to KATAKANA-HIRAGANA SEMI-VOICED SOUND 
				  c >= 0x30a1 && c <= 0x30fc)) // KATAKANA LETTER SMALL A to KATAKANA-HIRAGANA PROLONGED SOUND MARK
		{
			newChar[--j] = c;
		}
		// --- other characters ---
		else if (remainsOther)
		{
			newChar[--j] = c;
		}
		
		previousCharVoice = currentCharVoice;
	}
	
	return [NSString stringWithCharacters:newChar + j  length:(length - j)];
}

- (NSString *)filteredStringUsingCharacterSet:(NSCharacterSet *)charSet
{
	unichar c;
	int	    length = [self length];
	unichar newChar[length];
	
	int i, j = 0;
	for (i = 0; i < length; i++)
	{
		if ([charSet characterIsMember:c])
		{
			newChar[j++] = c;
		}
	}
	return [NSString stringWithCharacters:newChar length:j];
}

@end
