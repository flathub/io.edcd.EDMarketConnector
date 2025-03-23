#!/bin/sh

export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"

cd /app/edmarketconnector; python3 EDMarketConnector.py 2>&1 | tee "${XDG_DATA_HOME}/EDMarketConnector/logs/EDMarketConnector.log"
rm "${XDG_DATA_HOME}/EDMarketConnector/logs/EDMarketConnector.log"
