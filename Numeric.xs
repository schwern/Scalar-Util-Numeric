#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

MODULE = Scalar::Util::Numeric		PACKAGE = Scalar::Util::Numeric		

void
is_num(sv)
    SV *sv
    PROTOTYPE: $
    PREINIT:
    I32 num = 0;
    PPCODE:

    if (!(SvROK(sv) || (sv == (SV *)&PL_sv_undef))) {
		num = looks_like_number(sv);
    }

    EXTEND(SP,1);
    PUSHs(sv_2mortal(newSViv(num)));
