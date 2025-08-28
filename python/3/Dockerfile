# Python image for AMP containers including Python 3.10, 3.11 (default) and 3.12 from upstream
# ghcr.io/cubecoders/amp:python-3-testing

FROM        python:3.10-slim-bookworm AS py310

ENV         DEBIAN_FRONTEND="noninteractive"

ARG         PYTHON_VERSION="3.10"

COPY        scripts/python/find-deps.sh /usr/local/bin/find-deps.sh
RUN         chmod +x /usr/local/bin/find-deps.sh

RUN         set -eux; \
            /usr/local/bin/find-deps.sh ${PYTHON_VERSION} >/tmp/${PYTHON_VERSION}-run-deps.txt
            
FROM        python:3.11-slim-bookworm AS py311

ENV         DEBIAN_FRONTEND="noninteractive"

ARG         PYTHON_VERSION="3.11"

COPY        scripts/python/find-deps.sh /usr/local/bin/find-deps.sh
RUN         chmod +x /usr/local/bin/find-deps.sh

RUN         set -eux; \
            /usr/local/bin/find-deps.sh ${PYTHON_VERSION} >/tmp/${PYTHON_VERSION}-run-deps.txt

FROM        python:3.12-slim-bookworm AS py312

ENV         DEBIAN_FRONTEND="noninteractive"

ARG         PYTHON_VERSION="3.12"

COPY        scripts/python/find-deps.sh /usr/local/bin/find-deps.sh
RUN         chmod +x /usr/local/bin/find-deps.sh

RUN         set -eux; \
            /usr/local/bin/find-deps.sh ${PYTHON_VERSION} >/tmp/${PYTHON_VERSION}-run-deps.txt

FROM        ghcr.io/cubecoders/amp:debian
LABEL       org.opencontainers.image.licenses=MIT

ENV         PIP_DISABLE_PIP_VERSION_CHECK="1"
ENV         DEBIAN_FRONTEND="noninteractive"

ARG         PYTHON_DEFAULT="3.11"
ARG         PYTHON_NON_DEFAULT="3.10 3.12"

# Drop in upstream Python 3.10
COPY        --from=py310 /usr/local/ /usr/local/

COPY        --from=py310 /tmp/3.10-run-deps.txt /tmp/3.10-run-deps.txt

# Drop in upstream Python 3.12
COPY        --from=py312 /usr/local/ /usr/local/

COPY        --from=py312 /tmp/3.12-run-deps.txt /tmp/3.12-run-deps.txt

# Drop in upstream Python 3.11 (default last)
COPY        --from=py311 /usr/local/ /usr/local/

COPY        --from=py311 /tmp/3.11-run-deps.txt /tmp/3.11-run-deps.txt

RUN         set -eux; \
            apt-get update; \
            # Purge gdb from base image to remove conflicting Python libs
            apt-get purge gdb -y --autoremove; \
            \
            sort -u /tmp/*-run-deps.txt \
            | awk 'NF && $1 !~ /^#/' \
            | xargs -r apt-get install -o APT::Keep-Downloaded-Packages="false" -y --no-install-recommends; \
            apt-get clean; \
            rm -rf /var/lib/apt/lists/* /tmp/*-run-deps.txt; \
            \
            for v in ${PYTHON_NON_DEFAULT}; do \  
                python${v} -m pip install --no-cache-dir --upgrade pip setuptools wheel; \
                for shim in python${v} pip${v}; do \
                    [ -x "/usr/local/bin/${shim}" ] && ln -sf "/usr/local/bin/${shim}" "/usr/bin/${shim}"; \
                done; \
            done; \
            python${PYTHON_DEFAULT} -m pip install --no-cache-dir --upgrade pip setuptools wheel; \
            #for p in /usr/bin/python3 /usr/bin/python${PYTHON_DEFAULT} /usr/bin/pip3 /usr/bin/pip; do \
            #    if [ -e "$p" ] && ! dpkg-divert --list "$p" >/dev/null 2>&1; then \
            #        dpkg-divert --quiet --local --rename --add "$p"; \
            #    fi; \
            #done; \
            #rm -rf /usr/local/bin/python /usr/local/bin/python3 /usr/local/bin/pip /usr/local/bin/pip3; \
            #ln -sf "/usr/local/bin/python${PYTHON_DEFAULT}" "/usr/local/bin/python3"; \
            #ln -sf "/usr/local/bin/python${PYTHON_DEFAULT}" "/usr/local/bin/python"; \
            #ln -sf "/usr/local/bin/pip${PYTHON_DEFAULT}" "/usr/local/bin/pip3"; \
            #ln -sf "/usr/local/bin/pip${PYTHON_DEFAULT}" "/usr/local/bin/pip"; \
            for shim in python python3 python${PYTHON_DEFAULT} pip pip3 pip${PYTHON_DEFAULT}; do \
                ln -sf "/usr/local/bin/${shim}" "/usr/bin/${shim}"; \
            done