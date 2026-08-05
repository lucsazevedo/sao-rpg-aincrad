"""
Uso: python scripts/gerar_faltantes.py [tipo] [opcoes]

Gera TODAS as imagens que ainda faltam no projeto, uma por uma, pulando as que
ja existem. Em vez de voce colar 60 comandos na mao, roda um so.

  python scripts/gerar_faltantes.py --listar        # so mostra o que falta
  python scripts/gerar_faltantes.py monstros        # 25 monstros sem retrato
  python scripts/gerar_faltantes.py npcs            # 30 NPCs sem retrato
  python scripts/gerar_faltantes.py armas           # 28 armas novas
  python scripts/gerar_faltantes.py equipamentos    # 66 equipamentos
  python scripts/gerar_faltantes.py tudo            # tudo acima, em ordem

Opcoes:
  --listar          nao gera nada, so imprime a fila
  --limite N        gera no maximo N imagens e para (bom pra testar o estilo)
  --refazer         gera de novo mesmo pra quem ja tem imagem
  --seed 1234       fixa a seed

PRECISA: ComfyUI rodando em http://127.0.0.1:8188 (run_nvidia_gpu.bat em
C:\\AI\\ComfyUI). Para NPCs/armas/equipamentos tambem precisa do Ollama
(`ollama list` pra confirmar) porque o prompt passa por ele.

Monstros usam --prompt-bruto com prompt em ingles escrito a mao (dicionario
PROMPTS_MONSTRO abaixo) -- ver docs/guia_estilo_visual.md, secao "Monstros":
deixar o Ollama traduzir monstro faz ele virar cavaleiro humano generico.

Depois de gerar, rode:  python scripts/gerar_dados_web.py
(pro Compendio enxergar as imagens novas)
"""
import argparse
import os
import re
import subprocess
import sys
import time

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPTS = os.path.join(RAIZ, "scripts")
PY = sys.executable or "python"

NEG_MONSTRO = ("2girls, multiple girls, multiple characters, human girl, bunny girl, "
               "kemonomimi, humanoid woman, second character, cute girl, human face, human skin")

