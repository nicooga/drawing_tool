import { strict as assert } from 'assert';
import fs from 'fs';
import peg from "pegjs";

const grammar = fs.readFileSync('./time.pegjs', 'utf8');
const parser = peg.generate(grammar);

iterate({ from: 0, to: 23 }, hour => {
  iterate({ from: 0, to: 59 }, minute => {
    const timeStr = buildTimeString(hour, minute);
    const expected = hour * 60 + minute

    assertParsedCorrectly(timeStr, expected);
  });
});

["am", "pm"].forEach(amOrPm => {
  iterate({ from: 0, to: 12 }, hour => {
    iterate({ from: 0, to: 59 }, minute => {
      const timeStr = buildTimeString(hour, minute, amOrPm);
      const offset = amOrPm === "pm" ? 12 * 60 : 0
      const expected = hour * 60 + minute + offset;

      assertParsedCorrectly(timeStr, expected);
    });
  });
});

console.log("All tests passed");

function iterate({ from, to }, fn) {
  for (let i = from; i <= to; i++) {
    fn(i);
  }
}

function iterateTimes(n, fn) {
  iterate({ from: 0, to: n -1 }, fn);
}

function assertParsedCorrectly(timeStr, expected) {
  const parsedTimeStr = parser.parse(timeStr);

  logParsing(timeStr, parsedTimeStr)

  assert.equal(
    parsedTimeStr,
    expected,
    `Expected date "${timeStr} to parse to ${expected}. Instead got ${parsedTimeStr}"`
  );
}

function logParsing(toBeParsed, parsed) {
  if (!process.env.DEBUG) return;
  console.debug(toBeParsed + " parsed to => " + parsed);
}

function buildTimeString(hour, minute, amOrPm = '') {
  const hourStr = pad(hour, 2);
  const minuteStr = pad(minute, 2);

  return hourStr + ":" + minuteStr + amOrPm;
}

function pad(n, padding) {
  let str = n.toString();
  const paddingToAdd = padding - str.length;

  if (paddingToAdd > 0) {
    iterateTimes(paddingToAdd, () => {
      str = "0" + str;
    });
  }

  return str;
}