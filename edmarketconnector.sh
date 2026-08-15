#!/bin/sh

export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"

LOGFILE="${XDG_DATA_HOME}/EDMarketConnector/logs/EDMarketConnector.log"
FIFO="${TMPDIR}/edmarketconnector.pipe"

rm -f "${FIFO}"
mkfifo "${FIFO}"

cd /app/edmarketconnector

tee "${LOGFILE}" <"${FIFO}" &
TEE_PID=$!

python3 EDMarketConnector.py >"${FIFO}" 2>&1 &
PYTHON_PID=$!

rm -f "${FIFO}"

handle_signal() {
    signal="$1"
    if kill -0 "$PYTHON_PID" 2>/dev/null; then
        kill -"$signal" "$PYTHON_PID" 2>/dev/null || kill -TERM "$PYTHON_PID" 2>/dev/null || true
    fi
}

trap 'handle_signal INT' INT
trap 'handle_signal TERM' TERM
trap 'handle_signal HUP' HUP

wait "$PYTHON_PID"
STATUS=$?

kill -TERM "$TEE_PID" 2>/dev/null || true
wait "$TEE_PID" 2>/dev/null || true

trap - INT TERM HUP
exit "$STATUS"
