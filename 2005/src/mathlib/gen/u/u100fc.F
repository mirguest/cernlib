*
* $Id: u100fc.F,v 1.1.1.1 1996/04/01 15:01:45 mclareni Exp $
*
* $Log: u100fc.F,v $
* Revision 1.1.1.1  1996/04/01 15:01:45  mclareni
* Mathlib gen
*
*
#include "gen/pilot.h"
      SUBROUTINE U100FC (I,K)
      DIMENSION K(40), L(40)
      CALL VZERO (K, 40)
      IF(I)  4,3,2
    4 K(1)=-77
      RETURN
    2 DO 5  JK=1,I
      CALL U100PR(JK,L,M)
      DO 5 JM=1,40
    5 K(JM)=K(JM)+L(JM)
    3 RETURN
      END
