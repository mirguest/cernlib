*
* $Id: hwuinc.F,v 1.1.1.1 1996/03/08 17:02:17 mclareni Exp $
*
* $Log: hwuinc.F,v $
* Revision 1.1.1.1  1996/03/08 17:02:17  mclareni
* Herwig58
*
*
*CMZ :          29/08/94  11.51.48  by  Unknown
*-- Author :
CDECK  ID>, HWUINC.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C------------------------------------------------------------------------
      SUBROUTINE HWUINC
C     COMPUTES CONSTANTS AND LOOKUP TABLES
C-----------------------------------------------------------------------
#include "herwig58/herwig58.inc"
      INTEGER ISTOP,I,J,IQK,IDB,IDT
      DOUBLE PRECISION HWBVMC,HWUALF,HWUPCM,XMIN,XMAX,XPOW,QR,DQKWT,
     & UQKWT,SQKWT,DIQWT,QMAX,PMAX,PTLIM,ETLIM,PGS,PTELM
      COMMON/HWRPIN/XMIN,XMAX,XPOW,FIRST
      COMMON/W50516/FSTPDF
      LOGICAL FIRST,FSTPDF
      DOUBLE PRECISION X,QSCA,UPV,DNV,USEA,DSEA,STR,CHM,BTM,TOP,GLU
      CHARACTER*20 PARM(20)
      DOUBLE PRECISION VAL(20)
      IPRO=MOD(IPROC/100,100)
      IQK=MOD(IPROC,100)
C---SET UP BEAMS
      CALL HWUIDT(3,IDB,IPART1,PART1)
      CALL HWUIDT(3,IDT,IPART2,PART2)
      EBEAM1=SQRT(PBEAM1**2+RMASS(IPART1)**2)
      EBEAM2=SQRT(PBEAM2**2+RMASS(IPART2)**2)
C---PHOTON CUTOFF DEFAULTS TO ROOT S
      PTLIM=SQRT(HALF*(EBEAM1*EBEAM2+PBEAM1*PBEAM2))
      ETLIM=TWO*PTLIM
      IF (VPCUT.GT.ETLIM) VPCUT=ETLIM
      IF (Q2MAX.GT.ETLIM**2) Q2MAX=ETLIM**2
C---PRINT OUT MOST IMPORTANT INPUT PARAMETERS
      IF (IPRINT.EQ.0) GO TO 30
      WRITE (6,10) PART1,PBEAM1,PART2,PBEAM2,IPROC,NFLAV,NSTRU,
     & AZSPIN,AZSOFT,QCDLAM,(RMASS(I),I=1,6),RMASS(13)
      IF (ISPAC.LE.1) THEN
        WRITE (6,20) VQCUT,VGCUT,VPCUT,CLMAX,QSPAC,PTRMS
      ELSE
        WRITE (6,21) VQCUT,VGCUT,VPCUT,CLMAX,QSPAC,PTRMS
      ENDIF
      IF (NOSPAC) WRITE (6,22)
  10  FORMAT(/10X,'INPUT CONDITIONS FOR THIS RUN'//
     &10X,'BEAM 1 (',A4,') MOMENTUM =',F10.2/
     &10X,'BEAM 2 (',A4,') MOMENTUM =',F10.2/
     &10X,'PROCESS CODE (IPROC)   =',I8/
     &10X,'NUMBER OF FLAVOURS     =',I5/
     &10X,'STRUCTURE FUNCTION SET =',I5/
     &10X,'AZIM SPIN CORRELATIONS =',L5/
     &10X,'AZIM SOFT CORRELATIONS =',L5/
     &10X,'QCD LAMBDA (GEV)       =',F10.4/
     &10X,'DOWN     QUARK  MASS   =',F10.4/
     &10X,'UP       QUARK  MASS   =',F10.4/
     &10X,'STRANGE  QUARK  MASS   =',F10.4/
     &10X,'CHARMED  QUARK  MASS   =',F10.4/
     &10X,'BOTTOM   QUARK  MASS   =',F10.4/
     &10X,'TOP      QUARK  MASS   =',F10.4/
     &10X,'GLUON EFFECTIVE MASS   =',F10.4)
  20  FORMAT(10X,'EXTRA SHOWER CUTOFF (Q)=',F10.4/
     &10X,'EXTRA SHOWER CUTOFF (G)=',F10.4/
     &10X,'PHOTON SHOWER CUTOFF   =',F10.4/
     &10X,'CLUSTER MASS PARAMETER =',F10.4/
     &10X,'SPACELIKE EVOLN CUTOFF =',F10.4/
     &10X,'INTRINSIC P-TRAN (RMS) =',F10.4)
  21  FORMAT(10X,'EXTRA SHOWER CUTOFF (Q)=',F10.4/
     &10X,'EXTRA SHOWER CUTOFF (G)=',F10.4/
     &10X,'PHOTON SHOWER CUTOFF   =',F10.4/
     &10X,'CLUSTER MASS PARAMETER =',F10.4/
     &10X,'PDF FREEZING CUTOFF    =',F10.4/
     &10X,'INTRINSIC P-TRAN (RMS) =',F10.4)
  22  FORMAT(10X,'NO SPACE-LIKE SHOWERS')
  30  ISTOP=0
