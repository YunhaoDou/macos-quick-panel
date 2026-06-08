#!/bin/bash
# QuickPanel 发布脚本
# 用法: bash scripts/release.sh
# 功能: 
#   1. 编译 + 打包 .app
#   2. 生成 DMG 安装包
#   3. 推送到 GitHub (代码 + Release)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_NAME="QuickPanel"

cd "$PROJECT_DIR"

# ── 1. 读取当前版本 ──
VERSION=$(grep 'currentVersion' Sources/QuickPanel/Helpers/AppUpdater.swift | grep -o '"[0-9.]*"' | tr -d '"')
echo "══════════════════════════════════════════"
echo "  QuickPanel Release v${VERSION}"
echo "══════════════════════════════════════════"

# ── 2. 编译 ──
echo ""
echo "📦 [1/5] 编译..."
swift build -c release 2>&1 | grep -E "Build complete|error:" || {
    echo "❌ 编译失败"
    exit 1
}

# ── 3. 打包 .app ──
echo ""
echo "📦 [2/5] 打包 .app..."
bash scripts/build.sh --release 2>&1 | tail -3

# ── 4. 生成 DMG ──
echo ""
echo "📦 [3/5] 生成 DMG..."
bash scripts/create-dmg.sh 2>&1

DMG_PATH="$PROJECT_DIR/dist/${APP_NAME}-v${VERSION}.dmg"
if [ ! -f "$DMG_PATH" ]; then
    echo "❌ DMG 生成失败"
    exit 1
fi
DMG_SIZE=$(du -h "$DMG_PATH" | cut -f1)
echo "  ✅ DMG: $DMG_PATH ($DMG_SIZE)"

# ── 5. 提交代码 ──
echo ""
echo "📦 [4/5] 提交代码到 Git..."

# 动态生成 changelog (从上次 tag 到现在的 commits)
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [ -n "$LAST_TAG" ]; then
    CHANGES=$(git log --oneline --no-decorate "$LAST_TAG..HEAD" 2>/dev/null | head -20 || echo "")
else
    CHANGES=$(git log --oneline --no-decorate -10 2>/dev/null || echo "")
fi

git add -A
git commit -m "🔖 Release v${VERSION}

${CHANGES}"
git push origin main 2>&1 || git push origin +main 2>&1

echo "  ✅ 代码已推送"

# ── 6. 发布到 GitHub Releases ──
echo ""
echo "📦 [5/5] 发布到 GitHub Releases..."

TOKEN=$(echo -e "protocol=https\nhost=github.com" | git credential-osxkeychain get | grep "^password=" | cut -d= -f2)

# 删除旧 release (如果存在)
echo "  检查旧 release..."
curl -s -H "Authorization: token $TOKEN" \
  "https://api.github.com/repos/YunhaoDou/${APP_NAME}/releases/tags/v${VERSION}" 2>/dev/null | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('id',''))" 2>/dev/null | \
  while read id; do
    if [ -n "$id" ]; then
      curl -s -X DELETE -H "Authorization: token $TOKEN" \
        "https://api.github.com/repos/YunhaoDou/${APP_NAME}/releases/$id" >/dev/null 2>&1
      echo "  已删除旧 release"
    fi
  done

# 创建新 release
echo "  创建新 release..."
CHANGELOG=$(cat << EOM
## QuickPanel v${VERSION}

$(echo "$CHANGES" | sed 's/^/- /')

### 下载
- \`${APP_NAME}-v${VERSION}.dmg\` (${DMG_SIZE})
EOM
)

RELEASE_JSON=$(curl -s -X POST \
  "https://api.github.com/repos/YunhaoDou/${APP_NAME}/releases" \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d "$(python3 -c "
import json, sys
data = {
    'tag_name': 'v${VERSION}',
    'target_commitish': 'main',
    'name': 'v${VERSION}',
    'body': '''${CHANGELOG}''',
    'draft': False,
    'prerelease': False
}
print(json.dumps(data))
")" 2>/dev/null)

RELEASE_ID=$(echo "$RELEASE_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)

if [ -z "$RELEASE_ID" ]; then
    echo "❌ Release 创建失败"
    echo "$RELEASE_JSON"
    exit 1
fi
echo "  Release ID: $RELEASE_ID"

# 上传 DMG
echo "  上传 DMG..."
curl -s -X POST \
  "https://uploads.github.com/repos/YunhaoDou/${APP_NAME}/releases/${RELEASE_ID}/assets?name=${APP_NAME}-v${VERSION}.dmg" \
  -H "Authorization: token $TOKEN" \
  -H "Content-Type: application/x-apple-diskimage" \
  --upload-file "$DMG_PATH" >/dev/null 2>&1

echo "  ✅ DMG 已上传"

echo ""
echo "══════════════════════════════════════════"
echo "  🎉 Release v${VERSION} 完成!"
echo "  https://github.com/YunhaoDou/${APP_NAME}/releases/tag/v${VERSION}"
echo "══════════════════════════════════════════"
