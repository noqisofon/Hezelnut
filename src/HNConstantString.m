#import <stdlib.h>
#import <string.h>
#import <ctype.h>

#ifdef HEZELNUT_HAS_STREAM
#   import <hezelnut/HNStream.h>
#endif  /* HEZELNUT_HAS_STREAM */
#ifdef HEZELNUT_HAS_BYTEARRAY
#   import <hezelnut/HNByteArray.h>
#endif  /* HEZELNUT_HAS_BYTEARRAY */
#ifdef HEZELNUT_HAS_ORDEREDCOLLECTION
#   import <hezelnut/HNOrderedCollection.h>
#endif  /* HEZELNUT_HAS_ORDEREDCOLLECTION */

#import <hezelnut/HNConstantString.h>

#define TO_OBJCBOOL(pred) pred? YES: NO;


static char* _hn_make_cstring(unsigned int len) {
  return (char *)malloc( (len + 1) * sizeof(char) );
}


static void _hn_cstring_destroy(char* cs) {
  free( cs );
}


@implementation HNConstantString
+ (HNConstantString *) cr {
  return [ HNConstantString fromCString: "\n" ];
}

+ (HNConstantString *) lf {
  return [ HNConstantString fromCString: "\r" ];
}

+ (HNConstantString *) crlf {
  return [ HNConstantString fromCString: "\r\n" ];
}

+ (HNConstantString *) crlfcrlf {
  return [ HNConstantString fromCString: "\r\n\r\n" ];
}

+ (HNConstantString *) tab {
  return [ HNConstantString fromCString: "\t" ];
}

+ (HNConstantString *) new: (unsigned int)size_requested {
  return [ [ HNConstantString alloc ] init: size_requested ];
}

+ (HNConstantString *) value: (int)ch {
  return [ [ HNConstantString alloc ] init: 1 fillCharacter: (char)ch & 0x000000ff ];
}

+ (HNConstantString *) with: (char)ch {
  return [ [ HNConstantString alloc ] init: 1 fillCharacter: ch ];
}

+ (HNConstantString *) fromString: (NXConstantString *)a_string {
  return [ [ HNConstantString alloc ] initWithNXConstantString: a_string ];
}

+ (HNConstantString *) fromCString: (const char *)cs {
  return [ [ HNConstantString alloc ] initWithCString: cs ];
}

#ifdef HEZELNUT_HAS_BYTEARRAY
+ (HNConstantString *) fromByteArray: (HNByteArray *)a_byte_array {
}
#endif  /* ifdef HEZELNUT_HAS_BYTEARRAY */

#ifdef HEZELNUT_HAS_STREAM
+ (HNConstantString *) fromStream: (HNStream *)a_stream {
}
#endif  /* ifdef HEZELNUT_HAS_STREAM */


- (id) init: (unsigned int)size_requested {
  [ super init ];

  char* tmp_string = _hn_make_cstring( size_requested );

  memset( tmp_string, '\0', size_requested );
  tmp_string[size_requested + 1] = '\0';

  length_ = size_requested;
  c_string_ = tmp_string;

  return self;
}
- (id) init: (unsigned int)size_requested fillCharacter: (char)ch {
  [ super init ];

  char* tmp_string = _hn_make_cstring( size_requested );

  memset( tmp_string, ch, size_requested );
  tmp_string[size_requested + 1] = '\0';

  length_ = size_requested;
  c_string_ = tmp_string;

  return self;
}


- (id) initWithCString: (const char *)cs {
  [ super init ];

  length_ = strlen( cs );
  c_string_ = _hn_make_cstring( length_ );

  strncpy( c_string_, cs, length_ );

  return self;
}


- (id) initWithHNConstantString: (HNConstantString *)an_string {
  [ super init ];
  const char* cs = [ an_string cString ];

  length_ = strlen( cs );
  c_string_ = _hn_make_cstring( length_ );
  strncpy( c_string_, cs, length_ );

  return self;
}

- (id) initWithNXConstantString: (NXConstantString *)an_string {
  [ super init ];
  const char* cs = [ an_string cString ];

  length_ = strlen( cs );
  c_string_ = _hn_make_cstring( length_ );
  strncpy( c_string_, cs, length_ );

  return self;
}


