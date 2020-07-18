loadawskeys() {
  local credsfile=${AWS_SHARED_CREDENTIALS_FILE:-~/.aws/credentials}
  credsfile=$credsfile.${AWS_PROFILE:-default}.asc
  local creds=$(gpg2 -qdo - $credsfile)
  if [ "$creds" ] ; then
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
    eval "$creds"
    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
  else
    echo "could not read credentials from $credsfile" >&2
  fi
}

getawsmfa() {
  eval "$(aws-mfa-manager setup)"
}

clearawsmfa() {
  eval "$(aws-mfa-manager clear)"
}
