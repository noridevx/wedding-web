-- Script para corregir las políticas de Storage del bucket wedding-photos
-- Ejecuta este script en el SQL Editor de tu dashboard de Supabase

-- 1. Crear el bucket si no existe (ajusta el nombre si es diferente)
INSERT INTO storage.buckets (id, name, public)
VALUES ('wedding-photos', 'wedding-photos', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- 2. Eliminar políticas existentes del bucket (si existen)
DROP POLICY IF EXISTS "Allow public read access" ON storage.objects;
DROP POLICY IF EXISTS "Allow public uploads" ON storage.objects;
DROP POLICY IF EXISTS "Allow public update" ON storage.objects;
DROP POLICY IF EXISTS "Allow public delete" ON storage.objects;
DROP POLICY IF EXISTS "Public Access" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload" ON storage.objects;
DROP POLICY IF EXISTS "Public can upload" ON storage.objects;

-- 3. Crear políticas para el bucket wedding-photos

-- Política para permitir lectura pública de archivos
CREATE POLICY "Allow public read access"
ON storage.objects FOR SELECT
USING (bucket_id = 'wedding-photos');

-- Política para permitir subida pública de archivos
CREATE POLICY "Allow public uploads"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'wedding-photos');

-- Política para permitir actualización pública de archivos
CREATE POLICY "Allow public update"
ON storage.objects FOR UPDATE
USING (bucket_id = 'wedding-photos')
WITH CHECK (bucket_id = 'wedding-photos');

-- Política para permitir eliminación pública de archivos
CREATE POLICY "Allow public delete"
ON storage.objects FOR DELETE
USING (bucket_id = 'wedding-photos');

-- 4. Verificar que el bucket existe y está configurado correctamente
SELECT 
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
FROM storage.buckets
WHERE id = 'wedding-photos';

-- 5. Verificar que las políticas se crearon correctamente
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
WHERE tablename = 'objects' AND schemaname = 'storage';

