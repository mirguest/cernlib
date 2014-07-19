*
* $Id: norranib.s,v 1.1.1.1 1996/04/01 15:03:05 mclareni Exp $
*
* $Log: norranib.s,v $
* Revision 1.1.1.1  1996/04/01 15:03:05  mclareni
* Mathlib gen
*
*
#if defined(CERNLIB_IBM)
*       NORMAL RANDOM NUMBER GENERATOR FOR IBM 370
*       G.MARSAGLIA, K.ANANTHANARAYANAN, N.PAUL. MCGILL UNIV., MONTREAL
*       ADAPTED AT CERN BY T.LINDELOF, SEPT 1977
*       MODIFIED BY A BERGLUND JAN 1980 (INTRODUCE NORRUT AND NORRIN)
NORRAN START 0              CALL NORRAN(X)
#if defined(CERNLIB_QMIBMXA)
NORRAN AMODE ANY
NORRAN RMODE ANY
#endif
*
*     REGISTER USAGE
*     -------- -----
*     GPR 1 - (REGB) CALCULATION OF RESULTS
*     GPR 2 - (REGC) CALCULATION OF RESULTS
*     GPR 3 - (REGD) CALCULATION OF RESULTS
*     GPR13 - ADDRESS OF SAVE AREA OF CALLING PROGRAM,OR OF THIS
*             PROGRAMS'S SAVE AREA ON CALL TO RNORTH OR REXPTH
*     GPR14 - CONTAINS RETURN ADDRESS.
*     GPR15 - USED AS BASE REGISTER.
*     FPR 0 - RESULT OF UNI,VNI,REXP,RNOR.
       ENTRY NORRUT                           .CALL NORRUT(SEED1,SEED2)
       ENTRY NORRIN                           .CALL NORRIN(SEED1,SEED2)
       ENTRY UNI                       .U=UNI(0)
       ENTRY VNI                       .V=VNI(0)
       EXTRN RNORTH           FORTRAN FUNCTION REQUIRED-RNORTH(I)
REGB   EQU   1
REGC   EQU   2
REGD   EQU   3
*
*     CALL NORRAN(X)          RESULT IS STANDARD NORMAL VARIATE.
*
*     METHOD
*     ------
*   1.  GENERATE H1H2H3H4H5H6H7H8,8 RANDOM HEXADECIMAL DIGITS.
*
*   2.  IF H1H2.LT.68, SET 'X' TO
*                       (NTBL(H1H2)+.H3H4H5H6H7H8)/16, AND QUIT.
*   3.  IF H1H2.LT.D0, SET 'X' TO
*                       (-NTBL(H1H2-68)-.H3H4H5H6H7H8)/16, AND QUIT.
*   4.  IF H1H2H3.LT.E2F, SET 'X' TO
*                       (NTBL(H1H2H3-CE8)+.H4H5H6H7H8)/16, AND QUIT.
*   5.  IF H1H2H3.LT.F5E, SET 'X' TO
*                       (-NTBL(H1H2H3-E17)-.H4H5H6H7H8)/16, AND QUIT.
*   6.  ELSE,GENERATE 'X' FROM THE NORMAL TOOTH-TAIL SUBPROGRAM.
*
       USING *,15
       STM   REGB,REGD,24(13) SAVE REGISTERS 1,2,3
RDIGT3 L     REGB,SRGN        LOAD SRGN INTO REGB
       LR    REGC,REGB        AND INTO REGC
       SRL   REGC,15          SHIFT REGC RIGHT 15 BITS
       XR    REGB,REGC        AND XOR INTO REGB
       LR    REGC,REGB        COPY REGB INTO REGC
       SLL   REGC,17          SHIFT IT LEFT 17 BITS,
       XR    REGB,REGC        AND XOR INTO REGB
       ST    REGB,SRGN        SAVE THE NEW 'SRGN'
       L     REGD,MCGN        LOAD MCGN INTO REGD
       M     REGC,MULT        AND MULTIPLY BY 69069
       ST    REGD,MCGN        STORE RESULT,MODULO 2**32, AS NEW 'MCGN'
       XR    REGD,REGB        XOR NEW 'MCGN' AND 'SRGN' IN REGD
NRCT   SLR   REGC,REGC        ZERO OUT REGC
       CL    REGD,X68         IF REGD GE 68000000,BRANCH TO 'ND2'
       BC    11,ND2
