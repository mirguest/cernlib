      SUBROUTINE ZHTOI (HOLL,INTV,NP)

#include "zebra/zceta.inc"
C--------------    END CDE                             --------------
      INTEGER      INTV(99), HOLL(99)


      DO 39  JWH=1,NP
      MWH  = ISHFT (HOLL(JWH), -8)
      INTW = 0

      DO 29  JL=1,4
      INTW = ISHFT (INTW,6)
      JV   = IAND (MWH,127)
      IF (JV.EQ.32)  THEN
          IF (JL.NE.4)             GO TO 29
        ENDIF
      INTW = IOR (INTW, IQTCET(JV+1))
   29 MWH  = ISHFT (MWH,-7)

   39 INTV(JWH) = INTW
      RETURN
      END
