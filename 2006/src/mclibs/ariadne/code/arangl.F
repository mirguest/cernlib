C***********************************************************************
C $Id: arangl.F,v 1.2 1996/04/10 12:33:01 mclareni Exp $

      REAL FUNCTION ARANGL(I1,I2)

C...ARiadne function ANGLe

C...Returns the angle between parton I1 and I2

#include "arimpl.f"
#include "arpart.f"


      D12=BP(I1,1)*BP(I2,1)+BP(I1,2)*BP(I2,2)+BP(I1,3)*BP(I2,3)
      DP1=SQRT(BP(I1,1)**2+BP(I1,2)**2+BP(I1,3)**2)
      DP2=SQRT(BP(I2,1)**2+BP(I2,2)**2+BP(I2,3)**2)
      ARANGL=ACOS(MAX(-1.0D0,MIN(1.0D0,D12/(DP1*DP2))))

      RETURN

C**** END OF ARANGL ****************************************************
      END
