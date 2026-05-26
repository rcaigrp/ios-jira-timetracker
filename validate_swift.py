import os
import glob

def validate_swift_files():
    project_dir = '/workspace/projects/iOS-Jira-TimeTracker'
    swift_files = glob.glob(os.path.join(project_dir, '*.swift'))
    if not swift_files:
        raise Exception('No Swift files found')
    for f in swift_files:
        with open(f, 'r') as file:
            content = file.read()
            if 'import SwiftUI' not in content and 'import Foundation' not in content:
                raise Exception(f'Missing imports in {f}')
            if 'struct' not in content or 'class' not in content:
                raise Exception(f'Missing struct/class in {f}')
    print(f'All {len(swift_files)} Swift files are valid.')

if __name__ == '__main__':
    validate_swift_files()
