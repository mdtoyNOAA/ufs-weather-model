set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -traceback -fpp -fno-alias -auto -safe-cray-ptr -ftz -assume byterecl -nowarn -sox -align array64byte -qno-opt-dynamic-align")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -qno-opt-dynamic-align -sox -fp-model source")

if(NOT 32BIT)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -real-size 64")
endif()

if(DEBUG)
    add_definitions(-DDEBUG)
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -check -check noarg_temp_created -check nopointer -warn -warn noerrors -fp-stack-check -fstack-protector-all -fpe0 -debug -ftrapuv -init=snan,arrays")
    if(DEBUG_LINKMPI)
      if(OPENMP)
        set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -link_mpi=dbg_mt")
      else()
        set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -link_mpi=dbg")
      endif()
    endif()
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -ftrapuv")
elseif(REPRO)
    add_definitions(-DREPRO)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O2 -debug minimal -fp-model consistent -qoverride-limits")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2 -debug minimal")
else()
    if(32BIT)
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O2 -debug minimal -fp-model source -qoverride-limits -qopt-prefetch=3")
    else()
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O2 -debug minimal -fp-model source -qoverride-limits -qopt-prefetch=3 -no-prec-div -no-prec-sqrt")
    endif()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2 -debug minimal")
    set(FAST "-fast-transcendentals")
    if(AVX2)
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -march=core-avx2")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=core-avx2")
    elseif(SIMDMULTIARCH)
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -axSSE4.2,CORE-AVX2")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -axSSE4.2,CORE-AVX2")
     elseif(AVX)
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -march=core-avx-i")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=core-avx-i")
    endif()
endif()

# For ccpp
set(CMAKE_C_FLAGS_RELEASE       "-O2 -fPIC" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE     "-O2 -fPIC" CACHE STRING "" FORCE)
set(CMAKE_Fortran_FLAGS_RELEASE "-O2 -fPIC" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_BITFORBIT       "-O2 -fPIC" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_BITFORBIT     "-O2 -fPIC" CACHE STRING "" FORCE)
set(CMAKE_Fortran_FLAGS_BITFORBIT "-O2 -fPIC" CACHE STRING "" FORCE)

if(APPLE)
  # The linker on macOS does not include `common symbols` by default
  # Passing the -c flag includes them and fixes an error with undefined symbols
  set(CMAKE_Fortran_ARCHIVE_FINISH "<CMAKE_RANLIB> -c <TARGET>")
endif()