# ---------------------------------------------------------------------------
# Prompts de monstro escritos a mao, em ingles, no formato do Animagine.
# Formula: solo, single monster creature, [tipo], [pele/pelo], [focinho/boca],
# [orelhas], [cauda], [corpo], [armadura ou "no armor"], [arma], [olhos],
# monstrous non-human creature, not a person, [cenario], anime fantasy monster
# concept art, full body shot
# ---------------------------------------------------------------------------
PROMPTS_MONSTRO = {
 "aguia_de_pedra":
   "solo, single monster creature, giant eagle, slate grey stone-textured feathers, "
   "sharp hooked beak, no ears, short fan tail, massive wingspan, no armor, "
   "large curved talons, cold yellow eyes, monstrous non-human creature, not a person, "
   "rocky cliffside, anime fantasy monster concept art, full body shot",
 "arauto_das_alturas":
   "solo, single monster creature, enormous raptor bird, storm grey and white plumage, "
   "long hooked beak, crest of raised feathers on the head, long streaming tail feathers, "
   "gigantic wings spread wide, no armor, huge talons, piercing pale eyes, "
   "monstrous non-human creature, not a person, mountain peak above clouds, "
   "anime fantasy monster concept art, full body shot",
 "armadura_animada":
   "solo, single monster creature, empty animated suit of armor, dark tarnished steel plates, "
   "helmet with hollow visor and nothing inside, no skin, no face, rusted joints, "
   "floating rusted sword, faint blue glow inside the helmet, "
   "monstrous non-human creature, not a person, empty stone corridor, "
   "anime fantasy monster concept art, full body shot, knight armor with no one inside",
 "coruja_das_sombras":
   "solo, single monster creature, large owl, sooty black feathers with faint grey barring, "
   "small curved beak, feather tufts on the head, short tail, silent broad wings, no armor, "
   "black talons, huge round amber eyes, monstrous non-human creature, not a person, "
   "dark forest canopy, anime fantasy monster concept art, full body shot",
 "corvo_das_ruinas":
   "solo, single monster creature, large crow, glossy blue-black feathers, "
   "heavy black beak, no ears, wedge tail, ragged wings, no armor, "
   "small sharp claws, beady black eyes, monstrous non-human creature, not a person, "
   "broken battlefield banners, anime fantasy monster concept art, full body shot",
 "enxame_do_rio":
   "solo, single monster creature, dense swarm of small silver fish forming one shape, "
   "wet glinting scales, hundreds of tiny mouths, no ears, flicking tails, "
   "swirling mass of bodies, no armor, no weapon, many tiny black eyes, "
   "monstrous non-human creature, not a person, muddy river water, "
   "anime fantasy monster concept art, full body shot",
 "escorpiao_de_poeira":
   "solo, single monster creature, giant scorpion, sand-coloured chitin plates, "
   "clicking mandibles, no ears, long segmented tail raised with a dripping stinger, "
   "low wide body, natural carapace armor, heavy pincers, tiny black eyes, "
   "monstrous non-human creature, not a person, dry cracked plain, "
   "anime fantasy monster concept art, full body shot",
 "espectro_sussurrante":
   "solo, single monster creature, incorporeal ghost, translucent pale mist body, "
   "open mouth frozen mid-whisper, no ears, trailing wisps instead of legs, "
   "hollow torso, no armor, no weapon, two faint white eye-lights, "
   "monstrous non-human creature, not a person, old gravestones at night, "
   "anime fantasy monster concept art, full body shot, semi transparent",
 "fada_da_poeira":
   "solo, single monster creature, palm-sized insect with an elongated body, "
   "pale golden fuzz shedding glowing dust, no mouth, no ears, no tail, "
   "four translucent veined wings, no armor, no weapon, two dark eye-spots and no face, "
   "monstrous non-human creature, not a person, field of wildflowers with floating pollen, "
   "anime fantasy monster concept art, full body shot",
 "gafanhoto_gigante":
   "solo, single monster creature, dog-sized locust, olive green chitin mottled with brown, "
   "constantly working mandibles, no ears, short abdomen, oversized hind legs, "
   "short stubby wings, natural chitin armor, no weapon, compound eyes, "
   "monstrous non-human creature, not a person, terraced farmland eaten to the stalk, "
   "anime fantasy monster concept art, full body shot",
 "guardiao_de_mournhall":
   "solo, single monster creature, enormous cave bear, thick grizzled grey fur matted with dirt, "
   "wide snout with long yellow fangs, small round ears, stub tail, "
   "massive hunched body the size of a cart, no armor, huge claws, small pale eyes, "
   "monstrous non-human creature, not a person, dark cavern chamber, "
   "anime fantasy monster concept art, full body shot",
 "libelula_cortante":
   "solo, single monster creature, giant dragonfly, iridescent blue-green segmented body, "
   "serrated mandibles, no ears, long thin tail, four long razor-edged transparent wings, "
   "no armor, no weapon, huge compound eyes, monstrous non-human creature, not a person, "
   "over a river, anime fantasy monster concept art, full body shot",
 "lobo_da_alcateia":
   "solo, single monster creature, large wolf, dusty tan and grey fur, "
   "long snout baring white fangs, pointed upright ears with sharp tips, bushy tail, "
   "lean muscular body, no armor, no weapon, pale amber eyes, "
   "monstrous non-human creature, not a person, tall dry grassland, "
   "anime fantasy monster concept art, full body shot",
 "morcego_ecoante":
   "solo, single monster creature, large bat, dark brown leathery skin, "
   "open snout with tiny needle teeth, huge ribbed ears wider than the head, short tail, "
   "membranous wings, no armor, no weapon, tiny black eyes, "
   "monstrous non-human creature, not a person, cave ceiling with stalactites, "
   "anime fantasy monster concept art, full body shot",
 "predador_de_vaelor":
   "solo, single monster creature, cliff-hunting raptor beast, dark slate feathers over scaled skin, "
   "long toothed beak, no ears, rigid tail, hooked wings, no armor, "
   "long grasping talons, narrow orange eyes, monstrous non-human creature, not a person, "
   "windswept cliff edge, anime fantasy monster concept art, full body shot",
 "ra_venenosa_gigante":
   "solo, single monster creature, giant toad, wet warty skin in sickly yellow and green, "
   "huge wide mouth, no ears, no tail, bloated body with swollen poison glands on the back, "
   "no armor, no weapon, bulging orange eyes, monstrous non-human creature, not a person, "
   "shallow swamp water and reeds, anime fantasy monster concept art, full body shot",
 "ruin_kobold_arqueiro":
   "solo, single monster creature, kobold, coarse grey-brown fur, "
   "short canine snout with small fangs, pointed tapered ears close to the skull, thin tail, "
   "hunched wiry body, light leather straps only, short bow and quiver, yellow eyes, "
   "monstrous non-human creature, not a person, ruined stone corridor, "
   "anime fantasy monster concept art, full body shot",
 "sanguessuga_gigante":
   "solo, single monster creature, giant leech, glistening dark red segmented body, "
   "circular sucker mouth ringed with rasping teeth, no ears, no tail, "
   "long boneless tube body, no armor, no weapon, no eyes, "
   "monstrous non-human creature, not a person, black stagnant swamp water, "
   "anime fantasy monster concept art, full body shot",
 "sentinela_esquecida":
   "solo, single monster creature, ancient stone and bronze construct, "
   "cracked grey stone plating with green corrosion, no mouth, no ears, no tail, "
   "tall broad humanoid frame with visible joint gaps, integrated armor plates, "
   "one long bladed arm, single glowing orange eye slit, "
   "monstrous non-human creature, not a person, ruined battlefield with fallen banners, "
   "anime fantasy monster concept art, full body shot",
 "serpente_das_aguas_rasas":
   "solo, single monster creature, large water snake, dark green scales on the back and "
   "pale yellow belly with a silver stripe running head to tail, "
   "open jaws with curved fangs, no ears, long tapering tail, "
   "flattened swimming body, no armor, no weapon, vertical slit eyes, "
   "monstrous non-human creature, not a person, shallow clear lake water and reeds, "
   "anime fantasy monster concept art, full body shot",
 "sombra_de_mournhall":
   "solo, single monster creature, lanky cave predator, black oily hairless skin, "
   "wide lipless mouth full of needle teeth, no ears, long whip tail, "
   "elongated limbs and hunched spine, no armor, no weapon, "
   "large pale light-sensitive eyes squinting, monstrous non-human creature, not a person, "
   "pitch dark cave, anime fantasy monster concept art, full body shot",
 "toca_na_raiz":
   "solo, single monster creature, small burrowing beast, bristly brown fur caked with soil, "
   "short blunt snout with chisel teeth, tiny rounded ears, stub tail, "
   "compact low body, no armor, no weapon, small dark eyes, "
   "monstrous non-human creature, not a person, thick tree roots and dug earth, "
   "anime fantasy monster concept art, full body shot",
 "trepadeira_estranguladora":
   "solo, single monster creature, carnivorous vine plant, dark green woody creepers with thorns, "
   "no mouth, no ears, no tail, a writhing mass of coiling tendrils rising from a thick stem base, "
   "no armor, no weapon, no eyes, monstrous non-human creature, not a person, "
   "dense forest floor, anime fantasy monster concept art, full body shot, plant monster",
 "urso_de_pedra":
   "solo, single monster creature, enormous bear, thick ash-grey fur packed with dust and rubble "
   "so it looks like part of the mountain, broad snout with heavy fangs, small round ears, "
   "stub tail, massive bulk, no armor, huge blunt claws, small dark eyes, "
   "monstrous non-human creature, not a person, high rocky mountainside, "
   "anime fantasy monster concept art, full body shot",
 "verme_de_cristal":
   "solo, single monster creature, two-meter burrowing worm, pale grey soft skin with "
   "blue crystal shards growing straight out of the body in rows, "
   "round rasping mouth, no ears, tapering tail, long segmented body, "
   "natural crystal plating, no weapon, no eyes, monstrous non-human creature, not a person, "
   "glowing blue crystal cave, anime fantasy monster concept art, full body shot",
 # -- adicionados na rodada de varredura final (17 sem prompt escrito) --
 "aguia_do_planalto":
   "solo, single monster creature, giant eagle, bronze metallic-sheen feathers, "
   "sharp hooked beak, no ears, short fan tail, wide wingspan gliding in circles, no armor, "
   "large curved talons, cold pale eyes, monstrous non-human creature, not a person, "
   "dry highland plateau under bright sun, anime fantasy monster concept art, full body shot",
 "alfa_lupino":
   "solo, single monster creature, huge alpha wolf, one third larger than a normal wolf, "
   "near-white fur on the back fading to dark fur on the legs, one ear missing entirely, "
   "long snout baring fangs, bushy tail, lean powerful body, no armor, no weapon, "
   "pale colorless unblinking eyes, monstrous non-human creature, not a person, "
   "open grassland at dusk, anime fantasy monster concept art, full body shot",
 "baran_o_rei_touro":
   "solo, single monster creature, colossal minotaur humanoid, bull head with massive horns, "
   "cracked stone-textured skin instead of hide, no visible ears besides bull ears, short tail, "
   "towering muscular body, no armor, huge heavy war hammer held in both hands, "
   "glowing dim red eyes, monstrous non-human creature, not a person, "
   "large ruined stone chamber, anime fantasy monster concept art, full body shot, boss creature",
 "centopeia_do_aqueduto":
   "solo, single monster creature, giant centipede, dark glistening wet segmented carapace, "
   "clicking mandibles, no ears, many small legs along the body, thick tapering tail segment, "
   "natural chitin plating, no weapon, tiny black eyes, monstrous non-human creature, not a person, "
   "narrow wet stone aqueduct tunnel, anime fantasy monster concept art, full body shot",
 "ent_anciao":
   "solo, single monster creature, five-meter walking ancient tree, cracked grey bark trunk body, "
   "moss and ivy hanging from the arms like torn sleeves, no ears, no tail, "
   "massive slow humanoid tree shape, no armor, no weapon, two deep glowing green eyes in the bark, "
   "monstrous non-human creature, not a person, deep old forest, "
   "anime fantasy monster concept art, full body shot, treant",
 "enxame_de_abelhas_douradas":
   "solo, single monster creature, dense swarm of giant golden bees forming one shape, "
   "metallic gold fuzzy bodies, translucent wings trailing golden dust, hundreds of tiny stingers, "
   "no ears, no single face, swirling mass of bodies, no armor, no weapon, "
   "monstrous non-human creature, not a person, flowering forest clearing with a huge hive, "
   "anime fantasy monster concept art, full body shot",
 "guardiao_das_planicies":
   "solo, single monster creature, horse-sized stag, wide asymmetrical antlers, "
   "brown fur marked with pale writing-like patterns, no visible ears beside deer ears, short tail, "
   "sturdy muscular body, braided metal choker with a blue stone around the neck, no weapon, "
   "calm dark eyes, monstrous non-human creature, not a person, "
   "open sunlit plains, anime fantasy monster concept art, full body shot",
 "guerreiro_kobold":
   "solo, single monster creature, two-meter reptilian humanoid kobold, grey-green scales, "
   "mismatched armor plates from three different suits, no ears, thick tail, "
   "muscular hunched body, heavy armor patchwork, round wooden shield with tribal mark, heavy axe, "
   "yellow reptilian eyes, monstrous non-human creature, not a person, "
   "ruined stone corridor, anime fantasy monster concept art, full body shot",
 "hound_de_cobre":
   "solo, single monster creature, low canine beast, rust-colored fur, "
   "dull copper plates growing along the spine and back, short snout with fangs, "
   "pointed ears, short tail, lean low body, natural metal plating, no weapon, amber eyes, "
   "monstrous non-human creature, not a person, dusty trade road, "
   "anime fantasy monster concept art, full body shot",
 "mae_raiz_de_horunka":
   "solo, single monster creature, gigantic tree root boss creature, thick woody roots forming "
   "a bell-shaped hollow maw lined with dark green velvet-like tissue, amber sap dripping from within, "
   "no ears, no visible eyes, coiling root tendrils instead of limbs, no armor, no weapon, "
   "monstrous non-human creature, not a person, hidden forest clearing, "
   "anime fantasy monster concept art, full body shot, plant boss creature",
 "mimic_de_marcos":
   "solo, single monster creature, stone signpost mimic construct, grey stone slab body "
   "with cracked golden lettering, no face, four jointed metal legs unfolding from the base, "
   "no ears, no tail, natural stone plating, no weapon, no eyes, "
   "monstrous non-human creature, not a person, crossroads on a dirt path, "
   "anime fantasy monster concept art, full body shot, construct monster",
 "mosca_venenosa":
   "solo, single monster creature, forearm-sized giant fly, metallic blue-green thorax, "
   "thick-veined wings, no ears, no tail, oversized dark red compound eyes, "
   "long dripping proboscis with smoking yellow-green venom, no armor, no weapon, "
   "monstrous non-human creature, not a person, damp overgrown thicket, "
   "anime fantasy monster concept art, full body shot",
 "porta_estandarte_de_illfang":
   "solo, single monster creature, tall kobold standard bearer, head and a half taller than "
   "common kobolds, mismatched armor plates from three suits, no ears beside reptilian ears, "
   "thick tail, wiry strong body, patchwork armor, holds a tall pole with a dark red banner in one hand "
   "and a short axe in the other, yellow eyes, monstrous non-human creature, not a person, "
   "open ground before a giant stone tower, anime fantasy monster concept art, full body shot",
 "rei_das_planicies":
   "solo, single monster creature, cart-sized giant stag, antlers three meters wide with "
   "unnaturally repeating angular patterns like writing, entire fur covered in dense pale "
   "writing-like markings, no ears beside deer ears, no tail visible, massive powerful body, "
   "no armor, no weapon, eyes with no animal quality at all, "
   "monstrous non-human creature, not a person, open plains at midday, "
   "anime fantasy monster concept art, full body shot, boss creature",
 "sem_cor":
   "solo, single humanoid silhouette, plain nondescript player avatar shape, "
   "flat featureless face with no distinct expression, no colored cursor above the head, "
   "no name tag, no guild emblem, plain generic clothing with no ornamentation, "
   "standing still, faint translucent edges like it is about to fade, "
   "not a monster, ambiguous figure, anime fantasy concept art, full body shot, "
   "muted desaturated colors, unsettling emptiness",
 "slime":
   "solo, single monster creature, translucent gelatinous blob, vivid colorful jelly body, "
   "no ears, no tail, round soft shapeless form, faint darker core visible inside, "
   "no armor, no weapon, no visible eyes, monstrous non-human creature, not a person, "
   "grassy village field, anime fantasy monster concept art, full body shot",
 "touro_das_colinas":
   "solo, single monster creature, robust bull, short thick horns, "
   "brown dusty fur blending with dry hillside soil, no visible ears beside bull ears, short tail, "
   "sturdy heavy body, no armor, no weapon, dark determined eyes, "
   "monstrous non-human creature, not a person, dry rolling hills, "
   "anime fantasy monster concept art, full body shot",
}