C---INITIALIZE ALPHA-STRONG
      IF ( QLIM.GT.ETLIM)  QLIM=ETLIM
      QR=HWUALF(0,QLIM)
C---DO SOME SAFETY CHECKS ON INPUT PARAMETERS
C Check beam order for point-like photon/QCD processes
      IF (IPRO.GE.50.AND.IPRO.LE.59.AND.
     &     IDB.NE.22.AND.ABS(IDB).NE.11.AND.ABS(IDB).NE.13) THEN
         WRITE(6,40)
  40     FORMAT(1X,'WARNING: require FIRST beam to be a photon/lepton')
         ISTOP=ISTOP+1
      ENDIF
      QG=HWBVMC(13)
      QR=QG/QCDL3
      IF (QR.GE.2.01) GO TO 60
      WRITE (6,50) QG,QCDLAM,QCDL3
  50  FORMAT(//10X,'SHOWER GLUON VIRTUAL MASS CUTOFF =',F8.5/
     &         10X,'TOO SMALL RELATIVE TO QCD LAMBDA =',F8.5/
     &         10X,'CORRESPONDS TO  3-FLAV MC LAMBDA =',F8.5)
      ISTOP=ISTOP+1
  60   QV=MIN(HWBVMC(1),HWBVMC(2))
      IF (QV.GE.QG/(QR-1.)) GO TO 80
      ISTOP=ISTOP+1
      WRITE (6,70) QV,QCDLAM,QCDL3
  70  FORMAT(//10X,'SHOWER QUARK VIRTUAL MASS CUTOFF =',F8.5/
     &         10X,'TOO SMALL RELATIVE TO QCD LAMBDA =',F8.5/
     &         10X,'CORRESPONDS TO  3-FLAV MC LAMBDA =',F8.5)
  80  IF (ISTOP.NE.0) THEN
        WRITE (6,90) ISTOP
  90    FORMAT(//10X,'EXECUTION PREVENTED BY',I2,
     &  ' ERRORS IN INPUT PARAMETERS.')
        STOP
      ENDIF
      DO 100 I=1,6
  100 RMASS(I+6)=RMASS(I)
      RMASS(199)=RMASS(198)
C---A PRIORI WEIGHTS FOR QUARK AND DIQUARKS
      DQKWT=PWT(1)
      UQKWT=PWT(2)
      SQKWT=PWT(3)
      DIQWT=PWT(7)
      PWT(10)=PWT(4)
      PWT(11)=PWT(5)
      PWT(12)=PWT(6)
C
      PWT(4)=UQKWT*UQKWT*DIQWT
      PWT(5)=UQKWT*DQKWT*DIQWT*.5
      PWT(6)=DQKWT*DQKWT*DIQWT
      PWT(7)=UQKWT*SQKWT*DIQWT*.5
      PWT(8)=DQKWT*SQKWT*DIQWT*.5
      PWT(9)=SQKWT*SQKWT*DIQWT
      QMAX=MAX(PWT(1),PWT(2),PWT(3))
      PMAX=MAX(PWT(4),PWT(5),PWT(6),PWT(7),PWT(8),PWT(9),
     &PWT(10),PWT(11),PWT(12),QMAX)
      PMAX=1./PMAX
      QMAX=1./QMAX
      DO 110 I=1,3
  110 QWT(I)=PWT(I)*QMAX
      DO 120 I=1,12
  120 PWT(I)=PWT(I)*PMAX
