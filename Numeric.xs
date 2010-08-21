#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

I32 is_num(pTHX_ SV * const sv);
I32 is_num(pTHX_ SV * const sv) {
    I32 type = 0;

    if (!(SvROK(sv) || (sv == (SV *)&PL_sv_undef))) {
        /* stringify - ironically, looks_like_number always returns 1 unless arg is a string */

        if (SvPOK(sv)) {
            type = looks_like_number(sv);
        } else {
            STRLEN len;
            const char * const str = SvPV(sv, len);
            type = looks_like_number(sv_2mortal(newSVpv(str, len)));
        }
    }

    return type;
}

MODULE = Scalar::Util::Numeric    PACKAGE = Scalar::Util::Numeric

void
uvmax()
    PROTOTYPE:
    CODE:
        XSRETURN_UV(UV_MAX);

void
isnum (sv)
    SV * sv
    PROTOTYPE: $
    CODE:
        XSRETURN_IV(is_num(aTHX_ sv));

void
isint (sv)
    SV * sv
    PROTOTYPE: $
    CODE:
        I32 type = is_num(aTHX_ sv);
        I32 ret;

        if (type == 1) {
            ret = 1;
        } else if (type == 9) {
            ret = -1;
        } else {
            ret = -0;
        }

        XSRETURN_IV(ret);

void
isuv (sv)
    SV * sv
    PROTOTYPE: $
    CODE:
        XSRETURN_IV((is_num(aTHX_ sv) & 1) ? 1 : 0);

void
isbig (sv)
    SV * sv
    PROTOTYPE: $
    CODE:
        XSRETURN_IV((is_num(aTHX_ sv) & 2) ? 1 : 0);

void
isfloat (sv)
    SV * sv
    PROTOTYPE: $
    CODE:
        XSRETURN_IV((is_num(aTHX_ sv) & 4) ? 1 : 0);

void
isneg (sv)
    SV * sv
    PROTOTYPE: $
    CODE:
        XSRETURN_IV((is_num(aTHX_ sv) & 8) ? 1 : 0);

void
isinf (sv)
    SV * sv
    PROTOTYPE: $
    CODE:
        XSRETURN_IV((is_num(aTHX_ sv) & 16) ? 1 : 0);

void
isnan (sv)
    SV * sv
    PROTOTYPE: $
    CODE:
        XSRETURN_IV((is_num(aTHX_ sv) & 32) ? 1 : 0);
