# Setup Semantic Release

Este repositorio contiene un script automatizado para configurar **Semantic Release** en cualquier proyecto JavaScript/TypeScript desde cero.

## 🚀 Instalación y Uso

### Prerrequisitos

- Node.js (versión 16 o superior)
- Git configurado
- Repositorio en GitHub

### Ejecución del Script

1. **Descargar el script** en tu proyecto:
   ```bash
   curl -O https://raw.githubusercontent.com/charles-cart/setup-semantic-release/main/setup-semantic-release.sh
   ```

2. **Hacer el script ejecutable**:
   ```bash
   chmod +x setup-semantic-release.sh
   ```

3. **Ejecutar el script en la raiz de tu proyecto**:
   ```bash
   ./setup-semantic-release.sh
   ```

### ¿Qué hace el script?

El script configura automáticamente:

- ✅ **Semantic Release** y todos sus plugins
- ✅ **Husky** para validación de commits
- ✅ **Commitlint** para conventional commits
- ✅ **GitHub Actions** para releases automáticos

## 📚 Guías Detalladas

Este repositorio incluye guías completas para entender cada componente:

- **[GUIA_CONVENTIONAL_COMMITS.md](./GUIA_CONVENTIONAL_COMMITS.md)** - Cómo escribir commits siguiendo la convención
- **[GUIA_GITHUB_ACTIONS.yml](./GUIA_GITHUB_ACTIONS.yml)** - Configuración del workflow de CI/CD
- **[GUIA_PACKAGE_JSON.json](./GUIA_PACKAGE_JSON.json)** - Scripts y configuración del package.json
- **[GUIA_PRUEBAS.md](./GUIA_PRUEBAS.md)** - Cómo probar la configuración
- **[GUIA_RELEASE_CONFIG.js](./GUIA_RELEASE_CONFIG.js)** - Configuración detallada de semantic-release

## ⚙️ Configuración Post-Instalación

### 1. Configurar GitHub Token

Para que funcionen los releases automáticos, necesitas configurar un token de GitHub:

1. Ve a [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens)
2. Crea un nuevo token con permisos:
   - `repo` (acceso completo al repositorio)
   - `write:packages` (si planeas publicar en npm)
3. En tu repositorio, ve a **Settings > Secrets and variables > Actions**
4. Añade el token como `GITHUB_TOKEN`

### 2. Verificar la Configuración

Prueba que todo funciona correctamente:

```bash
# Probar semantic-release en modo dry-run
npm run release:dry-run

# Hacer un commit de prueba
git add .
git commit -m "feat: add semantic release configuration"
git push origin main
```

## 🎯 Tipos de Commits

Una vez configurado, usa estos tipos de commits:

| Tipo | Descripción | Versión |
|------|-------------|---------|
| `feat:` | Nueva funcionalidad | Minor (1.0.0 → 1.1.0) |
| `fix:` | Corrección de bugs | Patch (1.0.0 → 1.0.1) |
| `feat!:` | Breaking change | Major (1.0.0 → 2.0.0) |
| `docs:` | Solo documentación | No versión |
| `style:` | Formato, espacios | No versión |
| `refactor:` | Refactorización | Patch |
| `test:` | Añadir tests | Patch |
| `chore:` | Tareas de mantenimiento | Patch |

## 🔄 Flujo de Trabajo

1. **Desarrollo** → Hacer commits con conventional commits
2. **Push a main/master** → GitHub Actions ejecuta semantic-release
3. **Release automático** → Se crea tag, changelog y release en GitHub
4. **Sincronización** → La rama `staging` se actualiza automáticamente

## 🛠️ Comandos Disponibles

Después de ejecutar el script, tendrás estos comandos:

```bash
# Hacer un release en modo de prueba (no hace cambios)
npm run release:dry-run

# Hacer un release real (solo en CI/CD)
npm run release
```

## 📁 Archivos Generados

El script creará estos archivos en tu proyecto:

```
├── .github/
│   └── workflows/
│       └── release.yml          # GitHub Actions workflow
├── .husky/
│   └── commit-msg              # Hook para validar commits
├── commitlint.config.js        # Configuración de commitlint
├── release.config.js           # Configuración de semantic-release
└── package.json                # Scripts añadidos
```

## 🆘 Solución de Problemas

### Error: "No GitHub token specified"

Configura el token de GitHub como se explica en la sección de configuración.

### Error: "The release branches are invalid"

Asegúrate de que tu repositorio tenga una rama `main` o `master` en el remote.

### Error: Husky deprecation warnings

El script ya usa la sintaxis moderna de Husky (v8+), pero si ves warnings, actualiza Husky:

```bash
npm install --save-dev husky@latest
```

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Por favor:

1. Haz fork del repositorio
2. Crea una rama para tu feature: `git checkout -b feat/nueva-funcionalidad`
3. Haz commit con conventional commits
4. Haz push y crea un Pull Request

## 📄 Licencia

MIT License - ver [LICENSE](LICENSE) para más detalles.

---

**¿Necesitas ayuda?** Revisa las guías en este repositorio o abre un [issue](https://github.com/charles-cart/setup-semantic-release/issues).
