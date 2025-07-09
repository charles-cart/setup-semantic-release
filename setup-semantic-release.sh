#!/bin/bash
# setup-semantic-release.sh
# Script para configurar Semantic Release en un proyecto desde cero

echo "🚀 Configurando Semantic Release..."

# 1. Instalar dependencias
echo "📦 Instalando dependencias..."
npm install --save-dev semantic-release
npm install --save-dev @semantic-release/changelog
npm install --save-dev @semantic-release/git
npm install --save-dev @semantic-release/github
npm install --save-dev @semantic-release/npm
npm install --save-dev @commitlint/cli
npm install --save-dev @commitlint/config-conventional
npm install --save-dev husky

# 2. Configurar Husky
echo "🪝 Configurando Husky..."
npx husky install
npx husky add .husky/commit-msg 'npx --no -- commitlint --edit ${1}'
npx husky add .husky/pre-commit 'npm run lint && npm run test'

# 3. Crear archivos de configuración
echo "⚙️ Creando archivos de configuración..."

# commitlint.config.js
cat > commitlint.config.js << 'EOF'
module.exports = {
  extends: ['@commitlint/config-conventional'],
};
EOF

# release.config.js
cat > release.config.js << 'EOF'
const releaseRules = [
  { type: 'feat', release: 'minor' },
  { type: 'fix', release: 'patch' },
  { type: 'refactor', release: 'patch' },
  { type: 'build', release: 'patch' },
  { type: 'chore', release: 'patch' },
  { type: 'test', release: 'patch' },
  { type: 'ci', release: 'patch' },
  { type: 'perf', release: 'patch' },
  { type: 'docs', release: false },
  { type: 'style', release: false },
];

module.exports = {
  branches: ['master', 'main'],
  plugins: [
    [
      '@semantic-release/commit-analyzer',
      {
        preset: 'angular',
        releaseRules,
      },
    ],
    '@semantic-release/release-notes-generator',
    [
      '@semantic-release/changelog',
      {
        changelogFile: 'CHANGELOG.md',
      },
    ],
    [
      '@semantic-release/npm',
      {
        npmPublish: false,
      },
    ],
    [
      '@semantic-release/git',
      {
        assets: ['CHANGELOG.md', 'package.json'],
        message: 'chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}',
      },
    ],
    '@semantic-release/github',
  ],
};
EOF

# 4. Crear directorio de GitHub Actions si no existe
mkdir -p .github/workflows

# 5. Crear workflow de release
cat > .github/workflows/release.yml << 'EOF'
name: release
run-name: release

on:
  push:
    branches:
      - master
      - main
  workflow_dispatch:

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          token: ${{ secrets.GITHUB_TOKEN }}
      
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      
      - run: npm ci
      - run: npm run build
      - run: npx semantic-release
EOF

# 6. Actualizar package.json con scripts
echo "📝 Actualizando package.json..."
npm pkg set scripts.release="semantic-release"
npm pkg set scripts.release:dry-run="semantic-release --dry-run"
npm pkg set scripts.prepare="husky install"

# 7. Crear CHANGELOG.md inicial si no existe
if [ ! -f CHANGELOG.md ]; then
    echo "📄 Creando CHANGELOG.md inicial..."
    cat > CHANGELOG.md << 'EOF'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
EOF
fi

echo "✅ ¡Configuración completada!"
echo ""
echo "🎯 Próximos pasos:"
echo "1. Hacer commit de los cambios: git add . && git commit -m 'chore: setup semantic-release'"
echo "2. Hacer push a master/main para activar el primer release"
echo "3. Usar conventional commits de ahora en adelante"
echo ""
echo "🧪 Para probar la configuración:"
echo "npm run release:dry-run"
echo ""
echo "📚 Guía de commits:"
echo "feat: nueva funcionalidad (minor version)"
echo "fix: corrección de bugs (patch version)"
echo "docs: solo documentación (no version)"
echo "feat!: breaking change (major version)"
