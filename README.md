# 前言&为什么要在转到Github/gitee上记博客
- 在此之前我已经学习完了Java的相关技术栈、WebGIS相关技术，虽然之前记录了非常多博客：
  - **CSDN博客**：([**Dorian_Ov0的个人主页_CSDN**](https://blog.csdn.net/2301_80412275))。

  - **做过一些项目**：([**dorian个人主页_gitee**](https://gitee.com/Liao-dorian)) 

     **但是它们的目的只是告诉我应该怎么使用，而我现在想要深入技术以及深入计算机学科，同时有一点我的思考。**

- 对于我这个计算机非科班的同学来说想更深入学习计算机，学会使用**Github/Gitee以及git命令和markdown语法非常重要，所有就这样开始吧~**

- 由于我已经学习了数据结构与算法以及一些非常基础的计算机网络、操作系统、计算机组成原理、数据库的知识，对计算机学科已经有了一个全局观，所以现在开始学得细一点，为以后的开发和研究工作打下基础。

- 而我为什么想要深入学习计算机学科呢，因为是学GIS学的。🙃

- 力扣刷题菜鸡：[**Dorian-Epic - 力扣（LeetCode）**](https://leetcode.cn/u/epic-matsumotoy4a/)

<p style="text-align: right;color: red;">  
    since 2025.1.30
</p>  

## 如何解决开发中遇到的Bug

1. **将报错信息或者加上相关代码复制到deepseek等Ai来解决**
2. **将报错信息或者加上相关代码复制到CSDN相关博客网站、Bing搜索、谷歌**
3. **看官方文档**
4. **如果还没发现哪里有问题，就调试程序看是哪个代码报错**<br>==以上步骤如果没解决没关系，但是<span style="background-color: red">要知道是报错的具体原因</span>，进而follow下面的步骤来解决。==
5. **概括报错的原因重新进行Deepseek、CSDN、Bing、掘金等博客网站**
6. **如果这时还没解决，<span style="background-color: red">换实现方案</span>。**

### 此后在下面更新的内容（也许是自己的学习规划吧,嗯！自己画的饼好像有毒？？🐷）

- [前端](./前端/)
- [Java](./Java/)
- [GIS相关](./GIS相关/)
- [AI](./AI/)
- [Python](./Python/)
- [数据结构与算法](./数据结构与算法/)
- [计算机网络相关](./计算机网络相关/)
- [操作系统（Linux）](./操作系统（Linux）/)
- [微服务架构](./微服务架构/)
- [大数据](./大数据/)
- [设计模式](./设计模式/)
- [Other](./other/)

### **常用的git命令在这复制**
```
echo "# test" >> README.md
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/Dorian-0v0/MyMlogs.git
git remote add origin https://gitee.com/Liao-dorian/myblogs.git
git push -u origin main
```
**从命令行推送现有存储库**
gitee：https://gitee.com/Liao-dorian/myblogs.git

```
git remote add origin https://github.com/Dorian-0v0/MyMlogs.git
git branch -M main
git push -u origin main
git push -u origin main --force // 强制提交
```

# 如何使用Git

### **第一天：获取项目 & 创建分支**

1. **克隆项目**

   ```
   git clone <项目url>
   ```

   - 如果需要指定分支（如 `develop`），可以加参数：

     ```
     git clone -b develop <项目url>
     ```

2. **切换到开发分支并同步最新代码**

   ```
   git checkout develop
   git pull origin develop  # 确保本地分支与远程一致
   ```

3. **创建功能分支**

   ```
   git checkout -b feature/your-task-name
   ```

   - 分支命名建议：
     - `feature/xxx`（功能开发）
     - `fix/xxx`（问题修复）
     - `docs/xxx`（文档更新）等。

------

### **日常工作流程**

#### **1. 开始工作前**

- 拉取远程最新代码（避免冲突）：

  ```
  git pull origin develop  # 从主分支更新
  ```

  如果当前在功能分支，可以合并 `develop` 的更新：

  bash

  

  复制

  

  下载

  ```
  git merge develop
  ```

#### **2. 提交代码**

- 添加修改文件：

  ```
  git add <file>  # 或 git add .（谨慎使用）
  ```

- 提交到本地仓库：

  ```
  git commit -m "描述清晰的提交信息"
  ```

  - 提交信息规范：
    - 开头动词（Add/Fix/Update/Refactor等），如 `Fix: 解决登录页面的样式问题`。

#### **3. 推送代码前**

- **先拉取远程最新代码**（避免冲突）：

  ```
  git pull origin feature/your-task-name
  ```

  如果远程分支不存在（首次推送）：

  ```
  git push -u origin feature/your-task-name
  ```

#### **4. 推送代码**

- 推送到远程分支：

  ```
  git push origin feature/your-task-name
  ```

------

### **关键注意事项**

1. **频繁同步主分支**

   - 每天至少从 `develop` 拉取一次更新，减少后续冲突。
   - 使用 `git rebase develop`（替代 `merge`）保持提交历史整洁（需团队共识）。

2. **冲突解决**

   - 如果 `git pull` 提示冲突，手动解决后：

     ```
     git add <冲突文件>
     git commit  # 会生成合并提交
     git push
     ```

3. **代码审查**

   - 推送后发起 **Pull Request/Merge Request**（GitHub/GitLab），而非直接合并到主分支。

4. **分支管理**

   - 功能完成后删除本地和远程的临时分支：

     ```
     git branch -d feature/xxx
     git push origin --delete feature/xxx
     ```

5. **保护主分支**

   - 确保 `main`/`develop` 分支受保护，禁止直接 `push`。

------

### **第二天更新代码**

- 切换到开发分支并拉取最新代码：

  ```
  git checkout develop
  git pull origin develop
  ```

- 如果需要继续开发功能分支：

  ```
  git checkout feature/your-task-name
  git merge develop  # 同步最新代码
  ```

