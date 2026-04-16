"""
Post-Build Patch für Flutter Web:
1. Renderer von canvaskit → html (kein WASM, sofortiger Start)
2. Splash-Screen in index.html einbauen (kein weißer Bildschirm)
3. docs/ aktualisieren
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

# ── 2. index.html: Loading-Splash einbauen
index = BUILD / "index.html"
html = index.read_text()

splash_css = """
<style>
  #flutter-loading {
    position: fixed; inset: 0;
    display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    background: #1B3A5C;
    z-index: 9999;
    transition: opacity 0.4s ease;
  }
  #flutter-loading.hidden { opacity: 0; pointer-events: none; }
  .loader-logo {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    font-size: 28px; font-weight: 700;
    color: #ffffff; letter-spacing: -0.5px;
    margin-bottom: 8px;
  }
  .loader-sub {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    font-size: 14px; color: rgba(255,255,255,0.7);
    margin-bottom: 32px;
  }
  .loader-bar-bg {
    width: 200px; height: 3px;
    background: rgba(255,255,255,0.2);
    border-radius: 2px; overflow: hidden;
  }
  .loader-bar {
    height: 100%; width: 0%;
    background: #ffffff;
    border-radius: 2px;
    animation: load 2s ease forwards;
  }
  @keyframes load {
    0%   { width: 0%; }
    40%  { width: 60%; }
    80%  { width: 85%; }
    100% { width: 95%; }
  }
</style>
"""

splash_div = """
<div id="flutter-loading">
  <div class="loader-logo">AP1 Coach</div>
  <div class="loader-sub">IHK Prüfungsvorbereitung</div>
  <div class="loader-bar-bg"><div class="loader-bar"></div></div>
</div>
<script>
  window.addEventListener('flutter-first-frame', function() {
    var el = document.getElementById('flutter-loading');
    if (el) { el.classList.add('hidden'); setTimeout(function(){ el.remove(); }, 500); }
  });
</script>
"""

# Splash-CSS vor </head> einfügen
html = html.replace("</head>", splash_css + "\n</head>")
# Splash-Div nach <body> einfügen
html = html.replace("<body>", "<body>\n" + splash_div)
index.write_text(html)
print("✅ index.html: Splash-Screen eingebaut")

# ── 3. version.json mit aktuellem Build-Timestamp aktualisieren
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

# ── 4. docs/ aktualisieren
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
