{
  function digitsToInteger(digitsAry) {
    return [...digitsAry].reverse().reduce(
      (acc, digit, index) => {
        return acc + parseInt(digit || 0) * 10 ** index
      },
      0
    );
  }
}
Time = time:(TwelveHourTime / MilitaryTime) {
  const [hours, minutes] = time;
  return hours * 60 + minutes;
}

MilitaryTime = hours:MilitaryHour ":" minutes:Minute {
  return [hours, minutes];
}
MilitaryHour = digits:(
  ("0" Digit)
  / ("1" Digit)
  / ("2" [0-3])
) { return digitsToInteger(digits); }

TwelveHourTime = hours:TwelveHourHour ":" minutes:Minute offset:AmPm {
  return [hours + offset, minutes];
}
TwelveHourHour = digits:(("1" [0-2]) / ("0"? Digit)) {
  return digitsToInteger(digits);
}
AmPm = AM / PM
AM = "am" { return 0; }
PM = "pm" { return 12; }

Minute = digits:([0-5] Digit) {
  return digitsToInteger(digits);
}
Digit = [0-9]