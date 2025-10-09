# 在Astro项目中保留和访问自定义HTML文件

## 问题解答

当您使用`bun build`命令构建项目时，如果您的自定义`test.html`文件直接放在`dist`目录中，**它很可能会丢失**。这是因为：

1. Astro默认在每次构建时会清空并重新生成`dist`目录
2. package.json中的`clean`命令(`rm -rf .astro .vercel dist`)会完全删除dist目录
3. 构建过程会生成新的文件，覆盖原有内容

## 解决方案

### 方案1：使用public目录（推荐）

**这是最简单且最推荐的方法**。在Astro项目中，`public`目录中的所有文件会在构建时**自动复制**到`dist`目录的根目录，且不会被处理或修改。

#### 操作步骤：

1. 将您的`test.html`文件复制到项目的`public`目录：

```bash
cp /path/to/test.html /Volumes/ztx-1t/zackblog/public/
```

2. 执行构建命令：

```bash
bun build
```

3. 构建完成后，您会在`dist`目录中看到`test.html`文件

4. 访问方式：`http://your-domain.com/test.html`

### 方案2：创建构建后复制脚本

如果您需要更灵活的控制，可以创建一个脚本来在构建完成后将文件复制到`dist`目录。

#### 操作步骤：

1. 在项目根目录创建一个`copy-custom-files.js`脚本：

```javascript
import fs from 'fs';
import path from 'path';

// 定义源文件和目标目录
const customFiles = [
  { source: './custom-files/test.html', target: './dist/' }
  // 可以添加更多文件
];

// 创建目标目录（如果不存在）
customFiles.forEach(file => {
  const targetDir = path.dirname(path.join(file.target, path.basename(file.source)));
  if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
  }
  
  // 复制文件
  fs.copyFileSync(file.source, path.join(file.target, path.basename(file.source)));
  console.log(`Copied ${file.source} to ${file.target}`);
});
```

2. 在`package.json`中添加自定义脚本：

```json
"scripts": {
  "build": "bunx astro-pure check && bunx astro check && bunx astro build --host 0.0.0.0",
  "build-with-custom": "bun build && bun run copy-custom-files.js",
  "copy-custom-files": "node copy-custom-files.js"
}
```

3. 执行增强版构建命令：

```bash
bun run build-with-custom
```

### 方案3：修改Astro配置

您也可以通过修改`astro.config.mjs`来定制构建行为。

#### 操作步骤：

1. 在`astro.config.mjs`中添加Vite插件配置：

```javascript
import { defineConfig } from 'astro/config';
import fs from 'fs';
import path from 'path';

// ...其他导入和配置

export default defineConfig({
  // ...现有配置
  
  vite: {
    plugins: [
      {
        name: 'copy-custom-html',
        writeBundle() {
          // 确保dist目录存在
          const distDir = './dist';
          if (!fs.existsSync(distDir)) {
            fs.mkdirSync(distDir);
          }
          
          // 复制自定义HTML文件
          const customHtmlPath = './path/to/test.html';
          if (fs.existsSync(customHtmlPath)) {
            fs.copyFileSync(
              customHtmlPath,
              path.join(distDir, 'test.html')
            );
            console.log('Custom HTML file copied to dist directory');
          }
        }
      }
    ]
  }
});
```

2. 正常执行构建命令：

```bash
bun build
```

## 方案对比

| 方案 | 优点 | 缺点 |
|------|------|------|
| **public目录** | 简单直接，Astro原生支持 | 只能放在根目录或固定子目录，灵活性较低 |
| **构建后脚本** | 高度灵活，可以自定义复制逻辑和目标路径 | 需要额外维护脚本文件 |
| **修改配置** | 集成到构建流程中，无需单独运行命令 | 配置相对复杂，需要了解Vite插件系统 |

## 访问测试

构建完成后，您可以使用Astro的预览服务器测试自定义HTML文件是否能正确访问：

```bash
bun preview
```

然后在浏览器中访问：`http://localhost:4321/test.html`

## 注意事项

1. 确保自定义HTML文件使用相对路径引用资源，避免使用绝对路径导致资源加载失败

2. 如果您的自定义HTML文件需要引用项目中的CSS或JavaScript文件，请确保路径正确

3. 定期备份重要的自定义文件，防止意外丢失

4. 如果您使用版本控制系统（如Git），建议将自定义文件添加到版本控制中

5. 对于多个自定义HTML文件，建议组织在专门的目录中，便于管理

通过以上方法，您可以确保自定义的HTML文件在每次构建后都能保留并正确访问。