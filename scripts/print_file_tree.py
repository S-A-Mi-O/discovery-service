import os

EXCLUDED_DIRS = {
    '.git', 'External Libraries', '.gradle', '.idea', 'build',
    'Scratches and Consoles', 'gradle'
}

def print_tree(startpath, prefix=""):
    for item in os.listdir(startpath):
        path = os.path.join(startpath, item)
        if os.path.isdir(path):
            if item in EXCLUDED_DIRS:
                continue
            print(f"{prefix}├── {item}")
            print_tree(path, prefix + "│   ")
        else:
            print(f"{prefix}├── {item}")

if __name__ == "__main__":
    # Determine project root (assume the script is now in /scripts)
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

    # Print the tree starting from the project root
    print_tree(project_root)