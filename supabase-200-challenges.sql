-- Script para insertar 200 retos de fotografía divertidos y creativos para la boda
-- Ejecuta este script en el SQL Editor de tu dashboard de Supabase

-- IMPORTANTE: Corregir políticas RLS antes de insertar retos
-- Eliminar políticas existentes si las hay (para evitar conflictos)
DROP POLICY IF EXISTS "Allow public read access" ON challenges;
DROP POLICY IF EXISTS "Allow public insert" ON challenges;
DROP POLICY IF EXISTS "Allow public update" ON challenges;
DROP POLICY IF EXISTS "Allow public delete" ON challenges;

-- Asegurar que RLS está habilitado
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;

-- Crear políticas públicas para todas las operaciones
CREATE POLICY "Allow public read access" ON challenges
  FOR SELECT
  USING (true);

CREATE POLICY "Allow public insert" ON challenges
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow public update" ON challenges
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow public delete" ON challenges
  FOR DELETE
  USING (true);

-- Limpiar tabla existente (opcional - comentar si quieres mantener retos existentes)
-- DELETE FROM challenges;

-- Insertar 200 retos de fotografía creativos y divertidos
INSERT INTO challenges (description) VALUES

-- 📸 RETOS DE PERSPECTIVA Y ÁNGULOS (30 retos)
('Tómate una foto desde un ángulo imposible'),
('Haz una foto donde parezca que sostienes el sol'),
('Tómate una foto donde parezca que levantas el edificio'),
('Haz una foto donde parezca que eres un gigante'),
('Tómate una foto donde parezca que eres muy pequeño'),
('Haz una foto donde parezca que caminas por el techo'),
('Tómate una foto donde parezca que flotas en el aire'),
('Haz una foto donde parezca que sostienes la luna'),
('Tómate una foto donde parezca que eres un superhéroe volando'),
('Haz una foto donde parezca que sostienes las nubes'),
('Tómate una foto desde debajo de una mesa'),
('Haz una foto donde parezca que eres un gigante comiendo'),
('Tómate una foto desde dentro de un armario'),
('Haz una foto donde parezca que sostienes el árbol'),
('Tómate una foto desde detrás de una cortina'),
('Haz una foto donde parezca que eres un mago'),
('Tómate una foto desde arriba de una escalera'),
('Haz una foto donde parezca que sostienes el coche'),
('Tómate una foto desde debajo de las escaleras'),
('Haz una foto donde parezca que eres un ninja'),
('Tómate una foto desde dentro del baño'),
('Haz una foto donde parezca que sostienes la puerta'),
('Tómate una foto desde la ventana'),
('Haz una foto donde parezca que eres un espía'),
('Tómate una foto desde debajo de la cama'),
('Haz una foto donde parezca que sostienes la silla'),
('Tómate una foto desde el balcón'),
('Haz una foto donde parezca que eres un astronauta'),
('Tómate una foto desde el jardín'),
('Haz una foto donde parezca que sostienes la fuente'),

-- 🎭 RETOS DE POSES DIVERTIDAS (35 retos)
('Tómate una foto haciendo la pose más dramática posible'),
('Haz una foto imitando la pose de una estatua griega'),
('Tómate una foto haciendo la pose de "El Grito" de Munch'),
('Haz una foto imitando la pose de un superhéroe'),
('Tómate una foto recreando la escena de "Titanic"'),
('Haz una foto imitando la pose de un influencer'),
('Tómate una foto haciendo la pose de una modelo'),
('Haz una foto recreando una escena de película de acción'),
('Tómate una foto haciendo la pose más romántica'),
('Haz una foto imitando la pose de un bailarín'),
('Tómate una foto recreando "Romeo y Julieta"'),
('Haz una foto imitando la pose de un detective'),
('Tómate una foto haciendo la pose de un chef'),
('Haz una foto recreando "Los Vengadores"'),
('Tómate una foto imitando la pose de un astronauta'),
('Haz una foto haciendo la pose de un surfista'),
('Tómate una foto recreando "Star Wars"'),
('Haz una foto imitando la pose de un ninja'),
('Tómate una foto haciendo la pose de un mago'),
('Haz una foto recreando "Harry Potter"'),
('Tómate una foto imitando la pose de un cowboy'),
('Haz una foto haciendo la pose de un robot'),
('Tómate una foto recreando "Matrix"'),
('Haz una foto imitando la pose de un vampiro'),
('Tómate una foto haciendo la pose de un zombie'),
('Haz una foto recreando "Jurassic Park"'),
('Tómate una foto imitando la pose de un pirata'),
('Haz una foto haciendo la pose de un samurái'),
('Tómate una foto recreando "El Señor de los Anillos"'),
('Haz una foto imitando la pose de un rey'),
('Tómate una foto haciendo la pose de una reina'),
('Haz una foto recreando "Frozen"'),
('Tómate una foto imitando la pose de un dragón'),

