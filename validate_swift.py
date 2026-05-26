import os
import sys

def validate_swift_file(filepath):
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return False
    with open(filepath, 'r') as f:
        content = f.read()
    if 'import' not in content and 'struct' not in content and 'class' not in content:
        print(f"Invalid structure in {filepath}")
        return False
    if content.count('{') != content.count('}'):
        print(f"Unbalanced braces in {filepath}")
        return False
    if content.count('(') != content.count(')'):
        print(f"Unbalanced parentheses in {filepath}")
        return False
    print(f"{filepath} is valid.")
    return True

files = ['DashboardView.swift', 'DashboardViewModel.swift']
all_valid = True
for f in files:
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), f)
    if not validate_swift_file(path):
        all_valid = False

if all_valid:
    print("All Swift files are valid.")
else:
    print("Some Swift files are invalid.")
    sys.exit(1)