C  MASSES OF DIQUARKS (ASSUME BINDING NEGLIGIBLE)
      RMASS(109)=RMASS(2)+RMASS(2)
      RMASS(110)=RMASS(1)+RMASS(2)
      RMASS(111)=RMASS(1)+RMASS(1)
      RMASS(112)=RMASS(2)+RMASS(3)
      RMASS(113)=RMASS(1)+RMASS(3)
      RMASS(114)=RMASS(3)+RMASS(3)
      DO 130 I=109,114
  130 RMASS(I+6)=RMASS(I)
C  MASSES OF TOP HADRONS (ASSUME BINDING NEGLIGIBLE)
      RMASS(232)=RMASS(6)+RMASS(5)
      RMASS(233)=RMASS(6)+RMASS(1)
      RMASS(234)=RMASS(6)+RMASS(2)
      RMASS(235)=RMASS(6)+RMASS(3)
      RMASS(236)=RMASS(6)+RMASS(2)+RMASS(2)
      RMASS(237)=RMASS(6)+RMASS(1)+RMASS(2)
      RMASS(238)=RMASS(6)+RMASS(1)+RMASS(1)
      RMASS(239)=RMASS(6)+RMASS(2)+RMASS(3)
      RMASS(240)=RMASS(6)+RMASS(1)+RMASS(3)
      RMASS(241)=RMASS(6)+RMASS(3)+RMASS(3)
      RMASS(242)=RMASS(6)+RMASS(4)
      RMASS(243)=RMASS(6)+RMASS(5)
      RMASS(244)=RMASS(6)+RMASS(6)
      RMASS(232)=RMASS(243)
      DO 140 I=233,242
  140 RMASS(I+22)=RMASS(I)
C---COMPUTE PARTICLE PROPERTIES FOR HADRONIZATION
      CALL HWURES
C---IMPORTANCE SAMPLING
      FIRST=.TRUE.
      IF (IPRO.EQ.5) THEN
        IF (EMMAX.GT.ETLIM)  EMMAX=ETLIM
        IF (PTMAX.GT.PTLIM)  PTMAX=PTLIM
      ELSEIF (IPRO.EQ.13) THEN
        IF (EMMIN.EQ.0)      EMMIN=10
        IF (EMMAX.GT.ETLIM)  EMMAX=ETLIM
        XMIN=EMMIN
        XMAX=EMMAX
        XPOW=-EMPOW
      ELSEIF (IPRO.EQ.15.OR.IPRO.EQ.17.OR.IPRO.EQ.18.OR.IPRO.EQ.21
     &    .OR.IPRO.EQ.22.OR.IPRO.EQ.23.OR.IPRO.EQ.50.OR.IPRO.EQ.51
     &    .OR.IPRO.EQ.55) THEN
        IF (PTMAX.GT.PTLIM)  PTMAX=PTLIM
        IF (IQK.NE.0.AND.IQK.LT.7.AND.IPRO.NE.23) THEN
          XMIN=2.*SQRT(PTMIN**2+RMASS(IQK)**2)
          XMAX=2.*SQRT(PTMAX**2+RMASS(IQK)**2)
          IF (XMAX.GT.ETLIM)  XMAX=ETLIM
        ELSE
          XMIN=2.*PTMIN
          XMAX=2.*PTMAX
        ENDIF
        XPOW=-PTPOW
      ELSEIF (IPRO.EQ.52) THEN
         PTELM=PTLIM-RMASS(IQK)**2/(4.*PTLIM)
         IF (PTMAX.GT.PTELM) PTMAX=PTELM
         XMIN=PTMIN
         XMAX=PTMAX
         XPOW=-PTPOW
      ELSEIF (IPRO.EQ.90) THEN
        XMIN=SQRT(Q2MIN)
        XMAX=SQRT(Q2MAX)
        XPOW=1.-2.*Q2POW
      ELSEIF (IPRO.EQ.91) THEN
        IF (EMMAX.GT.ETLIM) EMMAX=ETLIM
      ENDIF
