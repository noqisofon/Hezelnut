#ifndef Hezelnut_HNPString_h
#define Hezelnut_HNPString_h

#import <objc/NXConstStr.h>


/*! \protocol HNPString  HNPString.h
  文字列クラスに必要なメソッドを集めたプロトコルです。
 */
@protocol HNPString
/*! \name primitive accessing
  
 */
/*! @{ */
/*!
  内部の C プリミティブ文字列を返します。
 */
- (const char *) cString;


/*!
  文字列の長さを返します。
 */
- (unsigned int) length;
/*! @} */


/*! \name accessing
  
 */
/*! @{ */
/*!
  index 番目の ASCII 値を返します。
 */
- (char) byteAt: (int)index;
/*!
  index 番目に ASCII 値を設定します。
 */
- (char) byteAt: (int)index put: (char)value;


/*!
  文字列のバイトサイズを返します。
 */
- (unsigned int) byteSize;


/*!
  文字列の最初の文字が数字なら真を返します。
 */
- (BOOL) startsWithDigit;


/*!
  文字列の最後の文字が数字なら真を返します。
 */
- (BOOL) endsWithDigit;


/*!
  start 番目から delimiters の何れかの文字を含む最初の位置を返します。無い場合は文字数 + 1 を返します。
 */
- (int) findAnySubstr: (id <HNPString>)delimiters startingAt: (int)start;


#ifdef HEZELNUT_HAS_ORDEREDCOLLECTION
/*!
  delimiters の文字列をデリミタとみなして、デリミタで分断した文字列を NSOrderedCollection のインスタンスとして返します。
 */
- (HNOrderedCollection *) findBetweenSubstrs: (id <HNPString>)delimiters;
#endif  /* ifdef defined(HEZELNUT_HAS_ORDEREDCOLLECTION) */


/*!
  start_index 番目の '(' に対応する、')' の文字位置を返します。対応する ')' が見つからない場合は size + 1 を返します。
 */
- (int) findCloseParenthesisFor: (int)start_index;


/*!
  start_index 番目から delimiters の文字位置を返します。
 */
- (int) findDelimiters: (id <HNPString>)delimiters startingAt: (int)start_index;


/*!
  sub_string を含む位置を返します。sub_string を含まない場合は -1 を返します。
 */
- (int) findString: (id <HNPString>)sub_string;
/*!
  findString: の開始位置を指定できるようにしたものです。
 */
- (int) findString: (id <HNPString>)sub_string startingAt: (int)start_index;
/**
 * findString:startingAt: の大文字小文字を無視するか指定できるようにしたものです。
 */
- (int) findString: (id <HNPString>)sub_string startingAt: (int)start_index caseSensitive: (BOOL)case_sensitive;


#ifdef HEZELNUT_HAS_ORDEREDCOLLECTION
/*!
  delimiters 文字、または文字列で分割した HNOrderedCollection オブジェクトを返します。
 */
- (HNOrderedCollection *) findTokens: (id <HNPString>)delimiters;
/*!
  delimiters 文字、または文字列で分割した HNOrderedCollection オブジェクトから sub_string を含む文字列を返します。
 */
- (HNOrderedCollection *) findTokens: (id <HNPString>)delimiters includes: (id <HNPString>)sub_string;
/*!
  delimiters 文字、または文字列で分割するとき keepers 文字は残しておきます。
 */
- (HNOrderedCollection *) findTokens: (id <HNPString>)delimiters keep: (id <HNPString>)keepers;
#endif  /* ifdef defined(HEZELNUT_HAS_ORDEREDCOLLECTION) */


/*!
  start_index 番目から key の開始位置を求めます。key が無い場合は -1 を返します。
 */
- (int) findWordStart: (id <HNPString>)key startingAt: (int)start_index;


/*!
  レシーバに含まれる文字列 sub_string を指定位置 start_index より探索して、最後に見つけた位置を返します。見つからない場合は -1 を返します。
 */
- (int) findLastOccuranceOfString: (id <HNPString>)sub_string startingAt: (int)start_index;


/*!
  sub_string を含む場合は真、含まない場合は偽を返します。
 */
- (BOOL) includesSubstring: (id <HNPString>)sub_string;
/*!
 
 */
- (BOOL) includesSubstring: (id <HNPString>)sub_string caseSensitive: (BOOL)case_sensitive;


/*!
  a_character の存在する位置を返します。
 */
- (int) indexOf: (char)a_character;
/*!
 
 */
- (int) indexOf: (char)a_character startingAt: (int)start_index;
#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 
 */
- (int) indexOf: (char)a_character startingAt: (int)start_index ifAbsent: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