-- 🎨 RETOS DE EFECTOS VISUALES (30 retos)
('Tómate una foto reflejada en un espejo'),
('Haz una foto usando solo sombras'),
('Tómate una foto con efecto de movimiento borroso'),
('Haz una foto con simetría perfecta'),
('Tómate una foto usando solo luces y sombras'),
('Haz una foto con efecto de perspectiva forzada'),
('Tómate una foto usando solo texturas'),
('Haz una foto con efecto de silueta'),
('Tómate una foto usando solo formas geométricas'),
('Haz una foto con efecto de contraste extremo'),
('Tómate una foto usando solo líneas guía'),
('Haz una foto con efecto de minimalismo'),
('Tómate una foto usando solo colores monocromáticos'),
('Haz una foto con efecto de abstracción'),
('Tómate una foto usando solo transparencias'),
('Haz una foto con efecto de doble exposición'),
('Tómate una foto usando solo reflejos múltiples'),
('Haz una foto con efecto de distorsión'),
('Tómate una foto usando solo sombras proyectadas'),
('Haz una foto con efecto de velocidad'),
('Tómate una foto usando solo luces de neón'),
('Haz una foto con efecto de vintage'),
('Tómate una foto usando solo reflejos de agua'),
('Haz una foto con efecto de profundidad de campo'),
('Tómate una foto usando solo colores complementarios'),
('Haz una foto con efecto de patrón repetitivo'),
('Tómate una foto usando solo elementos flotantes'),
('Haz una foto con efecto de narrativa visual'),
('Tómate una foto usando solo elementos escondidos'),
('Haz una foto con efecto de elemento sorpresa'),
('Tómate una foto usando solo elementos mágicos'),
('Haz una foto con efecto de surrealismo'),

-- 👥 RETOS DE INTERACCIÓN CON PERSONAS (30 retos)
('Tómate una foto con 5 personas abrazándote'),
('Haz una foto con una cadena humana de 8 personas'),
('Tómate una foto siendo llevado en brazos'),
('Haz una foto con un círculo de baile'),
('Tómate una foto con 3 personas dándote besos'),
('Haz una foto con una fila de conga'),
('Tómate una foto siendo levantado en el aire'),
('Haz una foto con un grupo de selfie de 6 personas'),
('Tómate una foto siendo llevado a hombros'),
('Haz una foto con una ronda de aplausos'),
('Tómate una foto con un grupo de abrazos'),
('Haz una foto con una cadena de susurros'),
('Tómate una foto con un grupo de risas'),
('Haz una foto con una ronda de chistes'),
('Tómate una foto con un grupo de bailes'),
('Haz una foto con una cadena de saludos'),
('Tómate una foto con un grupo de gestos'),
('Haz una foto con una ronda de imitaciones'),
('Tómate una foto con un grupo de expresiones'),
('Haz una foto con una cadena de guiños'),
('Tómate una foto con un grupo de muecas'),
('Haz una foto con una ronda de señas'),
('Tómate una foto con un grupo de caras'),
('Haz una foto con una cadena de reverencias'),
('Tómate una foto con un grupo de cosquillas'),
('Haz una foto con una ronda de cumplidos'),
('Tómate una foto con un grupo de caricias'),
('Haz una foto con una cadena de bromas'),
('Tómate una foto con un grupo de sorpresas'),

-- 🎪 RETOS DE ESCENAS CREATIVAS (25 retos)
('Tómate una foto recreando una escena de circo'),
('Haz una foto recreando una escena de teatro'),
('Tómate una foto recreando una escena de ópera'),
('Haz una foto recreando una escena de ballet'),
('Tómate una foto recreando una escena de musical'),
('Haz una foto recreando una escena de comedia'),
('Tómate una foto recreando una escena de drama'),
('Haz una foto recreando una escena de acción'),
('Tómate una foto recreando una escena de romance'),
('Haz una foto recreando una escena de terror'),
('Tómate una foto recreando una escena de ciencia ficción'),
('Haz una foto recreando una escena de fantasía'),
('Tómate una foto recreando una escena de western'),
('Haz una foto recreando una escena de época'),
('Tómate una foto recreando una escena de futuro'),
('Haz una foto recreando una escena de pasado'),
('Tómate una foto recreando una escena de presente'),
('Haz una foto recreando una escena de sueño'),
('Tómate una foto recreando una escena de pesadilla'),
('Haz una foto recreando una escena de realidad'),
('Tómate una foto recreando una escena de ficción'),
('Haz una foto recreando una escena de documental'),
('Tómate una foto recreando una escena de noticias'),
('Haz una foto recreando una escena de anuncio'),
('Tómate una foto recreando una escena de programa'),

