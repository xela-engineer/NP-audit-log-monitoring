#!/bin/bash

# E.G. /var/home/core/np_audit_log_montioring/log/
export logPath=$1
# E.G. smtp://smtp.gmail.com:587
export smtpServer=$2
# E.G. alex.working.space2@gmail.com
export smtpUser=$3
export smtpRcpt=$4
export smtpPW=$5

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
}

send_email(){
  time=""
  tempFileName="$logPath/"
  echo "From: “Robot” <testing@gmail.com>" >> tempFileName
  echo "To: “AAAA woo” <alex23woo@gmail.com>" >> tempFileName
  echo "" >> tempFileName
  echo "Raw Log: {raw_log}" >> tempFileName

  curl  --ssl-reqd --url "$smtpServer" \
    --user "$userAndPW" --mail-from "$smtpUser" \
    --mail-rcpt "$smtpRcpt" --upload-file /var/home/core/np_audit_log_montioring/message.txt

}

start_monitoring() {
  while :; do
    echo "Start tailing log"
    tail -f /var/log/ovn/acl-audit-log.log | grep  --line-buffered "flags=psh|ack" | grep  --line-buffered "0a:58:0a:83:00:0f" | xargs -I {} echo "Detected Alert: {}"
    echo "End tailing log"
  done

  return 0
}

echo "logpath : $logPath"
send_email
start_monitoring
