// Executa um dados_*.js (JS de verdade, nao JSON — tem concatenacao de
// string com +, chave sem aspas, etc.) numa sandbox e devolve todo `var`
// de nivel superior como um unico JSON pro stdout. Usado por
// scripts/migrar_para_supabase.py em vez de tentar reparsear JS na mao.
const vm = require("vm");
const fs = require("fs");

const caminho = process.argv[2];
const codigo = fs.readFileSync(caminho, "utf-8");
const sandbox = {};
vm.createContext(sandbox);
vm.runInContext(codigo, sandbox, { filename: caminho });

const saida = {};
for (const chave of Object.keys(sandbox)) {
  if (typeof sandbox[chave] !== "function") {
    saida[chave] = sandbox[chave];
  }
}
process.stdout.write(JSON.stringify(saida));
