If your AWS account has "must MFA" access then typically you can't do
much from the CLI until you get temporary credentials.

# Files in this repository

## aws-mfa-manager

This is the main script used to manage MFA credentials.  `aws-mfa-manager`
is invoked as `aws-mfa-manager COMMAND [OPTION...]`, where `COMMAND`
tells `aws-mfa-manager` what operation to perform, and `OPTION`s may
customize how the operation is performed.

`aws-mfa-manager` helps you manage your environment by writing shell
commands to STDOUT that are suitable for evaluating in your shell session.
You would typically use `aws-mfa-manager` with a command such as:

    eval "$(aws-mfa-manager setup)"

### Commands

`aws-mfa-manager` accepts the following commands:

* `help` or `usage` - Show brief usage information.
* `clear` - Removes the MFA credentials from your environment that were set
  by setup.
* `setup` - Talk to the AWS endpoints to discover your account and what
  MFA token is assigned then request the credentials and allow them to be
  exported.

### Options for `setup`

The `setup` command accepts the following options:

* `-d SECONDS` or `--duration SECONDS` - When requesting a session token from
  AWS, ask that the credentials be valid for SECONDS seconds.

* `-s` or `--save-keys` - Save non-MFA access keys for use with future calls
  to `aws-mfa-manager`.

  The temporary access keys for an MFA session will replace the permanent
  access keys in a shell's environment that were used to start the MFA
  session.  You can not use access keys for an MFA session to setup
  another MFA session.  When the temporary MFA session expires, and the
  `--save-keys` option is not used, you must clear the session credentials
  then set the access key environment variables back to their original values
  before you can setup a new MFA session.

  When you use the `--save-keys` option, `aws-mfa-manager` uses alternative
  variables in the shell's environment (that to not get overwritten by MFA
  session credentials) to save a copy of the permanent access keys used to
  setup the MFA session.  `aws-mfa-manager` will restore saved keys when you
  clear an MFA session.  It will also use the saved credentials if you setup a
  new MFA session without clearing an old one.

* `-u NAME` or `--update-profile NAME` - Write credentials for the MFA
  session to the shared credentials file under the profile named NAME.

## bash-functions.gpg2.sh

This is a set of bash functions that provide an example of how someone
might use `aws-mfa-manager` with `gpg2` in a scenario where long lived
access keys are encrypted when stored on disk.  The file can be sourced
from a bash profile or an interactive shell.  It defines three functions:

* `loadawskeys` - Decrypts and loads access keys into the current
  shell environment from a file named `credentials.<PROFILE>.asc`, where
  `<PROFILE>` is the profile defined in the environment or "default" if
  `$AWS_PROFILE` is not set.  The file is expected to reside in the same
  directory as the AWS shared credentials file (`~/.aws` by default) and
  to define access keys that when decrypted are formatted as follows:

    ```
    AWS_ACCESS_KEY_ID=AKIAYSVZPRXEVA2QESMN
    AWS_SECRET_ACCESS_KEY=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
    ```

* `getawsmfa` - Uses `aws-mfa-manager` and the long-term access keys loaded
  by `loadawskeys` to obtain and add sort-term MFA based session keys to
  the current environment.

* `clearawsmfa` - Removes short-term MFA based session keys obtained using
  `getawsmfa` from the current environment.

## getaws

This is a simple function that unsets the main AWS variables
and then calls the `eval` command

    getaws myprofile

## clearaws

Just unsets the main AWS variables


# EXAMPLE

    % getaws gcsf
    You are: sweharris
    Your MFA device is: arn:aws:iam::123456789012:mfa/sweharris
    Enter your MFA code now: 299255
    Keys valid until 2017-11-04T02:12:13Z
