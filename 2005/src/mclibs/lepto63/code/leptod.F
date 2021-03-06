
C **********************************************************************

      BLOCK DATA LEPTOD

C...Give sensible default values to switches and parameters.

      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,Y,W2,Q2,U
      COMMON /LINTER/ PARI(40),EWQC(2,2,8),QC(8),ZL(2,4),ZQ(2,8),PQ(17)
      COMMON /LFLMIX/ CABIBO(4,4)
      COMMON /LOPTIM/ OPTX(4),OPTY(4),OPTQ2(4),OPTW2(4),COMFAC
      COMMON /LGRID/ NXX,NWW,XX(31),WW(21),PQG(31,21,3),PQQB(31,21,2),
     &QGMAX(31,21,3),QQBMAX(31,21,2),YCUT(31,21),XTOT(31,21),NP
      COMMON /FLGRID/ NFX,NFQ,XR(2),QR(2),FLQT(41,16),FLGT(41,16),
     &FLMT(41,16)
      COMMON /LYPARA/ IPY(80),PYPAR(80),PYVAR(80)
      COMMON /LMINUI/ XKIN(4),UKIN(4),WKIN(4),AIN(4),BIN(4),
     &MAXFIN,RELUP,RELERR,RELER2,FCNMAX
      COMMON /LMINUC/ NAMKIN(4),NAM(30)
      CHARACTER*10 NAMKIN,NAM

C...LEPTOU: Cuts, basic switches and parameters.
      DATA CUT/1.E-04,1.,0.,1.,4.,1.E+08,5.,1.E+08,1.,1.E+08,1.,1.E+08,
     &0.,3.1416/
C...            0    1    2    3    4    5    6    7    8    9
      DATA LST/      0,   1,   5,   1,   3,   1,   1,  12,   5,
     1          1,   0,   4,   5,   4,   9,   1,   0,   2, -10,
     2          5,   0,   0,   0,   0,   0,   0,   0,   0,   0,
     3          0,   0,   0,   0,   2,   1,   5*0/
C...            0    1    2    3    4    5    6    7    8    9
      DATA PARL/     1.,  1.,  0.44,0.75,.2319,0., 0.5, .04, 4.,
     1         0.44, 0.01,0.01,0.1, 0.35,0.01,7.29735E-03,
     &                                   1.16639E-05,0.044,0.03,
     2         0.1,10*0./
C...Internally used variables.
      DATA PARI/40*0./
      DATA QC/-.33333,.66667,-.33333,.66667,-.33333,.66667,
     &        -.33333,.66667/
      DATA CABIBO/.95,.05,2*0.,.05,.948,.002,2*0.,.002,.998,4*0.,1./
      DATA OPTX/1.,3*0./,OPTY/1.,3*0./,OPTQ2/1.,3*0./,OPTW2/1.,3*0./
      DATA NXX,NWW/31,21/
      DATA PQG,PQQB,QGMAX,QQBMAX/6510*0./,YCUT/651*0./,XTOT/651*0./
      DATA NFX,NFQ/41,16/,FLQT,FLGT,FLMT/1968*0./
      DATA XKIN/1.,2.,3.,4./,UKIN,WKIN,AIN,BIN/16*0./,MAXFIN/2000/
      DATA RELUP,RELERR,RELER2/0.1,0.05,0.05/
      DATA NAMKIN/'         x','          ','          ','          '/
      DATA IPY/
     1 0,     0,     2,     2,     6,     1,     1,     6,     3,     1,
     2 3,     1,     1,     2,     1,     1,     4,     1,     1,     1,
     3 0,     1,     1,     1,     1,     1,     1,     0,     0,     0,
     4 1,     2,     1,     1,    30,    33,     1,     1,     7,     0,
     5 0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     6 0,     0,     0,     1,   100,     0,     0,     0,     0,     0,
     7 0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     8 0,     0,     0,     0,     0,     0,     0,     0,     0,     0/
      DATA (PYPAR(I),I=1,40)/
     1   7.299E-03,   2.290E-01,   2.000E-01,   2.500E-01,   4.000E+00,
     1   1.000E+00,   4.400E-01,   4.400E-01,   7.500E-02,   0.000E+00,
     2   2.000E+00,   2.000E+00,   1.000E+00,   0.000E+00,   3.000E+00,
     2   1.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,   1.000E+00,
     3   2.500E-01,   1.000E+00,   2.000E+00,   1.000E-03,   1.000E+00,
     3   1.000E+00,   1.000E+00,  -2.000E-02,  -1.000E-02,   0.000E+00,
     4   0.000E+00,   1.600E+00,   0.500E+00,   0.200E+00,   3.894E-01,
     4   1.000E+00,   3.300E-01,   6.600E-01,   0.000E+00,   1.000E+00/
      DATA (PYPAR(I),I=41,80)/
     5   2.260E+00,   1.000E+04,   1.000E-04,   0.000E+00,   0.000E+00,
     5   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,
     6   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,
     6   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,
     7   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,
     7   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,
     8   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,
     8   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00,   0.000E+00/
      DATA PYVAR/80*0./
      END
