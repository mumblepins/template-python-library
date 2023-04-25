import shutil
from pathlib import Path

import pytest


@pytest.fixture
def temp_path_filled(tmp_path):
    print(tmp_path)
    res_path = Path(__file__).parent / "resources"
    if res_path.exists():
        shutil.copytree(res_path.resolve(), tmp_path / "src", dirs_exist_ok=True)
    return tmp_path / "src", tmp_path / "dst"
