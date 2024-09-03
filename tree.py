import os
from pathlib import Path

output_file_name = 'directory_structure.md'

excluded_items = {
    '.DS_Store',
    '.git',
    'node_modules',
    '.vscode',
    '.idea',
    '__pycache__',
    '.gitignore',
    '.npmignore',
    '.eslintignore',
}

def get_directory_structure(dir_path, level=0, parent_is_last=None):
    if parent_is_last is None:
        parent_is_last = []

    structure = ''

    try:
        files = [f for f in os.listdir(dir_path) if f not in excluded_items]
        files.sort()
    except PermissionError:
        return structure

    for index, file in enumerate(files):
        full_path = Path(dir_path) / file
        is_last_item = index == len(files) - 1

        prefix = ''.join('    ' if is_last else '│   ' for is_last in parent_is_last)
        line = '└── ' if is_last_item else '├── '

        if full_path.is_dir():
            structure += f"{prefix}{line}{file}\n"
            structure += get_directory_structure(full_path, level + 1, parent_is_last + [is_last_item])
        else:
            structure += f"{prefix}{line}{file}\n"

    return structure

def write_directory_structure_to_file():
    current_dir = os.getcwd()
    structure = get_directory_structure(current_dir)
    with open(output_file_name, 'w',encoding='utf-8') as f:
        f.write("```\n" + structure + "```\n")
    print(f"Directory structure written to {output_file_name}")

if __name__ == '__main__':
    write_directory_structure_to_file()
