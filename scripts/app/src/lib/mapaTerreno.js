// Mapa Artístico do Andar 1 — terreno vetorial desenhado por código.
// Porta fiel de scripts/web/dados_terreno.js + scripts/web/mapa_limpo.html
// (modo "arte" apenas — sem modo referência/export PNG, que eram só pra
// preparar imagem de IA num fluxo manual à parte, fora de escopo aqui).
//
// Sistema de coordenadas: viewBox 0 0 1536 1024 — o MESMO dos 246 pontos
// reais da tabela `pontos` (x entre 20-1506, y entre 20-1004), então o
// terreno nasce alinhado com os marcadores sem precisar de calibração.
//
// tipos: massa (contorno da ilha), campo, lavoura, agua (lago|rio|brejo|poco),
// floresta, montanha, colina, penhasco, ruina, estrada, cidade, vila, torre,
// castelo, ilha, rotulo (nome de acidente geográfico).

export const TERRENO = [
  { tipo: "massa", cx: 768, cy: 512, rx: 742, ry: 474, seed: 7, irregular: 0.05 },

  { tipo: "campo", cx: 615, cy: 470, rx: 225, ry: 158, seed: 11 },
  { tipo: "campo", cx: 985, cy: 452, rx: 215, ry: 150, seed: 12, seco: true },
  { tipo: "campo", cx: 665, cy: 645, rx: 165, ry: 108, seed: 13 },
  { tipo: "campo", cx: 400, cy: 205, rx: 145, ry: 92, seed: 14, flor: true },
  { tipo: "campo", cx: 760, cy: 944, rx: 245, ry: 112, seed: 15, seco: true },
  { tipo: "campo", cx: 1120, cy: 250, rx: 170, ry: 110, seed: 16, seco: true },
  { tipo: "campo", cx: 300, cy: 430, rx: 150, ry: 120, seed: 17 },

  { tipo: "lavoura", cx: 1182, cy: 594, w: 168, h: 92, linhas: 7, ang: -8 },
  { tipo: "lavoura", cx: 1098, cy: 566, w: 132, h: 70, linhas: 6, ang: 7 },

  { tipo: "agua", forma: "rio", pontos: [[128,96],[150,190],[168,286],[142,372],[178,462],[152,556],[206,660],[262,762],[300,846]], largura: 19 },
  { tipo: "agua", forma: "lago", cx: 938, cy: 742, rx: 182, ry: 116, seed: 21 },
  { tipo: "agua", forma: "brejo", cx: 856, cy: 858, rx: 128, ry: 66, seed: 22 },
  { tipo: "agua", forma: "brejo", cx: 1416, cy: 604, rx: 132, ry: 96, seed: 23 },
  { tipo: "agua", forma: "poco", cx: 1452, cy: 764, rx: 54, ry: 34, seed: 24 },

  { tipo: "floresta", cx: 255, cy: 702, rx: 196, ry: 142, seed: 31, densidade: 52 },
  { tipo: "floresta", cx: 108, cy: 492, rx: 118, ry: 112, seed: 32, densidade: 26, palida: true },
  { tipo: "floresta", cx: 322, cy: 566, rx: 88, ry: 64, seed: 33, densidade: 16 },
  { tipo: "floresta", cx: 668, cy: 232, rx: 104, ry: 64, seed: 34, densidade: 18 },
  { tipo: "floresta", cx: 1086, cy: 694, rx: 110, ry: 76, seed: 35, densidade: 20 },
  { tipo: "floresta", cx: 962, cy: 902, rx: 118, ry: 64, seed: 36, densidade: 18 },
  { tipo: "floresta", cx: 470, cy: 840, rx: 110, ry: 74, seed: 37, densidade: 18 },
  { tipo: "floresta", cx: 1250, cy: 392, rx: 92, ry: 62, seed: 38, densidade: 14 },

  { tipo: "montanha", x1: 262, x2: 812, y: 112, picos: 11, altura: 74, seed: 41 },
  { tipo: "montanha", x1: 52, x2: 246, y: 212, picos: 5, altura: 52, seed: 42 },
  { tipo: "montanha", x1: 1300, x2: 1470, y: 150, picos: 4, altura: 46, seed: 43 },
  { tipo: "colina", x1: 1152, x2: 1372, y: 186, lombadas: 6, altura: 30 },
  { tipo: "colina", x1: 1030, x2: 1206, y: 596, lombadas: 5, altura: 22 },
  { tipo: "colina", x1: 480, x2: 640, y: 398, lombadas: 4, altura: 18 },
  { tipo: "penhasco", pontos: [[1286,236],[1354,258],[1408,302],[1424,368],[1400,430]] },

  { tipo: "ruina", cx: 427, cy: 834, w: 160, h: 76, blocos: 11 },
  { tipo: "ruina", cx: 756, cy: 948, w: 210, h: 66, blocos: 13 },
  { tipo: "ruina", cx: 1450, cy: 748, w: 126, h: 84, blocos: 8 },
  { tipo: "ruina", cx: 634, cy: 502, w: 64, h: 32, blocos: 4 },

  { tipo: "estrada", pontos: [[804,440],[889,478],[974,520],[1061,508],[1144,481]] },
  { tipo: "estrada", pontos: [[804,440],[714,454],[649,483],[600,480]] },
  { tipo: "estrada", pontos: [[804,440],[885,451],[950,462],[982,458]] },
  { tipo: "estrada", pontos: [[600,480],[480,556],[356,640],[258,700]] },
  { tipo: "estrada", pontos: [[804,440],[807,331],[806,237],[808,146]] },
  { tipo: "estrada", pontos: [[1144,481],[1031,330],[931,204],[862,124]] },
  { tipo: "estrada", pontos: [[982,458],[1002,556],[962,662],[938,722]] },
  { tipo: "estrada", pontos: [[600,480],[624,568],[658,624]] },
  { tipo: "estrada", pontos: [[258,700],[353,772],[427,826]] },
  { tipo: "estrada", pontos: [[982,458],[1109,536],[1180,592]] },
  { tipo: "estrada", pontos: [[168,286],[132,378]], tracejada: true },
  { tipo: "estrada", pontos: [[804,440],[713,579],[671,753],[756,906],[952,900]], tracejada: true },

  { tipo: "cidade", cx: 804, cy: 440, r: 78, aneis: 3, ruas: 14, portoes: 4 },
  { tipo: "cidade", cx: 1144, cy: 479, r: 46, aneis: 2, ruas: 9, portoes: 3 },
  { tipo: "vila", cx: 252, cy: 700, casas: 10, raio: 36 },
  { tipo: "vila", cx: 130, cy: 380, casas: 8, raio: 30 },
  { tipo: "vila", cx: 655, cy: 620, casas: 7, raio: 28, barracas: true },

  { tipo: "castelo", cx: 782, cy: 269, w: 78, h: 58 },
  { tipo: "torre", cx: 810, cy: 104, w: 100, h: 100, tipoTorre: "labirinto" },
  { tipo: "torre", cx: 500, cy: 352, w: 26, h: 54, tipoTorre: "relogio", inclinada: true },
  { tipo: "torre", cx: 100, cy: 205, w: 36, h: 28, tipoTorre: "caverna" },
  { tipo: "torre", cx: 1254, cy: 388, w: 36, h: 28, tipoTorre: "caverna", brilho: true },
  { tipo: "ilha", cx: 900, cy: 702, r: 24 },

  { tipo: "rotulo", x: 938, y: 742, txt: "Lago Sylvaine", classe: "agua", dy: 6 },
  { tipo: "rotulo", x: 152, y: 330, txt: "Rio Coluber", classe: "agua", ang: -72 },
  { tipo: "rotulo", x: 255, y: 702, txt: "Floresta de Horunka", classe: "mata", dy: -118 },
  { tipo: "rotulo", x: 530, y: 56, txt: "Montanhas de Grauvenn", classe: "pedra" },
  { tipo: "rotulo", x: 1416, y: 604, txt: "Pântano de Kavir", classe: "agua", dy: 74 },
  { tipo: "rotulo", x: 756, y: 948, txt: "Campo de Ruyn", classe: "pedra", dy: 52 },
  { tipo: "rotulo", x: 1262, y: 170, txt: "Colinas de Braxhold", classe: "pedra", dy: -42 },
  { tipo: "rotulo", x: 108, y: 492, txt: "Bosque de Ashwen", classe: "mata", dy: -92 },
  { tipo: "rotulo", x: 1412, y: 372, txt: "Penhascos de Vaelor", classe: "pedra", ancora: "end", dy: 38 },
  { tipo: "rotulo", x: 400, y: 205, txt: "Jardim de Fenwyth", classe: "mata", dy: -74 },
  { tipo: "rotulo", x: 615, y: 470, txt: "Planície de Verrun", classe: "campo", dy: 96 },
  { tipo: "rotulo", x: 985, y: 452, txt: "Estepes de Kaldan", classe: "campo", dy: -96 },
  { tipo: "rotulo", x: 1182, y: 594, txt: "Vale de Molwyn", classe: "campo", dy: -62 },
]

