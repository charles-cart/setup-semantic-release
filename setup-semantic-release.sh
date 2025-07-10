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
npx husky init

# Crear hook de commit-msg
echo 'npx --no -- commitlint --edit $1' > .husky/commit-msg
chmod +x .husky/commit-msg

# Crear hook de pre-commit (opcional - comentado porque puede no tener lint/test)
# echo 'npm run lint && npm run test' > .husky/pre-commit
# chmod +x .husky/pre-commit

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
          fetch-depth: 0 # Necesario para semantic-release
          token: ${{ secrets.GITHUB_TOKEN }}
      
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      
      - run: npm ci
      - run: npm run build
      - run: npx semantic-release
    env:
      GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  refresh-staging:
    needs: release
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Merge master branch into staging # update branch staging
        if: github.ref == 'refs/heads/master' && github.event_name == 'push'
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git checkout staging
          git pull origin master --no-ff --no-edit
          git push origin staging
EOF

# 6. Actualizar package.json con scripts
echo "📝 Actualizando package.json..."
npm pkg set scripts.release="semantic-release"
npm pkg set scripts.release:dry-run="semantic-release --dry-run"
npm pkg set scripts.prepare="husky install"

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
