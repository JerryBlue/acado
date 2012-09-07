#
# This file is part of ACADO Toolkit.
#
# ACADO Toolkit -- A Toolkit for Automatic Control and Dynamic Optimization.
# Copyright (C) 2008-2011 by Boris Houska and Hans Joachim Ferreau.
# All rights reserved.
#
# ACADO Toolkit is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# ACADO Toolkit is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with ACADO Toolkit; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
#

################################################################################
#
# Description:
#	Compiler Options for building ACADO static and shared libraries
#
# Authors:
#	Joel Andersson
#	Attila Kozma
#	Milan Vukov, milan.vukov@esat.kuleuven.be
#
# Credits:
#	Enrico Bertolazzi, Universita` degli Studi di Trento
#
# Year:
#	2011 - 2012
#
# Usage:
#	- /
#
################################################################################

################################################################################
#
# Compiler settings - General
#
################################################################################

#
# Temporary patch, needed for compilation
#
ADD_DEFINITIONS( -DACADO_CMAKE_BUILD )

#
# Includes
#
INCLUDE( CompilerOptionsSSE )

################################################################################
#
# Compiler settings - GCC/G++; Linux, Apple
#
################################################################################
IF( CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_GNUCC )

	#
	# Compiler options from original Makefiles
	#
	SET( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -pedantic -Wfloat-equal -Wshadow" )
	SET( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -pedantic -Wfloat-equal -Wshadow" )
	
	IF( ACADO_DEVELOPER )
		SET( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Winline" )
		SET( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Winline" )
	ENDIF()

	#
	# Some common stuff...
	#
	SET(CMAKE_CXX_FLAGS_DEBUG			"${CMAKE_CXX_FLAGS_DEBUG}")
	SET(CMAKE_CXX_FLAGS_MINSIZEREL		"${CMAKE_CXX_FLAGS_MINSIZEREL} ")
	SET(CMAKE_CXX_FLAGS_RELEASE			"${CMAKE_CXX_FLAGS_RELEASE} -O3")
	SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO	"${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -DNDEBUG -O3")
	SET(CMAKE_C_FLAGS_DEBUG				"${CMAKE_C_FLAGS_DEBUG}")
	SET(CMAKE_C_FLAGS_MINSIZEREL		"${CMAKE_C_FLAGS_MINSIZEREL} ")
	SET(CMAKE_C_FLAGS_RELEASE			"${CMAKE_C_FLAGS_RELEASE} -O3")
	SET(CMAKE_C_FLAGS_RELWITHDEBINFO	"${CMAKE_C_FLAGS_RELWITHDEBINFO} -DNDEBUG -O3")

	#
	# The following commands are needed to fix a problem with the libraries
	# for Linux 64 bits
	#
	IF( "${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "x86_64" )
		MESSAGE( STATUS "x86_64 architecture detected - setting flag -fPIC" )
		SET( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC" )
		SET( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC" )
	ENDIF( "${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "x86_64" )

	#
	# Apple specifics
	#
	IF( APPLE )
		SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -gstabs+")
		SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -gstabs+")
		
#		SET( CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -funroll-loops -ftree-vectorize  -pthtread" )
#		SET( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -funroll-loops -ftree-vectorize -gstabs+ -pthtread" )

		# Option for FAT
		SET( CMAKE_OSX_ARCHITECTURES "i386;x86_64;" )

	ENDIF( APPLE )

	#
	# Adding SSE compilation flags
	#
	SET( CMAKE_C_FLAGS_RELEASE   "${CMAKE_C_FLAGS_RELEASE} ${SSE_FLAGS}" )
	SET( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}  ${SSE_FLAGS}" )

################################################################################
#
# Compiler settings - MS Visual Studio; Windows
#
################################################################################
ELSEIF( MSVC )
	SET( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -nologo -EHsc " )
	
	#
	# Check for Gnuplot installation
	#
	SET(GNUPLOT_EXECUTABLE_PATH "C:/gnuplot/bin" CACHE STRING
		"Abosulute path of the Gnuplot executable."
		FORCE
	)
	FIND_PROGRAM( GNUPLOT_EXECUTABLE
		NAMES gnuplot
		PATHS ${GNUPLOT_EXECUTABLE_PATH}
		NO_DEFAULT_PATH
	)
	IF( GNUPLOT_EXECUTABLE )
		MESSAGE( STATUS "Looking for Gnuplot executable: found." )
	ELSE ()
		MESSAGE( STATUS "Looking for Gnuplot executable: not found." )
	ENDIF()
	
	#
	# Some cool definitions
	#
	ADD_DEFINITIONS( -DWIN32 )
	ADD_DEFINITIONS( -D__NO_COPYRIGHT__ )
	ADD_DEFINITIONS( -Dsnprintf=_snprintf )
	ADD_DEFINITIONS( -Dusleep=Sleep )
	ADD_DEFINITIONS( -Dsleep=Sleep )
	ADD_DEFINITIONS( -D_CRT_SECURE_NO_WARNINGS )
	ADD_DEFINITIONS( -D__NO_PIPES__ )
	
	IF( GNUPLOT_EXECUTABLE )
		ADD_DEFINITIONS( -DGNUPLOT_EXECUTABLE="${GNUPLOT_EXECUTABLE}" )
	ENDIF()

	#
	# Enable project grouping when making Visual Studio solution
	# NOTE: This feature is NOT supported in Express editions
	#
	SET_PROPERTY( GLOBAL PROPERTY USE_FOLDERS ON )

ENDIF( )
