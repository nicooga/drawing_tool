import { strict as assert } from 'assert';
import StringExtractor from './StringExtractor';

(function testMultipleScenarios() {
  const sourceCode = `
    "Some source code"
    this is not a string
    "this is a string"
    he hey { }
    thisAlso("this is a string with \\"escaped\\" quotes")
  `;
  const stringExtractor = new StringExtractor(sourceCode);
  assert.deepEqual(stringExtractor.extract(), [
    "Some source code",
    "this is a string",
    'this is a string with "escaped" quotes'
  ]);
})();

(function testSourceCodeWithEscapedQuotes() {
  const sourceCode = '"this is a string with \\"escaped quotes\\""';
  const stringExtractor = new StringExtractor(sourceCode);
  assert.deepEqual(stringExtractor.extract(), ['this is a string with "escaped quotes"']);
})();

(function testSourceCodeThatStartsWithAnEscapedQuote() {
  const sourceCode = 'blah blah \\"this is not a string\\". But, "this is a string"';
  const stringExtractor = new StringExtractor(sourceCode);
  assert.deepEqual(stringExtractor.extract(), ['this is a string']);
})();

console.log("Yey, all tests passed!!");