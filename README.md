# 阅屿 · Read Isle v17 — 阶段五：Supabase 账号与云同步

## 已搭建的功能
- 邮箱注册、登录、退出登录（Supabase Auth）。
- 登录后将书籍记录和外观设置保存到 Supabase `reading_data` 表。
- 本机书籍保存后自动触发云同步，也可在“账号 / 云同步”里手动同步。
- 登录时检测云端数据：可选择下载云端覆盖本机，或上传本机覆盖云端。
- 每个账号的数据由 Row Level Security（RLS）策略隔离。
- 不配置云端时，阅屿仍按原方式保存在本机；本版尚未替用户创建 Supabase 项目或填入项目密钥。

## 必须由你完成的一次性 Supabase 配置

### 1. 创建项目
1. 打开 https://supabase.com/ 并注册/登录。
2. 创建一个新 Project，记住数据库密码（不要发给别人）。
3. 等待项目初始化完成。

### 2. 创建数据库表和权限
1. 在 Supabase Dashboard 打开 **SQL Editor**，选择 **New query**。
2. 打开本压缩包里的 `supabase-schema.sql`，复制全部内容粘贴进去。
3. 点击 **Run**。脚本会创建 `reading_data` 表并启用 RLS，每个账号只能访问自己的数据。

### 3. 填入网页客户端配置
1. 在 Supabase 项目里打开 **Project Settings → API**（新版界面也可能显示 API Keys）。
2. 找到 **Project URL** 和公开的 **anon / publishable key**。
3. 用文本编辑器打开 `supabase-config.js`，替换：
   - `https://YOUR_PROJECT_REF.supabase.co` 为 Project URL
   - `YOUR_ANON_OR_PUBLISHABLE_KEY` 为公开 anon/publishable key
4. 保存文件。只填写公开客户端 key；**绝不要把 `service_role` / secret key 放进网页文件，也不要发给我或其他人**。

### 4. 设置邮箱验证
- Supabase Dashboard → **Authentication → URL Configuration**，按部署方式配置 Site URL 和 Redirect URLs。
- 本地直接打开 `index.html`（`file://`）时，部分邮箱验证跳转或浏览器安全策略可能受限。推荐把整个文件夹部署到 HTTPS 静态托管（如 Netlify、Cloudflare Pages 或 GitHub Pages），再把部署地址填入 URL Configuration。
- 在 Authentication → Providers → Email 中按需要开启邮箱确认。若启用确认，注册后需先点击邮件验证链接，再回网页登录。

### 5. 开始同步
1. 用 Chrome / Safari 打开 `index.html`。
2. 点击顶部 **账号 / 云同步**，注册或登录。
3. 若云端为空，确认后可上传本机书架；若云端已有数据，可选择下载云端或上传本机。两种操作都会覆盖其中一侧，**操作前先点击“导出数据”保存 JSON 备份**。
4. 在另一台设备打开同一部署网址，登录同一账号即可选择恢复云端书架。

## 重要说明与限制
- 本版将书籍记录（包括封面数据）和外观设置存成该用户的一行 JSON 数据。封面图片较多时可能让同步载荷较大；后续可改用 Supabase Storage 保存图片。
- 当前是基础的整份数据同步，不是逐条冲突合并。若两台设备同时修改，请先手动同步，避免较旧设备覆盖较新数据。
- 浏览器仍保留本地副本。云同步只会在已登录、网络可用且 Supabase 配置正确时发生。
- 不要分享账号密码、数据库密码或任何 secret/service_role key。
