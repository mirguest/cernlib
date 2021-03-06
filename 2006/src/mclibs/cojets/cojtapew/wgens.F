*
* $Id: wgens.F,v 1.1.1.1 1996/01/11 14:15:03 mclareni Exp $
*
* $Log: wgens.F,v $
* Revision 1.1.1.1  1996/01/11 14:15:03  mclareni
* Cojets
*
*
#include "cojets/pilot.h"
      SUBROUTINE WGENS
C     ****************
C-- ADAPTED FROM ISAJET
C
C          COPY EVENT INFORMATION INTO ZEVEL AND CALL BUFOUT
C          IF NUMBER OF WORDS REQUIRED EXCEEDS MAXLEN-8, THE NUMBER
C          OF RECORDS WRITTEN=NO. OF WORDS/(MAXLEN-8)+1
C
C-- CREATED: 88/05/08
#if defined(CERNLIB_SINGLE)
      IMPLICIT REAL (A-H,O-Z)
#endif
#if defined(CERNLIB_DOUBLE)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
#endif
#include "cojets/event.inc"
#include "cojets/idrun.inc"
#include "cojets/itapes.inc"
#include "cojets/jetpar.inc"
#include "cojets/jetset.inc"
#include "cojets/keys.inc"
#include "cojets/pfirst.inc"
#include "cojets/pinits.inc"
#include "cojets/pjets.inc"
#include "cojets/zevel.inc"
C
C-- START WRITING
      ITA=ABS(ITEVT)
      NJET=2
      IF(ISIGS.EQ.0) NJET=0
C-- 1ST TWO RECORDS
      IZEVEL(1)=100
      IZEVEL(2)=1
      IL=3
C-- /IDRUN/
      CALL MOVLEV(IDVER,IZEVEL(IL),4)
      IL=IL+4
C-- /JETPAR/, ISIGS ONLY
      IZEVEL(IL)=ISIGS
      IL=IL+1
C-- /PRIMAR/, NJET ONLY
      IZEVEL(IL)=NJET
      IL=IL+1
C-- /EVENT/
C          IF ITEVT.LT.0 WRITE ONLY STABLE PARTICLES AND FLAG
C          BY NPTCL=-(NO. OF STABLE PARTICLES)
      NPTCL=NPART
      IF(ITEVT.GT.0) THEN
        IZEVEL(IL)=NPTCL
      ELSE
        NPSTA=0
        IF(NPTCL.EQ.0) GO TO 991
        DO 990 I=1,NPTCL
990     IF(IDCAY(I).EQ.0) NPSTA=NPSTA+1
991     CONTINUE
        IZEVEL(IL)=-NPSTA
      ENDIF
      IL=IL+1
C
      IF(ISIGS.GT.0) THEN
C-- /PFIRST/
        CALL MOVLEV(PFIRST,ZEVEL(IL),12)
        IL=IL+12
C-- /PINITS/
        CALL MOVLEV(PINITS,ZEVEL(IL),12)
        IL=IL+12
      ENDIF
      IF(NJET.GT.0) THEN
C-- /JETPAR/
        CALL MOVLEV(P,ZEVEL(IL),46)
        IL=IL+46
        CALL MOVLEV(INITYP,IZEVEL(IL),4)
        IL=IL+4
        CALL MOVLEV(PBEAMS,ZEVEL(IL),5)
        IL=IL+5
C-- /PJETS/
        IEX=NJET*5
        CALL MOVLEV(PJETS,IZEVEL(IL),IEX)
        IL=IL+IEX
        CALL MOVLEV(IDJETS,IZEVEL(IL),NJET)
        IL=IL+NJET
      ENDIF
      IF(KEYS(3)) THEN
C-- /PJETS/
        CALL MOVLEV(QWJET,IZEVEL(IL),6)
        IL=IL+6
C-- /JETPAR/
        CALL MOVLEV(QMW,IZEVEL(IL),16)
        IL=IL+16
      ELSEIF(KEYS(6)) THEN
C-- /PJETS/, W PAIRS
        IZEVEL(IL)=NPAIR
        IL=IL+1
        CALL MOVLEV(PPAIR(1,1),ZEVEL(IL),5*NPAIR)
        IL=IL+5*NPAIR
        CALL MOVLEV(IDPAIR(1),IZEVEL(IL),NPAIR)
        IL=IL+NPAIR
        CALL MOVLEV(JPAIR(1),IZEVEL(IL),NPAIR)
        IL=IL+NPAIR
      ENDIF
C-- /JETSET/
      IZEVEL(IL)=NJSET
      IL=IL+1
      IF(NJSET.LT.1) GOTO 12
      DO 50 I=1,NJSET
      CALL MOVLEV(PJSET(1,I),ZEVEL(IL),5)
      IL=IL+5
      IZEVEL(IL)=JORIG(I)
      IZEVEL(IL+1)=JTYPE(I)
      IZEVEL(IL+2)=JDCAY(I)
      IL=IL+3
      IF(IL.LE.MAXLEN-9) GO TO 50
      IZEVEL(1)=IZEVEL(1)+1
      CALL BUFOUT(IL)
      IF(I.EQ.NJSET) GO TO 12
50    CONTINUE
C
C-- /EVENT/
C          IF ITEVT.LT.0, WRITE OUT ONLY STABLE PARTICLES
C          FLAG BY NPTCL=-(NO. OF STABLE PARTICLES)
C          SUPPRESS ORIGIN AND DECAY INFORMATION
12    IF(NPTCL.EQ.0) GOTO 999
C
      IF(ITEVT.GT.0) GOTO 997
C          ONLY STABLE PARTICLES
      DO 992 K=1,NPTCL
      IF(IDCAY(K).NE.0) GOTO 992
      JET=ABS(IORIG(K))/IPACK
      DO 995 J=1,5
995   ZEVEL(IL+J-1)=PARHAD(K,J)
      IZEVEL(IL+5)=IORIG(K)
      IZEVEL(IL+6)=IDENT(K)
      IL=IL+7
      IF(IL.LE.MAXLEN-7) GOTO 992
      IZEVEL(1)=IZEVEL(1)+1
      CALL BUFOUT(IL)
      IF(K.EQ.NPTCL) RETURN
  992 CONTINUE
      GOTO 999
  997 CONTINUE
C          ALL PARTICLES
C          NOTE IDCAY CAN EXCEED 2**24 LIMIT OF PAIRPAK
      DO 998 K=1,NPTCL
      DO 996 J=1,5
996   ZEVEL(IL+J-1)=PARHAD(K,J)
      IZEVEL(IL+5)=IORIG(K)
      IZEVEL(IL+6)=IDENT(K)
      IZEVEL(IL+7)=IDCAY(K)/IPACK
      IZEVEL(IL+8)=MOD(IDCAY(K),IPACK)
      IL=IL+9
      IF(IL.LE.MAXLEN-9) GOTO 998
      IZEVEL(1)=IZEVEL(1)+1
      CALL BUFOUT(IL)
      IF(K.EQ.NPTCL) RETURN
  998 CONTINUE
  999 CONTINUE
      IZEVEL(1)=IZEVEL(1)+1
      CALL BUFOUT(IL)
      RETURN
      END