C---CALCULATE HIGGS WIDTH
      IF (IPRO.EQ. 3.OR.IPRO.EQ. 4.OR.IPRO.EQ.16.OR.IPRO.EQ.19
     &.OR.IPRO.EQ.23.OR.IPRO.EQ.95) THEN
        GAMH=RMASS(201)
        CALL HWDHIG(GAMH)
      ENDIF
      IF (IPRINT.NE.0) THEN
        IF (PBEAM1.NE.PBEAM2) WRITE (6,145) USECMF
        IF (IPRO.EQ.91.OR.IPRO.EQ.92)
     &      WRITE (6,150) PTMIN
        IF (IPRO.EQ.90.OR.(IPRO.EQ.91.AND.IQK.NE.7).OR.IPRO.EQ.92)
     &      WRITE (6,160) Q2MIN,Q2MAX,BREIT
        IF (IPRO.EQ.90) WRITE (6,162) YBMIN,YBMAX
        IF (IPRO.EQ.91.AND.IQK.EQ.7)
     &      WRITE (6,165) Q2WWMN,Q2WWMX,BREIT,ZJMAX
        IF (IPROC/10.EQ.11) WRITE (6,170) THMAX
        IF (IPRO.EQ.13) WRITE (6,180) EMMIN,EMMAX
        IF (IPRO.EQ.15.OR.IPRO.EQ.17.OR.IPRO.EQ.18.OR.IPRO.EQ.21
     &  .OR.IPRO.EQ.22.OR.IPRO.EQ.23.OR.IPRO.EQ.50.OR.IPRO.EQ.51
     &  .OR.IPRO.EQ.52.OR.IPRO.EQ.55)
     &      WRITE (6,190) PTMIN,PTMAX
        IF (IPRO.EQ. 3.OR.IPRO.EQ. 4.OR.IPRO.EQ.16.OR.IPRO.EQ.19
     &  .OR.IPRO.EQ.23.OR.IPRO.EQ.95)
     &      WRITE (6,200) RMASS(201),GAMH,
     &      GAMMAX,RMASS(201)+GAMMAX*GAMH,(BRHIG(I)*100,I=1,12)
        IF (IPRO.EQ.91) WRITE (6,210) BGSHAT,EMMIN,EMMAX
        IF (IPRO.EQ.5.AND.IQK.LT.50)
     &      WRITE (6,220) EMMIN,EMMAX,PTMIN,PTMAX,CTMAX
        IF (IPRO.EQ.5.AND.IQK.GE.50)
     &      WRITE (6,230) EMMIN,EMMAX,Q2MIN,Q2MAX,PTMIN
        IF (IPRO.GT.10.AND.
     &    (IPRO.LT.90.AND.(ABS(IDB).EQ.11.OR.ABS(IDB).EQ.13).OR.
     &                    (ABS(IDT).EQ.11.OR.ABS(IDT).EQ.13))) THEN
          WRITE (6,235) Q2WWMN,Q2WWMX,YBMIN,YBMAX
          IF (PHOMAS.GT.ZERO) WRITE (6,236) PHOMAS
        ENDIF
        IF (IPROC/10.EQ.10.OR.IPRO.EQ.90)
     &      WRITE (6,237) HARDME,SOFTME
  145   FORMAT(10X,'USE BEAM-TARGET C.M.F. =',L5)
  150   FORMAT(10X,'MIN P-T FOR O(AS) DILS =',F10.4)
  160   FORMAT(10X,'MIN ABS(Q**2) FOR DILS =',E10.4/
     &         10X,'MAX ABS(Q**2) FOR DILS =',E10.4/
     &         10X,'BREIT FRAME SHOWERING  =',L5)
  162   FORMAT(10X,'MIN BJORKEN Y FOR DILS =',F10.4/
     &         10X,'MAX BJORKEN Y FOR DILS =',F10.4)
  165   FORMAT(10X,'MIN ABS(Q**2) FOR J/PSI=',E10.4/
     &         10X,'MAX ABS(Q**2) FOR J/PSI=',E10.4/
     &         10X,'BREIT FRAME SHOWERING  =',L5/
     &         10X,'MAX Z FOR J/PSI        =',F10.4)
  170   FORMAT(10X,'MAX THRUST FOR 2->3    =',F10.4)
  180   FORMAT(10X,'MIN MASS FOR DRELL-YAN =',F10.4/
     &         10X,'MAX MASS FOR DRELL-YAN =',F10.4)
  190   FORMAT(10X,'MIN P-TRAN FOR 2->2    =',F10.4/
     &         10X,'MAX P-TRAN FOR 2->2    =',F10.4)
  200   FORMAT(10X,'HIGGS BOSON MASS       =',F10.4/
     &         10X,'HIGGS BOSON WIDTH      =',F10.4/
     &         10X,'CUTOFF = EMH +',F4.1,'*GAMH=',F10.4/
     &         10X,'HIGGS          D DBAR  =',F10.4/
     &         10X,'BRANCHING      U UBAR  =',F10.4/
     &         10X,'FRACTIONS      S SBAR  =',F10.4/
     &         10X,'(PER CENT)     C CBAR  =',F10.4/
     &         10X,'               B BBAR  =',F10.4/
     &         10X,'               T TBAR  =',F10.4/
     &         10X,'              E+ E-    =',F10.4/
     &         10X,'             MU+ MU-   =',F10.4/
     &         10X,'            TAU+ TAU-  =',F10.4/
     &         10X,'               W W     =',F10.4/
     &         10X,'               Z Z     =',F10.4/
     &         10X,'           GAMMA GAMMA =',F10.4)
  210   FORMAT(10X,'SCALE FOR BGF IS S-HAT =',L5/
     &         10X,'MIN MASS FOR BGF       =',F10.4/
     &         10X,'MAX MASS FOR BGF       =',F10.4)
  220   FORMAT(10X,'MIN MASS FOR 2 PHOTONS =',F10.4/
     &         10X,'MAX MASS FOR 2 PHOTONS =',F10.4/
     &         10X,'MIN PT OF 2 PHOTON CMF =',F10.4/
     &         10X,'MAX PT OF 2 PHOTON CMF =',F10.4/
     &         10X,'MAX COS THETA IN CMF   =',F10.4)
  230   FORMAT(10X,'MIN MASS FOR GAMMA + W =',F10.4/
     &         10X,'MAX MASS FOR GAMMA + W =',F10.4/
     &         10X,'MIN ABS(Q**2)          =',E10.4/
     &         10X,'MAX ABS(Q**2)          =',E10.4/
     &         10X,'MIN PT                 =',F10.4)
  235   FORMAT(10X,'MIN Q**2 FOR WW PHOTON =',F10.4/
     &         10X,'MAX Q**2 FOR WW PHOTON =',F10.4/
     &         10X,'MIN MOMENTUM FRACTION  =',F10.4/
     &         10X,'MAX MOMENTUM FRACTION  =',F10.4)
  236   FORMAT(10X,'GAMMA* S.F. MASS PARAM =',F10.4)
  237   FORMAT(10X,'HARD M.E. MATCHING     =',L5/
     &         10X,'SOFT M.E. MATCHING     =',L5)
        IF (LWEVT.LE.0) THEN
          WRITE (6,240)
        ELSE
          WRITE (6,250) LWEVT
        ENDIF
  240   FORMAT(/10X,'NO EVENTS WILL BE WRITTEN TO DISK')
  250   FORMAT(/10X,'EVENTS WILL BE OUTPUT ON UNIT',I4)
      ENDIF
