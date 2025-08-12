# Configuración de Retos Fotográficos

Esta funcionalidad permite a los usuarios completar retos fotográficos durante la boda, subiendo fotos que cumplan con desafíos específicos.

## Configuración de la Base de Datos

### 1. Ejecutar el script SQL

Ejecuta el archivo `supabase-challenges-setup.sql` en el SQL Editor de tu dashboard de Supabase:

1. Ve a tu proyecto en [Supabase Dashboard](https://supabase.com/dashboard)
2. Navega a **SQL Editor**
3. Copia y pega el contenido del archivo `supabase-challenges-setup.sql`
4. Ejecuta el script

### 2. Verificar la configuración

El script creará:
- Tabla `challenges` con los campos necesarios
- Índices para optimizar consultas
- Políticas de seguridad (RLS)
- 10 retos de ejemplo

## Variables de Entorno

Asegúrate de tener configuradas las siguientes variables en tu archivo `.env`:

```env
VITE_SUPABASE_URL=tu_url_de_supabase
VITE_SUPABASE_ANON_KEY=tu_clave_anonima
VITE_SUPABASE_BUCKET=wedding-photos
VITE_SUPABASE_FOLDER=uploads
```

## Funcionalidad

### Componentes Creados

1. **ChallengeButton.vue**: Botón principal que muestra un reto aleatorio
2. **ChallengeUploadForm.vue**: Formulario para subir fotos y completar retos
3. **useChallenges.js**: Composable para manejar la lógica de retos

### Lógica de Selección de Retos

- **Prioridad 1**: Retos no completados (aleatorio)
- **Prioridad 2**: Si todos están completados, selecciona uno aleatorio de todos

### Flujo de Completado

1. Usuario hace clic en "¡Completa un reto!"
2. Se muestra un modal con un reto aleatorio (solo descripción)
3. Usuario selecciona una foto y añade comentario opcional
4. La foto se sube a Supabase Storage en la carpeta `challenges/`
5. Se guarda la información en la tabla `photos` con `challenge_id`
6. Se marca el reto como completado en la tabla `challenges`
7. Se muestra notificación de éxito

## Personalización

### Añadir Nuevos Retos

Puedes añadir nuevos retos ejecutando SQL directamente:

```sql
INSERT INTO challenges (description) VALUES
  ('Descripción del nuevo reto');
```

### Modificar Retos Existentes

```sql
UPDATE challenges 
SET description = 'Nueva descripción'
WHERE id = 'id_del_reto';
```

### Ver Estadísticas

```sql
-- Ver retos completados vs pendientes
SELECT 
  COUNT(*) as total,
  COUNT(*) FILTER (WHERE is_completed = true) as completados,
  COUNT(*) FILTER (WHERE is_completed = false) as pendientes
FROM challenges;

-- Ver retos completados con detalles y fotos relacionadas
SELECT 
  c.description, 
  c.completed_at, 
  c.completed_by, 
  p.public_url as photo_url,
  p.comment as photo_comment
FROM challenges c
LEFT JOIN photos p ON c.id = p.challenge_id
WHERE c.is_completed = true
ORDER BY c.completed_at DESC;

-- Ver todas las fotos de un reto específico
SELECT 
  p.public_url,
  p.comment,
  p.uploaded_at
FROM photos p
WHERE p.challenge_id = 'id_del_reto'
ORDER BY p.uploaded_at DESC;
```

## Estructura de Archivos

```
src/
├── components/
│   ├── ChallengeButton.vue          # Botón principal
│   └── ChallengeUploadForm.vue      # Formulario de subida
├── composables/
│   └── useChallenges.js             # Lógica de retos
└── pages/
    └── app.vue                      # Página principal (actualizada)
```

## Notas Técnicas

- Las fotos de retos se almacenan en la carpeta `challenges/` dentro del bucket
- Los comentarios incluyen automáticamente "Reto completado: [descripción del reto]"
- Los retos se relacionan con las fotos a través de `challenge_id` en la tabla `photos` (foreign key opcional)
- Un reto puede tener múltiples fotos, pero una foto solo puede pertenecer a un reto
- El sistema maneja errores y rollback en caso de fallos
- Responsive design para móviles y desktop
- Integración completa con el sistema de notificaciones existente

## Troubleshooting

### Error: "Supabase no está configurado"
- Verifica que las variables de entorno estén configuradas
- Asegúrate de que el archivo `.env` esté en la raíz del proyecto

### Error: "Error al completar el reto"
- Verifica que la tabla `challenges` exista en Supabase
- Comprueba que las políticas RLS permitan operaciones públicas
- Revisa los logs de la consola para más detalles

### No se muestran retos
- Ejecuta el script SQL para crear la tabla y datos de ejemplo
- Verifica que la conexión a Supabase funcione correctamente