def ler(caminho):
    with open(caminho, "r", encoding="utf-8") as f:
        return f.read()


def existe(rel):
    return os.path.exists(os.path.join(RAIZ, rel.replace("/", os.sep)))


def secao(texto, titulo, limite=400):
    m = re.search(r"^## %s\s*$(.*?)(?=^## |\Z)" % re.escape(titulo), texto, re.M | re.S)
    if not m:
        return ""
    for bloco in m.group(1).strip().split("\n\n"):
        bloco = " ".join(l.strip() for l in bloco.split("\n")).strip()
        if bloco and not bloco.startswith(("|", "-", "*", ">", "**Nota")):
            return bloco[:limite]
    return ""


# ---------------------------------------------------------------- filas

def fila_monstros(refazer):
    dir_ = os.path.join(RAIZ, "monstros")
    fila = []
    for arq in sorted(os.listdir(dir_)):
        if not arq.endswith(".md") or arq.startswith("_"):
            continue
        slug = arq[:-3]
        alvo = "imagens/monstro_%s.png" % slug
        if existe(alvo) and not refazer:
            continue
        prompt = PROMPTS_MONSTRO.get(slug)
        if not prompt:
            print("  (sem prompt escrito para %s -- pule ou adicione em PROMPTS_MONSTRO)" % slug)
            continue
        fila.append({
            "nome": slug, "alvo": alvo,
            "cmd": [PY, os.path.join(SCRIPTS, "gerar_imagem.py"), prompt,
                    "--prompt-bruto", "--negativo", NEG_MONSTRO,
                    "--nome", "monstro_" + slug],
        })
    return fila


