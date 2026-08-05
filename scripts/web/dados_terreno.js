/* Terreno vetorial do Andar 1 — desenhado por código, alinhado com dados_mapa.js.
   -------------------------------------------------------------------------
   A geografia NASCE das mesmas coordenadas dos pontos, então nunca desalinha.
   Sistema de coordenadas: viewBox 0 0 1536 1024 (o mesmo do mapa).
   As features são desenhadas na ordem desta lista (de trás pra frente).

   tipos:
     massa      contorno do andar (a ilha flutuante) + costa
     campo      planície; opcional flor:true, seco:true
     lavoura    campo cultivado com sulcos
     agua       forma: lago | rio | brejo | poco
     floresta   mata em camadas
     montanha   cadeia com sombra e neve
     colina     lombadas
     penhasco   borda cortada com hachura
     ruina      muro quebrado
     estrada    caminho com contorno
     cidade     muralha, anéis, ruas, quarteirões, portões
     vila       telhados
     torre      labirinto | relogio | caverna
     castelo    bloco escuro com torres
     ilha       ilhota
     rotulo     nome de acidente geográfico
*/

var TERRENO = [
  /* ---------------- a ilha ---------------- */
  {tipo:"massa", cx:768, cy:512, rx:742, ry:474, seed:7, irregular:0.05},

  /* ---------------- planícies ---------------- */
  {tipo:"campo", cx:615, cy:470, rx:225, ry:158, seed:11},
  {tipo:"campo", cx:985, cy:452, rx:215, ry:150, seed:12, seco:true},
  {tipo:"campo", cx:665, cy:645, rx:165, ry:108, seed:13},
  {tipo:"campo", cx:400, cy:205, rx:145, ry:92,  seed:14, flor:true},
  {tipo:"campo", cx:760, cy:944, rx:245, ry:112, seed:15, seco:true},
  {tipo:"campo", cx:1120, cy:250, rx:170, ry:110, seed:16, seco:true},
  {tipo:"campo", cx:300, cy:430, rx:150, ry:120, seed:17},

  /* ---------------- lavoura ---------------- */
  {tipo:"lavoura", cx:1182, cy:594, w:168, h:92, linhas:7, ang:-8},
  {tipo:"lavoura", cx:1098, cy:566, w:132, h:70, linhas:6, ang:7},

  /* ---------------- água ---------------- */
  {tipo:"agua", forma:"rio", pontos:[[128,96],[150,190],[168,286],[142,372],[178,462],[152,556],[206,660],[262,762],[300,846]], largura:19},
  {tipo:"agua", forma:"lago", cx:938, cy:742, rx:182, ry:116, seed:21},
  {tipo:"agua", forma:"brejo", cx:856, cy:858, rx:128, ry:66, seed:22},
  {tipo:"agua", forma:"brejo", cx:1416, cy:604, rx:132, ry:96, seed:23},
  {tipo:"agua", forma:"poco", cx:1452, cy:764, rx:54, ry:34, seed:24},

  /* ---------------- mata ---------------- */
  {tipo:"floresta", cx:255, cy:702, rx:196, ry:142, seed:31, densidade:52},
  {tipo:"floresta", cx:108, cy:492, rx:118, ry:112, seed:32, densidade:26, palida:true},
  {tipo:"floresta", cx:322, cy:566, rx:88,  ry:64,  seed:33, densidade:16},
  {tipo:"floresta", cx:668, cy:232, rx:104, ry:64,  seed:34, densidade:18},
  {tipo:"floresta", cx:1086, cy:694, rx:110, ry:76, seed:35, densidade:20},
  {tipo:"floresta", cx:962, cy:902, rx:118, ry:64, seed:36, densidade:18},
  {tipo:"floresta", cx:470, cy:840, rx:110, ry:74, seed:37, densidade:18},
  {tipo:"floresta", cx:1250, cy:392, rx:92,  ry:62, seed:38, densidade:14},

  /* ---------------- relevo ---------------- */
  {tipo:"montanha", x1:262, x2:812, y:112, picos:11, altura:74, seed:41},
  {tipo:"montanha", x1:52,  x2:246, y:212, picos:5,  altura:52, seed:42},
  {tipo:"montanha", x1:1300, x2:1470, y:150, picos:4, altura:46, seed:43},
  {tipo:"colina",   x1:1152, x2:1372, y:186, lombadas:6, altura:30},
  {tipo:"colina",   x1:1030, x2:1206, y:596, lombadas:5, altura:22},
  {tipo:"colina",   x1:480,  x2:640,  y:398, lombadas:4, altura:18},
  {tipo:"penhasco", pontos:[[1286,236],[1354,258],[1408,302],[1424,368],[1400,430]]},

  /* ---------------- ruínas ---------------- */
  {tipo:"ruina", cx:427, cy:834, w:160, h:76, blocos:11},
  {tipo:"ruina", cx:756, cy:948, w:210, h:66, blocos:13},
  {tipo:"ruina", cx:1450, cy:748, w:126, h:84, blocos:8},
  {tipo:"ruina", cx:634, cy:502, w:64,  h:32, blocos:4},

  /* ---------------- estradas ---------------- */
  {tipo:"estrada", pontos:[[804,440],[889,478],[974,520],[1061,508],[1144,481]]},
  {tipo:"estrada", pontos:[[804,440],[714,454],[649,483],[600,480]]},
  {tipo:"estrada", pontos:[[804,440],[885,451],[950,462],[982,458]]},
  {tipo:"estrada", pontos:[[600,480],[480,556],[356,640],[258,700]]},
  {tipo:"estrada", pontos:[[804,440],[807,331],[806,237],[808,146]]},
  {tipo:"estrada", pontos:[[1144,481],[1031,330],[931,204],[862,124]]},
  {tipo:"estrada", pontos:[[982,458],[1002,556],[962,662],[938,722]]},
  {tipo:"estrada", pontos:[[600,480],[624,568],[658,624]]},
  {tipo:"estrada", pontos:[[258,700],[353,772],[427,826]]},
  {tipo:"estrada", pontos:[[982,458],[1109,536],[1180,592]]},
  {tipo:"estrada", pontos:[[168,286],[132,378]], tracejada:true},
  {tipo:"estrada", pontos:[[804,440],[713,579],[671,753],[756,906],[952,900]], tracejada:true},

  /* ---------------- assentamentos ---------------- */
  {tipo:"cidade", cx:804, cy:440, r:78, aneis:3, ruas:14, portoes:4},
  {tipo:"cidade", cx:1144, cy:479, r:46, aneis:2, ruas:9, portoes:3},
  {tipo:"vila", cx:252, cy:700, casas:10, raio:36},
  {tipo:"vila", cx:130, cy:380, casas:8, raio:30},
  {tipo:"vila", cx:655, cy:620, casas:7, raio:28, barracas:true},

  /* ---------------- marcos ---------------- */
  {tipo:"castelo", cx:782, cy:269, w:78, h:58},
  {tipo:"torre", cx:810, cy:104, w:100, h:100, tipoTorre:"labirinto"},
  {tipo:"torre", cx:500, cy:352, w:26, h:54, tipoTorre:"relogio", inclinada:true},
  {tipo:"torre", cx:100, cy:205, w:36, h:28, tipoTorre:"caverna"},
  {tipo:"torre", cx:1254, cy:388, w:36, h:28, tipoTorre:"caverna", brilho:true},
  {tipo:"ilha", cx:900, cy:702, r:24},

  /* ---------------- rótulos de geografia ---------------- */
  {tipo:"rotulo", x:938, y:742, txt:"Lago Sylvaine", classe:"agua", dy:6},
  {tipo:"rotulo", x:152, y:330, txt:"Rio Coluber", classe:"agua", ang:-72},
  {tipo:"rotulo", x:255, y:702, txt:"Floresta de Horunka", classe:"mata", dy:-118},
  {tipo:"rotulo", x:530, y:56, txt:"Montanhas de Grauvenn", classe:"pedra"},
  {tipo:"rotulo", x:1416, y:604, txt:"Pântano de Kavir", classe:"agua", dy:74},
  {tipo:"rotulo", x:756, y:948, txt:"Campo de Ruyn", classe:"pedra", dy:52},
  {tipo:"rotulo", x:1262, y:170, txt:"Colinas de Braxhold", classe:"pedra", dy:-42},
  {tipo:"rotulo", x:108, y:492, txt:"Bosque de Ashwen", classe:"mata", dy:-92},
  {tipo:"rotulo", x:1412, y:372, txt:"Penhascos de Vaelor", classe:"pedra", ancora:"end", dy:38},
  {tipo:"rotulo", x:400, y:205, txt:"Jardim de Fenwyth", classe:"mata", dy:-74},
  {tipo:"rotulo", x:615, y:470, txt:"Planície de Verrun", classe:"campo", dy:96},
  {tipo:"rotulo", x:985, y:452, txt:"Estepes de Kaldan", classe:"campo", dy:-96},
  {tipo:"rotulo", x:1182, y:594, txt:"Vale de Molwyn", classe:"campo", dy:-62}
];