#ifdef HEZELNUT_HAS_MUTABLESTRING
/**
 * a_characterset で与えられた文字が最初に見つかったインデックス値を返します。
 */
- (int) indexOfAnyOf: (HNCharacterSet *)a_characterset;
/**
 * 
 */
- (int) indexOfAnyOf: (HNCharacterSet *)a_characterset startingAt: (int)start_index;
#   ifdef HEZELNUT_ENABLE_BLOCK
/*!
  
 */
- (int) indexOfAnyOf: (HNCharacterSet *)a_characterset startingAt: (int)start_index ifAbsent: a_block;
#   endif  /* def HEZELNUT_ENABLE_BLOCK */
#endif  /* def HEZELNUT_HAS_MUTABLESTRING */


/*!
  index 番目の文字の leading char が何個続くかを返します。
 */
- (int) leadingCharRunLengthAt: (int)index;


/*!
  index 行目より文字数が多い行の文字列を返します。
 */
- (id <HNPString>) lineCorrespodingToIndex: (int)index;
  

/*!
  文字列の行数をカウントします。
 */
- (int) lineCount;


/*!
  index 行目の文字列を返します。
 */
- (id <HNPString>) lineNumber: (int)index;



#ifdef HEZELNUT_ENABLE_BLOCK
/*!
 * 行毎に a_block を評価します。ただし、最後の行が CR のみの場合は評価しません。
 */
- (void) linesDo: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


/*!
  delimiter を含まない最初の文字位置を返します。レシーバが delimiters のみの場合は size + 1 を返します。
 */
- (int) skipAnySubstr: (id <HNPString>)delimiters startingAt: (int)start_index;


/*!
  delimiter を含まない最初の文字位置を返します。レシーバが delimiters のみの場合は size + 1 を返します。
 */
- (int) skipDelimiters: (id <HNPString>)delimiters startingAt: (int)start_index;
/*! @} */


/*! \name comparing
  
 */
/*! @{ */
/*!
  レシーバ側が短いか同じ文字列の場合、アスキー値をが小さい場合に真を返します。
  <p>
  オペレーターが使えないっぽいため、'<' の代わりとして遣います。
  </p>
 */
- (BOOL) lessThan: (id <HNPString>)a_string;


/*!
  lessThan: に対し同一文字列の場合、真を返します。
  <p>
  オペレーターが使えないっぽいため、'<=' の代わりとして遣います。
  </p>
 */
- (BOOL) lessOrEqual: (id <HNPString>)a_string;


/*!
  self <= a_string の評価結果を返します(大文字小文字の区別はしない)。
 */
- (BOOL) caseInsensitiveLessOrEqual: (id <HNPString>)a_string;


/*!
  同一文字列の場合のみ真を返します。
 */
- (BOOL) equals: (id <HNPString>)a_string;


/*!
  lessThan: の逆です。
  <p>
  オペレーターが使えないっぽいため、'>' の代わりとして遣います。
  </p>
 */
- (BOOL) greaterThan: (id <HNPString>)a_string;


/*!
  lessThanEquals: の逆です。
  <p>
  オペレーターが使えないっぽいため、'>=' の代わりとして遣います。
  </p>
 */
- (BOOL) greaterOrEqual: (id <HNPString>)a_string;


/*!
  大文字、小文字を無視して比較します。比較の結果一致しない場合は 0 を返します。
 */
- (int) alike: (id <HNPString>)a_string;


/*!
  大文字、小文字を区別して、文字列先頭が prefix と一致する場合に真を返します。
 */
- (BOOL) beginsWith: (id <HNPString>)prefix;


/*!
  大文字、小文字を区別して、文字列末尾が suffix と一致する場合に真を返します。
 */
- (BOOL) endsWith: (id <HNPString>)suffix;


/*!
  a_collection の要素の何れかがレシーバの最後の文字列に一致すれば真を返します。
 */
- (BOOL) endsWithAnyOf: (id <JNPCollectable>)a_collection;


/*!
  レシーバと a_string の最大一致長を返します。
 */
- (int) charactersExactlyMating: (id <HNPString>)a_string;


/*!
  a_string との比較結果を返します。0 の時は一致、-1 の時は a_string が(ASCII コード的な意味で)大きい、
  1 の時は a_string が(ASCII コード的な意味で)小さいことを表します。
 */
- (int) compare: (id <HNPString>)a_string;
/*!
  
 */
- (int) compare: (id <HNPString>)a_string caseSensitive: (BOOL)case_sensitive;
#ifdef HEZELNUT_HAS_CHARACTERMAP
/*!
  
 */
- (int) compare: (id <HNPString>)a_string1 with: (id <HNPString>)a_string2 collated: (HNCharacterMap *)order;
#endif  /* def HEZELNUT_HAS_CHARACTERMAP */