ND1    SLDL  REGC,8           SHIFT FIRST 2 HEX DIGITS INTO REGC
       IC    REGC,NTBL(REGC)  FETCH CORRESPONDING BYTE FROM NTBL
       STC   REGC,PSTWRD+1    STORE AS 2ND BYTE OF PSTWRD
       SRL   REGD,8           TAKE REMAINING 24 BITS OF REGD
       AL    REGD,PCHAR       FORM FLOATING POINT FRACTION,CHAR X'3F'
       ST    REGD,FRAC        AND STORE AT 'FRAC'
       LE    0,PSTWRD         ADD 'PSTWRD' AND 'FRAC'
       AE    0,FRAC           LEAVING RESULT IN FPR 0
       L REGB,24(0,13)
       L REGB,0(0,REGB)
       STE 0,0(REGB)
       LM    REGB,REGD,24(13)
       BCR   15,14            RETURN
ND2    CL    REGD,XD0         IF REGD GE D0000000,BRANCH TO 'ND3'
       BC    11,ND3
       SLDL  REGC,8           SHIFT FIRST 2 HEX DIGITS INTO REGC
       SL    REGC,X68R        AND SUBTRACT 00000068
       IC    REGC,NTBL(REGC)  FETCH CORRESPONDING BYTE FROM NTBL
       STC   REGC,NSTWRD+1    STORE AS 2ND BYTE OF NSTWRD
       SRL   REGD,8           TAKE REMAINING 24 BITS OF REGD
       AL    REGD,PCHAR       FORM FLOATING POINT FRACTION,CHAR X'3F'
       ST    REGD,FRAC        AND STORE AT 'FRAC'
       LE    0,NSTWRD         SUBTRACT 'FRAC' FROM 'NSTWRD'
       SE    0,FRAC           LEAVING RESULT IN FPR 0
       L REGB,24(0,13)
       L REGB,0(0,REGB)
       STE 0,0(REGB)
       LM    REGB,REGD,24(13)
       BCR   15,14            RETURN
ND3    CL    REGD,XE2F        IF REGD GE E2F00000,BRANCH TO 'ND4'
       BC    11,ND4
       SLDL  REGC,12          SHIFT FIRST 3 HEX DIGITS INTO REGC
       SL    REGC,XCE8        AND SUBTRACT 00000CE8
       IC    REGC,NTBL(REGC)  FETCH CORRESPONDING BYTE FROM NTBL
       STC   REGC,PSTWRD+1    STORE AS 2ND BYTE OF PSTWRD
       SRL   REGD,8           TAKE REMAINING 20 BITS OF REGD
       AL    REGD,PCHAR       FORM FLOATING POINT FRACTION,CHAR X'3F'
       ST    REGD,FRAC        AND STORE AT 'FRAC'
       LE    0,PSTWRD         ADD 'PSTWRD' AND 'FRAC'
       AE    0,FRAC           LEAVING RESULT IN FPR 0
       L REGB,24(0,13)
       L REGB,0(0,REGB)
       STE 0,0(REGB)
       LM    REGB,REGD,24(13)
       BCR   15,14            RETURN
ND4    CL    REGD,XF5E        IF REGD GE XF5E00000,BRANCH TO 'NTTHTL'
       BC    11,NTTHTL
       SLDL  REGC,12          SHIFT FIRST 3 HEX DIGITS INTO REGC
       SL    REGC,XE17        AND SUBTRACT 00000E17
       IC    REGC,NTBL(REGC)  FETCH CORRESPONDING BYTE FROM NTBL
       STC   REGC,NSTWRD+1    STORE AS 2ND BYTE OF NSTWRD
       SRL   REGD,8           TAKE REMAINING 20 BITS OF REGD
       AL    REGD,PCHAR       FORM FLOATING POINT FRACTION,CHAR X'3F'
       ST    REGD,FRAC        AND STORE AT 'FRAC'
       LE    0,NSTWRD         SUBTRACT 'FRAC' FROM 'NSTWRD'
       SE    0,FRAC           LEAVING RESULT IN FPR 0
       L REGB,24(0,13)
       L REGB,0(0,REGB)
       STE 0,0(REGB)
       LM    REGB,REGD,24(13)
       BCR   15,14            RETURN
