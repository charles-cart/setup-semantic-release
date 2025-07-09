# Guía de Conventional Commits para Semantic Release

## 📝 Formato Básico
```
<tipo>[alcance opcional]: <descripción>

[cuerpo opcional]

[pie opcional]
```

## 🏷️ Tipos de Commit y su Impacto en Versioning

### 🚀 **MINOR VERSION** (1.0.0 → 1.1.0)
```bash
feat: add user authentication system
feat(auth): implement JWT token validation
feat!: redesign API endpoints (BREAKING CHANGE)
```

### 🐛 **PATCH VERSION** (1.0.0 → 1.0.1)
```bash
fix: resolve login redirect issue
fix(api): handle null response in user service
perf: improve database query performance
refactor: extract user validation logic
build: update webpack configuration
test: add unit tests for auth service
ci: update GitHub Actions workflow
chore: update dependencies
```

### ❌ **NO VERSION** (no genera release)
```bash
docs: update README with new examples
style: fix code formatting issues
```

## 🔥 **MAJOR VERSION** (1.0.0 → 2.0.0)
Para breaking changes, usa `!` o `BREAKING CHANGE:`

```bash
# Opción 1: Usar !
feat!: redesign user API endpoints

# Opción 2: Usar BREAKING CHANGE en el pie
feat: redesign user API endpoints

BREAKING CHANGE: The user endpoints now require authentication headers
```

## 📋 **Ejemplos Completos**

### ✅ Buenos ejemplos:
```bash
# Nueva funcionalidad
feat: add product search filters
feat(search): implement advanced filtering options

# Corrección de bug
fix: resolve pagination issue in product list
fix(api): handle timeout errors in payment service

# Mejora de rendimiento
perf: optimize image loading in gallery
perf(db): add indexes to frequently queried tables

# Refactoring
refactor: extract common validation logic
refactor(auth): simplify token verification process

# Documentación
docs: add API examples to README
docs(auth): document new authentication flow

# Tests
test: add unit tests for payment service
test(e2e): add checkout flow tests

# Build/CI
build: update Docker configuration
ci: add automated security scanning

# Breaking changes
feat!: remove deprecated payment methods

BREAKING CHANGE: 
- Removed support for legacy payment API
- All clients must update to use new payment endpoints
```

### ❌ Malos ejemplos:
```bash
# Muy vago
fix: bug fixes
feat: improvements

# No sigue el formato
Fixed the login bug
Added new feature

# Typos o formato incorrecto
fix resolve login issue  # falta ':'
feat:add new feature     # falta espacio después de ':'
```

## 🎯 **Consejos para Buenos Commits**

1. **Usa imperativos**: "add" no "adds" o "added"
2. **Sé específico**: En lugar de "fix bug", usa "fix login redirect issue"
3. **Mantén líneas cortas**: Máximo 50 caracteres en el título
4. **Usa scope cuando sea útil**: `feat(auth):`, `fix(api):`, etc.
5. **Explica el QUÉ y POR QUÉ**: No solo el cómo

## 🛠️ **Configuración de tu Editor**

### VSCode (extensión recomendada):
- **Conventional Commits**: Ayuda a escribir commits correctos
- **GitLens**: Mejora la experiencia con git

### Configurar template de commit:
```bash
git config --global commit.template ~/.gitmessage
```

Crear `~/.gitmessage`:
```
# <tipo>[alcance]: <descripción>
# 
# Tipos: feat, fix, docs, style, refactor, test, chore, perf, ci, build
# Alcance: auth, api, ui, db, etc.
# 
# Ejemplos:
# feat(auth): add JWT token validation
# fix(api): resolve timeout in user service
# docs: update installation guide
```

## 🔍 **Validación Automática**

Con la configuración de commitlint, estos commits serán **rechazados**:
```bash
❌ "quick fix"
❌ "WIP"
❌ "update stuff"
❌ "feat add feature"  # falta ':'
```

Y estos serán **aceptados**:
```bash
✅ "feat: add user dashboard"
✅ "fix: resolve memory leak in worker"
✅ "docs: update API documentation"
✅ "refactor(auth): simplify login flow"
```
