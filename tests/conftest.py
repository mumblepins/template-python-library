from pathlib import Path
from typing import TYPE_CHECKING

import pytest

if TYPE_CHECKING:
    from collections.abc import Generator


@pytest.fixture
def temp_path_filled(tmp_path: Path) -> Generator[tuple[Path, Path]]:
    res_path = Path(__file__).parent / "resources"
    if res_path.exists():
        import shutil

        shutil.copytree(res_path.resolve(), tmp_path / "src", dirs_exist_ok=True)
    yield tmp_path / "src", tmp_path / "dst"
