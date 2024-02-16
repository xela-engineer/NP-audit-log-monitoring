#!/bin/bash

scriptPID=$$
echo "Script PID : $scriptPID"

# E.G. /var/home/core/np_audit_log_montioring/log/
export logPath=$1
# E.G. smtp://smtp.gmail.com:587
export smtpServer=$2
# E.G. alex.working.space2@gmail.com
export smtpUser=$3
export senderName=$4
export smtpRcpt=$5
export rcptName=$6
export smtpPW=$7

trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] -p param_value arg1 [arg2...]

Script description here.

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-f, --flag      Some flag description
-p, --param     Some param description
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
  exit
}

send_email(){
  rawLog=$1
  echo "Detected Alert: $rawLog"
  export TZ='Asia/Hong_Kong'
  time="`date  +'%Y%m%d%H%M'`"
  tempFileName="$logPath/message-$time-$RANDOM.txt"
  echo "file name : $tempFileName"

  touch $tempFileName
  echo "From: “$senderName” <$smtpUser>" > tempFileName
  echo "To: “$rcptName” <$smtpRcpt>" >> tempFileName
  echo "Subject: Network Policy Deny Log Detected" >> tempFileName
  echo "" >> tempFileName
  echo "Raw Log: $rawLog" >> tempFileName

  userAndPW="$smtpUser:$smtpPW"
  curl  --ssl-reqd --url "$smtpServer" \
    --user "$userAndPW" --mail-from "$smtpUser" \
    --mail-rcpt "$smtpRcpt" --upload-file tempFileName

  rm $tempFileName
}

export -f send_email

start_monitoring() {
#  while :; do
  echo "Start tailing log"
  tail -F --pid=$scriptPID /var/log/ovn/acl-audit-log.log | grep  --line-buffered "verdict=drop" | xargs -P 8 -I {} bash -c 'send_email "$@"' _ {}
  echo "End tailing log"
#    break
#  done

  return 0
}

echo "logpath : $logPath"

start_monitoring
