INCLUDE(CMakeForceCompiler)

# SYSTEM
SET(CMAKE_SYSTEM_NAME      Generic)
SET(CMAKE_SYSTEM_PROCESSOR arm-none-eabi)

# COMPILER
SET(CODESOURCERY_BASE_PATH /opt/CodeSourcery/Sourcery_G++_Lite)

SET(CMAKE_C_COMPILER   ${CODESOURCERY_BASE_PATH}/bin/arm-none-eabi-gcc)
SET(CMAKE_CXX_COMPILER ${CODESOURCERY_BASE_PATH}/bin/arm-none-eabi-g++)
SET(CMAKE_OBJCOPY      ${CODESOURCERY_BASE_PATH}/bin/arm-none-eabi-objcopy)
CMAKE_FORCE_C_COMPILER(${CMAKE_C_COMPILER} gcc)
CMAKE_FORCE_CXX_COMPILER(${CMAKE_CXX_COMPILER} gcc)

# BASIC INCLUDES/DEFENITIONS

# This is apparently because this symbol is defined in libstdc++, which is missing in a free-standing environment. Fixing the problem simply requires defining this symbol somewhere:
# Most of the compiler support routines used by GCC are present in libgcc, but there are a few exceptions. GCC requires the freestanding environment provide memcpy, memmove, memset and memcmp. Finally, if __builtin_trap is used, and the target does not implement the trap pattern, then GCC will emit a call to abort. 

get_filename_component(LINKER_SCRIPT_FILE_DIR "${LINKER_SCRIPT_FILE}" PATH)

SET(CMAKE_C_FLAGS_INIT          "-march=armv7-m -mcpu=cortex-m3 -mtune=cortex-m3 -mthumb -msoft-float -mno-sched-prolog -mapcs-frame -ffreestanding")
SET(CMAKE_CXX_FLAGS_INIT        "-march=armv7-m -mcpu=cortex-m3 -mtune=cortex-m3 -mthumb -msoft-float -mno-sched-prolog -mapcs-frame -ffreestanding")
SET(CMAKE_EXE_LINKER_FLAGS_INIT "-march=armv7-m -mcpu=cortex-m3 -mtune=cortex-m3 -mthumb -static -Wl,-Map=out.map -L ${LINKER_SCRIPT_FILE_DIR} -T ${LINKER_SCRIPT_FILE}")


# SEARCH PROGRAM/LIBRARIES
SET(CMAKE_FIND_ROOT_PATH  /usr/local)

SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

#
macro(GENERATE_HEX TARGET)
	add_custom_command(
		OUTPUT "${TARGET}.hex"
		COMMAND ${CODESOURCERY_BASE_PATH}/bin/arm-none-eabi-objcopy -O ihex --strip-debug ${TARGET} ${TARGET}.hex
		DEPENDS ${TARGET}
		VERBATIM
	)

	add_custom_command(
		OUTPUT "${TARGET}.bin"
		COMMAND ${CODESOURCERY_BASE_PATH}/bin/arm-none-eabi-objcopy -O binary --strip-debug ${TARGET} ${TARGET}.bin
		DEPENDS ${TARGET}
		VERBATIM
	)

	add_custom_command(
		TARGET ${TARGET}
		POST_BUILD
		COMMAND ${CODESOURCERY_BASE_PATH}/bin/arm-none-eabi-objcopy -O ihex --strip-debug ${TARGET} ${TARGET}.hex
		VERBATIM
	)
	add_custom_command(
		TARGET ${TARGET}
		POST_BUILD
		COMMAND ${CODESOURCERY_BASE_PATH}/bin/arm-none-eabi-objcopy -O binary --strip-debug ${TARGET} ${TARGET}.bin
		VERBATIM
	)
endmacro(GENERATE_HEX)
