If your AWS account has "must MFA" access then typically you can't do
much from the CLI until you get temporary credentials.

# Files in this repository

## aws-mfa-manager

This is the main script used to manage MFA credentials.  `aws-mfa-manager`
is invoked as `aws-mfa-manager <COMMAND> [<OPTION>...]`, where COMMAND
tells `aws-mfa-manager` what operation to perform, and OPTIONs may
customize how the operation is performed.

`aws-mfa-manager` helps you manage your environment by writing shell
commands to STDOUT that are suitable for evaluating in your shell session.
You would typically use `aws-mfa-manager` with a command such as:


    eval "$(aws-mfa-manager setup)"

`aws-mfa-manager` accepts the following commands:

* `help` or `usage` - Show brief usage information.
* `setup` - Talk to the AWS endpoints to discover your account and what
  MFA token is assigned then request the credentials and allow them to be
  exported.

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
