const QUOTE = '"';
const ESCAPE_CHAR = '\\';

export default class StringExtractor {
  private state: StringExtractorState;
  private foundStrings: string[] = [];
  private currentString: string = '';
  private source: string;

  constructor(source: string) {
    this.state = this.instantiateNewState(LookingForStringState);
    this.source = source;
  }

  public extract(): string[] {
    for (const char of this.source) {
      this.state.consume(char);
    }

    return this.foundStrings;
  }

  private setState(NewStateConstructor: StringExtractorStateConstructor) {
    this.state = this.instantiateNewState(NewStateConstructor);
  }

  private instantiateNewState(NewStateConstructor: StringExtractorStateConstructor) {
    return new NewStateConstructor(
      this,
      this.setState.bind(this),
      this.addChar.bind(this),
      this.finishString.bind(this)
    );
  }

  private addChar(char: string) {
    this.currentString += char;
  }

  private finishString(): void {
    this.foundStrings.push(this.currentString);
    this.currentString = '';
  }
}

type StringExtractorStateConstructor = new (...args: StringExtractorConstructorArgs) => StringExtractorState;
type StringExtractorConstructorArgs = [
  StringExtractor,
  OnStateChanged,
  OnCharFound,
  OnStringFinished
];
type OnStateChanged = (stateConstructor: StringExtractorStateConstructor) => void;
type OnCharFound = (char: string) => void;
type OnStringFinished = () => void;

abstract class StringExtractorState {
  protected stringExtractor: StringExtractor;
  protected onStateChanged: OnStateChanged;
  protected onCharFound: OnCharFound;
  protected onStringFinished: OnStringFinished;

  constructor(...args: StringExtractorConstructorArgs) {
    [
      this.stringExtractor,
      this.onStateChanged,
      this.onCharFound,
      this.onStringFinished
    ] = args;
  }

  abstract consume(char: string): void;
}

class LookingForStringState extends StringExtractorState {
  consume(char: string): void {
    if (char === ESCAPE_CHAR) {
      this.changeState(LookingForStringAndEscapingState);
      return;
    }

    if (char === QUOTE) {
      this.changeState(InStringState);
      return;
    }
  }

  private changeState(newStateConstructor: typeof LookingForStringAndEscapingState | typeof InStringState): void {
    this.onStateChanged(newStateConstructor);
  }
}

class LookingForStringAndEscapingState extends StringExtractorState {
  consume(_char: string): void {
    return this.changeState(LookingForStringState);
  }

  private changeState(newStateConstructor: typeof LookingForStringState) {
    this.onStateChanged(newStateConstructor);
  }
}

class InStringState extends StringExtractorState {
  consume(char: string): void {
    if (char === ESCAPE_CHAR) {
      this.changeState(InStringAndEscapingState);
      return;
    }

    if (char === QUOTE) {
      this.onStringFinished();
      this.changeState(LookingForStringState);
      return;
    }

    this.onCharFound(char);
  }

  private changeState(newStateConstructor: typeof InStringAndEscapingState | typeof LookingForStringState) {
    this.onStateChanged(newStateConstructor);
  }
}

class InStringAndEscapingState extends StringExtractorState {
  consume(char: string): void {
    this.onCharFound(char);
    this.changeState(InStringState);
  }

  private changeState(newStateConstructor: typeof InStringState) {
    this.onStateChanged(newStateConstructor);
  }
}