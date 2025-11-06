-- Script para corregir las políticas RLS de la tabla photos
-- Ejecuta este script en el SQL Editor de tu dashboard de Supabase

-- 1. Eliminar políticas existentes si las hay (para evitar conflictos)
DROP POLICY IF EXISTS "Allow public read access" ON photos;
DROP POLICY IF EXISTS "Allow public insert" ON photos;
DROP POLICY IF EXISTS "Allow public update comments" ON photos;
DROP POLICY IF EXISTS "Allow public update" ON photos;
DROP POLICY IF EXISTS "Allow public delete" ON photos;

-- 2. Asegurar que RLS está habilitado
ALTER TABLE photos ENABLE ROW LEVEL SECURITY;

-- 3. Asegurar que la columna challenge_id existe (si no existe, se añadirá)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'photos' AND column_name = 'challenge_id') THEN
    ALTER TABLE photos ADD COLUMN challenge_id UUID REFERENCES challenges(id) ON DELETE SET NULL;
    CREATE INDEX IF NOT EXISTS idx_photos_challenge_id ON photos(challenge_id);
    RAISE NOTICE 'Columna challenge_id añadida a la tabla photos';
  ELSE
    RAISE NOTICE 'La columna challenge_id ya existe en la tabla photos';
  END IF;
END $$;

-- 4. Asegurar que la columna phone existe (si no existe, se añadirá)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'photos' AND column_name = 'phone') THEN
    ALTER TABLE photos ADD COLUMN phone TEXT;
    RAISE NOTICE 'Columna phone añadida a la tabla photos';
  ELSE
    RAISE NOTICE 'La columna phone ya existe en la tabla photos';
  END IF;
END $$;

-- 5. Crear políticas públicas para todas las operaciones
-- Política para permitir lectura pública de todas las fotos
CREATE POLICY "Allow public read access" ON photos
  FOR SELECT
  USING (true);

-- Política para permitir inserción pública (subida de fotos)
CREATE POLICY "Allow public insert" ON photos
  FOR INSERT
  WITH CHECK (true);

-- Política para permitir actualización pública (actualizar comentarios, teléfono, etc.)
CREATE POLICY "Allow public update" ON photos
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- Política para permitir eliminación pública (opcional, para limpieza)
CREATE POLICY "Allow public delete" ON photos
  FOR DELETE
  USING (true);

-- 6. Verificar que las políticas se crearon correctamente
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'photos';

-- 7. Verificar que las columnas existen
SELECT 
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns 
WHERE table_name = 'photos'
ORDER BY ordinal_position;

