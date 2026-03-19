-- Agricultural Information Management System - data_init.sql
-- Execute after schema.sql
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
VALUES (10001, 'user1', '123456', '农业演示用户', '13800000001', 1, NOW(), NOW())
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
(1, '粮食作物', 1, 1),
(2, '经济作物', 2, 1),
(3, '果蔬作物', 3, 1),
(4, '农业技术', 4, 1)
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  sort = VALUES(sort),
  status = VALUES(status);

-- ----------------------------
-- 4) Secondary categories
-- ----------------------------
INSERT INTO ws_subcategory (id, category_id, name, sort, status) VALUES
(101, 1, '水稻种植', 1, 1),
(102, 1, '玉米种植', 2, 1),
(103, 1, '小麦种植', 3, 1),
(104, 1, '大豆种植', 4, 1),
(105, 1, '杂粮作物', 5, 1),
(201, 2, '蔬菜产业', 1, 1),
(202, 2, '茶叶产业', 2, 1),
(203, 2, '果树产业', 3, 1),
(204, 2, '花卉苗木', 4, 1),
(301, 3, '设施蔬菜', 1, 1),
(302, 3, '葡萄种植', 2, 1),
(303, 3, '柑橘果园', 3, 1),
(304, 3, '苹果梨类', 4, 1),
(305, 3, '西甜瓜类', 5, 1),
(401, 4, '农业政策', 1, 1),
(402, 4, '病虫害防治', 2, 1),
(403, 4, '农机装备', 3, 1),
(404, 4, '市场行情', 4, 1),
(405, 4, '种植技术', 5, 1)
ON DUPLICATE KEY UPDATE
  category_id = VALUES(category_id),
  name = VALUES(name),
  sort = VALUES(sort),
  status = VALUES(status);

-- ----------------------------
-- 5) Curated agricultural information
-- ----------------------------
INSERT INTO ws_product
(id, name, category_id, subcategory_id, cover_image, price, stock, sales, description, status, is_recommend)
VALUES
(1001, '优质水稻高产栽培指南', 1, 101, '/images/agri-rice.png', 92.50, 180, 126,
 '围绕良种选择、育秧密度、分蘖期水肥调控和后期稳产措施，适合用作粮食作物模块的核心展示条目。', 1, 1),
(1002, '玉米田间管理技术要点', 1, 102, '/images/agri-corn.png', 88.00, 156, 109,
 '整理播种密度、苗期查苗补苗、拔节前追肥节点与倒伏预防措施，适合用于玉米专题技术演示。', 1, 1),
(1003, '设施蔬菜周年生产方案', 3, 301, '/images/agri-vegetable.png', 95.00, 132, 97,
 '覆盖棚室温湿度调控、茬口衔接、病害预警和采收安排，可用于展示蔬菜档案与设施管理场景。', 1, 1),
(1004, '生态茶园标准化管理案例', 2, 202, '/images/agri-tea.png', 90.00, 84, 91,
 '聚焦茶园修剪、水肥管理、绿色防控与采摘组织，可作为经济作物管理专题的稳定演示样例。', 1, 0),
(1005, '苹果优质丰产种植专题', 3, 304, '/images/agri-apple.png', 93.00, 76, 86,
 '展示果园建园、整形修剪、花果管理和品质提升路径，适合果园管理页面与详情页展示。', 1, 1),
(1006, '葡萄绿色防控实务', 3, 302, '/images/agri-grape.png', 87.00, 68, 74,
 '梳理葡萄园病害监测、生草覆盖、水肥平衡和结果期管理方法，突出果树作物精细化管护主题。', 1, 0),
(1007, '智慧农业监测应用方案', 4, 403, '/images/agri-smart.png', 98.00, 58, 113,
 '围绕传感采集、墒情监测、远程预警和可视化管理，体现农业信息系统对田间管理的支撑作用。', 1, 1),
(1008, '农作物病虫害综合防治手册', 4, 402, '/images/agri-pest.png', 85.00, 92, 79,
 '整合巡田排查、诱捕监测、生物防治和安全用药建议，用于病虫害专题资料展示。', 1, 0),
(1009, '小麦拔节期追肥与病害监测', 1, 103, '/images/agri-rice.png', 86.00, 148, 118,
 '突出返青后苗情观察、拔节期养分补给和锈病赤霉病预警，适合粮食作物列表页首屏展示。', 1, 1),
(1010, '大豆鼓粒期墒情管理记录', 1, 104, '/images/agri-corn.png', 84.00, 126, 96,
 '围绕花荚保留、田间排涝、根系活力和鼓粒期灌溉安排，体现大豆生产过程中的精细管护。', 1, 0),
