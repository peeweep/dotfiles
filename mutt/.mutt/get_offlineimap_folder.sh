#!/usr/bin/env bash

if [[ -f ~/offlineimap.log ]]; then
  rm ~/offlineimap.log
fi

offlineimap --info -l ~/offlineimap.log

start_line=$(("$(grep -n 'INFO: Folderlist' ~/offlineimap.log | head -n 1 | awk -F ':' '{print $1}')" + 1))
end_line=$(("$(grep -n 'INFO: Folderlist' ~/offlineimap.log | tail -n 1 | awk -F ':' '{print $1}')" - 3))

echo -e "\n\n\n\n\n\n\n\n\n\nOutput formatted folder:\n"
sed -n "${start_line},${end_line}p" ~/offlineimap.log | sed 's/\//./g;s/^[ ]*//g' | grep -Ev "(disabled)" |
  while read line; do
    echo +\"${line}\" \\
  done

rm ~/offlineimap.log
