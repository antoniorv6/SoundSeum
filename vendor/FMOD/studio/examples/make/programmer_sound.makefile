NAME = programmer_sound

ifndef CPU
    $(error Specify CPU=[x86|x86_64|arm|arm64])
endif
ifndef CONFIG
    $(error Specify CONFIG=[Debug|Release])
endif

ifeq (${CPU}, arm)
    FLAGS += -marm -march=armv7-a -mfpu=neon -mfloat-abi=hard
else ifeq (${CPU}, arm64)
    FLAGS += -m64 -target aarch64-linux-gnu -march=armv8-a
else ifeq (${CPU}, x86)
    FLAGS += -m32
else
    override CPU = x86_64
    FLAGS += -m64
endif

ifeq (${CONFIG}, Debug)
    FLAGS += -g
    SUFFIX = L
else
    override CONFIG = Release
    FLAGS += -O2
    SUFFIX =
endif

SOURCE_FILES = \
    ../programmer_sound.cpp \
    ../common.cpp \
    ../common_platform.cpp

INCLUDE_DIRS = \
    -I../../../core/inc \
    -I../../../studio/inc

LOWLEVEL_LIB = ../../../core/lib/${CPU}/libfmod${SUFFIX}.so
STUDIO_LIB = ../../../studio/lib/${CPU}/libfmodstudio${SUFFIX}.so

all:
	g++ -pthread ${FLAGS} -o ${NAME} ${SOURCE_FILES} -Wl,-rpath=\$$ORIGIN/$(dir ${LOWLEVEL_LIB}),-rpath=\$$ORIGIN/$(dir ${STUDIO_LIB}) ${LOWLEVEL_LIB} ${STUDIO_LIB} ${INCLUDE_DIRS}
