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

`aws-mfa-manager` accepts the following commands:

* `help` or `usage` - Show brief usage information.
* `clear` - Removes the MFA credentials from your environment that were set
  by setup.
* `setup` - Talk to the AWS endpoints to discover your account and what
  MFA token is assigned then request the credentials and allow them to be
  exported.

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
