*
* $Id: prtevt.F,v 1.1.1.1 1996/01/11 14:15:04 mclareni Exp $
*
* $Log: prtevt.F,v $
* Revision 1.1.1.1  1996/01/11 14:15:04  mclareni
* Cojets
*
*
#include "cojets/pilot.h"
      SUBROUTINE PRTEVT(IPRT)
C     ***********************
C-- ADAPTED FROM ISAJET
C
C          PRINT THE EVENT STORED IN /PJETS/, /JETSET/, AND /PARTCL/
C          IPRT=0 ALWAYS PRINTS EVENT
C          IPRT<0 PRINTS ONLY JET PARAMETERS
C
C-- CREATED: 88/05/08
#include "cojets/idrun.inc"
#include "cojets/itapes.inc"
#include "cojets/jetpar.inc"
#include "cojets/jetset.inc"
#include "cojets/keys.inc"
#include "cojets/partcl.inc"
#include "cojets/pfirst.inc"
#include "cojets/pinits.inc"
#include "cojets/pjets.inc"
#include "cojets/primar.inc"
C
C          LABELS ARE CHARACTER*8
      CHARACTER*8 LABEL,LW,LJET,LPTCL,LFIRST,LACTV
C
C          INITIALIZE PI
      DATA ICALL/0/
      IF(ICALL.GT.0) GO TO 9
      ICALL=1
      PI=4.*ATAN(1.)
9     CONTINUE
C
C          PRINT EVENT NUMBER
      WRITE(ITLIS,1) IEVT
