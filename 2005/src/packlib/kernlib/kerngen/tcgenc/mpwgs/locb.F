*
* $Id: locb.F,v 1.1.1.1 1996/02/15 17:50:40 mclareni Exp $
*
* $Log: locb.F,v $
* Revision 1.1.1.1  1996/02/15 17:50:40  mclareni
* Kernlib
*
*
      FUNCTION LOCB (AM)
C
C CERN PROGLIB# N101    LOCB            .VERSION KERNMPW  1.00  891208
C ORIG. 13/12/83  F.Carminati
C
      DIMENSION AM(*)
 
      LOCB= %LOC (AM(1))
      END
