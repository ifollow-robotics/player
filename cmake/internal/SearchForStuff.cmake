INCLUDE (${PLAYER_CMAKE_DIR}/PlayerUtils.cmake)

INCLUDE (CheckFunctionExists)
INCLUDE (CheckIncludeFiles)
INCLUDE (CheckLibraryExists)

CHECK_FUNCTION_EXISTS (cfmakeraw HAVE_CFMAKERAW)
CHECK_FUNCTION_EXISTS (dirname HAVE_DIRNAME)
CHECK_FUNCTION_EXISTS (getaddrinfo HAVE_GETADDRINFO)
CHECK_LIBRARY_EXISTS (GL glBegin "" HAVE_LIBGL)
CHECK_LIBRARY_EXISTS (GLU main "" HAVE_LIBGLU)
CHECK_LIBRARY_EXISTS (glut main "" HAVE_LIBGLUT)
CHECK_LIBRARY_EXISTS (ltdl lt_dlopenext "" HAVE_LIBLTDL)
CHECK_INCLUDE_FILES (linux/joystick.h HAVE_LINUX_JOYSTICK_H)
CHECK_FUNCTION_EXISTS (poll HAVE_POLL)
CHECK_FUNCTION_EXISTS (round HAVE_ROUND)
CHECK_INCLUDE_FILES (stdint.h HAVE_STDINT_H)
CHECK_INCLUDE_FILES (strings.h HAVE_STRINGS_H)
CHECK_FUNCTION_EXISTS (compressBound NEED_COMPRESSBOUND)
CHECK_INCLUDE_FILES (dns_sd.h HAVE_DNS_SD)
IF (HAVE_DNS_SD)
    CHECK_LIBRARY_EXISTS (dns_sd DNSServiceRefDeallocate "" HAVE_DNS_SD)
ENDIF (HAVE_DNS_SD)

CHECK_LIBRARY_EXISTS (jpeg jpeg_read_header "" HAVE_LIBJPEG)
CHECK_INCLUDE_FILES ("stdio.h;jpeglib.h" HAVE_JPEGLIB_H)
IF (HAVE_LIBJPEG AND HAVE_JPEGLIB_H)
    SET (HAVE_JPEG TRUE)
ENDIF (HAVE_LIBJPEG AND HAVE_JPEGLIB_H)

CHECK_LIBRARY_EXISTS (z compress2 "" HAVE_LIBZ)
CHECK_INCLUDE_FILES (zlib.h HAVE_ZLIB_H)
IF (HAVE_LIBZ AND HAVE_ZLIB_H)
    SET (HAVE_Z TRUE)
ENDIF (HAVE_LIBZ AND HAVE_ZLIB_H)

# Endianess check
INCLUDE (TestBigEndian)
TEST_BIG_ENDIAN (WORDS_BIGENDIAN)

# GTK checks
INCLUDE (FindPkgConfig)
IF (NOT PKG_CONFIG_FOUND)
    MESSAGE (STATUS "WARNING: Could not find pkg-config; cannot search for GTK or related.")
ELSE (NOT PKG_CONFIG_FOUND)
    pkg_check_modules (GNOMECANVAS_PKG libgnomecanvas-2.0)
    IF (GNOMECANVAS_PKG_FOUND)
        SET (WITH_GNOMECANVAS TRUE)
        # Because the FindPkgConfig module annoyingly separates *all* results, not just the dirs,
        # we have to unseparate the flags back into strings so they can be passed to the
        # SET_x_PROPERTIES functions properly. Change the LIST_TO_STRING to SET and make with
        # VERBOSE=1 to see the mess that happens otherwise.
        LIST_TO_STRING (GNOMECANVAS_LINKFLAGS "${GNOMECANVAS_PKG_LDFLAGS}")
        LIST_TO_STRING (GNOMECANVAS_CFLAGS "${GNOMECANVAS_PKG_CFLAGS}")
    ENDIF (GNOMECANVAS_PKG_FOUND)

    pkg_check_modules (GTK_PKG gtk+-2.0)
    IF (GTK_PKG_FOUND)
        SET (WITH_GTK TRUE)
        SET (GTK_INCLUDEDIR ${GTK_PKG_INCLUDE_DIRS})
        LIST_TO_STRING (GTK_LINKFLAGS "${GTK_PKG_LDFLAGS}")
        LIST_TO_STRING (GTK_CFLAGS "${GTK_PKG_CFLAGS}")
    ENDIF (GTK_PKG_FOUND)

    pkg_check_modules (GDKPIXBUF_PKG gdk-pixbuf-2.0)
    IF (GDKPIXBUF_PKG_FOUND)
        SET (WITH_GDKPIXBUF TRUE)
        LIST_TO_STRING (GDKPIXBUF_LINKFLAGS "${GDKPIXBUF_PKG_LDFLAGS}")
        LIST_TO_STRING (GDKPIXBUF_CFLAGS "${GDKPIXBUF_PKG_CFLAGS}")
    ENDIF (GDKPIXBUF_PKG_FOUND)
ENDIF (NOT PKG_CONFIG_FOUND)
