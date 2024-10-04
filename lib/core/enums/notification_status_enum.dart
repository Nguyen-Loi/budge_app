enum NotificationStatusEnum {
  sent('SENT'),
  delivered('DELIVERED'),
  read('READ');

  final String value;
  const NotificationStatusEnum(this.value);
}
