  #!/bin/sh

  # 輸出提示訊息說：我要開始更新 GitHub Page 以及 Hugo Blog Repo 囉 !!
  set -e
  printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

  # 移除 `git clone` 指令下載下來的舊版 `public`: `origin-public-repo` 資料夾 
  if [ -d "ycyopen.github.io" ]; then
    rm -rf ycyopen.github.io
  fi

  # 移除 ./public when you run `hugo` generating ./public folder before
  if [ -d "public" ]; then
    rm -rf public
  fi

  # Clone public origin project
  git clone https://github.com/ycyopen/ycyopen.github.io.git

  # 重新打包成靜態資料包
  # 若你有指定佈景，可透過 -t 指定 `hugo -t <YOURTHEME>`
  hugo -t "hugo-coder"

  # 複製「你自己追加的檔案」與 .git
  #   - .git 你的 git repo (有這個你才能把 `新的異動` 更新到線上)
  #   - CNAME 你的 GitHub Page 設置的 CNAME (有這個才會轉導到自己買的網址)
  #   - README.md 說明檔案，因為 run hugo 產生的 public 不會有，若你複製過來留著他，之後更新時他就會不見
  cp -R ./ycyopen.github.io/.git ./public
  #cp ./ycyopen.github.io/CNAME ./public
  #cp ./ycyopen.github.io/README.md ./public

  # Add changes to git.
  cd public
  git add .

  # Commit changes.
  msg="rebuilding site $(date)"
  if [ -n "$*" ]; then
    msg="$*"
  fi
  git commit -s -m "$msg"

  # Push the /public source and build repos.
  git push origin master --force