// paleta "arte" (única portada — a "referência" do legado era só insumo
// pra gerador de imagem externo, não faz sentido dentro do jogo)
const P = {
  terra: "#2c3a25", campo: "#2f3d26", campoSeco: "#3a3d24", campoFlor: "#3d4526",
  mata: "#1f3320", matales: ["#1a2c16", "#24391f", "#2f4726"],
  agua: "#265b7c", aguaFunda: "#16384e", brejo: "#2c4239", rocha: "#4a4740", neve: "#c3c0b1",
  colina: "#3d452f", estrada: "#94805a", cidade: "#241c11", muro: "#8c6f3e", telhado: "#50331f",
  ruina: "#4a463d", lavoura: "#3f4927", costa: "#4f6240",
}

const NS = "http://www.w3.org/2000/svg"
function el(t, a) {
  const e = document.createElementNS(NS, t)
  for (const k in a) e.setAttribute(k, a[k])
  return e
}
function rnd(seed) {
  const x = Math.sin(seed * 9301 + 49297) * 233280
  return x - Math.floor(x)
}
function fechada(p) {
  const n = p.length
  let d = "M" + p[0][0].toFixed(1) + " " + p[0][1].toFixed(1)
  for (let i = 0; i < n; i++) {
    const p0 = p[(i - 1 + n) % n], p1 = p[i], p2 = p[(i + 1) % n], p3 = p[(i + 2) % n]
    d += "C" + (p1[0] + (p2[0] - p0[0]) / 6).toFixed(1) + " " + (p1[1] + (p2[1] - p0[1]) / 6).toFixed(1) +
      "," + (p2[0] - (p3[0] - p1[0]) / 6).toFixed(1) + " " + (p2[1] - (p3[1] - p1[1]) / 6).toFixed(1) +
      "," + p2[0].toFixed(1) + " " + p2[1].toFixed(1)
  }
  return d + "Z"
}
function aberta(p) {
  if (p.length < 2) return ""
  let d = "M" + p[0][0] + " " + p[0][1]
  for (let i = 0; i < p.length - 1; i++) {
    const p0 = p[Math.max(0, i - 1)], p1 = p[i], p2 = p[i + 1], p3 = p[Math.min(p.length - 1, i + 2)]
    d += "C" + (p1[0] + (p2[0] - p0[0]) / 6).toFixed(1) + " " + (p1[1] + (p2[1] - p0[1]) / 6).toFixed(1) +
      "," + (p2[0] - (p3[0] - p1[0]) / 6).toFixed(1) + " " + (p2[1] - (p3[1] - p1[1]) / 6).toFixed(1) +
      "," + p2[0].toFixed(1) + " " + p2[1].toFixed(1)
  }
  return d
}
function blob(cx, cy, rx, ry, seed, irr, lados) {
  lados = lados || 16
  irr = irr == null ? 0.14 : irr
  const pts = []
  for (let i = 0; i < lados; i++) {
    const ang = (i / lados) * Math.PI * 2
    const r1 = rx * (1 - irr + rnd(seed + i) * irr * 2)
    const r2 = ry * (1 - irr + rnd(seed + i + 99) * irr * 2)
    pts.push([cx + Math.cos(ang) * r1, cy + Math.sin(ang) * r2])
  }
  return fechada(pts)
}
function contornoDoAndar(f, pontosReais) {
  const pts = pontosReais.map((p) => [p.x, p.y])
  TERRENO.forEach((t) => {
    if (t.cx != null && t.rx != null && t.tipo !== "massa") {
      ;[[t.cx - t.rx, t.cy], [t.cx + t.rx, t.cy], [t.cx, t.cy - t.ry], [t.cx, t.cy + t.ry]].forEach((q) => pts.push(q))
    }
    if (t.pontos) t.pontos.forEach((q) => pts.push(q))
    if (t.x1 != null) pts.push([t.x1, t.y], [t.x2, t.y])
  })
  pts.sort((a, b) => a[0] - b[0] || a[1] - b[1])
  function cross(o, a, b) { return (a[0] - o[0]) * (b[1] - o[1]) - (a[1] - o[1]) * (b[0] - o[0]) }
  const baixo = [], alto = []
  for (let i = 0; i < pts.length; i++) {
    while (baixo.length >= 2 && cross(baixo[baixo.length - 2], baixo[baixo.length - 1], pts[i]) <= 0) baixo.pop()
    baixo.push(pts[i])
  }
  for (let i = pts.length - 1; i >= 0; i--) {
    while (alto.length >= 2 && cross(alto[alto.length - 2], alto[alto.length - 1], pts[i]) <= 0) alto.pop()
    alto.push(pts[i])
  }
  const casco = baixo.slice(0, -1).concat(alto.slice(0, -1))
  let cx = 0, cy = 0
  casco.forEach((q) => { cx += q[0]; cy += q[1] })
  cx /= casco.length; cy /= casco.length
  const margem = 34
  const exp = casco.map((q, k) => {
    const dx = q[0] - cx, dy = q[1] - cy, len = Math.sqrt(dx * dx + dy * dy) || 1
    const extra = margem * (0.82 + rnd((f.seed || 7) + k * 3) * 0.42)
    return [Math.max(10, Math.min(1526, cx + dx + (dx / len) * extra)),
            Math.max(10, Math.min(1014, cy + dy + (dy / len) * extra))]
  })
  const alvo = 30, denso = []
  for (let i = 0; i < alvo; i++) {
    const t2 = (i / alvo) * exp.length
    const a = exp[Math.floor(t2) % exp.length], b = exp[(Math.floor(t2) + 1) % exp.length]
    const fr = t2 - Math.floor(t2)
    denso.push([a[0] + (b[0] - a[0]) * fr, a[1] + (b[1] - a[1]) * fr])
  }
  return fechada(denso)
}

