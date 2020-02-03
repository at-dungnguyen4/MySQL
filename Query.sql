-- 2.Thêm 1 dòng dữ liệu trong bất kỳ table nào:
INSERT INTO category(title,description) values("categorytest","helo");
-- 3.Xoá và sửa 1 dòng dữ liệu trong bất kỳ table nào:
UPDATE category SET title="category" WHERE id = 4;
DELETE FROM category WHERE id=4;
-- 4.Select 10 blog mới nhất đã active:
SELECT * FROM blog WHERE is_active=1 ORDER BY id DESC LIMIT 10;
-- 5.Lấy 5 blog từ blog thứ 10:
SELECT * FROM blog LIMIT 5 OFFSET 10;
-- 6.Set is_active = 0 của user có id = 3 trong bảng user:
UPDATE user SET is_active="0" WHERE id=3;
-- 7.Xoá tất cả comment của user = 2 trong blog = 5:
DELETE FROM blog WHERE user_id=2 AND target_id=5 AND target_table="blog";
-- 8.Lấy 3 blog bất kỳ (random):
SELECT * FROM blog ORDER BY RAND() LIMIT 3;
-- 9.Lấy số lượng comment của các blog:
SELECT count(target_table), target_id FROM comment WHERE target_table="blog" GROUP BY target_id;
-- 10.Lấy Category có tồn tại blog hoặc news đã active (không được lặp lại category):
SELECT DISTINCT category.title FROM category INNER JOIN blog ON category.id=blog.category_id WHERE blog.is_active =1 
UNION 
SELECT DISTINCT category.title FROM category INNER JOIN news ON category.id=news.category_id WHERE news.is_active =1;
-- 11.Lấy tổng lượt view của từng category thông qua blog và news:
SELECT sum(Tong) as Tongview,category_id FROM (
SELECT category_id, sum(view) as Tong from blog GROUP BY category_id
UNION All
SELECT category_id, sum(view) as Tong from news GROUP BY category_id) as u GROUP BY category_id;
-- 12.Lấy blog được tạo bởi user mà user này không có bất kỳ comment ở blog:
SELECT title FROM blog WHERE user_id not in (SELECT DISTINCT user_id FROM comment WHERE target_table="blog");
-- 13.Lấy 5 blog mới nhất và số lượng comment cho từng blog:
SELECT count(comment.comment),comment.target_id FROM (SELECT * FROM blog ORDER BY id DESC LIMIT 5) as sub INNER JOIN comment on sub.id = comment.target_id GROUP BY comment.target_id;
-- 14.Lấy 3 User comment đầu tiên trong 5 blogs mới nhất:
SELECT c.user_id FROM (SELECT * FROM blog ORDER BY id DESC LIMIT 5) AS sub INNER JOIN comment AS c ON sub.id = c.target_id WHERE c.target_table="blog" ORDER BY c.target_id ASC LIMIT 3;
-- 15.Update rank user = 2 khi tổng số lượng comment của user > 20:
UPDATE user SET rank=2 WHERE id IN (SELECT user_id AS id FROM (SELECT count(comment) AS rs ,user_id FROM comment GROUP BY user_id) AS z WHERE rs >20);
-- 16.Xoá comment mà nội dung comment có từ "fuck" hoặc "phức":
DELETE FROM comment WHERE comment LIKE '%fuck%' OR comment LIKE '%phức%';
-- 17.Select 10 blog mới nhất được tạo bởi các user active:
SELECT blog.title, user.id as user_id ,user.is_active FROM blog INNER JOIN user ON blog.user_id=user.id WHERE user.is_active=1 ORDER BY blog.id DESC LIMIT 10; 
-- 18.Lấy số lượng Blog active của user có id là 1,2,4:
SELECT count(blog.id),user.id as user_id FROM blog INNER JOIN user ON blog.user_id=user.id WHERE user.id in (1,2,4) AND blog.is_active=1 GROUP BY user.id;
-- 19.Lấy 5 blog và 5 news của 1 category bất kỳ:
SELECT blog.title as Blog_Title,news.title as News_Title FROM blog INNER JOIN news ON blog.category_id=news.category_id ORDER BY RAND() LIMIT 5;
-- 20.Lấy blog và news có lượt view nhiều nhất:
(SELECT id, view FROM blog ORDER BY view DESC LIMIT 1)
UNION
(SELECT id, view FROM news ORDER BY view DESC LIMIT 1);
-- 21.Lấy blog được tạo trong 3 ngày gần nhất:
SELECT * FROM blog where DATEDIFF(curdate(),created_at)=3;
-- 22.Lấy danh sách user đã comment trong 2 blog mới nhất:
SELECT * FROM user INNER JOIN (SELECT * FROM blog order by id DESC LIMIT 2) as blog ON user.id=blog.user_id;
-- 23.Lấy 2 blog, 2 news mà user có id = 1 đã comment:
(SELECT DISTINCT target_id,user_id FROM comment WHERE user_id = 1 AND target_table = "news" LIMIT 2)
UNION
(SELECT DISTINCT target_id,user_id FROM comment WHERE user_id = 1 AND target_table = "blog" LIMIT 2);
-- 24.Lấy 1 blog và 1 news có số lượng comment nhiều nhất:
(SELECT target_id, count(comment) FROM comment WHERE target_table = "news" GROUP BY target_id ORDER BY count(comment) DESC LIMIT 1)
UNION
(SELECT target_id, count(comment) FROM comment WHERE target_table = "blog" GROUP BY target_id ORDER BY count(comment) DESC LIMIT 1);
-- 25.Lấy 5 blog và 5 news mới nhất đã active:
(SELECT id,title FROM blog WHERE is_active = 1 ORDER BY id DESC LIMIT 5)
UNION ALL
(SELECT id,title FROM news WHERE is_active = 1 ORDER BY id DESC LIMIT 5);
-- 26.Lấy nội dung comment trong blog và news của user id =1:
SELECT  comment FROM comment WHERE target_table="blog" OR target_table="news" AND user_id=1;
-- 27.Blog của user đang được user có id = 1 follow:
SELECT rs.from_user_id, b.* FROM blog as b INNER JOIN (SELECT from_user_id,to_user_id FROM follow WHERE from_user_id = 1) as rs ON b.user_id = rs.to_user_id;
-- 28.Lấy số lượng user đang follow user = 1:
SELECT count(*) FROM follow WHERE to_user_id = 1;
-- 29.Lấy số lượng user 1 đang follow:
SELECT count(*) FROM follow WHERE from_user_id = 1;
-- 30.Lấy 1 comment(id_comment, comment) mới nhất và thông tin user của user đang được follow bởi user 1:

-- 31.Hiển thị một chuổi "PHP Team " + ngày giờ hiện tại (Ex: PHP Team 2017-06-21 13:06:37):
SELECT concat("PHP team ",NOW());
-- 32.Tìm có tên(user.full_name) "Khiêu" và các thông tin trên blog của user này như: (blog.title, blog.view), title category(category) của blog này:
SELECT user.full_name,blog.title,blog.view,category.title FROM user INNER JOIN blog ON user.id=blog.user_id INNER JOIN category ON category.id=blog.category_id WHERE user.full_name LIKE '%Khiêu%';
-- 33.Liệt kê email user các user có tên(user.full_name) có chứa ký tự "Khi" theo danh sách như output bên dưới.:
SELECT group_concat(email SEPARATOR';') from user WHERE full_name LIKE '%Khi%';
-- 34. Tính điểm cho user có email là minh82@example.com trong bảng comment:
SELECT email,SUM(CASE target_table WHEN "blog" THEN 1 ELSE 2 END) AS DIEM FROM user INNER JOIN comment ON user.id = comment.user_id WHERE email = "minh82@example.com";

