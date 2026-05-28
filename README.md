# 黔韵居贵州家常菜微信点餐系统

## 系统简介

这是一个完整的微信点餐系统，包括顾客点餐和商家管理两大功能模块。系统采用现代化的前端技术栈开发，支持微信环境下的完整点餐流程。

### 主要功能

- **顾客端**：菜单浏览、菜品分类、购物车管理、订单提交、订单历史查看
- **管理端**：菜品管理（增删改查）、分类管理（增删改查）、订单管理（查看、完成、取消）
- **微信集成**：微信授权登录、微信支付、图片上传（支持从手机相册选择）
- **数据持久化**：所有数据存储在浏览器本地存储中

## 技术栈

- HTML5 + CSS3 + JavaScript (ES6+)
- Tailwind CSS v3 - 现代化的CSS框架
- Font Awesome - 图标库
- 微信JS-SDK - 微信功能集成

## 部署说明

### 1. 准备工作

#### 1.1 微信公众号配置
1. 注册并认证微信公众号（服务号或订阅号）
2. 获取AppID和AppSecret
3. 配置JS接口安全域名
4. 配置网页授权域名
5. 开启微信支付功能（需要营业执照等资质）

#### 1.2 服务器配置
1. 准备一台云服务器（推荐阿里云、腾讯云等）
2. 安装Web服务器软件（如Nginx、Apache）
3. 配置SSL证书，确保网站支持HTTPS（微信要求）
4. 将域名解析到服务器IP

### 2. 代码部署

#### 2.1 前端部署
1. 将项目文件上传到服务器的Web根目录
2. 确保index.html文件可以通过域名访问
3. 配置Nginx示例（仅供参考）：

```nginx
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name your-domain.com;
    
    ssl_certificate /path/to/ssl/cert.pem;
    ssl_certificate_key /path/to/ssl/key.pem;
    
    root /path/to/your/project;
    index index.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
```

#### 2.2 后端API开发（必需）

**重要：当前项目使用本地存储模拟数据，要正式使用必须开发后端API**

需要开发的后端API包括：

1. **微信授权相关**
   - 获取微信授权URL
   - 用code换取access_token和用户信息
   - 生成微信JS-SDK配置

2. **菜品管理相关**
   - 获取菜品列表
   - 添加/编辑/删除菜品
   - 上传菜品图片到服务器

3. **分类管理相关**
   - 获取分类列表
   - 添加/编辑/删除分类

4. **订单管理相关**
   - 创建订单
   - 获取订单列表
   - 更新订单状态
   - 生成微信支付参数

5. **用户管理相关**
   - 管理员登录认证
   - 权限控制

### 3. 系统配置

#### 3.1 修改前端配置

编辑index.html文件，修改以下配置：

```javascript
const SYSTEM_CONFIG = {
    // 微信公众号配置
    wechat: {
        appId: 'YOUR_WECHAT_APPID', // 替换为实际的公众号AppID
        isWechat: /MicroMessenger/i.test(navigator.userAgent)
    },
    // 管理员账号配置（实际应用中应该从后端获取并验证）
    admin: {
        username: 'admin',
        password: 'admin123'
    },
    // 当前用户角色
    currentRole: 'customer' // 'customer' 或 'admin'
};
```

#### 3.2 替换API调用

将所有模拟数据和本地存储操作替换为真实的API调用：

1. **微信授权**：
   ```javascript
   function checkWechatAuth() {
       // 替换为真实的授权逻辑
   }
   
   function exchangeCodeForToken(code) {
       // 调用后端API换取token
       fetch('/api/wechat/auth', {
           method: 'POST',
           headers: { 'Content-Type': 'application/json' },
           body: JSON.stringify({ code })
       })
       .then(res => res.json())
       .then(data => {
           // 处理授权结果
       });
   }
   ```

2. **菜品管理**：
   ```javascript
   function loadMenuItems() {
       // 调用后端API获取菜品列表
       fetch('/api/dishes')
           .then(res => res.json())
           .then(data => {
               menuItems = data;
               renderMenuItems();
           });
   }
   ```