def fila_npcs(refazer):
    dir_ = os.path.join(RAIZ, "npcs")
    fila = []
    for arq in sorted(os.listdir(dir_)):
        if not arq.endswith(".md") or arq.startswith("_"):
            continue
        slug = arq[:-3]
        texto = ler(os.path.join(dir_, arq))
        fm = re.search(r"^imagem: \.\./(.+)$", texto, re.M)
        alvo = fm.group(1).strip() if fm else "imagens/npc_%s.png" % slug
        if existe(alvo) and not refazer:
            continue
        nome = (re.search(r"^nome: (.+)$", texto, re.M).group(1)).split("(")[0].strip()
        aparencia = secao(texto, "Aparência")
        prof = re.search(r"^profissao: (.+)$", texto, re.M)
        local = re.search(r"^localizacao: (.+)$", texto, re.M)
        pedido = "retrato de %s, %s%s. %s" % (
            nome,
            ("profissão %s, " % prof.group(1).strip()) if prof and prof.group(1).strip() else "",
            ("em %s" % local.group(1).strip()) if local else "Aincrad andar 1",
            aparencia)
        fila.append({
            "nome": slug, "alvo": alvo,
            "cmd": [PY, os.path.join(SCRIPTS, "gerar_imagem.py"), pedido,
                    "--nome", os.path.splitext(os.path.basename(alvo))[0]],
        })
    return fila