- free {
  free( c_string_ );
  length_ = 0;

  return self;
}


/*** @addgroup primitive accessing */
- (const char *) cString { return c_string_; }

- (unsigned int) length { return length_; }


/** * @addgroup accessing */
/**
 * index 番目の ASCII 値を返します。
 */
- (char) byteAt: (int)index {
  return c_string_[index];
}
/**
 * index 番目に ASCII 値を設定します。
 */
- (char) byteAt: (int)index put: (char)value {
  char temp_ch = c_string_[index];

  c_string_[index] = value;

  return temp_ch;
}


/**
 * 文字列のバイトサイズを返します。
 */
- (unsigned int) byteSize {
  return [ self length ];
}


/**
 * 文字列の最後の文字が数字なら真を返します。
 */
- (BOOL) endsWithDigit {
  return TO_OBJCBOOL( isdigit( [ self byteAt: length_ - 1 ] ) );
}


/**
 * start 番目から delimiters の何れかの文字を含む最初の位置を返します。無い場合は文字数 + 1 を返します。
 */
- (int) findAnySubstr: (id <HNPString>)delimiters startingAt: (int)start {
  int i, j;
  const char* temp_cs = c_string_;
  int len = (int)length_;
  const char* temp_delimiters = [ delimiters cString ];
  int delimiters_len = (int)[ delimiters length ];

  for ( i = start; i < len; ++ i ) {
    for ( j = 0; j < delimiters_len; ++ i ) {
      if ( temp_cs[i] == temp_delimiters[j] )
        return i;
    }
  }
  return len + 1;
}


#ifdef HEZELNUT_HAS_ORDEREDCOLLECTION
/**
 * delimiters の文字列をデリミタとみなして、デリミタで分断した文字列を NSOrderedCollection のインスタンスとして返します。
 */
- (NSOrderedCollection *) findBetweenSubstrs: (id <HNPString>)delimiters {
  int i, j;
  char *p, *q;  // 分断した文字列の最初と最後。
  char* next_begin;
  NSOrderedCollection* collection;
  const char* temp_cs = c_string_;
  int len = (int)length_;
  const char* temp_delimiters = [ delimiters cString ];
  int delimiters_len = (int)[ delimiters length ];
  char* temp_element = NULL;
  int element_len = 0;
  int match_count = 0;

  collection = [ [ NSOrderedCollection alloc ] init ];
  p = q = next_begin = temp_cs;

  for ( i = 0; i < len; ++ i ) {
    if ( temp_cs[i] == temp_delimiters[match_count] ) {
      if ( match_count == 0 )
        q = (temp_cs + i);
      ++ match_count;
      if ( match_count == delimiters_len ) {
        element_len = q - p;
        temp_element = _hn_make_cstring( (unsigned int)element_len );
        for ( j = 0; *p != *q; ++ j, ++ p ) {
          temp_element[j] = *p;
        }
        temp_element[j] = '\0';
        [ collection add: [ HNConstantString fromCString: temp_element ] ];
        _hn_cstring_destoy( temp_element );

        next_begin = p + delimiters_len;
        match_count = 0;
      }
    } else {
      match_count = 0;
      p = next_begin;
    }
  }

  q = (temp_cs + i);
  element_len = q - p;
  temp_element = _hn_make_cstring( (unsigned int)element_len );
  for ( j = 0; *p != *q; ++ j, ++ p ) {
    temp_element[j] = *p;
  }
  temp_element[j] = '\0';
  [ collection add: [ HNConstantString fromCString: temp_element ] ];
  _hn_cstring_destoy( temp_element );
  
  return collection;
}
#endif  /* HEZELNUT_HAS_ORDEREDCOLLECTION */


/**
 * start_index 番目の '(' に対応する、')' の文字位置を返します。対応する ')' が見つからない場合は size + 1 を返します。
 */
- (int) findCloseParenthesisFor: (int)start_index {
  int i;
  const char* temp_cs = c_string_;
  int len = (int)length_;

  if ( temp_cs[start_index] == '(' )
    return start_index;

  for ( i = start_index; i < len; ++ i ) {
    if ( temp_cs[i] == ')' )
      return i;
  }
  return len + 1;
}


