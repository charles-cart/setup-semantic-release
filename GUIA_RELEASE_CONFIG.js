// release.config.js - Configuración completa de Semantic Release

const { GITHUB_REF_NAME: branch } = process.env;
console.log('BRANCH PUBLISH: ', branch);

// Reglas de release basadas en el tipo de commit
const releaseRules = [
  {
    type: 'feat',        // Nueva funcionalidad
    release: 'minor',    // 1.0.0 → 1.1.0
  },
  {
    type: 'fix',         // Corrección de bugs
    release: 'patch',    // 1.0.0 → 1.0.1
  },
  {
    type: 'refactor',    // Refactorización de código
    release: 'patch',
  },
  {
    type: 'build',       // Cambios en el sistema de build
    release: 'patch',
  },
  {
    type: 'chore',       // Tareas de mantenimiento
    release: 'patch',
  },
  {
    type: 'test',        // Agregar o modificar tests
    release: 'patch',
  },
  {
    type: 'ci',          // Cambios en CI/CD
    release: 'patch',
  },
  {
    type: 'perf',        // Mejoras de rendimiento
    release: 'patch',
  },
  {
    type: 'docs',        // Solo documentación
    release: false,      // No genera release
  },
  {
    type: 'style',       // Cambios de formato (no afectan lógica)
    release: false,
  },
];

console.log('releaseRules', releaseRules);

module.exports = {
  // Ramas desde las cuales se pueden hacer releases
  branches: ['master', 'main'],
  
  // Plugins que se ejecutan en orden
  plugins: [
    // 1. Analizar commits para determinar el tipo de release
    [
      '@semantic-release/commit-analyzer',
      {
        preset: 'angular',
        releaseRules,
      },
    ],
    
    // 2. Generar notas de release automáticamente
    '@semantic-release/release-notes-generator',
    
    // 3. Actualizar o crear CHANGELOG.md
    [
      '@semantic-release/changelog',
      {
        changelogFile: 'CHANGELOG.md',
      },
    ],
    
    // 4. Actualizar package.json (sin publicar en npm)
    [
      '@semantic-release/npm',
      {
        npmPublish: false, // ⚠️ Cambiar a true si quieres publicar en npm
      },
    ],
    
    // 5. Hacer commit de los archivos actualizados
    [
      '@semantic-release/git',
      {
        assets: ['CHANGELOG.md', 'package.json'],
        message: 'chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}',
      },
    ],
    
    // 6. Crear release en GitHub
    '@semantic-release/github',
  ],
};

/* 
EXPLICACIÓN DE CADA PLUGIN:

1. @semantic-release/commit-analyzer
   - Analiza los mensajes de commit desde el último release
   - Determina qué tipo de release generar (major, minor, patch)
   - Usa las reglas definidas en releaseRules

2. @semantic-release/release-notes-generator
   - Genera automáticamente las notas del release
   - Agrupa commits por tipo (Features, Bug Fixes, etc.)
   - Crea un resumen legible de los cambios

3. @semantic-release/changelog
   - Actualiza o crea el archivo CHANGELOG.md
   - Mantiene un historial completo de cambios
   - Formato estándar y profesional

4. @semantic-release/npm
   - Actualiza la versión en package.json
   - Opcionalmente publica en npm registry
   - Para servicios privados: npmPublish: false

5. @semantic-release/git
   - Hace commit de archivos modificados (CHANGELOG.md, package.json)
   - Usa [skip ci] para evitar loops infinitos en CI/CD
   - Mensaje de commit estandarizado

6. @semantic-release/github
   - Crea el tag de git con la nueva versión
   - Publica el release en GitHub
   - Incluye las notas generadas automáticamente
*/
