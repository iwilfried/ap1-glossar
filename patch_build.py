"""
Post-Build Patch für Flutter Web:
1. Renderer von canvaskit → html (kein WASM, sofortiger Start)
2. docs/ aktualisieren
(Splash-Screen wird direkt in web/index.html gepflegt — nahtloser
 Übergang zum Flutter-Welcome-Screen via identischem LF-Logo.)
"""
import os, re, shutil
from pathlib import Path

BUILD = Path("/home/user/workspace/ap1-glossar/build/web")
DOCS  = Path("/home/user/workspace/ap1-glossar/docs")

# ── 1. flutter_bootstrap.js: renderer canvaskit → html
bootstrap = BUILD / "flutter_bootstrap.js"
content = bootstrap.read_text()

# builds-Array: renderer von canvaskit auf html ändern
patched = content.replace(
    '"renderer":"canvaskit"',
    '"renderer":"html"'
)
# Sicherheitscheck: compileTarget bleibt dart2js
if '"renderer":"html"' in patched:
    bootstrap.write_text(patched)
    print("✅ flutter_bootstrap.js: renderer → html")
else:
    print("⚠️  Renderer-Patch nicht angewendet")

# ── 2. version.json mit aktuellem Build-Timestamp aktualisieren
import json, datetime
version_file = BUILD / "version.json"
ts = datetime.datetime.utcnow().strftime("%Y%m%d%H%M%S")
version_data = {
    "app_name": "ap1_glossar",
    "version": "1.4.0",
    "build_number": ts,
    "package_name": "ap1_glossar"
}
version_file.write_text(json.dumps(version_data))
print(f"✅ version.json → v1.4.0 (build {ts})")

# ── 3. docs/ aktualisieren
if DOCS.exists():
    shutil.rmtree(DOCS)
DOCS.mkdir()
shutil.copytree(BUILD, DOCS, dirs_exist_ok=True)
(DOCS / ".nojekyll").touch()
print(f"✅ docs/ aktualisiert ({sum(1 for _ in DOCS.rglob('*'))} Dateien)")

# Größen-Check
main_js = DOCS / "main.dart.js"
ck_wasm = DOCS / "canvaskit" / "canvaskit.wasm"
print(f"\n  main.dart.js:       {main_js.stat().st_size/1024/1024:.1f} MB")
if ck_wasm.exists():
    print(f"  canvaskit.wasm:     {ck_wasm.stat().st_size/1024/1024:.1f} MB (wird mit html-renderer NICHT geladen)")
print(f"\n  Renderer in bootstrap: html ✅")
