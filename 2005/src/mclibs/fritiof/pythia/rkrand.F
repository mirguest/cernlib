*
* $Id: rkrand.F,v 1.1.1.1 1996/01/11 14:05:30 mclareni Exp $
*
* $Log: rkrand.F,v $
* Revision 1.1.1.1  1996/01/11 14:05:30  mclareni
* Fritiof
*
*
*==================================================================
 
      FUNCTION RKRAND(IDUMMY)
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      SAVE
      DATA INIT/0/
      IF(INIT.EQ.0) THEN
        INIT=1
        X=DMOD(DSQRT(2D0),1D0)
        Y=DMOD(DSQRT(3D0),1D0)
        Z=DMOD(DSQRT(5D0),1D0)
      ELSE
        X=DMOD(X+Y+Z,1D0)
        Y=DMOD(X+Y+Z,1D0)
        Z=DMOD(X+Y+Z,1D0)
      ENDIF
      RKRAND=X
      END