C Verify and print beam polarisations
      IF (IPRO.EQ.1.OR.IPRO.EQ.3) THEN
C Set up transverse polarisation parameters for e+e-
         IF ((EPOLN(1)**2+EPOLN(2)**2)
     &      *(PPOLN(1)**2+PPOLN(2)**2).GT.0.) THEN
            TPOL=.TRUE.
            COSS=EPOLN(1)*PPOLN(1)-EPOLN(2)*PPOLN(2)
            SINS=EPOLN(2)*PPOLN(1)+EPOLN(1)*PPOLN(2)
         ELSE
            TPOL=.FALSE.
         ENDIF
C print out lepton beam polarisation(s)
         IF (IPRINT.NE.0) THEN
            IF (IPART1.EQ.121) THEN
               WRITE (6,260) PART1,EPOLN,PART2,PPOLN
            ELSE
               WRITE (6,260) PART1,PPOLN,PART2,EPOLN
            ENDIF
 260        FORMAT(10X,A4,'Beam polarisation=',3F10.4/
     &             10X,A4,'Beam polarisation=',3F10.4)
         ENDIF
      ELSEIF (IPRO.GE.90.AND.IPRO.LE.99) THEN
         IF (IDB.GE.11.AND.IDB.LE.16) THEN
            CALL HWVZRO(3,PPOLN)
C Check neutrino polarisations for DIS
            IF (IDB.EQ. 12.OR.IDB.EQ. 14.OR.IDB.EQ. 16.AND.
     &          EPOLN(3).NE.-1.) EPOLN(3)=-1.
            IF (IPRINT.NE.0) WRITE(6,270) PART1,EPOLN(3)
         ELSE
            CALL HWVZRO(3,EPOLN)
