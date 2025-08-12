#
# Copyright (C) Mellanox Technologies Ltd. 2001-2015.  ALL RIGHTS RESERVED.
# Copyright (c) 2022      Amazon.com, Inc. or its affiliates.  All Rights reserved.
# $COPYRIGHT$
#
# Additional copyrights may follow
#
# $HEADER$
#


AC_DEFUN([MCA_ompi_pml_ucx_POST_CONFIG], [
    AS_IF([test "$1" = "1"], [OMPI_REQUIRE_ENDPOINT_TAG([PML])])
])

AC_DEFUN([MCA_ompi_pml_ucx_CONFIG], [
    AC_CONFIG_FILES([ompi/mca/pml/ucx/Makefile])

    OMPI_CHECK_UCX([pml_ucx],
                   [pml_ucx_happy="yes"],
                   [pml_ucx_happy="no"])

    AC_ARG_ENABLE([ucx-recv-replyep],
       [AS_HELP_STRING([--enable-ucx-recv-replyep],
           [enable UCX tag receive call to specify a reply endpoint when possible (default: disable)])])
    AC_MSG_CHECKING([whether to enable reply ep])
    if test "$enable_ucx_recv_replyep" != "no"; then
        AC_MSG_RESULT([yes])
        ucx_recv_replyep_enabled=1
    else
        AC_MSG_RESULT([no])
        ucx_recv_replyep_enabled=0
    fi
    AC_DEFINE_UNQUOTED([OPAL_PML_UCX_RECV_REPLYEP],
        [$ucx_recv_replyep_enabled],
        [Enable UCX tag receive with reply endpoint when possible])
    AM_CONDITIONAL([OPAL_PML_UCX_RECV_REPLYEP],
        [test "$ucx_recv_replyep_enabled" = "1"])

    AS_IF([test "${pml_ucx_happy}" = "yes"],
          [OPAL_MCA_CHECK_DEPENDENCY([ompi], [pml], [ucx], [opal], [common], [ucx])])

    AS_IF([test "$pml_ucx_happy" = "yes"],
          [$1],
          [$2])

    # substitute in the things needed to build ucx
    AC_SUBST([pml_ucx_CPPFLAGS])
    AC_SUBST([pml_ucx_LDFLAGS])
    AC_SUBST([pml_ucx_LIBS])
])