-- 🎭 RETOS DE DISFRACES Y PERSONAJES (25 retos)
('Tómate una foto disfrazado de superhéroe'),
('Haz una foto disfrazado de princesa'),
('Tómate una foto disfrazado de pirata'),
('Haz una foto disfrazado de cowboy'),
('Tómate una foto disfrazado de astronauta'),
('Haz una foto disfrazado de mago'),
('Tómate una foto disfrazado de ninja'),
('Haz una foto disfrazado de vampiro'),
('Tómate una foto disfrazado de zombie'),
('Haz una foto disfrazado de robot'),
('Tómate una foto disfrazado de alienígena'),
('Haz una foto disfrazado de dragón'),
('Tómate una foto disfrazado de unicornio'),
('Haz una foto disfrazado de hada'),
('Tómate una foto disfrazado de bruja'),
('Haz una foto disfrazado de rey'),
('Tómate una foto disfrazado de reina'),
('Haz una foto disfrazado de caballero'),
('Tómate una foto disfrazado de dama'),
('Haz una foto disfrazado de soldado'),
('Tómate una foto disfrazado de policía'),
('Haz una foto disfrazado de bombero'),
('Tómate una foto disfrazado de médico'),
('Haz una foto disfrazado de chef'),
('Tómate una foto disfrazado de artista'),
('Haz una foto disfrazado de músico'),

-- 🎪 RETOS DE OBJETOS Y ELEMENTOS (25 retos)
('Tómate una foto usando solo flores'),
('Haz una foto usando solo velas'),
('Tómate una foto usando solo espejos'),
('Haz una foto usando solo luces'),
('Tómate una foto usando solo telas'),
('Haz una foto usando solo papel'),
('Tómate una foto usando solo metal'),
('Haz una foto usando solo madera'),
('Tómate una foto usando solo cristal'),
('Haz una foto usando solo plástico'),
('Tómate una foto usando solo agua'),
('Haz una foto usando solo fuego'),
('Tómate una foto usando solo tierra'),
('Haz una foto usando solo aire'),
('Tómate una foto usando solo hielo'),
('Haz una foto usando solo arena'),
('Tómate una foto usando solo piedras'),
('Haz una foto usando solo hojas'),
('Tómate una foto usando solo ramas'),
('Haz una foto usando solo frutas'),
('Tómate una foto usando solo verduras'),
('Haz una foto usando solo dulces'),
('Tómate una foto usando solo bebidas'),
('Haz una foto usando solo cubiertos'),
('Tómate una foto usando solo platos'),

-- 🎨 RETOS DE ARTE Y CREATIVIDAD (20 retos)
('Tómate una foto recreando una obra de arte famosa'),
('Haz una foto recreando un cuadro de Van Gogh'),
('Tómate una foto recreando una escultura'),
('Haz una foto recreando un mural'),
('Tómate una foto recreando un graffiti'),
('Haz una foto recreando una instalación artística'),
('Tómate una foto recreando una performance'),
('Haz una foto recreando un collage'),
('Tómate una foto recreando un móvil'),
('Haz una foto recreando una escultura de arena'),
('Tómate una foto recreando un castillo de naipes'),
('Haz una foto recreando una casa de galletas'),
('Tómate una foto recreando un jardín zen'),
('Haz una foto recreando un laberinto'),
('Tómate una foto recreando un puente'),
('Haz una foto recreando una torre'),
('Tómate una foto recreando una pirámide'),
('Haz una foto recreando una esfera'),
('Tómate una foto recreando un cubo'),
('Haz una foto recreando un triángulo');

-- Verificar que se insertaron todos los retos
SELECT COUNT(*) as total_challenges FROM challenges;

-- Mostrar algunos ejemplos de retos insertados
SELECT id, description FROM challenges ORDER BY created_at DESC LIMIT 10;
