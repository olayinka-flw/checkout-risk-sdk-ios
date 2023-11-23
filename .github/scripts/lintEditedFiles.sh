#!/bin/sh

set -o pipefail
git fetch origin main
echo "Fetched"

# Run SwiftLint
START_DATE=$(date +"%s")

SWIFT_LINT=/opt/homebrew/bin/swiftlint


# Run SwiftLint for given filename
run_swiftlint() {
    local filename="${1}"
    if [[ "${filename##*.}" == "swift" ]]; then
        ${SWIFT_LINT} -- "${filename}"
    fi
}

if [[ -e "${SWIFT_LINT}" ]]; then
    echo "SwiftLint version: $(${SWIFT_LINT} version)"
    # Run for both staged and unstaged files
    git diff --name-only | while read filename; do run_swiftlint "${filename}"; done
    git diff --cached --name-only | while read filename; do run_swiftlint "${filename}"; done
else
    echo "${SWIFT_LINT} is not installed."
    exit 0
fi

END_DATE=$(date +"%s")

DIFF=$(($END_DATE - $START_DATE))
echo "SwiftLint took $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds to complete."