NTTHTL ST    REGD,ARG         STORE REGD AS ARGUMENT FOR RNORTH ROUTINE
       STM   14,0,12(13)      SAVE ALL REGISTERS FROM 14 TO 3.
       LR    3,13             COPY PREVIOUS SAVE AREA ADDRESS TO GPR3
       LA    13,SVAREA        LOAD ADDRESS OF SVAREA INTO GPR13
       ST    13,8(0,3)        STORE ADDRESS OF SVAREA IN SAVE AREA
       ST    3,4(0,13)        STORE ADDRESS OF PREVIOUS SAVE AREA
       LA    1,ARGLST         PLACE ADDRESS OF ARGUMENT LIST IN GPR 1
       L     15,ADNTH
       BALR  14,15            BRANCH TO SUBPROGRAM
       LR    13,3             RESTORE ADDRESS OF SAVE AREA IN GPR13
***    MVI   12(13),X'FF'     SET RETURN INDICATOR
       L REGB,24(0,13)
       L REGB,0(0,REGB)
       STE 0,0(REGB)
RETRN3 LM    14,REGD,12(13)   RESTORE ALL REGISTERS
       BCR   15,14            RETURN
*
*     CALL NORRUT(SEED1,SEED2)   SETS SEED1=MCGN AND SEED2=SRGN
*
       USING NORRUT,15
NORRUT STM   REGB,REGD,24(13)
       L     REGC,0(REGB)
       MVC   0(4,REGC),MCGN
       L     REGD,4(REGB)
       MVC   0(4,REGD),SRGN
       LM    REGB,REGD,24(13)
       BR    14
*
*     CALL NORRIN(SEED1,SEED2)   SETS MCGN=SEED1 AND SRGN=SEED2
*
       USING NORRIN,15
NORRIN STM   REGB,REGD,24(13)
       L     REGC,0(REGB)
       MVC   MCGN(4),0(REGC)
       L     REGD,4(REGB)
       MVC   SRGN(4),0(REGD)
       LM    REGB,REGD,24(13)
       BR    14
*
*     U=UNI(0)                RESULT IS NORMALIZED FLOATING POINT VALUE
*                             UNIFORMLY DISTRIBUTED ON (0.0,1.0).
       USING UNI,15
UNI    STM   REGB,REGD,24(13) SAVE REGISTERS 1,2,3
RDIGT1 L     REGB,SRGN        LOAD SRGN INTO REGB
       LR    REGC,REGB        AND INTO REGC
       SRL   REGC,15          SHIFT REGC RIGHT 15 BITS
       XR    REGB,REGC        AND XOR INTO REGB
       LR    REGC,REGB        COPY REGB INTO REGC
       SLL   REGC,17          SHIFT IT LEFT 17 BITS,
       XR    REGB,REGC        AND XOR INTO REGB
       ST    REGB,SRGN        SAVE THE NEW 'SRGN'
       L     REGD,MCGN        LOAD MCGN INTO REGD
       M     REGC,MULT        AND MULTIPLY BY 69069
       ST    REGD,MCGN        STORE RESULT,MODULO 2**32, AS NEW 'MCGN'
       XR    REGD,REGB        XOR NEW 'MCGN' AND 'SRGN' IN REGD
       SRL   REGD,8           SHIFT REGD RIGHT 8 BITS FOR F.P. FRACTION
       AL    REGD,CHAR        ADD CHARACTERISTIC X'40' INTO FIRST BYTE
       ST    REGD,FWD         STORE AT FWD, LOAD INTO FPR 0,
       LE    0,FWD            AND ADD NORMALIZED TO ZERO
       AE    0,Z              LEAVING RESULT 'UNI' IN FPR 0.
RETRN1 LM    REGB,REGD,24(13)
       BCR   15,14            RETURN
*
*     V=VNI(0)                RESULT IS NORMALIZED FLOATING POINT VALUE
*                             UNIFORM ON (-1.0,1.0)
       USING VNI,15
