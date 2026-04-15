#!/bin/bash
set -e

PROJECT_DIR=~/AncientTarot
BUNDLE_ID="com.tokyonasu.AncientTarot"
APP_NAME="AncientTarot"

rm -rf "$PROJECT_DIR"
mkdir -p "$PROJECT_DIR/$APP_NAME"
cp -r ~/AncientTarot_tmp/AncientTarot/* "$PROJECT_DIR/$APP_NAME/"

# Assets
mkdir -p "$PROJECT_DIR/$APP_NAME/Assets.xcassets/AppIcon.appiconset"
mkdir -p "$PROJECT_DIR/$APP_NAME/Assets.xcassets/AccentColor.colorset"

cat > "$PROJECT_DIR/$APP_NAME/Assets.xcassets/Contents.json" << 'EOF'
{"info":{"author":"xcode","version":1}}
EOF

cat > "$PROJECT_DIR/$APP_NAME/Assets.xcassets/AppIcon.appiconset/Contents.json" << 'EOF'
{"images":[{"idiom":"universal","platform":"ios","size":"1024x1024"}],"info":{"author":"xcode","version":1}}
EOF

cat > "$PROJECT_DIR/$APP_NAME/Assets.xcassets/AccentColor.colorset/Contents.json" << 'EOF'
{"colors":[{"color":{"color-space":"srgb","components":{"alpha":"1.000","blue":"0.216","green":"0.686","red":"0.831"}},"idiom":"universal"}],"info":{"author":"xcode","version":1}}
EOF

# Info.plist
cat > "$PROJECT_DIR/$APP_NAME/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>ja</string>
    <key>CFBundleDisplayName</key>
    <string>古のタロット</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UILaunchScreen</key>
    <dict>
        <key>UIColorName</key>
        <string>AccentColor</string>
    </dict>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <false/>
    </dict>
    <key>ITSAppUsesNonExemptEncryption</key>
    <false/>
</dict>
</plist>
EOF

# Generate pbxproj with Python
mkdir -p "$PROJECT_DIR/$APP_NAME.xcodeproj"

python3 << 'PYEOF'
import os, hashlib

PROJECT_DIR = os.path.expanduser("~/AncientTarot")
APP_NAME = "AncientTarot"
BUNDLE_ID = "com.tokyonasu.AncientTarot"

def gen_uuid(seed):
    return hashlib.md5(seed.encode()).hexdigest().upper()[:24]

swift_files = []
resource_files = []
src_dir = os.path.join(PROJECT_DIR, APP_NAME)
for root, dirs, files in os.walk(src_dir):
    for f in sorted(files):
        rel = os.path.relpath(os.path.join(root, f), src_dir)
        if f.endswith(".swift"):
            swift_files.append((f, rel))
        elif f.endswith(".json") and not f.startswith("gen") and "Contents" not in f:
            resource_files.append((f, rel))

root_obj = gen_uuid("root_object")
main_group = gen_uuid("main_group")
product_group = gen_uuid("product_group")
app_target = gen_uuid("app_target")
bcl_proj = gen_uuid("bcl_proj")
bcl_target = gen_uuid("bcl_target")
debug_proj = gen_uuid("debug_proj")
release_proj = gen_uuid("release_proj")
debug_target = gen_uuid("debug_target")
release_target = gen_uuid("release_target")
product_ref = gen_uuid("product_ref")
sources_phase = gen_uuid("sources_phase")
resources_phase = gen_uuid("resources_phase")
frameworks_phase = gen_uuid("frameworks_phase")
source_group = gen_uuid("source_group")
assets_ref = gen_uuid("assets_ref")
assets_build = gen_uuid("assets_build")
info_ref = gen_uuid("info_plist_ref")

file_refs = []
for name, rel in swift_files:
    fr = gen_uuid(f"fileref_{rel}")
    bf = gen_uuid(f"buildfile_{rel}")
    file_refs.append((fr, bf, name, rel))

res_refs = []
for name, rel in resource_files:
    fr = gen_uuid(f"fileref_{rel}")
    bf = gen_uuid(f"buildfile_{rel}")
    res_refs.append((fr, bf, name, rel))

L = []
L.append('// !$*UTF8*$!')
L.append('{')
L.append('\tarchiveVersion = 1;')
L.append('\tclasses = {};')
L.append('\tobjectVersion = 56;')
L.append('\tobjects = {')
L.append('')
L.append('/* Begin PBXBuildFile section */')
for fr, bf, name, rel in file_refs:
    L.append(f'\t\t{bf} = {{isa = PBXBuildFile; fileRef = {fr}; }};')
for fr, bf, name, rel in res_refs:
    L.append(f'\t\t{bf} = {{isa = PBXBuildFile; fileRef = {fr}; }};')
