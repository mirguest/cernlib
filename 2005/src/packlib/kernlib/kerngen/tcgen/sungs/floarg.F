*
* $Id: floarg.F,v 1.1.1.1 1996/02/15 17:49:58 mclareni Exp $
*
* $Log: floarg.F,v $
* Revision 1.1.1.1  1996/02/15 17:49:58  mclareni
* Kernlib
*
*
      FUNCTION FLOARG (ARGM)
C
C CERN PROGLIB# M250    FLOARG          .VERSION KERNSUN  1.00  880922
C ORIG. 22/09/88, JZ
C
C
      DIMENSION    ARGM(9)
      EQUIVALENCE  (A,IA)
C
C
      A   = ARGM(1)
      JCH = RSHIFT (IA,23)
      IF (JCH.EQ.0)          GO TO 36
      IF (JCH.EQ.-1)         GO TO 36
      FLOARG = A
      RETURN
C
   36 FLOARG = IA
      RETURN
      END
