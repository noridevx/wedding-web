-- Script para corregir las políticas RLS de la tabla challenges
-- Ejecuta este script en el SQL Editor de tu dashboard de Supabase

-- 1. Eliminar políticas existentes si las hay (para evitar conflictos)
DROP POLICY IF EXISTS "Allow public read access" ON challenges;
DROP POLICY IF EXISTS "Allow public insert" ON challenges;
DROP POLICY IF EXISTS "Allow public update" ON challenges;
DROP POLICY IF EXISTS "Allow public delete" ON challenges;

-- 2. Asegurar que RLS está habilitado
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;

-- 3. Crear políticas públicas para todas las operaciones
-- Política para permitir lectura pública de todos los retos
CREATE POLICY "Allow public read access" ON challenges
  FOR SELECT
  USING (true);

-- Política para permitir inserción pública (crear retos)
CREATE POLICY "Allow public insert" ON challenges
  FOR INSERT
  WITH CHECK (true);

-- Política para permitir actualización pública (completar retos)
CREATE POLICY "Allow public update" ON challenges
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- Política para permitir eliminación pública (opcional, para limpieza)
CREATE POLICY "Allow public delete" ON challenges
  FOR DELETE
  USING (true);

-- 4. Verificar que las políticas se crearon correctamente
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
WHERE tablename = 'challenges';

-- 5. Probar la inserción con un reto de prueba
INSERT INTO challenges (description) 
VALUES ('Reto de prueba - verificar políticas RLS')
ON CONFLICT DO NOTHING;

-- 6. Verificar que se insertó correctamente
SELECT id, description, created_at 
FROM challenges 
WHERE description = 'Reto de prueba - verificar políticas RLS';

-- 7. Limpiar el reto de prueba (opcional)
-- DELETE FROM challenges WHERE description = 'Reto de prueba - verificar políticas RLS';

