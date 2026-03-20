-- 爱心宠物系统 - data_init.sql
-- Execute after schema.sql
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 0) Refresh demo content only
-- Keep account tables intact to avoid breaking login testing.
-- ----------------------------
DELETE FROM ws_comment;
DELETE FROM ws_order_item;
DELETE FROM ws_order;
DELETE FROM ws_activity_join;
DELETE FROM ws_activity;
DELETE FROM ws_cart;
DELETE FROM ws_favorite;
DELETE FROM ws_address;
DELETE FROM ws_product_image;
DELETE FROM ws_product;
DELETE FROM ws_subcategory;
DELETE FROM ws_category;
DELETE FROM ws_banner;
DELETE FROM ws_notice;

-- ----------------------------
-- 1) Default admin account
-- ----------------------------
INSERT INTO ws_admin (id, username, password, real_name, status, created_at, updated_at)
VALUES (1, 'admin', 'admin123', '系统管理员', 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  password = VALUES(password),
  real_name = VALUES(real_name),
  status = VALUES(status),
  updated_at = NOW();

-- ----------------------------
-- 2) Demo normal user
-- ----------------------------
INSERT INTO ws_user (id, username, password, nickname, phone, status, created_at, updated_at)
VALUES (10001, 'user1', '123456', '宠物体验用户', '13800000001', 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  password = VALUES(password),
  nickname = VALUES(nickname),
  phone = VALUES(phone),
  status = VALUES(status),
  updated_at = NOW();

-- ----------------------------
-- 3) Primary categories
-- ----------------------------
INSERT INTO ws_category (id, name, sort, status) VALUES
(1, '猫咪', 1, 1),
(2, '狗狗', 2, 1),
(3, '兔兔', 3, 1),
(4, '鸟类', 4, 1);

-- ----------------------------
-- 4) Secondary categories
-- ----------------------------
INSERT INTO ws_subcategory (id, category_id, name, sort, status) VALUES
(101, 1, '布偶', 1, 1),
(102, 1, '英国短毛猫', 2, 1),
(103, 1, '幼年', 3, 1),
(201, 2, '金毛', 1, 1),
(202, 2, '柯基', 2, 1),
(203, 2, '亲人', 3, 1),
(301, 3, '垂耳兔', 1, 1),
(302, 3, '已登记', 2, 1),
(303, 3, '温顺', 3, 1),
(401, 4, '虎皮鹦鹉', 1, 1),
(402, 4, '玄凤鹦鹉', 2, 1),
(403, 4, '活泼', 3, 1);

-- ----------------------------
-- 5) Pet demo entries
-- ----------------------------
INSERT INTO ws_product
(id, name, category_id, subcategory_id, cover_image, price, stock, sales, description, status, is_recommend)
VALUES
(1001, '布偶猫 团团', 1, 101, '/images/pet-cat-ragdoll.png', 399.00, 1, 28,
 '毛发柔顺，亲近人，已完成基础体检和驱虫登记，适合居家陪伴。', 1, 1),
(1002, '英国短毛猫 年糕', 1, 102, '/images/pet-cat-orange.png', 329.00, 1, 35,
 '圆脸安静，作息稳定，适合喜欢温和互动和规律相处的家庭。', 1, 1),
(1003, '狸花幼猫 栗子', 1, 103, '/images/pet-toy-feather.png', 259.00, 1, 41,
 '年龄约四个月，活力充沛，正在适应猫抓板和基础陪玩训练。', 1, 0),
(1004, '金毛 可乐', 2, 201, '/images/pet-dog-golden.png', 599.00, 1, 31,
 '性格开朗，愿意与人互动，已完成疫苗接种记录，适合家庭陪伴。', 1, 1),
(1005, '柯基 豆包', 2, 202, '/images/pet-dog-shiba.png', 499.00, 1, 22,
 '腿短活泼，外出意愿强，喜欢追逐玩具，适合日常散步频率稳定的家庭。', 1, 1),
(1006, '米克斯犬 七喜', 2, 203, '/images/pet-dog-leash.png', 289.00, 1, 27,
 '对人友善，适应新环境较快，已建立喂食和外出时间记录。', 1, 0),
(1007, '垂耳兔 糯米', 3, 301, '/images/pet-rabbit-lop.png', 219.00, 1, 18,
 '耳位自然下垂，喜欢安静角落，进食规律，适合室内稳定环境。', 1, 1),
(1008, '侏儒兔 奶糖', 3, 302, '/images/pet-parrot-cockatiel.png', 239.00, 1, 14,
 '已登记健康档案，体型轻巧，抱持时配合度高，适合细致照护。', 1, 0),
(1009, '白兔 麻薯', 3, 303, '/images/pet-hamster-silver.png', 199.00, 1, 24,
 '性格温顺，适应力好，梳毛和清洁配合度高，适合新手了解兔兔习性。', 1, 0),
(1010, '虎皮鹦鹉 小七', 4, 401, '/images/pet-food-bag.png', 189.00, 1, 33,
 '鸣叫清脆，喜欢站杆互动，羽色鲜亮，适合希望建立日常陪伴感的用户。', 1, 1),
(1011, '玄凤鹦鹉 云朵', 4, 402, '/images/pet-carrier-box.png', 269.00, 1, 19,
 '已完成基础登记，接受手喂训练，情绪稳定，能较快适应熟悉环境。', 1, 1),
(1012, '牡丹鹦鹉 青豆', 4, 403, '/images/pet-clean-kit.png', 229.00, 1, 26,
 '动作灵活，互动积极，适合喜欢观察和建立固定互动节奏的家庭。', 1, 0);

