#ifndef CERNLIB_ISAJET_MGLIMS_INC
#define CERNLIB_ISAJET_MGLIMS_INC
*
*
* mglims.inc
*
C          Limits for MadGraph multiparton processes
      COMMON/MGLIMS/EHMGMN,EHMGMX,YHMGMN,YHMGMX,
     $AMIJMN(MXLIM,MXLIM),AMIJMX(MXLIM,MXLIM),FIXMIJ(MXLIM,MXLIM)
      SAVE /MGLIMS/
      REAL EHMGMN,EHMGMX,YHMGMN,YHMGMX,AMIJMN,AMIJMX
      LOGICAL FIXMIJ

#endif
