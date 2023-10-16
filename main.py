

from typing import Dict, Set, Any, Union

import os
from pathlib import Path
import json


def read_text(path: Union[str, os.PathLike]) -> str:
    return Path(path).read_text('utf-8')


def read_json(path: Union[str, os.PathLike]) -> Dict[str, Any]:
    return json.loads(read_text(path))


def get_ast_commands(tree: Dict[str, Any]) -> Set[str]:
    """
    extract bash commands from bash ast tree
    Args:
        tree:

    Returns:

    >>> data = read_json('ast_example.json')
    >>> sorted(get_ast_commands(data))
    ['bash', 'cd', 'ln -s', 'make', 'python']
    """

    res = set()

    def step(dct: Dict[str, Any]):

        if dct.get('type') == 'Command' and 'name' in dct:
            cmd: str = dct['name']['text']
            if cmd[0].isalpha():
                suff = [
                    t for s in dct.get('suffix', [])
                    if (t := s.get('text')).startswith('-')
                ]
                if suff:
                    cmd = f"{cmd} {' '.join(suff)}"
                res.add(cmd)

        for v in dct.values():
            if isinstance(v, dict):
                step(v)
            elif isinstance(v, list):
                for item in v:
                    step(item)

    step(tree)

    return res