L.append(f'\t\t{assets_build} = {{isa = PBXBuildFile; fileRef = {assets_ref}; }};')
L.append('/* End PBXBuildFile section */')
L.append('')
L.append('/* Begin PBXFileReference section */')
for fr, bf, name, rel in file_refs:
    L.append(f'\t\t{fr} = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{rel}"; sourceTree = "<group>"; }};')
for fr, bf, name, rel in res_refs:
    L.append(f'\t\t{fr} = {{isa = PBXFileReference; lastKnownFileType = text.json; path = "{rel}"; sourceTree = "<group>"; }};')
L.append(f'\t\t{assets_ref} = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; }};')
L.append(f'\t\t{info_ref} = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; }};')
L.append(f'\t\t{product_ref} = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = "{APP_NAME}.app"; sourceTree = BUILT_PRODUCTS_DIR; }};')
L.append('/* End PBXFileReference section */')
L.append('')
L.append('/* Begin PBXFrameworksBuildPhase section */')
L.append(f'\t\t{frameworks_phase} = {{')
L.append('\t\t\tisa = PBXFrameworksBuildPhase;')
L.append('\t\t\tbuildActionMask = 2147483647;')
L.append('\t\t\tfiles = ();')
L.append('\t\t\trunOnlyForDeploymentPostprocessing = 0;')
L.append('\t\t};')
L.append('/* End PBXFrameworksBuildPhase section */')
L.append('')
L.append('/* Begin PBXGroup section */')
L.append(f'\t\t{main_group} = {{')
L.append('\t\t\tisa = PBXGroup;')
L.append(f'\t\t\tchildren = ({source_group},{product_group},);')
L.append('\t\t\tsourceTree = "<group>";')
L.append('\t\t};')
L.append(f'\t\t{product_group} = {{')
L.append('\t\t\tisa = PBXGroup;')
L.append(f'\t\t\tchildren = ({product_ref},);')
L.append('\t\t\tname = Products;')
L.append('\t\t\tsourceTree = "<group>";')
L.append('\t\t};')
L.append(f'\t\t{source_group} = {{')
L.append('\t\t\tisa = PBXGroup;')
L.append('\t\t\tchildren = (')
for fr, bf, name, rel in file_refs:
    L.append(f'\t\t\t\t{fr},')
for fr, bf, name, rel in res_refs:
    L.append(f'\t\t\t\t{fr},')
L.append(f'\t\t\t\t{assets_ref},')
L.append(f'\t\t\t\t{info_ref},')
L.append('\t\t\t);')
L.append(f'\t\t\tpath = "{APP_NAME}";')
L.append('\t\t\tsourceTree = "<group>";')
L.append('\t\t};')
L.append('/* End PBXGroup section */')
L.append('')
L.append('/* Begin PBXNativeTarget section */')
L.append(f'\t\t{app_target} = {{')
L.append('\t\t\tisa = PBXNativeTarget;')
L.append(f'\t\t\tbuildConfigurationList = {bcl_target};')
L.append(f'\t\t\tbuildPhases = ({sources_phase},{frameworks_phase},{resources_phase},);')
L.append('\t\t\tbuildRules = ();')
L.append('\t\t\tdependencies = ();')
L.append(f'\t\t\tname = "{APP_NAME}";')
L.append(f'\t\t\tproductName = "{APP_NAME}";')
L.append(f'\t\t\tproductReference = {product_ref};')
L.append('\t\t\tproductType = "com.apple.product-type.application";')
L.append('\t\t};')
L.append('/* End PBXNativeTarget section */')
L.append('')
L.append('/* Begin PBXProject section */')
L.append(f'\t\t{root_obj} = {{')
L.append('\t\t\tisa = PBXProject;')
L.append(f'\t\t\tattributes = {{BuildIndependentTargetsInParallel = 1; LastSwiftUpdateCheck = 1620; LastUpgradeCheck = 1620; TargetAttributes = {{{app_target} = {{CreatedOnToolsVersion = 16.2;}};}};}}; ')
L.append(f'\t\t\tbuildConfigurationList = {bcl_proj};')
L.append('\t\t\tcompatibilityVersion = "Xcode 14.0";')
L.append('\t\t\tdevelopmentRegion = ja;')
L.append('\t\t\thasScannedForEncodings = 0;')
L.append('\t\t\tknownRegions = (ja, Base);')
L.append(f'\t\t\tmainGroup = {main_group};')
L.append(f'\t\t\tproductRefGroup = {product_group};')
L.append('\t\t\tprojectDirPath = "";')
L.append('\t\t\tprojectRoot = "";')
L.append(f'\t\t\ttargets = ({app_target},);')
L.append('\t\t};')
L.append('/* End PBXProject section */')
L.append('')
L.append('/* Begin PBXResourcesBuildPhase section */')
L.append(f'\t\t{resources_phase} = {{')
L.append('\t\t\tisa = PBXResourcesBuildPhase;')
L.append('\t\t\tbuildActionMask = 2147483647;')
L.append('\t\t\tfiles = (')
L.append(f'\t\t\t\t{assets_build},')
for fr, bf, name, rel in res_refs:
    L.append(f'\t\t\t\t{bf},')