(1011, '番茄设施栽培环境调控档案', 3, 301, '/images/agri-vegetable.png', 96.00, 134, 131,
 '记录棚室温度、湿度、放风、授粉和采收衔接节点，适合用于设施蔬菜模块的详情展示。', 1, 1),
(1012, '柑橘园保花保果技术专报', 3, 303, '/images/agri-apple.png', 94.00, 82, 104,
 '聚焦花期营养补充、坐果稳定、夏梢控制和果园排水管理，强化果园类作物内容占比。', 1, 1),
(1013, '茶园春季萌芽期管护台账', 2, 202, '/images/agri-tea.png', 91.00, 79, 93,
 '汇总春茶萌芽观察、轻修剪、水分管理和采前巡园记录，可与公告内容形成互补展示。', 1, 0),
(1014, '玉米大喇叭口期养分诊断', 1, 102, '/images/agri-corn.png', 90.00, 142, 122,
 '围绕株高长势、叶色判断、中耕追肥和高温天气响应，强化玉米专题的阶段性管理信息。', 1, 1)
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  category_id = VALUES(category_id),
  subcategory_id = VALUES(subcategory_id),
  cover_image = VALUES(cover_image),
  price = VALUES(price),
  stock = VALUES(stock),
  sales = VALUES(sales),
  description = VALUES(description),
  status = VALUES(status),
  is_recommend = VALUES(is_recommend);

DELETE FROM ws_product_image WHERE product_id IN (1001, 1004, 1005, 1009, 1011, 1012, 1013, 1014);
INSERT INTO ws_product_image (product_id, image_url, sort) VALUES
(1001, '/images/agri-rice.png', 1),
(1001, '/images/agri-corn.png', 2),
(1004, '/images/agri-tea.png', 1),
(1005, '/images/agri-apple.png', 1),
(1009, '/images/agri-rice.png', 1),
(1011, '/images/agri-vegetable.png', 1),
(1012, '/images/agri-apple.png', 1),
(1013, '/images/agri-tea.png', 1),
(1014, '/images/agri-corn.png', 1);

-- ----------------------------
-- 6) Lightweight demo address
-- ----------------------------
DELETE FROM ws_address WHERE user_id = 10001;
INSERT INTO ws_address
(id, user_id, receiver_name, receiver_phone, province, city, district, detail_address, is_default, created_at, updated_at)
VALUES
(20001, 10001, '农情演示员', '13800000001', '广东省', '广州市', '黄埔区', '现代农业展示中心 1 号楼', 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  receiver_name = VALUES(receiver_name),
  receiver_phone = VALUES(receiver_phone),
  province = VALUES(province),
  city = VALUES(city),
  district = VALUES(district),
  detail_address = VALUES(detail_address),
  is_default = VALUES(is_default),
  updated_at = NOW();

-- ----------------------------
-- 7) Lightweight cart and favorite data
-- ----------------------------
DELETE FROM ws_cart WHERE user_id = 10001;
INSERT INTO ws_cart (id, user_id, product_id, quantity, selected, created_at, updated_at) VALUES
(30001, 10001, 1001, 1, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  quantity = VALUES(quantity),
  selected = VALUES(selected),
  updated_at = NOW();

DELETE FROM ws_favorite WHERE user_id = 10001;
INSERT INTO ws_favorite (id, user_id, product_id, created_at) VALUES
(40001, 10001, 1007, NOW())
ON DUPLICATE KEY UPDATE
  created_at = VALUES(created_at);

-- ----------------------------
-- 8) Homepage banners
-- ----------------------------
INSERT INTO ws_banner (id, title, image_url, link_url, sort, status) VALUES
(1, '粮食作物苗情监测专题', '/images/agri-banner-1.png', '聚焦水稻、小麦、玉米等粮食作物的苗情巡查、墒情研判与田间管理。', 1, 1),
(2, '果园与设施栽培信息', '/images/agri-banner-2.png', '集中展示果园管理、棚室蔬菜、采收节点与产区档案等演示内容。', 2, 1),
(3, '农技服务与数字巡田', '/images/agri-banner-3.png', '突出传感监测、病虫害预警、农机装备与农业信息化服务案例。', 3, 1)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  image_url = VALUES(image_url),
  link_url = VALUES(link_url),
  sort = VALUES(sort),
  status = VALUES(status);