def fila_armas(refazer):
    fila = []
    dir_ = os.path.join(RAIZ, "armas")
    # fichas individuais
    for arq in sorted(os.listdir(dir_)):
        if not arq.endswith(".md") or arq.startswith(("_", "00")):
            continue
        slug = arq[:-3]
        alvo = "imagens/arma_%s.png" % slug
        if existe(alvo) and not refazer:
            continue
        texto = ler(os.path.join(dir_, arq))
        nome = re.search(r"^nome: (.+)$", texto, re.M).group(1).strip()
        pedido = "%s, arma de Aincrad andar 1. %s" % (nome, secao(texto, "Aparência"))
        fila.append({"nome": slug, "alvo": alvo,
                     "cmd": [PY, os.path.join(SCRIPTS, "gerar_imagem.py"), pedido, "--item",
                             "--nome", "arma_" + slug, "--largura", "1024", "--altura", "1024"]})
    # catalogo expandido
    cat = os.path.join(dir_, "00_catalogo_expandido.md")
    if os.path.exists(cat):
        texto = ler(cat)
        for m in re.finditer(r"^## (?P<nome>.+?) — (?:Comum|Incomum|Raro) · (?P<tipo>[^·\n]+) · ",
                             texto, re.M):
            nome = m.group("nome").strip()
            slug = re.sub(r"[^a-z0-9]+", "_",
                          nome.lower().replace("á", "a").replace("ã", "a").replace("â", "a")
                          .replace("é", "e").replace("ê", "e").replace("í", "i")
                          .replace("ó", "o").replace("ô", "o").replace("õ", "o")
                          .replace("ú", "u").replace("ç", "c")).strip("_")
            alvo = "imagens/arma_%s.png" % slug
            if existe(alvo) and not refazer:
                continue
            corpo = texto[m.end():m.end() + 700]
            desc = ""
            for bloco in corpo.split("\n\n"):
                bloco = " ".join(l.strip() for l in bloco.split("\n")).strip()
                if bloco and not bloco.startswith("**"):
                    desc = bloco
                    break
            pedido = "%s, %s de Aincrad andar 1. %s" % (nome, m.group("tipo").strip(), desc)
            fila.append({"nome": slug, "alvo": alvo,
                         "cmd": [PY, os.path.join(SCRIPTS, "gerar_imagem.py"), pedido, "--item",
                                 "--nome", "arma_" + slug, "--largura", "1024", "--altura", "1024"]})
    return fila


