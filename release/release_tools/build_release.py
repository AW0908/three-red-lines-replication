"""T093 deterministic website build; T091 legacy entry-point staging retained."""
import sys
sys.dont_write_bytecode=True
from pathlib import Path
folder=Path(__file__).resolve().parent
if (folder.parent/'release/release_tools').exists():
    sys.path.insert(0,str(folder.parent/'release/release_tools'))
from t093_site import build
if '--legacy-entrypoints' in sys.argv:
    import shutil
    from t091_layout import OUT
    legacy=OUT/'release_tools'
    legacy.mkdir(exist_ok=True)
    for name in ['build_release.py','check_release.py']:
        shutil.copyfile(OUT/'release/release_tools'/name,legacy/name)
    print('Staged legacy card entry points; check_release.py removes them after the exact card command.')
    raise SystemExit(0)
build()
