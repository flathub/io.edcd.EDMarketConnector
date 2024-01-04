#!/bin/sh

export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"

cd /app/edmarketconnector; python3 EDMarketConnector.py
