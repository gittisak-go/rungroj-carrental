-- =====================================================
-- Seed: รุ่งโรจน์คาร์เร้นท์ อุดรธานี
-- รถ 12 รุ่น — รุ่น 1-11: 5 คัน | MU-X: 1 คัน — รวม 56 คัน
-- =====================================================

-- ล้างข้อมูลเก่าก่อน seed (staging/preview เท่านั้น)
TRUNCATE public.vehicles RESTART IDENTITY CASCADE;

INSERT INTO public.vehicles (brand, model, year, price_per_day, transmission, seats, fuel_type, image_url, is_available, description) VALUES

-- 1. City Turbo x5
('Honda','City Turbo',2023,1000,'Automatic',5,'Petrol','https://placehold.co/400x240?text=City+Turbo',true,'ซีดานสปอร์ต เกียร์ออโต เบนซิน เหมาะสำหรับเดินทางในเมือง'),
('Honda','City Turbo',2023,1000,'Automatic',5,'Petrol','https://placehold.co/400x240?text=City+Turbo',true,'ซีดานสปอร์ต เกียร์ออโต เบนซิน เหมาะสำหรับเดินทางในเมือง'),
('Honda','City Turbo',2023,1000,'Automatic',5,'Petrol','https://placehold.co/400x240?text=City+Turbo',true,'ซีดานสปอร์ต เกียร์ออโต เบนซิน เหมาะสำหรับเดินทางในเมือง'),
('Honda','City Turbo',2023,1000,'Automatic',5,'Petrol','https://placehold.co/400x240?text=City+Turbo',true,'ซีดานสปอร์ต เกียร์ออโต เบนซิน เหมาะสำหรับเดินทางในเมือง'),
('Honda','City Turbo',2023,1000,'Automatic',5,'Petrol','https://placehold.co/400x240?text=City+Turbo',true,'ซีดานสปอร์ต เกียร์ออโต เบนซิน เหมาะสำหรับเดินทางในเมือง'),