/**
 * start_index 番目から delimiters の文字位置を返します。
 */
- (int) findDelimiters: (id <HNPString>)delimiters startingAt: (int)start_index {
  int i;
  int lazy_index = 0;
  int match_count = 0;
  int len = (int)length_;
  const char* temp_delimiters = [ delimiters cString ];
  int delimiters_len = (int)[ delimiters length ];

  for ( i = start_index; i < len; ++ i ) {
    if ( c_string_[i] == temp_delimiters[match_count] ) {
      if ( match_count == 0 )
        lazy_index = i;
      ++ match_count;
      if ( match_count == delimiters_len )
        return lazy_index;
    } else {
      match_count = 0;
      lazy_index = 0;
    }
  }
  return len + 1;
}


/**
 * sub_string を含む位置を返します。sub_string を含まない場合は -1 を返します。
 */
- (int) findString: (id <HNPString>)sub_string {
  return [ self findString: sub_string startingAt: 0 caseSensitive: true ];
}
/**
 * findString: の開始位置を指定できるようにしたものです。
 */
- (int) findString: (id <HNPString>)sub_string startingAt: (int)start_index {
  return [ self findString: sub_string startingAt: start_index caseSensitive: true ];
}
/**
 * findString:startingAt: の大文字小文字を無視するか指定できるようにしたものです。
 */
- (int) findString: (id <HNPString>)sub_string startingAt: (int)start_index caseSensitive: (BOOL)case_sensitive {
  int i;
  const char* temp_cs = c_string;
  int len = (int)length_;
  const char* temp_sub_string = [ sub_string cString ];
  int sub_len = (int)[ sub_string length ];
  int match_count = 0,
    lazy_index = 0;

  for ( i = start_index; i < len; ++ i ) {
    if ( temp_cs[i] == temp_sub_string[j] ) {
      if ( match_count == 0 )
        lazy_index = i;
      ++ match_count;
      if ( match_count == sub_len )
        return laze_index;
    } else {
      lazy_index = 0;
      match_count = 0;
    }
  }
  return -1;
}


#ifdef HEZELNUT_HAS_ORDEREDCOLLECTION
/**
 * delimiters 文字、または文字列で分割した HNOrderedCollection オブジェクトを返します。
 */
- (HNOrderedCollection *) findTokens: (id <HNPString>)delimiters {
}
/**
 * delimiters 文字、または文字列で分割した HNOrderedCollection オブジェクトから sub_string を含む文字列を返します。
 */
- (HNOrderedCollection *) findTokens: (id <HNPString>)delimiters includes: (id <HNPString>)sub_string {
}
/**
 * delimiters 文字、または文字列で分割するとき keepers 文字は残しておきます。
 */
- (HNOrderedCollection *) findTokens: (id <HNPString>)delimiters keep: (id <HNPString>)keepers {
}
#endif  /* ifdef defined(HEZELNUT_HAS_ORDEREDCOLLECTION) */


/**
 * start_index 番目から key の開始位置を求めます。key が無い場合は -1 を返します。
 */
- (int) findWordStart: (id <HNPString>)key startingAt: (int)start_index {
  int i;
  const char* temp_cs = c_string;
  int len = (int)length_;
  const char* temp_key = [ key cString ];
  int key_len = (int)[ key length ];
  int match_count = 0,
    lazy_index = 0;

  for ( i = start_index; i < len; ++ i ) {
    if ( temp_cs[i] == temp_key[j] ) {
      if ( match_count == 0 )
        lazy_index = i;
      ++ match_count;
      if ( match_count == key_len )
        return laze_index;
    } else {
      lazy_index = 0;
      match_count = 0;
    }
  }
  return -1;
}


/**
 * レシーバに含まれる文字列 sub_string を指定位置 start_index より探索して、最後に見つけた位置を返します。見つからない場合は -1 を返します。
 */
