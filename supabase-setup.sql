-- Script para configurar la tabla de fotos en Supabase
-- Ejecuta este script en el SQL Editor de tu dashboard de Supabase

-- 1. Crear la tabla de fotos
CREATE TABLE IF NOT EXISTS photos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  file_path TEXT NOT NULL,
  file_name TEXT NOT NULL,
  file_size BIGINT NOT NULL,
  file_type TEXT NOT NULL,
  public_url TEXT NOT NULL,
  comment TEXT,
  phone TEXT,
  uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Añadir columna phone a tabla photos existente (si no existe)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'photos' AND column_name = 'phone') THEN
    ALTER TABLE photos ADD COLUMN phone TEXT;
    RAISE NOTICE 'Columna phone añadida a la tabla photos';
  ELSE
    RAISE NOTICE 'La columna phone ya existe en la tabla photos';
  END IF;
END $$;

-- 2. Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_photos_uploaded_at ON photos(uploaded_at DESC);
CREATE INDEX IF NOT EXISTS idx_photos_file_type ON photos(file_type);

-- 3. Habilitar Row Level Security (RLS)
ALTER TABLE photos ENABLE ROW LEVEL SECURITY;

-- 4. Crear políticas para permitir operaciones públicas
-- Política para permitir lectura pública de todas las fotos
CREATE POLICY "Allow public read access" ON photos
  FOR SELECT USING (true);

-- Política para permitir inserción pública (subida de fotos)
CREATE POLICY "Allow public insert" ON photos
  FOR INSERT WITH CHECK (true);

-- Política para permitir actualización de comentarios (opcional)
CREATE POLICY "Allow public update comments" ON photos
  FOR UPDATE USING (true)
  WITH CHECK (true);

-- 5. Crear función para actualizar el timestamp de created_at
CREATE OR REPLACE FUNCTION update_created_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.created_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- 6. Crear trigger para actualizar created_at automáticamente
CREATE TRIGGER update_photos_created_at 
  BEFORE UPDATE ON photos 
  FOR EACH ROW 
  EXECUTE FUNCTION update_created_at_column();

-- 7. Comentarios sobre la tabla
COMMENT ON TABLE photos IS 'Tabla para almacenar información de fotos subidas por usuarios';
COMMENT ON COLUMN photos.file_path IS 'Ruta del archivo en Supabase Storage';
COMMENT ON COLUMN photos.file_name IS 'Nombre original del archivo';
COMMENT ON COLUMN photos.file_size IS 'Tamaño del archivo en bytes';
COMMENT ON COLUMN photos.file_type IS 'Tipo MIME del archivo';
COMMENT ON COLUMN photos.public_url IS 'URL pública para acceder a la imagen';
COMMENT ON COLUMN photos.comment IS 'Comentario opcional del usuario';
COMMENT ON COLUMN photos.phone IS 'Número de teléfono opcional para contactar al usuario';
COMMENT ON COLUMN photos.uploaded_at IS 'Fecha y hora de subida';
COMMENT ON COLUMN photos.created_at IS 'Fecha y hora de creación del registro';

-- 8. Verificar que la tabla se creó correctamente
SELECT 
  table_name,
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns 
WHERE table_name = 'photos'
ORDER BY ordinal_position;
