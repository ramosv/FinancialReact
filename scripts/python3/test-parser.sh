#!/bin/bash -

# Initializes this project in order to be able to run several of its scripts.

# Exit when any command fails
set -e

script_start=$(date +%s)

script_directory=$(dirname "$0")

if [ -z "$VIRTUAL_ENV" ]
then
  echo 'Attempting to activate your Python virtual environment...'
  if [ -f ./.venv/bin/activate ]; then
    source ./.venv/bin/activate
    echo 'Done'
  elif [ -f ./.venv/Scripts/activate ]; then
    source ./.venv/Scripts/activate
    echo 'Done'
  fi
fi

if [ -z "$VIRTUAL_ENV" ]
then
  echo 'Unable to activate your Python virtual environment.'
  exit 2
fi

# Use python3 command if available, otherwise try python
# Note: Be sure to activate the Python virtual environment before trying to
# resolve the python version
set +e
python_cmd=$(which python3 2> /dev/null)
if [ -n "$python_cmd" ]; then
  python_cmd=python3
else
  python_cmd=$(which python 2> /dev/null)
  if [ -n "$python_cmd" ]; then
    python_cmd=python
  fi
fi

# ================================
# Arguments are injected in the `test.py` file.
$python_cmd ./scripts/test.py
# ================================

echo
script_end=$(date +%s)
dur_secs=$((script_end - script_start))
if ((dur_secs > 60)); then
  echo "Finished in $((dur_secs/60)) minutes."
else
  echo "Finished in $dur_secs seconds."
fi