- (int) findLastOccuranceOfString: (id <HNPString>)sub_string startingAt: (int)start_index {
  int i;
  const char* temp_cs = c_string;
  int len = (int)length_;
  const char* temp_sub_string = [ sub_string cString ];
  int sub_string_len = (int)[ sub_string length ];
  int match_count = 0,
    lazy_index = 0,
    result_index = -1;

  for ( i = start_index; i < len; ++ i ) {
    if ( temp_cs[i] == temp_sub_string[j] ) {
      if ( match_count == 0 )
        lazy_index = i;
      ++ match_count;
      if ( match_count == sub_string_len )
        result_index = laze_index;
    } else {
      lazy_index = 0;
      match_count = 0;
    }
  }
  return result_index;
}


/**
 * sub_string を含む場合は真、含まない場合は偽を返します。
 */
- (BOOL) includesSubstring: (id <HNPString>)sub_string {
  return [ self includesSubstring: sub_string caseSensitive: YES ];
}
/**
 * 
 */
- (BOOL) includesSubstring: (id <HNPString>)sub_string caseSensitive: (BOOL)case_sensitive {
  int i;
  const char* temp_cs = c_string;
  int len = (int)length_;
  const char* temp_sub_string = [ sub_string cString ];
  int sub_string_len = (int)[ sub_string length ];
  int match_count = 0,
    lazy_index = 0;
  char left, right;
  BOOL result = NO;

  for ( i = start_index; i < len; ++ i ) {
    if ( case_sensitive ) {
      left = tolower( temp_cs[i] );
      right = tolower( temp_sub_string[j] );
    } else {
      left = temp_cs[i];
      right = temp_sub_string[j];
    }

    if ( left == right ) {
      if ( match_count == 0 )
        lazy_index = i;
      ++ match_count;
      if ( match_count == sub_string_len )
        result = YES;
    } else {
      lazy_index = 0;
      match_count = 0;
    }
  }
  return result;
}


/**
 * a_character の存在する位置を返します。
 */
- (int) indexOf: (char)a_character {
  return [ self indexOf: a_character startingAt: 0 ];
}
/**
 * 
 */
- (int) indexOf: (char)a_character startingAt: (int)start_index {
  int i;
  const char* temp_cs = c_string;
  int len = (int)length_;

  for ( i = start_index; i < len; ++ i ) {
    if ( temp_cs[i] == a_character )
      return i;
  }
  return -1;
}
#ifdef HEZELNUT_ENABLE_BLOCK
/**
 * 
 */
- (int) indexOf: (char)a_character startingAt: (int)start_index ifAbsent: a_block {
  int i;
  const char* temp_cs = c_string;
  int len = (int)length_;

  for ( i = start_index; i < len; ++ i ) {
    if ( temp_cs[i] == a_character )
      return i;
  }
  return a_block();
}
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
/**
 * 
 */
- (int) indexOfAnyOf: (HNCharacterSet *)a_characterset startingAt: (int)start_index ifAbsent: a_block;
#   endif  /* def HEZELNUT_ENABLE_BLOCK */
#endif  /* def HEZELNUT_HAS_MUTABLESTRING */


/**
 * index 番目の文字の leading char が何個続くかを返します。
 */
- (int) leadingCharRunLengthAt: (int)index {
  int i;
  const char* temp_cs = c_string;
  int len = (int)length_;
  char leading_ch;
  int count = 0;

  if ( index < 0 && index > len )
    return -1;
  else
    leading_ch = temp_cs[index];

  for ( i = index + 1; i < len; ++ i ) {
    if ( temp_cs[i] == leading_ch )
      ++ count;
    else
      break;
  }
  return count;
}


/**
 * index 行目より文字数が多い行の文字列を返します。
 */
- (id <HNPString>) lineCorrespodingToIndex: (int)index {
  
}
  

/**
 * 文字列の行数をカウントします。
 */
- (int) lineCount {
}


/**
 * index 行目の文字列を返します。
 */
- (id <HNPString>) lineNumber: (int)index;



#ifdef HEZELNUT_ENABLE_BLOCK
/**
 * 行毎に a_block を評価します。ただし、最後の行が CR のみの場合は評価しません。
 */
- (void) linesDo: a_block;
#endif  /* def HEZELNUT_ENABLE_BLOCK */


#ifdef HEZELNUT_HAS_MUTABLESTRING
- (HNMutableString *) asMutableString {
  return [ HNMutableString fromConstantString: self ];
}
#endif  /* ifdef HEZELNUT_HAS_MUTABLESTRING */
@end
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
