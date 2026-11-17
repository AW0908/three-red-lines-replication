"""T091 checks; complete initial legacy-path migration before validation."""
import sys
sys.dont_write_bytecode=True
from pathlib import Path
import runpy
folder=Path(__file__).resolve().parent
if folder.name=='release_tools' and folder.parent.name=='public_release':
    folder=folder.parent/'release/release_tools'
sys.path.insert(0,str(folder))
from t091_layout import finish_legacy
finish_legacy()
runpy.run_path(str(folder/'t091_check.py'),run_name='__main__')