-- 2. New Yaris Sport x5
('Toyota','New Yaris Sport',2024,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Yaris+Sport',true,'แฮตช์แบ็กสปอร์ต ประหยัดน้ำมัน'),
('Toyota','New Yaris Sport',2024,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Yaris+Sport',true,'แฮตช์แบ็กสปอร์ต ประหยัดน้ำมัน'),
('Toyota','New Yaris Sport',2024,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Yaris+Sport',true,'แฮตช์แบ็กสปอร์ต ประหยัดน้ำมัน'),
('Toyota','New Yaris Sport',2024,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Yaris+Sport',true,'แฮตช์แบ็กสปอร์ต ประหยัดน้ำมัน'),
('Toyota','New Yaris Sport',2024,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Yaris+Sport',true,'แฮตช์แบ็กสปอร์ต ประหยัดน้ำมัน'),

-- 3. New Yaris Ativ x5
('Toyota','New Yaris Ativ',2024,1000,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Yaris+Ativ',true,'ซีดานทันสมัย ราคาคุ้มค่า'),
('Toyota','New Yaris Ativ',2024,1000,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Yaris+Ativ',true,'ซีดานทันสมัย ราคาคุ้มค่า'),
('Toyota','New Yaris Ativ',2024,1000,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Yaris+Ativ',true,'ซีดานทันสมัย ราคาคุ้มค่า'),
('Toyota','New Yaris Ativ',2024,1000,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Yaris+Ativ',true,'ซีดานทันสมัย ราคาคุ้มค่า'),
('Toyota','New Yaris Ativ',2024,1000,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Yaris+Ativ',true,'ซีดานทันสมัย ราคาคุ้มค่า'),

-- 4. Almera Sportech x5
('Nissan','Almera Sportech',2023,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Almera',true,'ซีดานสปอร์ต เกียร์ CVT ประหยัดน้ำมัน'),
('Nissan','Almera Sportech',2023,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Almera',true,'ซีดานสปอร์ต เกียร์ CVT ประหยัดน้ำมัน'),
('Nissan','Almera Sportech',2023,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Almera',true,'ซีดานสปอร์ต เกียร์ CVT ประหยัดน้ำมัน'),
('Nissan','Almera Sportech',2023,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Almera',true,'ซีดานสปอร์ต เกียร์ CVT ประหยัดน้ำมัน'),
('Nissan','Almera Sportech',2023,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Almera',true,'ซีดานสปอร์ต เกียร์ CVT ประหยัดน้ำมัน'),

-- 5. Ciaz x5
('Suzuki','Ciaz',2023,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Ciaz',true,'ซีดานกว้างขวาง นั่งสบาย เบนซิน'),
('Suzuki','Ciaz',2023,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Ciaz',true,'ซีดานกว้างขวาง นั่งสบาย เบนซิน'),
('Suzuki','Ciaz',2023,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Ciaz',true,'ซีดานกว้างขวาง นั่งสบาย เบนซิน'),
('Suzuki','Ciaz',2023,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Ciaz',true,'ซีดานกว้างขวาง นั่งสบาย เบนซิน'),
('Suzuki','Ciaz',2023,800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Ciaz',true,'ซีดานกว้างขวาง นั่งสบาย เบนซิน'),

-- 6. Ranger Raptor x5
('Ford','Ranger Raptor',2023,2500,'Automatic',5,'Diesel','https://placehold.co/400x240?text=Ranger+Raptor',true,'กระบะสมรรถนะสูง ดีเซล เหมาะทริปผจญภัย'),
('Ford','Ranger Raptor',2023,2500,'Automatic',5,'Diesel','https://placehold.co/400x240?text=Ranger+Raptor',true,'กระบะสมรรถนะสูง ดีเซล เหมาะทริปผจญภัย'),
('Ford','Ranger Raptor',2023,2500,'Automatic',5,'Diesel','https://placehold.co/400x240?text=Ranger+Raptor',true,'กระบะสมรรถนะสูง ดีเซล เหมาะทริปผจญภัย'),
('Ford','Ranger Raptor',2023,2500,'Automatic',5,'Diesel','https://placehold.co/400x240?text=Ranger+Raptor',true,'กระบะสมรรถนะสูง ดีเซล เหมาะทริปผจญภัย'),
('Ford','Ranger Raptor',2023,2500,'Automatic',5,'Diesel','https://placehold.co/400x240?text=Ranger+Raptor',true,'กระบะสมรรถนะสูง ดีเซล เหมาะทริปผจญภัย'),

-- 7. Vigo Champ x5
('Toyota','Vigo Champ',2022,2000,'Manual',5,'Diesel','https://placehold.co/400x240?text=Vigo+Champ',true,'กระบะแข็งแกร่ง เกียร์ธรรมดา ดีเซล'),
('Toyota','Vigo Champ',2022,2000,'Manual',5,'Diesel','https://placehold.co/400x240?text=Vigo+Champ',true,'กระบะแข็งแกร่ง เกียร์ธรรมดา ดีเซล'),
('Toyota','Vigo Champ',2022,2000,'Manual',5,'Diesel','https://placehold.co/400x240?text=Vigo+Champ',true,'กระบะแข็งแกร่ง เกียร์ธรรมดา ดีเซล'),
('Toyota','Vigo Champ',2022,2000,'Manual',5,'Diesel','https://placehold.co/400x240?text=Vigo+Champ',true,'กระบะแข็งแกร่ง เกียร์ธรรมดา ดีเซล'),
('Toyota','Vigo Champ',2022,2000,'Manual',5,'Diesel','https://placehold.co/400x240?text=Vigo+Champ',true,'กระบะแข็งแกร่ง เกียร์ธรรมดา ดีเซล'),

-- 8. Veloz x5
('Toyota','Veloz',2024,1800,'Automatic',7,'Petrol','https://placehold.co/400x240?text=Veloz',true,'MPV 7 ที่นั่ง เหมาะครอบครัว เบนซิน'),
('Toyota','Veloz',2024,1800,'Automatic',7,'Petrol','https://placehold.co/400x240?text=Veloz',true,'MPV 7 ที่นั่ง เหมาะครอบครัว เบนซิน'),
('Toyota','Veloz',2024,1800,'Automatic',7,'Petrol','https://placehold.co/400x240?text=Veloz',true,'MPV 7 ที่นั่ง เหมาะครอบครัว เบนซิน'),
('Toyota','Veloz',2024,1800,'Automatic',7,'Petrol','https://placehold.co/400x240?text=Veloz',true,'MPV 7 ที่นั่ง เหมาะครอบครัว เบนซิน'),
('Toyota','Veloz',2024,1800,'Automatic',7,'Petrol','https://placehold.co/400x240?text=Veloz',true,'MPV 7 ที่นั่ง เหมาะครอบครัว เบนซิน'),

-- 9. Pajero Sport Elite x5
('Mitsubishi','Pajero Sport Elite Edition',2024,2200,'Automatic',7,'Diesel','https://placehold.co/400x240?text=Pajero+Sport',true,'SUV 7 ที่นั่ง Elite ดีเซล เหมาะเดินทางไกล'),
('Mitsubishi','Pajero Sport Elite Edition',2024,2200,'Automatic',7,'Diesel','https://placehold.co/400x240?text=Pajero+Sport',true,'SUV 7 ที่นั่ง Elite ดีเซล เหมาะเดินทางไกล'),
('Mitsubishi','Pajero Sport Elite Edition',2024,2200,'Automatic',7,'Diesel','https://placehold.co/400x240?text=Pajero+Sport',true,'SUV 7 ที่นั่ง Elite ดีเซล เหมาะเดินทางไกล'),
('Mitsubishi','Pajero Sport Elite Edition',2024,2200,'Automatic',7,'Diesel','https://placehold.co/400x240?text=Pajero+Sport',true,'SUV 7 ที่นั่ง Elite ดีเซล เหมาะเดินทางไกล'),
('Mitsubishi','Pajero Sport Elite Edition',2024,2200,'Automatic',7,'Diesel','https://placehold.co/400x240?text=Pajero+Sport',true,'SUV 7 ที่นั่ง Elite ดีเซล เหมาะเดินทางไกล'),

-- 10. Cross x5
('Toyota','Cross',2024,1800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Cross',true,'SUV ขนาดกลาง ทันสมัย เบนซิน'),
('Toyota','Cross',2024,1800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Cross',true,'SUV ขนาดกลาง ทันสมัย เบนซิน'),
('Toyota','Cross',2024,1800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Cross',true,'SUV ขนาดกลาง ทันสมัย เบนซิน'),
('Toyota','Cross',2024,1800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Cross',true,'SUV ขนาดกลาง ทันสมัย เบนซิน'),
('Toyota','Cross',2024,1800,'Automatic',5,'Petrol','https://placehold.co/400x240?text=Cross',true,'SUV ขนาดกลาง ทันสมัย เบนซิน'),

-- 11. Xpander x5
('Mitsubishi','Xpander',2024,1800,'Automatic',7,'Petrol','https://placehold.co/400x240?text=Xpander',true,'MPV 7 ที่นั่ง กว้างขวาง เบนซิน'),
('Mitsubishi','Xpander',2024,1800,'Automatic',7,'Petrol','https://placehold.co/400x240?text=Xpander',true,'MPV 7 ที่นั่ง กว้างขวาง เบนซิน'),
('Mitsubishi','Xpander',2024,1800,'Automatic',7,'Petrol','https://placehold.co/400x240?text=Xpander',true,'MPV 7 ที่นั่ง กว้างขวาง เบนซิน'),
('Mitsubishi','Xpander',2024,1800,'Automatic',7,'Petrol','https://placehold.co/400x240?text=Xpander',true,'MPV 7 ที่นั่ง กว้างขวาง เบนซิน'),
('Mitsubishi','Xpander',2024,1800,'Automatic',7,'Petrol','https://placehold.co/400x240?text=Xpander',true,'MPV 7 ที่นั่ง กว้างขวาง เบนซิน'),

-- 12. MU-X x1
('Isuzu','MU-X',2024,1990,'Automatic',7,'Diesel','https://placehold.co/400x240?text=MU-X',true,'SUV 7 ที่นั่ง ดีเซล มีเพียง 1 คัน');
