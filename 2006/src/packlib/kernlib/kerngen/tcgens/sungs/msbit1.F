*
* $Id: msbit1.F,v 1.1.1.1 1996/02/15 17:50:21 mclareni Exp $
*
* $Log: msbit1.F,v $
* Revision 1.1.1.1  1996/02/15 17:50:21  mclareni
* Kernlib
*
*
      FUNCTION MSBIT1 (IZW,IZP)
C
C CERN PROGLIB# M421    MSBIT1          .VERSION KERNSUN  1.00  880922
C ORIG. 22/09/88, JZ
C
      MSBIT1 = OR (IZW, LSHIFT(1,IZP-1))
      RETURN
      END