-- ----------------------------
-- 9) Public notices
-- ----------------------------
INSERT INTO ws_notice (id, title, content, type, status, publish_time) VALUES
(1, '平台巡检提示', '当前演示环境已补充粮食作物、果园管理和设施栽培记录，首页专题、分类信息和公告内容可直接用于答辩展示。', 1, 1, NOW()),
(2, '春季农事更新说明', '近期重点维护苗情监测、棚室管理、果园保果和病虫害预警类内容，后台发布后前台将同步展示。', 1, 1, NOW()),
(3, '农业资料阅读建议', '建议先查看粮食作物与果蔬作物专题，再结合公告页了解平台更新节奏和农情演示内容。', 2, 1, NOW())
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  content = VALUES(content),
  type = VALUES(type),
  status = VALUES(status),
  publish_time = VALUES(publish_time);

-- ----------------------------
-- 10) Legacy activity data kept minimal
-- ----------------------------
DELETE FROM ws_activity_join WHERE activity_id IN (1, 2, 3);
DELETE FROM ws_activity WHERE id IN (1, 2, 3);
INSERT INTO ws_activity (id, title, cover_image, content, start_time, end_time, status) VALUES
(1, '农情数据演示周', '/images/agri-banner-3.png',
 '保留一条轻量活动记录，用于兼容原活动表结构与后台历史数据说明。',
 '2026-03-10 00:00:00', '2026-03-31 23:59:59', 1)
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  cover_image = VALUES(cover_image),
  content = VALUES(content),
  start_time = VALUES(start_time),
  end_time = VALUES(end_time),
  status = VALUES(status);

INSERT INTO ws_activity_join (id, activity_id, user_id, created_at)
VALUES (50001, 1, 10001, NOW())
ON DUPLICATE KEY UPDATE
  activity_id = VALUES(activity_id),
  created_at = VALUES(created_at);

-- ----------------------------
-- 11) Minimal history records for statistics compatibility
-- ----------------------------
DELETE FROM ws_comment WHERE user_id = 10001;
DELETE FROM ws_order_item WHERE order_id IN (60001, 60002);
DELETE FROM ws_order WHERE id IN (60001, 60002);

INSERT INTO ws_order
(id, order_no, user_id, total_amount, pay_amount, status,
 receiver_name, receiver_phone, province, city, district, detail_address,
 remark, pay_time, delivery_time, receive_time, created_at, updated_at)
VALUES
(60001, 'WS202603140001', 10001, 180.50, 0.00, 0,
 '农情演示员', '13800000001', '广东省', '广州市', '黄埔区', '现代农业展示中心 1 号楼',
 '演示待处理历史记录', NULL, NULL, NULL, NOW(), NOW()),
(60002, 'WS202603140002', 10001, 191.00, 191.00, 3,
 '农情演示员', '13800000001', '广东省', '广州市', '黄埔区', '现代农业展示中心 1 号楼',
 '演示已完成历史记录', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY), NOW(), NOW())
ON DUPLICATE KEY UPDATE
  total_amount = VALUES(total_amount),
  pay_amount = VALUES(pay_amount),
  status = VALUES(status),
  receiver_name = VALUES(receiver_name),
  receiver_phone = VALUES(receiver_phone),
  province = VALUES(province),
  city = VALUES(city),
  district = VALUES(district),
  detail_address = VALUES(detail_address),
  remark = VALUES(remark),
  pay_time = VALUES(pay_time),
  delivery_time = VALUES(delivery_time),
  receive_time = VALUES(receive_time),
  updated_at = NOW();

INSERT INTO ws_order_item
(id, order_id, order_no, product_id, product_name, product_cover, product_price, quantity, total_price, created_at)
VALUES
(70001, 60001, 'WS202603140001', 1001, '优质水稻高产栽培指南', '/images/agri-rice.png', 92.50, 1, 92.50, NOW()),
(70002, 60001, 'WS202603140001', 1007, '智慧农业监测应用方案', '/images/agri-smart.png', 98.00, 1, 98.00, NOW()),
(70003, 60002, 'WS202603140002', 1005, '苹果优质丰产种植专题', '/images/agri-apple.png', 93.00, 1, 93.00, NOW()),
(70004, 60002, 'WS202603140002', 1008, '农作物病虫害综合防治手册', '/images/agri-pest.png', 98.00, 1, 98.00, NOW())
ON DUPLICATE KEY UPDATE
  product_name = VALUES(product_name),
  product_cover = VALUES(product_cover),
  product_price = VALUES(product_price),
  quantity = VALUES(quantity),
  total_price = VALUES(total_price);

INSERT INTO ws_comment
(id, order_id, order_item_id, user_id, product_id, score, content, status, created_at, updated_at)
VALUES
(80001, 60002, 70003, 10001, 1005, 5, '专题内容结构清晰，果园管理节点与品质提升建议适合演示展示。', 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  score = VALUES(score),
  content = VALUES(content),
  status = VALUES(status),
  updated_at = NOW();

SET FOREIGN_KEY_CHECKS = 1;