INSERT INTO ws_product_image (product_id, image_url, sort) VALUES
(1001, '/images/pet-cat-ragdoll.png', 1),
(1001, '/images/pet-cat-orange.png', 2),
(1002, '/images/pet-cat-orange.png', 1),
(1004, '/images/pet-dog-shiba.png', 1),
(1005, '/images/pet-dog-golden.png', 1),
(1007, '/images/pet-rabbit-lop.png', 1),
(1008, '/images/pet-parrot-cockatiel.png', 1),
(1010, '/images/pet-food-bag.png', 1),
(1011, '/images/pet-carrier-box.png', 1),
(1012, '/images/pet-clean-kit.png', 1);

-- ----------------------------
-- 6) Demo address
-- ----------------------------
INSERT INTO ws_address
(id, user_id, receiver_name, receiver_phone, province, city, district, detail_address, is_default, created_at, updated_at)
VALUES
(20001, 10001, '宠物体验员', '13800000001', '广东省', '广州市', '天河区', '爱心宠物服务中心 2 号楼', 1, NOW(), NOW());

-- ----------------------------
-- 7) Demo cart and favorite
-- ----------------------------
INSERT INTO ws_cart (id, user_id, product_id, quantity, selected, created_at, updated_at) VALUES
(30001, 10001, 1001, 1, 1, NOW(), NOW()),
(30002, 10001, 1010, 1, 1, NOW(), NOW());

INSERT INTO ws_favorite (id, user_id, product_id, created_at) VALUES
(40001, 10001, 1004, NOW()),
(40002, 10001, 1007, NOW());

-- ----------------------------
-- 8) Homepage banners
-- ----------------------------
INSERT INTO ws_banner (id, title, image_url, link_url, sort, status) VALUES
(1, '领养代替购买', '/images/agri-banner-1.png', '/front/product/detail?id=1001', 1, 1),
(2, '给流浪动物一个温暖的家', '/images/agri-banner-2.png', '/front/product/detail?id=1004', 2, 1),
(3, '发现属于你的陪伴', '/images/agri-banner-3.png', '/front/product/detail?id=1007', 3, 1);

-- ----------------------------
-- 9) Notices
-- ----------------------------
INSERT INTO ws_notice (id, title, content, type, status, publish_time) VALUES
(1, '平台领养须知', '申请领养前请先阅读宠物档案，确认居住环境、陪伴时间和基础护理条件符合对应要求。', 1, 1, NOW()),
(2, '文明养宠提醒', '外出请使用牵引并及时清理宠物排泄物，日常陪伴中注意邻里环境与公共秩序。', 1, 1, NOW()),
(3, '宠物健康护理提示', '春季换毛和温差变化较明显，建议定期观察食欲、精神状态与排便情况，必要时及时就诊。', 2, 1, NOW());

-- ----------------------------
-- 10) Minimal activity data
-- ----------------------------
INSERT INTO ws_activity (id, title, cover_image, content, start_time, end_time, status) VALUES
(1, '春季领养见面日', '/images/agri-banner-2.png',
 '开放猫咪、狗狗和小宠档案预约见面，方便用户集中了解宠物习性与领养要求。',
 '2026-03-15 00:00:00', '2026-04-15 23:59:59', 1);

INSERT INTO ws_activity_join (id, activity_id, user_id, created_at)
VALUES (50001, 1, 10001, NOW());

-- ----------------------------
-- 11) Minimal order history for compatibility
-- ----------------------------
INSERT INTO ws_order
(id, order_no, user_id, total_amount, pay_amount, status,
 receiver_name, receiver_phone, province, city, district, detail_address,
 remark, pay_time, delivery_time, receive_time, created_at, updated_at)
VALUES
(60001, 'WS202603200001', 10001, 588.00, 0.00, 0,
 '宠物体验员', '13800000001', '广东省', '广州市', '天河区', '爱心宠物服务中心 2 号楼',
 '等待确认到店见面时间', NULL, NULL, NULL, NOW(), NOW()),
(60002, 'WS202603200002', 10001, 818.00, 818.00, 3,
 '宠物体验员', '13800000001', '广东省', '广州市', '天河区', '爱心宠物服务中心 2 号楼',
 '回访记录已完成', DATE_SUB(NOW(), INTERVAL 6 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY), NOW(), NOW());

INSERT INTO ws_order_item
(id, order_id, order_no, product_id, product_name, product_cover, product_price, quantity, total_price, created_at)
VALUES
(70001, 60001, 'WS202603200001', 1001, '布偶猫 团团', '/images/pet-cat-ragdoll.png', 399.00, 1, 399.00, NOW()),
(70002, 60001, 'WS202603200001', 1010, '虎皮鹦鹉 小七', '/images/pet-food-bag.png', 189.00, 1, 189.00, NOW()),
(70003, 60002, 'WS202603200002', 1004, '金毛 可乐', '/images/pet-dog-golden.png', 599.00, 1, 599.00, NOW()),
(70004, 60002, 'WS202603200002', 1007, '垂耳兔 糯米', '/images/pet-rabbit-lop.png', 219.00, 1, 219.00, NOW());

INSERT INTO ws_comment
(id, order_id, order_item_id, user_id, product_id, score, content, status, created_at, updated_at)
VALUES
(80001, 60002, 70003, 10001, 1004, 5, '档案信息清晰，性格和健康记录完整，方便提前了解日常陪伴需求。', 1, NOW(), NOW());

SET FOREIGN_KEY_CHECKS = 1;
