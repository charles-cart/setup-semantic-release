# Guía de Pruebas para Semantic Release

## 🧪 **Pruebas Locales**

### 1. Probar configuración sin hacer release real
```bash
# Dry run - muestra qué haría sin ejecutar
npm run release:dry-run

# O directamente:
npx semantic-release --dry-run
```

### 2. Validar mensajes de commit
```bash
# Probar commitlint manualmente
echo "feat: add new feature" | npx commitlint

# Debería pasar ✅
echo "fix: resolve bug" | npx commitlint

# Debería fallar ❌
echo "quick fix" | npx commitlint
```

### 3. Simular diferentes tipos de commits
```bash
# Crear commits de prueba (no hacer push aún)
git commit --allow-empty -m "feat: add user authentication"
git commit --allow-empty -m "fix: resolve login issue"
git commit --allow-empty -m "docs: update README"

# Probar qué versión generaría
npm run release:dry-run
```

## 🔍 **Verificaciones Importantes**

### ✅ **Checklist antes del primer release:**

1. **Dependencias instaladas**
   ```bash
   npm ls semantic-release @semantic-release/changelog @semantic-release/git @semantic-release/github @semantic-release/npm
   ```

2. **Archivos de configuración presentes**
   - [ ] `release.config.js` existe
   - [ ] `commitlint.config.js` existe
   - [ ] `.github/workflows/release.yml` existe
   - [ ] `.husky/commit-msg` existe

3. **Scripts en package.json**
   - [ ] `"release": "semantic-release"`
   - [ ] `"release:dry-run": "semantic-release --dry-run"`
   - [ ] `"prepare": "husky install"`

4. **Rama correcta configurada**
   ```bash
   # Verificar que estás en master/main
   git branch --show-current
   ```

5. **Historial de git limpio**
   ```bash
   # Verificar que no hay cambios pendientes
   git status
   ```

## 🎯 **Flujo de Prueba Completo**

### 1. Configuración inicial
```bash
# Clonar en un proyecto nuevo o usar existente
git clone <tu-repo>
cd <tu-proyecto>

# Ejecutar script de configuración
chmod +x setup-semantic-release.sh
./setup-semantic-release.sh
```

### 2. Probar commitlint
```bash
# Intentar commit inválido (debería fallar)
git commit --allow-empty -m "quick fix"

# Intentar commit válido (debería pasar)
git commit --allow-empty -m "feat: add new feature"
```

### 3. Probar semantic-release en dry-run
```bash
# Ver qué release generaría
npm run release:dry-run
```

### 4. Primer release real
```bash
# Hacer commit inicial de configuración
git add .
git commit -m "chore: setup semantic-release configuration"

# Push a master para activar el workflow
git push origin master
```

## 📊 **Interpretar Resultados**

### Output esperado de dry-run:
```
[semantic-release] › ℹ  Running semantic-release version X.X.X
[semantic-release] › ✔  Loaded plugin "verifyConditions"
[semantic-release] › ✔  Loaded plugin "analyzeCommits"
[semantic-release] › ✔  Loaded plugin "generateNotes"
[semantic-release] › ℹ  The next release version is X.X.X
[semantic-release] › ℹ  The release will be published to GitHub
```

### Posibles errores y soluciones:

#### ❌ "No commits found"
```
[semantic-release] › ℹ  No commits to analyze
```
**Solución**: Hacer commits con conventional format desde el último tag

#### ❌ "Plugin not found"
```
[semantic-release] › ✖  Cannot find module '@semantic-release/changelog'
```
**Solución**: Instalar la dependencia faltante
```bash
npm install --save-dev @semantic-release/changelog
```

#### ❌ "Branch not configured"
```
[semantic-release] › ✖  This branch is not configured for releases
```
**Solución**: Verificar que estás en master/main o actualizar `release.config.js`

## 🚀 **Verificar Release Exitoso**

Después de un release exitoso, deberías ver:

1. **Nuevo tag en GitHub**: `v1.0.0`, `v1.1.0`, etc.
2. **Release en GitHub**: Con notas automáticas
3. **CHANGELOG.md actualizado**: Con los cambios
4. **package.json actualizado**: Nueva versión
5. **Commit automático**: `chore(release): X.X.X [skip ci]`

## 🔧 **Debugging y Logs**

### Habilitar logs detallados:
```bash
DEBUG=semantic-release:* npm run release:dry-run
```

### Verificar configuración:
```bash
# Ver configuración actual
npx semantic-release --dry-run --debug
```

### Logs del GitHub Actions:
1. Ir a tu repositorio en GitHub
2. Ir a "Actions" tab
3. Seleccionar el workflow "release"
4. Ver los logs detallados de cada step

## 🎯 **Troubleshooting Común**

### Problema: Release no se ejecuta
- Verificar que el push fue a master/main
- Verificar que hay commits desde el último release
- Verificar que los commits siguen conventional format

### Problema: Permisos de GitHub
- Verificar que GITHUB_TOKEN tiene permisos suficientes
- Verificar configuración de permisos en el workflow

### Problema: Tests fallan
- Verificar que todos los tests pasan localmente
- Verificar que el comando `npm run test:ci` existe
