

from typing import Dict, Set, Any, Union, List

import os
import sys
from pathlib import Path
import json
import re
import traceback

from collections import defaultdict


def read_text(path: Union[str, os.PathLike]) -> str:
    return Path(path).read_text('utf-8')


def write_text(text: str, path: Union[str, os.PathLike]):
    Path(path).write_text(text, encoding='utf-8')


def read_json(path: Union[str, os.PathLike]) -> Dict[str, Any]:
    return json.loads(read_text(path))


def is_bash_script(p: Path) -> bool:
    s = p.suffix
    if s in ('.sh', '.bash'):
        return True

    t = read_text(p)
    return '#!/bin/bash' in t or '#!/bin/sh' in t


def get_ast_commands(tree: Dict[str, Any]) -> Set[str]:
    """
    extract bash commands from bash ast tree
    Args:
        tree:

    Returns:

    >>> data = read_json('data/ast_example.json')
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
                    if (t := s.get('text')).startswith('-') and '=' not in t
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


def clean_bash_text(inpath: Union[str, os.PathLike], outpath: Union[str, os.PathLike]):
    txt = read_text(inpath)

    # convert function func {} -> func () {}
    txt = re.sub(r'(function )((\w|_)+ )', r'\2() ', txt)

    write_text(txt, outpath)


def get_dir_shell_commands(path: Union[str, os.PathLike]) -> Dict[str, List[str]]:

    AST_PATH = 'ast.json'
    CLEAN_BASH_PATH = 'cleaned.sh'

    file2commands = {}
    failed_files = []

    for p in Path(path).rglob('*'):
        if p.is_dir():
            continue
        if not is_bash_script(p):
            continue

        print(f"Clean script {str(p)}")
        clean_bash_text(p, CLEAN_BASH_PATH)

        try:
            Path(AST_PATH).unlink(missing_ok=True)
            os.system(f'node parse_bash {os.path.abspath(CLEAN_BASH_PATH)}')
            assert os.path.exists(AST_PATH), 'error on ast construction'
            file2commands[str(p)] = get_ast_commands(read_json(AST_PATH))
        except Exception:
            traceback.print_exc()
            failed_files.append(str(p))

    command2files = defaultdict(list)
    for f, cc in file2commands.items():
        for c in cc:
            command2files[c].append(f)

    print(f"Successfully processed files: {len(file2commands)}")
    if failed_files:
        count = len(failed_files)
        count_len = len(str(count))
        print(
            f"Failed files ({count}):\n\t" + '\n\t'.join(
                f"{str(i).rjust(count_len)}) {f}"
                for i, f in enumerate(sorted(failed_files), 1)
            )
        )

    return dict(command2files)


def extract_shell_commands(path: Union[str, os.PathLike], outpath: Union[str, os.PathLike]):

    dct = get_dir_shell_commands(path)

    cmd_len = max(len(k) for k in dct.keys())

    out = Path(outpath)
    out.parent.mkdir(exist_ok=True, parents=True)
    write_text(
        '\n'.join(
            cmd.ljust(cmd_len) + '\t--\t' + ';'.join(sorted(files))
            for cmd, files in sorted(dct.items())
        ),
        path=out
    )


if __name__ == '__main__':
    extract_shell_commands(*sys.argv[1:])