def fila_equipamentos(refazer):
    dir_ = os.path.join(RAIZ, "equipamentos")
    if not os.path.isdir(dir_):
        return []
    fila = []
    for arq in sorted(os.listdir(dir_)):
        if not arq.endswith(".md") or arq.startswith("00"):
            continue
        texto = ler(os.path.join(dir_, arq))
        slot = (re.search(r"^slot: (.+)$", texto, re.M) or [None, arq[:-3]])[1]
        for m in re.finditer(r"^## (?P<nome>.+?) — (?:Comum|Incomum|Raro)", texto, re.M):
            nome = m.group("nome").strip()
            slug = re.sub(r"[^a-z0-9]+", "_",
                          nome.lower().replace("á", "a").replace("ã", "a").replace("â", "a")
                          .replace("é", "e").replace("ê", "e").replace("í", "i")
                          .replace("ó", "o").replace("ô", "o").replace("õ", "o")
                          .replace("ú", "u").replace("ç", "c")).strip("_")
            alvo = "imagens/equip_%s.png" % slug
            if existe(alvo) and not refazer:
                continue
            corpo = texto[m.end():m.end() + 700]
            desc = ""
            for bloco in corpo.split("\n\n"):
                bloco = " ".join(l.strip() for l in bloco.split("\n")).strip()
                if bloco and not bloco.startswith("**"):
                    desc = bloco
                    break
            pedido = "%s, equipamento (%s) de Aincrad andar 1, sem pessoa vestindo. %s" % (
                nome, slot, desc)
            fila.append({"nome": slug, "alvo": alvo,
                         "cmd": [PY, os.path.join(SCRIPTS, "gerar_imagem.py"), pedido, "--item",
                                 "--nome", "equip_" + slug,
                                 "--largura", "1024", "--altura", "1024"]})
    return fila


