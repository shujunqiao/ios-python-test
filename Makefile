PY_EMBED=python-embedded
CPython=${PY_EMBED}/CPython
PYLIB=${PY_EMBED}/pylib
PROJ=test-python/test-python

all: libpython xcodefiles

${PY_EMBED}/libpython.a: ${PY_EMBED}
	cd "${PY_EMBED}"; ./compile.py

build/python/include/pyconfig.h: ${PYLIB}/pyconfig.h
	@mkdir -p build/python/include
	cp "$<" build/python/include

build/python/include/%.h: ${CPython}/Include/%.h
	@mkdir -p build/python/include
	cp "$<" build/python/include

build/python/include: $(addprefix build/python/include/, $(notdir $(wildcard ${CPython}/Include/*.h))) build/python/include/pyconfig.h

build/python/libpython.a: ${PY_EMBED}/libpython.a
	mkdir -p build/python
	cp "$<" "$@"

build/python: build/python/libpython.a build/python/include

# TODO: check if compiling to .pyc improves performance
${PROJ}/python/pylib/lib: ${CPython}/Lib
	mkdir -p video-dl/python/pylib
	cp -Rf "$<" "$@"

${PROJ}/python/pylib/exec: ${PY_EMBED}/pylib/exec
	cp -Rf "$<" "$@"

${PROJ}/python/pylib/exec/include/python2.7/pyconfig.h: ${PY_EMBED}/pylib/pyconfig.h ${PROJ}/python/pylib/exec
	cp -f "$<" "$@"

${PROJ}/python/pylib/pyconfig.h: ${PY_EMBED}/pylib/pyconfig.h
	mkdir -p "$(dir $@)"
	cp -f "$<" "$@"

${PROJ}/python/pylib: ${PROJ}/python/pylib/pyconfig.h ${PROJ}/python/pylib/lib ${PROJ}/python/pylib/exec/include/python2.7/pyconfig.h ${PROJ}/python/pylib/exec

${PROJ}/python: ${PROJ}/python/pylib

libpython: build/python

xcodefiles: ${PROJ}/python

clean:
	rm -fR "${PY_EMBED}/build" "${PY_EMBED}/libpython.a" "${PROJ}/python/pylib"
