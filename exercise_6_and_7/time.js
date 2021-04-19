import path from 'path';
import fs from 'fs';
import { Grammars } from 'ebnf';

const __dirname = path.resolve();
const grammarPath = path.join(__dirname, 'time.ebnf');
const grammar = fs.readFileSync(grammarPath, 'utf8');
const parser = new Grammars.BNF.Parser(grammar);

console.log(parser);