C Check anti-neutrino polarisations for DIS
            IF (IDB.EQ.-12.OR.IDB.EQ.-14.OR.IDB.EQ.-16.AND.
     &          PPOLN(3).NE. 1.) PPOLN(3)=+1.
            IF (IPRINT.NE.0) WRITE(6,270) PART1,PPOLN(3)
         ENDIF
 270     FORMAT(/10X,A4,1X,'Longitudinal beam polarisation=',F10.4/)
      ENDIF
      IF (IPRINT.NE.0) THEN
        IF (ZPRIME) THEN
          WRITE(6,280) RMASS(200),RMASS(202),GAMZ,GAMZP
          WRITE(6,290) (RNAME(I),VFCH(I,1),AFCH(I,1),VFCH(I,2),
     &                  AFCH(I,2),I=1,6)
          WRITE(6,290) (RNAME(110+I),VFCH(I,1),AFCH(I,1),
     &                  VFCH(I,2),AFCH(I,2),I=11,16)
  280     FORMAT(/10X,'MASSIVE NEUTRAL VECTOR BOSON PARAMS'/
     &            10X,'Z   MASS=',F10.4,7X,'Z-PRIME MASS=',F10.4/
     &            10X,'   WIDTH=',F10.4,7X,'       WIDTH=',F10.4/
     &            10X,'FERMION COUPLINGS: e.(V.1+A.G_5)G_mu'/
     &            10X,'FERMION:  VECTOR     AXIAL',6X,
     &                'VECTOR     AXIAL'/)
  290     FORMAT(10X,A4,2X,F10.4,1X,F10.4,1X,F10.4,1X,F10.4)
        ENDIF
C---PDF STRUCTURE FUNCTIONS
        WRITE (6,'(1X)')
        DO 310 I=1,2
          IF (MODPDF(I).GE.0) THEN
            WRITE (6,300) I,MODPDF(I),AUTPDF(I)
          ELSE
            WRITE (6,305) I
          ENDIF
 300      FORMAT(10X,'PDFLIB USED FOR BEAM',I2,': SET',I3,' OF ',A20)
 305      FORMAT(10X,'PDFLIB NOT USED FOR BEAM',I2)
 310    CONTINUE
C---GET THE UGLY INITIALISATION MESSAGES OVER AND DONE WITH NOW TOO
        DO 315 I=1,2
          IF (MODPDF(I).GE.0) THEN
            PARM(1)=AUTPDF(I)
            VAL(1)=MODPDF(I)
            FSTPDF=.TRUE.
            X=0.5
            QSCA=10
            CALL PDFSET(PARM,VAL)
            CALL STRUCTM(X,QSCA,UPV,DNV,USEA,DSEA,STR,CHM,BTM,TOP,GLU)
          ENDIF
 315    CONTINUE
        WRITE (6,'(1X)')
      ENDIF
C---B DECAY PACKAGE
      IF (BDECAY.EQ.'EURO') THEN
        IF (IPRINT.NE.0) WRITE (6,320) 'EURODEC'
      ELSEIF (BDECAY.EQ.'CLEO') THEN
        IF (IPRINT.NE.0) WRITE (6,320) 'CLEO'
      ELSE
        BDECAY='HERW'
      ENDIF
  320 FORMAT (10X,A,' B DECAY PACKAGE WILL BE USED')
C---MISCELLANEOUS DERIVED QUANTITIES
      TMTOP=2.*LOG(RMASS(6)/30.)
      PXRMS=PTRMS/SQRT(2.)
      ZBINM=0.25/ZBINM
      PSPLT=1./PSPLT
      NDTRY=2*NCTRY
      NGSPL=0
      PGSMX=0.
      DO 330 I=1,4
      PGS=HWUPCM(RMASS(13),RMASS(I),RMASS(I))
      IF (PGS.GE.0.) NGSPL=I
      IF (PGS.GE.PGSMX) PGSMX=PGS
      PGSPL(I)=PGS
  330 CONTINUE
      CALL HWVZRO(6,PTINT)
      IF (IPRO.NE.80) THEN
C---SET UP TABLES OF SUDAKOV FORM FACTORS, GIVING
C   PROBABILITY DISTRIBUTION IN VARIABLE Q = E*SQRT(XI)
        NSUD=NFLAV
        CALL HWBSUD
C---SET PARAMETERS FOR SPACELIKE BRANCHING
        DO 350 I=1,NSUD
        DO 340 J=2,NQEV
        IF (QEV(J,I).GT.QSPAC) GO TO 350
  340   CONTINUE
  350   NSPAC(I)=J-1
      ENDIF
      EVWGT=AVWGT
      ISTAT=1
  999 END