1     FORMAT(/////1X,10HEVENT NO.  ,I8/1X,18(1H*)///)
C
C          PRINT RUN ID, REAC, SUBPROCESS CODE
      WRITE(ITLIS,10) IDG,REAC,ISIGS
10    FORMAT(/5X,'RUN ID',2I10,5X,A8,5X,'SUBPROCESS CODE',I5)
C
C          PRINT PARTONS ORIGINATING INITIAL SHOWERS
      IF(ISIGS.EQ.0) GO TO 300
      WRITE(ITLIS,80)
80    FORMAT(//20X,'PARTONS ORIGINATING INITIAL SHOWERS'//
     *10X,'TYPE ',7X,'ID',8X,'PX',8X,'PY',8X,'PZ',8X,'P0',9X,'X')
      DO 81 I=1,2
      LFIRST=LABEL(IDFRST(I))
      IF(I.EQ.1) X=XI1
      IF(I.EQ.2) X=XI2
      WRITE(ITLIS,82) I,LFIRST,IDFRST(I),(PFIRST(K,I),K=1,4),X
82    FORMAT(1X,I5,4X,A5,4X,I5,5F10.2)
81    CONTINUE
C
C          PRINT PARTONS ENTERING THE SUBPROCESS
      WRITE(ITLIS,90)
90    FORMAT(//20X,'PARTONS ENTERING THE SUBPROCESS'//
     *10X,'TYPE ',7X,'ID',8X,'PX',8X,'PY',8X,'PZ',8X,'P0',9X,'X')
      DO 91 I=1,2
      LACTV=LABEL(IDINIT(I))
      IF(I.EQ.1) X=X1
      IF(I.EQ.2) X=X2
      WRITE(ITLIS,92) I,LACTV,IDINIT(I),(PINITS(K,I),K=1,4),X
92    FORMAT(1X,I5,4X,A5,4X,I5,5F10.2)
91    CONTINUE
C
C          PRINT JET PARAMETERS
      IF(NJET.EQ.0) GO TO 300
      WRITE(ITLIS,20)
20    FORMAT(//20X,'JET PARAMETERS'//3X,'JET',4X,'TYPE ',7X,'ID',
     18X,'PX',8X,'PY',8X,'PZ',8X,'P0',8X,'PT',
     25X,'THETA',7X,'PHI',9X,'X',9X,'Y')
      IF(KEYS(3)) THEN
        LW=LABEL(IDENTW)
        WRITE(ITLIS,31) LW,IDENTW,(QWJET(K),K=1,4),QTW,THW,PHIW,XW,YW
31      FORMAT(5X,'W',4X,A5,4X,I5,5F10.2,4F10.4)
      ENDIF
      DO 100 I=1,NJET
      LJET=LABEL(IDJETS(I))
      WRITE(ITLIS,30) I,LJET,IDJETS(I),(PJETS(K,I),K=1,4),PT(I),TH(I),
     $PHI(I),XJ(I),YJ(I)
30    FORMAT(1X,I5,4X,A5,4X,I5,5F10.2,4F10.4)
100   CONTINUE
      IF(IPRT.LT.0) RETURN
C
C          PRINT /JETSET/ PARAMETERS
      IF(KEYS(4)) GO TO 300
      IF(NJSET.EQ.0) GO TO 300
      WRITE(ITLIS,70)
70    FORMAT(//20X,'PARTON CASCADE PARAMETERS'//
     C  6X,'I',3X,'JET',4X,'ORIG',4X,'TYPE',7X,'ID',9X,'DECAY',
     C  8X,'PX',8X,'PY',8X,'PZ',8X,'P0',6X,'MASS')
      DO 310 I=1,NJSET
      JET=ABS(JORIG(I))/JPACK
      I1=MOD(JORIG(I),JPACK)
      JTLV1=JTYPE(I)
      LJET=LABEL(JTLV1)
      J1=JDCAY(I)/JPACK
      J2=MOD(JDCAY(I),JPACK)
      IF(JDCAY(I).EQ.0) THEN
        WRITE(ITLIS,71) I,JET,I1,LJET,JTLV1,(PJSET(K,I),K=1,5)
71      FORMAT(1X,I6,I6,I8,4X,A5,4X,I5,8X,'FINAL',5F10.2)
      ELSE
        WRITE(ITLIS,72) I,JET,I1,LJET,JTLV1,J1,J2,(PJSET(K,I),K=1,5)
72      FORMAT(1X,I6,I6,I8,4X,A5,4X,I5,4X,I4,'-',I4,5F10.2)
      ENDIF
310   CONTINUE
      WRITE(ITLIS,73)
73    FORMAT(/1X,'NOTE: FOR SPACELIKE PARTONS, IDENTIFIED BY'
     1,' NEGATIVE MASSES, THE MASS REPRESENTS ONLY THE PARTON'
     2,' VIRTUALITY.'
     3/1X,'P0-PL, WHERE PL IS THE LONGITUDINAL MOMENTUM'
     4,' ALONG THE BEAM DIRECTION, IS DEFINED FOR THEM AS:'
     5/20X,'P0-PL=(PX**2+PY**2)/(P0+PL)')
C
C          PRINT HADRON PARAMETERS
300   IF(NPTCL.EQ.0) RETURN
      WRITE(ITLIS,40)
40    FORMAT(//20X,'HADRON PARAMETERS'//7X,'I',3X,'JET',5X,'ORIG'
     C  ,5X,'TYPE',7X,'ID',10X,'DECAY',8X,'PX',8X,'PY',8X,'PZ',8X,'P0'
     C  ,8X,'PT',5X,'THETA',7X,'PHI')
      DO 200 I=1,NPTCL
      I1=ABS(IORIG(I))
      JET=I1/IPACK
      I1=I1-IPACK*JET
      I1=SIGN(I1,IORIG(I))
      IDLV1=IDENT(I)
      LPTCL=LABEL(IDLV1)
      J1=IDCAY(I)/IPACK
      J2=MOD(IDCAY(I),IPACK)
      PTHAD=SQRT(PPTCL(1,I)**2+PPTCL(2,I)**2)
      PHAD=SQRT(PPTCL(3,I)**2+PTHAD**2)
      IF(PHAD.EQ.0.) THEN
        THHAD=0.
      ELSE
        THHAD=ACOS(PPTCL(3,I)/PHAD)
      ENDIF
      IF(PPTCL(2,I).EQ.0..AND.PPTCL(1,I).EQ.0.) THEN
        PHIHAD=0.
      ELSE
        PHIHAD=ATAN2(PPTCL(2,I),PPTCL(1,I))
      ENDIF
      IF(PHIHAD.LT.0.) PHIHAD=2.*PI+PHIHAD
      IF(IDCAY(I).EQ.0) THEN
        WRITE(ITLIS,50) I,JET,I1,LPTCL,IDLV1,(PPTCL(K,I),K=1,4),PTHAD,
     $  THHAD,PHIHAD
50      FORMAT(1X,I7,I6,I9,4X,A5,4X,I5,9X,'STABLE',5F10.2,2F10.4)
      ELSE
        WRITE(ITLIS,60) I,JET,I1,LPTCL,IDLV1,J1,J2,(PPTCL(K,I),K=1,4),
     $  PTHAD,THHAD,PHIHAD
60      FORMAT(1X,I7,I6,I9,4X,A5,4X,I5,4X,I5,'-',I5,5F10.2,2F10.4)
      ENDIF
200   CONTINUE
      RETURN
      END
