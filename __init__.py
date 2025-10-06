import importlib.util
import os
import sys
import types

_module = sys.modules[__name__]
_dir = os.path.dirname(__file__)
_loaded_files = set()


def _merge_module(target: types.ModuleType, mod: types.ModuleType):
    """Merge non-private globals from mod into target."""
    for k, v in vars(mod).items():
        if not k.startswith("_"):
            if hasattr(target, k):
                raise RuntimeError(
                    f"Name collision while merging modules: '{k}' already defined in {target.__name__}"
                )
            setattr(target, k, v)


def _load_file(path: str, modname: str):
    """Load a single .py file as a temporary module."""
    if path in _loaded_files:
        return None
    _loaded_files.add(path)

    spec = importlib.util.spec_from_file_location(modname, path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def _load_directory(target: types.ModuleType, dirpath: str, parent_name: str):
    """Recursively load all .py files and subdirectories."""
    for entry in os.scandir(dirpath):
        if entry.is_file() and entry.name.endswith(".py"):
            if entry.name == "__init__.py":
                continue
            modname = f"{parent_name}.{entry.name[:-3]}"
            mod = _load_file(entry.path, modname)
            if mod:
                _merge_module(target, mod)

        elif entry.is_dir():
            submodule_name = f"{parent_name}.{entry.name}"
            # Recursively create a namespace for the subdirectory
            submodule = types.ModuleType(submodule_name)
            sys.modules[submodule_name] = submodule
            _load_directory(submodule, entry.path, submodule_name)
            setattr(target, entry.name, submodule)


# --- main entry ---
_load_directory(_module, _dir, __name__)