3. **订单管理**：
   ```javascript
   function submitOrderFunc() {
       // 调用后端API创建订单
       fetch('/api/orders', {
           method: 'POST',
           headers: { 'Content-Type': 'application/json' },
           body: JSON.stringify(orderData)
       })
       .then(res => res.json())
       .then(data => {
           // 处理订单创建结果
       });
   }
   ```

### 4. 数据库设计（参考）

#### 4.1 菜品表（dishes）
```sql
CREATE TABLE dishes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT NOT NULL,
    description TEXT,
    image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);
```

#### 4.2 分类表（categories）
```sql
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### 4.3 订单表（orders）
```sql
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_no VARCHAR(50) NOT NULL UNIQUE,
    table_number INT NOT NULL,
    user_id VARCHAR(100),
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### 4.4 订单详情表（order_items）
```sql
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    dish_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (dish_id) REFERENCES dishes(id)
);
```

## 使用说明

### 顾客使用流程

1. **进入系统**：通过微信扫描二维码或点击链接进入点餐系统
2. **微信授权**：首次使用需要授权微信登录
3. **浏览菜单**：查看菜品列表，可按分类筛选
4. **添加购物车**：选择喜欢的菜品加入购物车
5. **确认订单**：填写桌号和备注信息
6. **微信支付**：使用微信支付完成付款
7. **查看订单**：在订单历史中查看已提交的订单

### 商家管理流程

1. **管理员登录**：点击右上角用户图标，输入管理员账号密码（默认：admin/admin123）
2. **菜品管理**：
   - 查看所有菜品列表
   - 添加新菜品（支持上传图片）
   - 编辑现有菜品信息
   - 删除不需要的菜品
3. **分类管理**：
   - 查看所有分类
   - 添加新分类
   - 编辑分类名称
   - 删除未使用的分类
4. **订单管理**：
   - 查看所有订单
   - 处理待处理订单
   - 完成已制作的订单
   - 取消无法完成的订单

## 安全注意事项

1. **管理员账号安全**：
   - 正式使用时务必修改默认管理员密码
   - 建议定期更换密码
   - 考虑添加多管理员支持和权限控制

2. **数据安全**：
   - 所有API接口必须添加身份验证
   - 敏感数据传输必须使用HTTPS
   - 数据库密码等敏感信息不要硬编码在前端代码中

3. **微信安全**：
   - 妥善保管微信公众号的AppID和AppSecret
   - 定期检查授权域名和JS接口安全域名配置

## 性能优化建议

1. **图片优化**：
   - 上传前压缩图片
   - 使用CDN加速图片加载
   - 考虑使用WebP等现代图片格式

2. **代码优化**：
   - 压缩HTML、CSS、JavaScript文件
   - 使用懒加载技术加载图片
   - 考虑使用Vue.js或React等现代前端框架重构

3. **服务器优化**：
   - 使用缓存减少数据库查询
   - 考虑使用负载均衡应对高并发
   - 定期备份数据

## 故障排除

### 常见问题及解决方案

1. **微信授权失败**
   - 检查AppID是否正确
   - 确认授权域名已在微信公众号后台配置
   - 检查URL是否为HTTPS

2. **图片上传失败**
   - 检查服务器是否有足够的存储空间
   - 确认上传目录权限设置正确
   - 检查图片大小是否超过限制

3. **订单提交失败**
   - 检查网络连接
   - 确认表单数据填写完整
   - 查看浏览器控制台是否有错误信息

4. **管理页面无法访问**
   - 确认管理员账号密码正确
   - 检查是否有访问权限
   - 清除浏览器缓存后重试

## 更新日志

### v1.0.0 (2024-01-01)
- 初始版本发布
- 实现基本的点餐功能
- 支持微信授权和支付
- 提供简单的后台管理功能

## 技术支持

如有任何问题或需要技术支持，请联系：
- 邮箱：your-email@example.com
- 电话：138-0000-0000

---

© 2024 黔韵居贵州家常菜. 保留所有权利.