class TimeFormatterUtil{
  static String getFormattedTime(int time) {
    if (time == 0) {
      return '00:00:00';
    }

    final hours = time ~/ 3600;
    final minutes = (time % 3600) ~/ 60;
    final seconds = time % 60;

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

}