FILAS = {
    "monstros": fila_monstros,
    "npcs": fila_npcs,
    "armas": fila_armas,
    "equipamentos": fila_equipamentos,
}
ORDEM = ["monstros", "npcs", "armas", "equipamentos"]


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("tipo", nargs="?", default="tudo",
                    choices=ORDEM + ["tudo"])
    ap.add_argument("--listar", action="store_true")
    ap.add_argument("--limite", type=int)
    ap.add_argument("--refazer", action="store_true")
    ap.add_argument("--seed", type=int)
    args = ap.parse_args()

    alvos = ORDEM if args.tipo == "tudo" else [args.tipo]
    fila = []
    for a in alvos:
        itens = FILAS[a](args.refazer)
        print("%-14s %d pendente(s)" % (a, len(itens)))
        fila += itens

    if args.limite:
        fila = fila[:args.limite]

    if args.listar:
        print("\n--- fila (%d) ---" % len(fila))
        for i, it in enumerate(fila, 1):
            print("%3d. %-34s -> %s" % (i, it["nome"], it["alvo"]))
        print("\nRode sem --listar pra gerar. Tempo estimado: ~%d min "
              "(cerca de 25s por imagem numa 4070 Ti)." % max(1, len(fila) * 25 // 60))
        return

    if not fila:
        print("\nNada pendente. Tudo ja tem imagem.")
        return

    print("\nGerando %d imagem(ns). ComfyUI precisa estar rodando.\n" % len(fila))
    t0 = time.time()
    falhas = []
    for i, it in enumerate(fila, 1):
        cmd = list(it["cmd"])
        if args.seed:
            cmd += ["--seed", str(args.seed + i)]
        print("[%d/%d] %s" % (i, len(fila), it["nome"]))
        r = subprocess.run(cmd, cwd=RAIZ)
        if r.returncode != 0:
            falhas.append(it["nome"])
            print("      ^ FALHOU (segue pro proximo)")

    print("\nTerminou em %d min. %d ok, %d falha(s)." %
          ((time.time() - t0) / 60, len(fila) - len(falhas), len(falhas)))
    if falhas:
        print("Falharam: " + ", ".join(falhas))
    print("\nAgora rode:  python scripts/gerar_dados_web.py")


if __name__ == "__main__":
    main()
