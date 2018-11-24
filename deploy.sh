hexo generate
cp -R public/* .deploy/funaihui.github.io
cd .deploy/funaihui.github.io
git add .
git commit -m "update"
git push origin master

