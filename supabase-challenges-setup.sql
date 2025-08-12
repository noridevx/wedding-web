-- Script para configurar la tabla de retos en Supabase
-- Ejecuta este script en el SQL Editor de tu dashboard de Supabase

-- 1. Crear la tabla de retos (solo con descripción)
CREATE TABLE IF NOT EXISTS challenges (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  description TEXT NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  is_reserved BOOLEAN DEFAULT FALSE,
  reserved_at TIMESTAMP WITH TIME ZONE,
  reserved_by TEXT,
  completed_at TIMESTAMP WITH TIME ZONE,
  completed_by TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_challenges_is_completed ON challenges(is_completed);
CREATE INDEX IF NOT EXISTS idx_challenges_is_reserved ON challenges(is_reserved);
CREATE INDEX IF NOT EXISTS idx_challenges_created_at ON challenges(created_at DESC);

-- 3. Habilitar Row Level Security (RLS)
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;

-- 4. Crear políticas para permitir operaciones públicas
-- Política para permitir lectura pública de todos los retos
CREATE POLICY "Allow public read access" ON challenges
  FOR SELECT USING (true);

-- Política para permitir inserción pública (crear retos)
CREATE POLICY "Allow public insert" ON challenges
  FOR INSERT WITH CHECK (true);

-- Política para permitir actualización (completar retos)
CREATE POLICY "Allow public update" ON challenges
  FOR UPDATE USING (true)
  WITH CHECK (true);

-- 5. Crear función para actualizar el timestamp de updated_at
CREATE OR REPLACE FUNCTION update_challenges_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- 6. Crear trigger para actualizar updated_at automáticamente
CREATE TRIGGER update_challenges_updated_at 
  BEFORE UPDATE ON challenges 
  FOR EACH ROW 
  EXECUTE FUNCTION update_challenges_updated_at_column();

-- 7. Insertar algunos retos de ejemplo (solo con descripción)
INSERT INTO challenges (description) VALUES
  ('Tómate una selfie con la novia y compártela'),
  ('Captura un momento especial con el novio'),
  ('Muéstranos tus mejores pasos de baile en la pista'),
  ('Reúnete con la familia para una foto grupal'),
  ('Captura el momento del brindis'),
  ('Una foto divertida con tus amigos'),
  ('No te pierdas el momento de cortar el pastel'),
  ('Captura un momento romántico de la boda'),
  ('Una foto con todos los invitados'),
  ('Una foto especial del vestido de la novia');

-- 8. Añadir columna challenge_id a la tabla photos existente
-- (Solo si la tabla photos ya existe)
DO $$
BEGIN
  IF EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'photos' AND column_name = 'challenge_id') THEN
    RAISE NOTICE 'La columna challenge_id ya existe en la tabla photos';
  ELSE
    ALTER TABLE photos ADD COLUMN challenge_id UUID REFERENCES challenges(id) ON DELETE SET NULL;
    CREATE INDEX IF NOT EXISTS idx_photos_challenge_id ON photos(challenge_id);
    RAISE NOTICE 'Columna challenge_id añadida a la tabla photos';
  END IF;
END $$;

-- 9. Comentarios sobre la tabla
COMMENT ON TABLE challenges IS 'Tabla para almacenar retos fotográficos de la boda';
COMMENT ON COLUMN challenges.description IS 'Descripción detallada del reto';
COMMENT ON COLUMN challenges.is_completed IS 'Indica si el reto ha sido completado';
COMMENT ON COLUMN challenges.is_reserved IS 'Indica si el reto está reservado por un dispositivo';
COMMENT ON COLUMN challenges.reserved_at IS 'Fecha y hora de reserva del reto';
COMMENT ON COLUMN challenges.reserved_by IS 'Identificador del dispositivo que reservó el reto';
COMMENT ON COLUMN challenges.completed_at IS 'Fecha y hora de completado del reto';
COMMENT ON COLUMN challenges.completed_by IS 'Identificador de quien completó el reto';
COMMENT ON COLUMN challenges.created_at IS 'Fecha y hora de creación del reto';
COMMENT ON COLUMN challenges.updated_at IS 'Fecha y hora de última actualización';

-- 10. Verificar que la tabla se creó correctamente
SELECT 
  table_name,
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns 
WHERE table_name = 'challenges'
ORDER BY ordinal_position;
