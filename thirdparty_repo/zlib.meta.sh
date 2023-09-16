
# Metadata for deploy script

PN="zlib"
#PV="1.2.13"
PV="1.3"
# package revision: when patchset is changed (but not version), increase it
# when version changed, reset to "1".
REV="1"
SRCFILE="${PN}-${PV}.tar.xz"
#SHA512="9e7ac71a1824855ae526506883e439456b74ac0b811d54e94f6908249ba8719bec4c8d7672903c5280658b26cb6b5e93ecaaafe5cdc2980c760fa196773f0725"
SHA512="3868ac4da5842dd36c9dad794930675b9082ce15cbd099ddb79c0f6bd20a24aa8f33a123f378f26fe0ae02d91f31f2994dccaac565cedeaffed7b315e6ded2a2"

URL="http://www.zlib.net/${SRCFILE}"

SOURCESDIR="${PN}-${PV}"

PATCHES="01-cmake-static-only-no-install.patch"