VNI    STM   REGB,REGD,24(13) SAVE REGISTERS 1,2,3
RDIGT2 L     REGB,SRGN        LOAD SRGN INTO REGB
       LR    REGC,REGB        AND INTO REGC
       SRL   REGC,15          SHIFT REGC RIGHT 15 BITS
       XR    REGB,REGC        AND XOR INTO REGB
       LR    REGC,REGB        COPY REGB INTO REGC
       SLL   REGC,17          SHIFT IT LEFT 17 BITS,
       XR    REGB,REGC        AND XOR INTO REGB
       ST    REGB,SRGN        SAVE THE NEW 'SRGN'
       L     REGD,MCGN        LOAD MCGN INTO REGD
       M     REGC,MULT        AND MULTIPLY BY 69069
       ST    REGD,MCGN        STORE RESULT,MODULO 2**32, AS NEW 'MCGN'
       XR    REGD,REGB        XOR NEW 'MCGN' AND 'SRGN' IN REGD
       SRA   REGD,7           SHIFT RIGHT 7 BITS PRESERVING SIGN BIT
       N     REGD,SIGN        ZERO OUT LAST 7 BITS  OF FIRST BYTE
       AL    REGD,CHAR        ADD CHARACTERISTIC X'40' TO FIRST BYTE
       ST    REGD,FWD         STORE AT FWD, LOAD INTO FPR 0
       LE    0,FWD            AND ADD NORMALIZED TO ZERO
       AE    0,Z              LEAVING RESULT 'VNI' IN FPR 0.
RETRN2 LM    REGB,REGD,24(13)
       BCR   15,14            RETURN
*      CONSTANTS AND STORAGE RESERVATION
SRGN   DC    F'01073'
MCGN   DC    F'12345'
Z      DC       E'0.0'
FWD    DC       F'0'
CHAR   DC       X'40000000'
SIGN   DC       X'80FFFFFF'
MULT   DC    F'69069'
X68    DC    X'68000000'
PSTWRD DC    X'41AA0000'
NSTWRD DC    X'C1AA0000'
PCHAR  DC    X'3F000000'
FRAC   DC    F'0'
XD0    DC    X'D0000000'
X68R   DC    X'00000068'
XE2F   DC    X'E2F00000'
XCE8   DC    X'00000CE8'
XF5E   DC    X'F5E00000'
XE17   DC    X'00000E17'
ARG    DS    F
SVAREA DS    18F
ARGLST DC    AL4(ARG+X'80000000')
ADNTH  DC    A(RNORTH)
NTBL   DC     1X'00'          TABLE USED FOR NORMAL LOOK-UP
       DC     1X'01'          FIRST PART HAS 104 ELEMENTS
       DC     2X'02'
       DC     4X'03'
       DC     5X'04'
       DC     1X'09'
       DC     5X'0A'
       DC     3X'0E'
       DC     1X'12'
       DC     1X'17'
       DC     5X'00'          START OF SECOND PART OF NORMAL TABLE
       DC     5X'01'          223 ELEMENTS
       DC     4X'02'
       DC     2X'03'
       DC     1X'04'
       DC     5X'05'
       DC     5X'06'
       DC     5X'07'
       DC     5X'08'
       DC     4X'09'
       DC     4X'0B'
       DC     4X'0C'
       DC     4X'0D'
       DC     1X'0E'
       DC     3X'0F'
       DC     3X'10'
       DC     3X'11'
       DC     2X'12'
       DC     2X'13'
       DC     2X'14'
       DC     2X'15'
       DC     2X'16'
       DC     1X'17'
       DC     1X'18'
       DC     1X'19'
       DC     1X'1A'
       DC     1X'1B'
       DC     1X'1C'
       DC     1X'1D'
       DC    10X'05'
       DC     7X'06'
       DC     5X'07'
       DC     2X'08'
       DC     9X'0B'
       DC     5X'0C'
       DC     1X'0D'
       DC    10X'0F'
       DC     7X'10'
       DC     3X'11'
       DC    12X'13'
       DC     9X'14'
       DC     5X'15'
       DC     2X'16'
       DC    13X'18'
       DC    10X'19'
       DC     7X'1A'
       DC     5X'1B'
       DC     2X'1C'
       DC    15X'1E'
       DC    13X'1F'
       DC    12X'20'
       DC    10X'21'
       DC     9X'22'
       DC     8X'23'
       DC     7X'24'
       DC     6X'25'
       DC     5X'26'
       DC     4X'27'
       DC     3X'28'
       DC     3X'29'
       DC     2X'2A'
       DC     2X'2B'
       END
#endif