/*!
  ハッシュ値を求めます。
 */
- (int) hash;


//- (?) hashMappedBy:


/*!
  a_string とレシーバの最大一致長を返します。
 */
- (int) howManyMatch: (id <HNPString>)a_string;


/*!
  正規表現でマッチングします。
 */
- (BOOL) match: (id <HNPString>)text;


/*!
  大文字小文字を無視して文字列の比較を行います。比較の結果、一致すれば真を返します。
 */
- (BOOL) someAs: (id <HNPString>)a_string;


/*!
  レシーバの称号開始位置を key_start、レシーバの文字列を正規表現文字列、
  非照合文字列を text 非照合文字列の称号開始位置を text_start としてマッチングを行います。
 */
- (BOOL) startingAt: (int)key_start match: (id <HNPString>)text statringAt: (id <HNPString>)text_start;
/*! @} */


/*! \name copying
  
 */
/*! @{ */
/*!
  レシーバの文字列から old_substring を new_substring で全て置き換えたものを返します。
 */
- (id <HNPString>) copyReplaceTokens: (id <HNPString>)old_substring with: (id <HNPString>)new_substring;


/*!
  コピーします。
 */
- (id) deepCopy;


#ifdef HEZELNUT_HAS_SYMBOL
/*!
  文字列長が length になるまで前か後ろに ch を追加します。left_or_right で前か後ろかを指定します。
 */
- (id <HNPString>) padded: (HNSymbol *)left_or_right to: (int)length with: (char)ch;
#endif  /* def HEZELNUT_HAS_SYMBOL */
/*! @} */


/*! \name converting

 */
/*! @{ */
#ifdef HEZELNUT_HAS_MUTABLESTRING
/*!
  レシーバを HNMutableString に変換して返します。
 */
- (HNMutableString *) asMutableString;
#endif  /* ifdef HEZELNUT_HAS_MUTABLESTRING */


#ifdef HEZELNUT_HAS_BYTEARRAY
/*!
  レシーバを HNByteArray に変換して返します。
 */
- (HNByteArray *) asByteArray;
#endif  /* ifdef HEZELNUT_HAS_BYTEARRAY */


#ifdef HEZELNUT_HAS_CHARACTER
/*!
  レシーバの先頭文字を返します。
 */
- (HNCharacter *) asCharacter;
#endif  /* def HEZELNUT_HAS_CHARACTER */


#ifdef HEZELNUT_HAS_DATE
/*!
  レシーバを Date オブジェクトに変換します。
 */
- (HNDate *) asDate;
#endif  /* def HEZELNUT_HAS_DATE */


#ifdef HEZELNUT_HAS_DATEANDTIME
/*!
  レシーバを Date オブジェクトに変換します。
 */
- (HNDateAndTime *) asDateAndTime;
#endif  /* def HEZELNUT_HAS_DATEANDTIME */


/*!
  self を返します。
 */
- (id <HNPString>) asDefaultDecodedString;


/*!
  ファイル名として変換します。ファイル名に許されない文字を使用すると、'#' に変換されます。ファイル名に相当する文字列がない場合、例外が発生します。
 */
- (id <HNPString>) asFileName;


/*!
  4 文字からなる文字列から各文字のアスキーコードで 32 bit 長のコードを生成します。
 */
- (int) asFourCode;


/*!
  文字列の各文字のキャラクタコードを 16 新表記で列挙した文字列を作成します。
 */
- (id <HNPString>) asHex;


/*!
  HTML での特殊文字([<>&"')( ]) を文字参照に変換します。
 */
- (id <HNPString>) asHtml;


/*!
  レシーバを IRC の定義で小文字に変換します。
 */
- (id <HNPString>) asIRCLowercase;


/*!
  正当な文字だけを残します。should_be_capitalized が真ならば先頭の文字を大文字に変換します。
 */
- (id <HNPString>) asIdentifier: (BOOL)should_be_capitalized;


/**
 * 文字列の数字部分を抜き出します。数字がない場合は nil を返します。
 */
- (int) asInteger;


#ifdef HEZELNUT_HAS_NUMBER
/**
 * 
 */
- (HNNumder *) asNumber;
#endif  /* def HEZELNUT_HAS_NUMBER */


/**
 * 英数字だけ抽出し、先頭文字が英字でなければ、先頭に 'v' を付加します。文字数が 0 の場合は "v" のみが返ります。
 */
- (id <HNPString>) asLegalSelector;


/*!
  全て小文字に変換したものを返します。
 */
- (id <HNPString>) asLowercase;
/*! @} */
@end


#endif  /* Hezelnut_HNPString_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
