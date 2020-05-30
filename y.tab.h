#define tINT_TYPE 257
#define tREAL_TYPE 258
#define tAUTO_TYPE 259
#define tSTRING_TYPE 260
#define tPOINTER_TYPE 261
#define tINPUT 262
#define tPUBLIC 263
#define tREQUIRE 264
#define tWRITE 265
#define tWRITELN 266
#define tAND 267
#define tOR 268
#define tSIZEOF 269
#define tFOR 270
#define tIF 271
#define tBEGIN 272
#define tEND 273
#define tBREAK 274
#define tCONTINUE 275
#define tRETURN 276
#define tPROCEDURE 277
#define tINTEGER 278
#define tIDENTIFIER 279
#define tSTRING 280
#define tREAL 281
#define tNULLPTR 282
#define tTHEN 283
#define tDO 284
#define tELIF 285
#define tELSE 286
#define tEQ 287
#define tNE 288
#define tGE 289
#define tLE 290
#define tUNARY 291
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {
  int                   i;	/* integer value */
  double			   d;   /* real value*/
  std::string          *s;	/* symbol name or string literal */
  cdk::basic_node      *node;	/* node pointer */
  cdk::sequence_node   *sequence;
  cdk::expression_node *expression; /* expression nodes */
  cdk::lvalue_node     *lvalue;
  cdk::basic_type       *type;
  og::block_node       *block;     /* block nodes */
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;