/** Desenha o terreno artístico dentro de gTerreno (limpa o conteúdo antes).
 *  pontosReais: array de {x,y} (a própria lista carregada de `pontos`/`pontos_publico`
 *  — mesmo sistema de coordenadas, então o contorno da ilha nasce alinhado). */
export function desenharTerreno(gTerreno, pontosReais) {
  gTerreno.textContent = ""
  const c = P
  function add(tag, attrs, pai) {
    const e = el(tag, attrs)
    ;(pai || gTerreno).appendChild(e)
    return e
  }
  const defs = add("defs", {})
  const g = el("radialGradient", { id: "gTerraArt", cx: "50%", cy: "36%", r: "74%" })
  ;[["0%", "#36462d"], ["55%", "#2c3a25"], ["100%", "#20291b"]].forEach((q) => {
    g.appendChild(el("stop", { offset: q[0], "stop-color": q[1] }))
  })
  defs.appendChild(g)

  TERRENO.forEach((f) => {
    if (f.tipo === "massa") {
      const d = pontosReais.length >= 3 ? contornoDoAndar(f, pontosReais) : blob(f.cx, f.cy, f.rx, f.ry, f.seed, f.irregular, 24)
      add("path", { d, fill: "none", stroke: "#080c08", "stroke-width": 38, opacity: .6 })
      add("path", { d, fill: "none", stroke: "#71845d", "stroke-width": 10, opacity: .25 })
      add("path", { d, fill: "url(#gTerraArt)", stroke: c.costa, "stroke-width": 2.5 })
      const cp = el("clipPath", { id: "clipIlhaArt" })
      cp.appendChild(el("path", { d }))
      defs.appendChild(cp)
      gTerreno.setAttribute("clip-path", "url(#clipIlhaArt)")
    } else if (f.tipo === "campo") {
      add("path", { d: blob(f.cx, f.cy, f.rx, f.ry, f.seed, 0.17, 14), fill: f.flor ? c.campoFlor : (f.seco ? c.campoSeco : c.campo), opacity: .92 })
    } else if (f.tipo === "lavoura") {
      const gg = add("g", { transform: `rotate(${f.ang} ${f.cx} ${f.cy})` })
      add("rect", { x: f.cx - f.w / 2, y: f.cy - f.h / 2, width: f.w, height: f.h, rx: 6, fill: c.lavoura, stroke: "#5a6636", "stroke-width": 1.2 }, gg)
      for (let l = 1; l < f.linhas; l++) {
        const yy = f.cy - f.h / 2 + (f.h / f.linhas) * l
        add("line", { x1: f.cx - f.w / 2 + 5, y1: yy, x2: f.cx + f.w / 2 - 5, y2: yy, stroke: "#616f3a", "stroke-width": 1.4, opacity: .9 }, gg)
      }
    } else if (f.tipo === "agua") {
      if (f.forma === "rio") {
        add("path", { d: aberta(f.pontos), fill: "none", stroke: c.aguaFunda, "stroke-width": f.largura + 8, "stroke-linecap": "round" })
        add("path", { d: aberta(f.pontos), fill: "none", stroke: c.agua, "stroke-width": f.largura, "stroke-linecap": "round" })
      } else if (f.forma === "brejo") {
        add("path", { d: blob(f.cx, f.cy, f.rx, f.ry, f.seed, 0.24, 16), fill: c.brejo })
        add("path", { d: blob(f.cx, f.cy, f.rx * .7, f.ry * .66, f.seed + 9, 0.3, 14), fill: c.agua, opacity: .62 })
      } else {
        add("path", { d: blob(f.cx, f.cy, f.rx, f.ry, f.seed, 0.08, 20), fill: c.aguaFunda, stroke: c.agua, "stroke-width": 5 })
        add("path", { d: blob(f.cx, f.cy, f.rx * .9, f.ry * .87, f.seed + 4, 0.09, 20), fill: c.agua })
      }
    } else if (f.tipo === "floresta") {
      add("path", { d: blob(f.cx, f.cy, f.rx, f.ry, f.seed, 0.19, 16), fill: f.palida ? "#26372f" : c.mata, opacity: .95 })
      for (let t = 0; t < f.densidade; t++) {
        const an = rnd(f.seed + t * 3) * Math.PI * 2, ra = Math.sqrt(rnd(f.seed + t * 3 + 40))
        const x2 = f.cx + Math.cos(an) * f.rx * ra * .93, y2 = f.cy + Math.sin(an) * f.ry * ra * .89
        const rr2 = 4.5 + rnd(f.seed + t + 9) * 6
        add("circle", { cx: (x2 + 1.5).toFixed(1), cy: (y2 + 1.8).toFixed(1), r: rr2.toFixed(1), fill: "#0d160b", opacity: .55 })
        add("circle", { cx: x2.toFixed(1), cy: y2.toFixed(1), r: rr2.toFixed(1), fill: c.matales[t % 3], stroke: "#0f1a0d", "stroke-width": .7 })
      }
    } else if (f.tipo === "montanha") {
      const larg = (f.x2 - f.x1) / f.picos
      const base = []
      for (let b = 0; b <= f.picos; b++) base.push([f.x1 + larg * b, f.y + f.altura * .5])
      add("path", { d: aberta(base) + "L" + f.x2 + " " + (f.y + f.altura * .95) + "L" + f.x1 + " " + (f.y + f.altura * .95) + "Z", fill: "#2a2823", opacity: .92 })
      for (let pk = 0; pk < f.picos; pk++) {
        const px = f.x1 + larg * pk + larg / 2, hh = f.altura * (.62 + rnd(f.seed + pk) * .72)
        const yb = f.y + f.altura * .55
        add("path", { d: "M" + (px - larg * .68).toFixed(1) + " " + yb.toFixed(1) + "L" + px.toFixed(1) + " " + (f.y - hh).toFixed(1) + "L" + (px + larg * .68).toFixed(1) + " " + yb.toFixed(1) + "Z", fill: c.rocha, stroke: "#726f63", "stroke-width": 1.1, "stroke-linejoin": "round" })
        add("path", { d: "M" + px.toFixed(1) + " " + (f.y - hh).toFixed(1) + "L" + (px + larg * .68).toFixed(1) + " " + yb.toFixed(1) + "L" + (px + larg * .1).toFixed(1) + " " + yb.toFixed(1) + "Z", fill: "#201d17", opacity: .6 })
        add("path", { d: "M" + (px - larg * .2).toFixed(1) + " " + (f.y - hh * .58).toFixed(1) + "l" + (larg * .1).toFixed(1) + " " + (hh * .11).toFixed(1) + "L" + px.toFixed(1) + " " + (f.y - hh).toFixed(1) + "l" + (larg * .2).toFixed(1) + " " + (hh * .42).toFixed(1) + "l-" + (larg * .11).toFixed(1) + " -" + (hh * .09).toFixed(1) + "Z", fill: c.neve, opacity: .88 })
      }
    } else if (f.tipo === "colina") {
      const lg = (f.x2 - f.x1) / f.lombadas
      for (let c2 = 0; c2 < f.lombadas; c2++) {
        const cx2 = f.x1 + lg * c2 + lg / 2, h2 = f.altura * (.7 + rnd(cx2) * .6)
        add("path", { d: "M" + (cx2 - lg * .62).toFixed(1) + " " + f.y + "Q" + cx2 + " " + (f.y - h2).toFixed(1) + " " + (cx2 + lg * .62).toFixed(1) + " " + f.y + "Z", fill: c.colina, stroke: "#5a6342", "stroke-width": 1.1 })
      }
    } else if (f.tipo === "penhasco") {
      add("path", { d: aberta(f.pontos), fill: "none", stroke: c.rocha, "stroke-width": 8, "stroke-linecap": "round" })
      for (let hc = 0; hc < f.pontos.length - 1; hc++) {
        const a1 = f.pontos[hc], a2 = f.pontos[hc + 1]
        for (let q2 = 0; q2 < 4; q2++) {
          const tq = (q2 + .5) / 4, hx = a1[0] + (a2[0] - a1[0]) * tq, hy = a1[1] + (a2[1] - a1[1]) * tq
          add("line", { x1: hx.toFixed(1), y1: hy.toFixed(1), x2: (hx - 12).toFixed(1), y2: (hy + 8).toFixed(1), stroke: "#5d5a50", "stroke-width": 2, opacity: .85 })
        }
      }
    } else if (f.tipo === "ruina") {
      for (let b3 = 0; b3 < f.blocos; b3++) {
        const bx = f.cx - f.w / 2 + rnd(b3 * 13 + f.cx) * f.w, by = f.cy - f.h / 2 + rnd(b3 * 17 + f.cy) * f.h
        const bw = 9 + rnd(b3 * 7) * 16, bh = 4 + rnd(b3 * 11) * 6, rot = (rnd(b3 * 3) * 44 - 22).toFixed(1)
        add("rect", { x: bx.toFixed(1), y: by.toFixed(1), width: bw.toFixed(1), height: bh.toFixed(1), fill: c.ruina, stroke: "#68624f", "stroke-width": .9, transform: `rotate(${rot} ${bx.toFixed(1)} ${by.toFixed(1)})` })
      }
    } else if (f.tipo === "estrada") {
      const dd = aberta(f.pontos)
      add("path", { d: dd, fill: "none", stroke: "#1f190f", "stroke-width": 7, "stroke-linecap": "round", "stroke-dasharray": f.tracejada ? "12 10" : "", opacity: .85 })
      add("path", { d: dd, fill: "none", stroke: c.estrada, "stroke-width": 3.2, "stroke-linecap": "round", "stroke-dasharray": f.tracejada ? "12 10" : "" })
    } else if (f.tipo === "cidade") {
      add("circle", { cx: f.cx, cy: f.cy, r: f.r, fill: c.cidade, stroke: c.muro, "stroke-width": 3 })
      for (let a3 = 1; a3 <= f.aneis; a3++) add("circle", { cx: f.cx, cy: f.cy, r: (f.r * (a3 / (f.aneis + 1))).toFixed(1), fill: "none", stroke: "#433826", "stroke-width": 1 })
      for (let r4 = 0; r4 < f.ruas; r4++) {
        const an4 = (r4 / f.ruas) * Math.PI * 2
        add("line", { x1: (f.cx + Math.cos(an4) * f.r * .18).toFixed(1), y1: (f.cy + Math.sin(an4) * f.r * .18).toFixed(1), x2: (f.cx + Math.cos(an4) * f.r * .97).toFixed(1), y2: (f.cy + Math.sin(an4) * f.r * .97).toFixed(1), stroke: "#584a31", "stroke-width": 1.1 })
      }
      for (let t3 = 0; t3 < f.ruas * 3; t3++) {
        const at3 = (t3 / (f.ruas * 3)) * Math.PI * 2 + .11, rt3 = f.r * (.34 + rnd(t3 * 5 + f.cx) * .56)
        add("rect", { x: (f.cx + Math.cos(at3) * rt3 - 3.2).toFixed(1), y: (f.cy + Math.sin(at3) * rt3 - 2.6).toFixed(1), width: 6.4, height: 5.2, rx: 1, fill: c.telhado, stroke: "#74492f", "stroke-width": .6 })
      }
      add("circle", { cx: f.cx, cy: f.cy, r: (f.r * .17).toFixed(1), fill: "#2d2618", stroke: c.muro, "stroke-width": 1.4 })
    } else if (f.tipo === "vila") {
      for (let v = 0; v < f.casas; v++) {
        const av = (v / f.casas) * Math.PI * 2 + rnd(v * 3 + f.cx) * .6, rv = f.raio * (.3 + rnd(v * 7 + f.cy) * .7)
        add("rect", { x: (f.cx + Math.cos(av) * rv - 4.5).toFixed(1), y: (f.cy + Math.sin(av) * rv - 3.4).toFixed(1), width: 9, height: 6.8, rx: 1.2, fill: f.barracas ? "#423927" : c.telhado, stroke: "#74492f", "stroke-width": .8 })
      }
    } else if (f.tipo === "castelo") {
      add("rect", { x: f.cx - f.w / 2, y: f.cy - f.h / 2, width: f.w, height: f.h, rx: 2, fill: "#100d0c", stroke: c.muro, "stroke-width": 2 })
      ;[-1, 0, 1].forEach((o) => {
        add("rect", { x: (f.cx + o * f.w * .34 - 5.5).toFixed(1), y: (f.cy - f.h / 2 - 18).toFixed(1), width: 11, height: 20, rx: 1.5, fill: "#100d0c", stroke: c.muro, "stroke-width": 1.5 })
      })
    } else if (f.tipo === "torre") {
      if (f.tipoTorre === "labirinto") {
        add("rect", { x: f.cx - f.w / 2, y: f.cy - f.h / 2, width: f.w, height: f.h, rx: 3, fill: "#171021", stroke: "#a05fff", "stroke-width": 2.4 })
        add("rect", { x: f.cx - f.w * .17, y: f.cy - f.h / 2 - 30, width: f.w * .34, height: 32, rx: 2, fill: "#171021", stroke: "#a05fff", "stroke-width": 2 })
      } else if (f.tipoTorre === "relogio") {
        add("rect", { x: f.cx - f.w / 2, y: f.cy - f.h / 2, width: f.w, height: f.h, rx: 2, fill: "#1c1712", stroke: c.muro, "stroke-width": 1.8, transform: f.inclinada ? `rotate(-7 ${f.cx} ${f.cy})` : "" })
      } else {
        add("path", { d: "M" + (f.cx - f.w / 2) + " " + (f.cy + f.h / 2) + "q" + (f.w / 2) + " " + (-f.h * 1.7) + " " + f.w + " 0Z", fill: f.brilho ? "#1c2e14" : "#0d0b09", stroke: f.brilho ? "#8fe27a" : "#7a776b", "stroke-width": 1.8 })
      }
    } else if (f.tipo === "ilha") {
      add("path", { d: blob(f.cx, f.cy, f.r, f.r * .72, f.cx, .22, 12), fill: c.terra, stroke: c.costa, "stroke-width": 1.4 })
    } else if (f.tipo === "rotulo") {
      const yy2 = f.y + (f.dy || 0)
      const corRotulo = { agua: "#7cc0e2", mata: "#8cbb7c", pedra: "#b3a992", campo: "#a8b07a" }[f.classe] || "#efe5d2"
      const t4 = add("text", {
        x: f.x, y: yy2, "text-anchor": f.ancora || "middle",
        "font-family": "Palatino Linotype, Palatino, Georgia, serif", "font-style": "italic",
        "font-size": "15", fill: corRotulo, "letter-spacing": ".14em", opacity: .95,
        "paint-order": "stroke", stroke: "#0a0806", "stroke-width": "3.4px",
      })
      if (f.ang) t4.setAttribute("transform", `rotate(${f.ang} ${f.x} ${yy2})`)
      t4.textContent = f.txt
    }
  })
}
