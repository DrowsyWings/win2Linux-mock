from PyInstaller.utils.hooks import collect_data_files, collect_dynamic_libs
import os
import shutil
from PyInstaller.building.api import COLLECT, EXE, PYZ
from PyInstaller.building.build_main import Analysis
from PyInstaller.building.datastruct import Tree

kirigami_qml_root = r"C:\CraftRoot\build\kde\frameworks\tier1\kirigami\image-RelWithDebInfo-6.12.0\qml"
kirigami_bin_path = r"C:\CraftRoot\build\kde\frameworks\tier1\kirigami\image-RelWithDebInfo-6.12.0\bin"
qt_plugins_path = r"C:\Qt\6.9.0\mingw_64\plugins"
qt_qml_path = r"C:\Qt\6.9.0\mingw_64\qml"

app_qml_files = [
    ('src/qml', 'qml'),
    ('src/qml/pages', 'qml/pages'),
]

kirigami_qml_files = []
kirigamiplugin_path = os.path.join(kirigami_qml_root, 'org', 'kde', 'kirigami', 'Kirigamiplugin.dll')

if os.path.exists(os.path.join(kirigami_qml_root, 'org')):
    # Recursive collection of all Kirigami QML files
    for root, dirs, files in os.walk(os.path.join(kirigami_qml_root, 'org')):
        rel_path = os.path.relpath(root, kirigami_qml_root)
        dest_path = os.path.join('qml', rel_path)
        for file in files:
            source_path = os.path.join(root, file)
            kirigami_qml_files.append((source_path, dest_path))

if os.path.exists(kirigamiplugin_path):
    kirigami_qml_files.append((kirigamiplugin_path, 'qml/org/kde/kirigami'))


dll_files = []
required_dlls = [
    'Kirigami.dll',
    'KirigamiPlatform.dll',
    'KirigamiDelegates.dll',
    'KirigamiDialogs.dll',
    'KirigamiLayouts.dll',
    'KirigamiPrimitives.dll',
    'KirigamiPrivate.dll',
]

for dll in required_dlls:
    dll_path = os.path.join(kirigami_bin_path, dll)
    if os.path.exists(dll_path):
        # Add to root for general loading
        dll_files.append((dll_path, '.'))
        # Also add to the plugin directory where QML will look for it
        dll_files.append((dll_path, 'qml/org/kde/kirigami'))

for file in os.listdir(kirigami_bin_path):
    if file.endswith('.dll') and file not in required_dlls:
        dll_path = os.path.join(kirigami_bin_path, file)
        dll_files.append((dll_path, '.'))

dll_files.extend([
    (r"C:\Qt\6.9.0\mingw_64\bin\Qt6Qml.dll", '.'),
    (r"C:\Qt\6.9.0\mingw_64\bin\Qt6Gui.dll", '.'),
    (r"C:\Qt\6.9.0\mingw_64\bin\Qt6Core.dll", '.'),
])


# Qt plugins to include
qt_plugin_dirs = [
    'platforms',       # Essential for window creation
    'imageformats',    # For image handling
    'iconengines',     # For icon handling
    'styles',          # For QStyle implementations
    'sqldrivers',      # If your app uses SQL
    'tls',             # For secure connections
    'qmltooling',      # For QML debugging
]

qt_plugin_files = []
for plugin_dir in qt_plugin_dirs:
    plugin_path = os.path.join(qt_plugins_path, plugin_dir)
    if os.path.exists(plugin_path):
        for file in os.listdir(plugin_path):
            if file.endswith('.dll'):
                full_path = os.path.join(plugin_path, file)
                qt_plugin_files.append((full_path, os.path.join('plugins', plugin_dir)))

# Include Qt QML modules
qt_qml_dirs = ['QtQml', 'QtQuick', 'QtCore', 'QtGui']
qt_qml_files = []

for qml_dir in qt_qml_dirs:
    qml_path = os.path.join(qt_qml_path, qml_dir)
    if os.path.exists(qml_path):
        for root, dirs, files in os.walk(qml_path):
            rel_path = os.path.relpath(root, qt_qml_path)
            dest_path = os.path.join('qml', rel_path)
            for file in files:
                qt_qml_files.append((os.path.join(root, file), dest_path))

json_files = [
    ('src/backend/questionnaire/questionnaire.json', 'backend/questionnaire'),
    ('src/backend/questionnaire/responses.json', 'backend/questionnaire'),
    ('src/backend/distro.json', 'backend'),
    ('src/backend/recomendationModel/marking.json', 'backend/recomendationModel'),
]

assets_files = []
assets_dir = 'assets'
if os.path.exists(assets_dir):
    assets_files = [(os.path.join(assets_dir, file), 'assets') for file in os.listdir(assets_dir)]

datas = app_qml_files + kirigami_qml_files + json_files + assets_files + qt_qml_files

a = Analysis(
    ['src/main.py'],
    pathex=[],
    binaries=dll_files + qt_plugin_files,
    datas=datas,
    hiddenimports=[
        'PySide6.QtQml', 
        'PySide6.QtQuick', 
        'PySide6.QtCore', 
        'PySide6.QtGui',
        'PySide6.QtWidgets',
        'PySide6.QtNetwork',
        'PySide6.QtQuickControls2',
    ],
    hookspath=[],
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=None,
)

# Create the executable
pyz = PYZ(a.pure)
exe = EXE(
    pyz,
    a.scripts,
    [],  # Remove a.binaries, a.zipfiles, a.datas from here
    exclude_binaries=True,  # Important!
    name='main',
    debug=True,
    strip=False,
    upx=True,
    console=True,
)

coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='main',
)
