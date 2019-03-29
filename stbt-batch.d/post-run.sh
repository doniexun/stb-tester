#!/usr/bin/bash
#                                                    -*- sh-basic-offset: 2 -*-

# Copyright 2013 YouView TV Ltd.
#           2013-2015 stb-tester.com Ltd.
# License: LGPL v2.1 or (at your option) any later version (see
# https://github.com/stb-tester/stb-tester/blob/master/LICENSE for details).
#
# Input environment variables:
#
# * $stbt_root
#
# Outputs:
#
# * Files in the current working directory
#

main() {
  grep -q "FAIL: .*: MatchTimeout" stdout.log && template
  grep -q "FAIL: .*: NoVideo" stdout.log && {
    check_capture_hardware || touch unrecoverable-error; }
}

template() {
  local template=$(
    sed -n 's,^.*stbt-run: Searching for \(.*\.png\)$,\1,p' stderr.log |
    tail -1)
  [ -f "$template" ] && cp "$template" template.png
}

check_capture_hardware() {
  case "$("$stbt_root"/stbt-config global.source_pipeline | awk '{print $1}')" in
    v4l2src)
      if grep -q "Cannot identify device '/dev/v" failure-reason; then
        echo "v4l2 device not found; exiting."
        return 1
      fi
      ;;

    decklinksrc)
      ( echo "$(basename "$0"): Checking Blackmagic video-capture device"
        GST_DEBUG=decklinksrc:5 GST_DEBUG_NO_COLOR=1 \
        "$stbt_root"/stbt-run --sink-pipeline='' \
          <(echo "import time; time.sleep(1)") 2>&1
      ) | ts '[%Y-%m-%d %H:%M:%.S %z] ' > decklinksrc.log

      if grep -q "enable video input failed" decklinksrc.log; then
        local subdevice=$(
          "$stbt_root"/stbt-config global.source_pipeline |
          grep -o device-number=. | awk -F= '{print $2}')
        local users=$(
          lsof -F Lnc \
            /dev/blackmagic${subdevice:-0} \
            /dev/blackmagic/dv${subdevice:-0} \
            2>/dev/null |
          # Example `lsof` output:
          # p70752
          # cgst-launch-0.10
          # Lstb-tester
          # n/dev/blackmagic0
          awk '/^p/ { printf "\n" }
                    { sub(/^./, ""); printf $0 " " }')
        echo "Blackmagic card in use: $users" > failure-reason
        cp failure-reason failure-reason.manual
        echo "Blackmagic card in use; exiting."
        return 1

      # Even if the card has no video connected to its input you see
      # "VideoInputFrameArrived: Frame received - No input signal detected"
      elif ! grep -q VideoInputFrameArrived decklinksrc.log; then
        echo "Blackmagic card froze" > failure-reason
        cp failure-reason failure-reason.manual
        echo "Blackmagic card froze; exiting."
        return 1
      fi
      ;;
  esac
}

trap on_term sigterm
on_term() {
    # Ignore SIGTERM.  It will have been sent to the whole process group, but we
    # want this process to finish running to write out the right results files.
    true;
}

main "$@"
