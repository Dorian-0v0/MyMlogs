# 提示用户输入提交信息
echo "请输入提交信息（commit message）："
read commit_message

if [ -z "$commit_message" ]; then
    echo "提交信息不能为空，请重新运行脚本并输入提交信息。"
    exit 1
fi

# 添加所有更改到暂存区
git add .

# 提交更改，使用用户输入的信息
git commit -m "$commit_message"

# 检查git commit是否成功
if [ $? -ne 0 ]; then
    echo "git commit 命令执行失败，请检查你的提交信息。"
    exit 1
fi

# 强制推送到远程仓库
git push -u origin main --force

# 检查git push是否成功
if [ $? -ne 0 ]; then
    echo "git push 命令执行失败，可能的原因包括远程仓库有冲突的更改。"
else
    echo "提交和推送成功！"
fi
