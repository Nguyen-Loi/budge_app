enum InactiveAccountReasonEnum {
  userRequested("USER_REQUESTED"),
  inactivityTimeout("INACTIVITY_TIMEOUT"),
  accountSuspended("ACCOUNT_SUSPENDED"),
  transferNewAccount("TRANSFER_NEW_ACCOUNT");

  final String code;
  const InactiveAccountReasonEnum(this.code);
}