L.append('\t\t\t);')
L.append('\t\t\trunOnlyForDeploymentPostprocessing = 0;')
L.append('\t\t};')
L.append('/* End PBXResourcesBuildPhase section */')
L.append('')
L.append('/* Begin PBXSourcesBuildPhase section */')
L.append(f'\t\t{sources_phase} = {{')
L.append('\t\t\tisa = PBXSourcesBuildPhase;')
L.append('\t\t\tbuildActionMask = 2147483647;')
L.append('\t\t\tfiles = (')
for fr, bf, name, rel in file_refs:
    L.append(f'\t\t\t\t{bf},')
L.append('\t\t\t);')
L.append('\t\t\trunOnlyForDeploymentPostprocessing = 0;')
L.append('\t\t};')
L.append('/* End PBXSourcesBuildPhase section */')
L.append('')

# Build configs
for uid, name, is_debug, is_proj in [
    (debug_proj, "Debug", True, True), (release_proj, "Release", False, True),
    (debug_target, "Debug", True, False), (release_target, "Release", False, False)]:
    L.append(f'\t\t{uid} = {{')
    L.append('\t\t\tisa = XCBuildConfiguration;')
    L.append('\t\t\tbuildSettings = {')
    if is_proj:
        L.append('\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;')
        L.append('\t\t\t\tCLANG_ENABLE_MODULES = YES;')
        L.append('\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;')
        L.append('\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;')
        L.append('\t\t\t\tSDKROOT = iphoneos;')
        L.append(f'\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "{"-Onone" if is_debug else "-O"}";')
        if is_debug:
            L.append('\t\t\t\tONLY_ACTIVE_ARCH = YES;')
            L.append('\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;')
            L.append('\t\t\t\tENABLE_TESTABILITY = YES;')
        else:
            L.append('\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";')
            L.append('\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;')
            L.append('\t\t\t\tVALIDATE_PRODUCT = YES;')
    else:
        L.append('\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;')
        L.append('\t\t\t\tASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;')
        L.append('\t\t\t\tCODE_SIGN_STYLE = Automatic;')
        L.append('\t\t\t\tCURRENT_PROJECT_VERSION = 1;')
        L.append('\t\t\t\tDEVELOPMENT_TEAM = 83VGKGSQUH;')
        L.append('\t\t\t\tGENERATE_INFOPLIST_FILE = NO;')
        L.append(f'\t\t\t\tINFOPLIST_FILE = "{APP_NAME}/Info.plist";')
        L.append('\t\t\t\tLD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/Frameworks");')
        L.append('\t\t\t\tMARKETING_VERSION = 1.0.0;')
        L.append(f'\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = "{BUNDLE_ID}";')
        L.append('\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";')
        L.append('\t\t\t\tSUPPORTED_PLATFORMS = "iphoneos iphonesimulator";')
        L.append('\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;')
        L.append('\t\t\t\tSWIFT_VERSION = 5.0;')
        L.append('\t\t\t\tTARGETED_DEVICE_FAMILY = "1";')
    L.append('\t\t\t};')
    L.append(f'\t\t\tname = {name};')
    L.append('\t\t};')

L.append('')
L.append('/* Begin XCConfigurationList section */')
for uid, configs in [(bcl_proj, (debug_proj, release_proj)), (bcl_target, (debug_target, release_target))]:
    L.append(f'\t\t{uid} = {{')
    L.append('\t\t\tisa = XCConfigurationList;')
    L.append(f'\t\t\tbuildConfigurations = ({configs[0]},{configs[1]},);')
    L.append('\t\t\tdefaultConfigurationIsVisible = 0;')
    L.append('\t\t\tdefaultConfigurationName = Release;')
    L.append('\t\t};')
L.append('/* End XCConfigurationList section */')
L.append('')
L.append('\t};')
L.append(f'\trootObject = {root_obj};')
L.append('}')

path = os.path.join(PROJECT_DIR, f"{APP_NAME}.xcodeproj", "project.pbxproj")
with open(path, "w") as f:
    f.write("\n".join(L) + "\n")
print(f"pbxproj: {len(swift_files)} swift, {len(resource_files)} json")
PYEOF

echo "Done! $(find "$PROJECT_DIR/$APP_NAME" -name '*.swift' | wc -l) Swift files"
